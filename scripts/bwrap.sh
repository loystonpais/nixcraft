MESA_PATH="${MESA_PATH:-}"

MOUNT_OPENGL=0
EXTRA_BWRAP_ARGS=()
COMMAND=()

while [ "$#" -gt 0 ]; do
  case "$1" in
    --mount-opengl-driver)
      MOUNT_OPENGL=1
      shift
      ;;
    --)
      shift
      COMMAND=("$@")
      break
      ;;
    *)
      EXTRA_BWRAP_ARGS+=("$1")
      shift
      ;;
  esac
done

BWRAP_ARGS=(
  --bind / /
  --dev-bind /dev /dev
  --proc /proc
  --ro-bind /sys /sys
)

if [ "$MOUNT_OPENGL" -eq 1 ]; then
  # Build a unified /run/opengl-driver inside the sandbox
  BWRAP_ARGS+=(--tmpfs /run)
  for entry in /run/*; do
    if [ -e "$entry" ] && [ "$entry" != "/run/opengl-driver" ] && [ "$entry" != "/run/opengl-driver-32" ]; then
      BWRAP_ARGS+=(--bind-try "$entry" "$entry")
    fi
  done

  # Create destination directory structure
  BWRAP_ARGS+=(
    --dir "/run/opengl-driver"
    --dir "/run/opengl-driver/lib"
    --dir "/run/opengl-driver/lib/dri"
    --dir "/run/opengl-driver/lib/gbm"
    --dir "/run/opengl-driver/lib/vdpau"
    --dir "/run/opengl-driver/share"
    --dir "/run/opengl-driver/share/vulkan/icd.d"
    --dir "/run/opengl-driver/share/vulkan/implicit_layer.d"
    --dir "/run/opengl-driver/share/vulkan/explicit_layer.d"
    --dir "/run/opengl-driver/share/glvnd/egl_vendor.d"
    --dir "/run/opengl-driver/share/egl/egl_external_platform.d"
    --dir "/run/opengl-driver/etc/OpenCL/vendors"
  )

  # 1. Base Layer: Bind pure in-tree Mesa drivers and manifests
  if [ -n "$MESA_PATH" ] && [ -d "$MESA_PATH" ]; then
    if [ -d "$MESA_PATH/lib/dri" ]; then
      for f in "$MESA_PATH"/lib/dri/*.so*; do
        if [ -e "$f" ]; then
          bName=$(basename "$f")
          BWRAP_ARGS+=(--ro-bind "$f" "/run/opengl-driver/lib/dri/$bName")
        fi
      done
    fi

    if [ -d "$MESA_PATH/lib/gbm" ]; then
      for f in "$MESA_PATH"/lib/gbm/*.so*; do
        if [ -e "$f" ]; then
          bName=$(basename "$f")
          BWRAP_ARGS+=(--ro-bind "$f" "/run/opengl-driver/lib/gbm/$bName")
        fi
      done
    fi

    for f in "$MESA_PATH"/lib/lib*.so*; do
      if [ -e "$f" ]; then
        bName=$(basename "$f")
        BWRAP_ARGS+=(--ro-bind "$f" "/run/opengl-driver/lib/$bName")
      fi
    done

    if [ -d "$MESA_PATH/share/drirc.d" ]; then
      BWRAP_ARGS+=(--ro-bind "$MESA_PATH/share/drirc.d" "/run/opengl-driver/share/drirc.d")
    fi

    if [ -d "$MESA_PATH/share/vulkan/icd.d" ]; then
      for f in "$MESA_PATH"/share/vulkan/icd.d/*.json; do
        if [ -e "$f" ]; then
          bName=$(basename "$f")
          BWRAP_ARGS+=(--ro-bind "$f" "/run/opengl-driver/share/vulkan/icd.d/$bName")
        fi
      done
    fi

    if [ -d "$MESA_PATH/share/vulkan/implicit_layer.d" ]; then
      for f in "$MESA_PATH"/share/vulkan/implicit_layer.d/*.json; do
        if [ -e "$f" ]; then
          bName=$(basename "$f")
          BWRAP_ARGS+=(--ro-bind "$f" "/run/opengl-driver/share/vulkan/implicit_layer.d/$bName")
        fi
      done
    fi

    if [ -d "$MESA_PATH/share/vulkan/explicit_layer.d" ]; then
      for f in "$MESA_PATH"/share/vulkan/explicit_layer.d/*.json; do
        if [ -e "$f" ]; then
          bName=$(basename "$f")
          BWRAP_ARGS+=(--ro-bind "$f" "/run/opengl-driver/share/vulkan/explicit_layer.d/$bName")
        fi
      done
    fi

    if [ -d "$MESA_PATH/share/glvnd/egl_vendor.d" ]; then
      for f in "$MESA_PATH"/share/glvnd/egl_vendor.d/*.json; do
        if [ -e "$f" ]; then
          bName=$(basename "$f")
          BWRAP_ARGS+=(--ro-bind "$f" "/run/opengl-driver/share/glvnd/egl_vendor.d/$bName")
        fi
      done
    fi
  fi

  # 2. Overlay Layer: Discover and mount host NVIDIA drivers and manifests if present
  IS_NVIDIA=0
  if [ -e "/proc/driver/nvidia" ] || [ -e "/sys/module/nvidia" ] || [ -e "/run/opengl-driver/lib/libGLX_nvidia.so.0" ] || (command -v ldconfig >/dev/null 2>&1 && ldconfig -p 2>/dev/null | grep -q "libGLX_nvidia"); then
    IS_NVIDIA=1
  fi

  if [ "$IS_NVIDIA" -eq 1 ]; then
    FOUND_NVIDIA_LIBS=()

    # 1. Query ldconfig first (standard Linux distros: Ubuntu, Fedora, Arch, Debian)
    if command -v ldconfig >/dev/null 2>&1; then
      while IFS= read -r libPath; do
        if [ -f "$libPath" ]; then
          FOUND_NVIDIA_LIBS+=("$libPath")
        fi
      done < <(ldconfig -p 2>/dev/null | grep -E "x86-64|libc6,x86-64" | grep -E "libGLX_nvidia|libEGL_nvidia|libGLESv.*_nvidia|libnvidia-|libcuda|libnvcuvid|libnvoptix" | awk '{print $NF}' | sort -u)
    fi

    # 2. Fallback candidate directories (NixOS or systems without ld.so.cache)
    if [ "${#FOUND_NVIDIA_LIBS[@]}" -eq 0 ]; then
      LIB_SEARCH_DIRS=(
        /run/opengl-driver/lib
        /usr/lib/x86_64-linux-gnu
        /usr/lib64
        /usr/lib
        /usr/local/lib
      )
      for libDir in "${LIB_SEARCH_DIRS[@]}"; do
        if [ -d "$libDir" ]; then
          for f in "$libDir"/libGLX_nvidia*.so* "$libDir"/libEGL_nvidia*.so* "$libDir"/libnvidia-*.so* "$libDir"/libcuda*.so* "$libDir"/libnvcuvid*.so* "$libDir"/libnvoptix*.so*; do
            if [ -e "$f" ]; then
              FOUND_NVIDIA_LIBS+=("$f")
            fi
          done
          if [ "${#FOUND_NVIDIA_LIBS[@]}" -gt 0 ]; then
            break
          fi
        fi
      done
    fi

    # Bind discovered NVIDIA libraries (both soname and realpath)
    for libFile in "${FOUND_NVIDIA_LIBS[@]}"; do
      baseName=$(basename "$libFile")
      BWRAP_ARGS+=(--ro-bind "$libFile" "/run/opengl-driver/lib/$baseName")

      realPath=$(realpath "$libFile" 2>/dev/null || true)
      if [ -n "$realPath" ] && [ -e "$realPath" ] && [ "$realPath" != "$libFile" ]; then
        realBase=$(basename "$realPath")
        BWRAP_ARGS+=(--ro-bind-try "$realPath" "/run/opengl-driver/lib/$realBase")
      fi
    done

    # Discover and mount host NVIDIA GBM driver
    for gbmDir in /run/opengl-driver/lib/gbm /usr/lib/gbm /usr/lib64/gbm /usr/lib/x86_64-linux-gnu/gbm; do
      FOUND=0
      if [ -d "$gbmDir" ]; then
        for f in "$gbmDir"/*nvidia*.so*; do
          if [ -e "$f" ]; then
            fName=$(basename "$f")
            BWRAP_ARGS+=(--ro-bind "$f" "/run/opengl-driver/lib/gbm/$fName")
            FOUND=1
          fi
        done
        if [ "$FOUND" -eq 1 ]; then
          break
        fi
      fi
    done

    # 3. Discover and merge host Vulkan ICD manifests
    for vkDir in /run/opengl-driver/share/vulkan/icd.d /usr/share/vulkan/icd.d /etc/vulkan/icd.d /usr/local/share/vulkan/icd.d; do
      FOUND=0
      if [ -d "$vkDir" ]; then
        for f in "$vkDir"/*nvidia*.json; do
          if [ -e "$f" ]; then
            fName=$(basename "$f")
            BWRAP_ARGS+=(--ro-bind "$f" "/run/opengl-driver/share/vulkan/icd.d/$fName")
            FOUND=1
          fi
        done
        if [ "$FOUND" -eq 1 ]; then
          break
        fi
      fi
    done

    # Discover and merge host Vulkan implicit layers (e.g. nvidia_layers.json)
    for vkImpDir in /run/opengl-driver/share/vulkan/implicit_layer.d /usr/share/vulkan/implicit_layer.d /etc/vulkan/implicit_layer.d /usr/local/share/vulkan/implicit_layer.d; do
      FOUND=0
      if [ -d "$vkImpDir" ]; then
        for f in "$vkImpDir"/*nvidia*.json; do
          if [ -e "$f" ]; then
            fName=$(basename "$f")
            BWRAP_ARGS+=(--ro-bind "$f" "/run/opengl-driver/share/vulkan/implicit_layer.d/$fName")
            FOUND=1
          fi
        done
        if [ "$FOUND" -eq 1 ]; then
          break
        fi
      fi
    done

    # 4. Discover and merge host EGL vendor manifests
    for eglDir in /run/opengl-driver/share/glvnd/egl_vendor.d /usr/share/glvnd/egl_vendor.d /etc/glvnd/egl_vendor.d /usr/local/share/glvnd/egl_vendor.d; do
      FOUND=0
      if [ -d "$eglDir" ]; then
        for f in "$eglDir"/*nvidia*.json; do
          if [ -e "$f" ]; then
            fName=$(basename "$f")
            BWRAP_ARGS+=(--ro-bind "$f" "/run/opengl-driver/share/glvnd/egl_vendor.d/$fName")
            FOUND=1
          fi
        done
        if [ "$FOUND" -eq 1 ]; then
          break
        fi
      fi
    done

    # Discover and merge host EGL external platform manifests (e.g. nvidia-egl-wayland)
    for extDir in /run/opengl-driver/share/egl/egl_external_platform.d /usr/share/egl/egl_external_platform.d /etc/egl/egl_external_platform.d /usr/local/share/egl/egl_external_platform.d; do
      FOUND=0
      if [ -d "$extDir" ]; then
        for f in "$extDir"/*.json; do
          if [ -e "$f" ]; then
            fName=$(basename "$f")
            BWRAP_ARGS+=(--ro-bind "$f" "/run/opengl-driver/share/egl/egl_external_platform.d/$fName")
            FOUND=1
          fi
        done
        if [ "$FOUND" -eq 1 ]; then
          break
        fi
      fi
    done

    # Bind host wayland-eglstream directory if present
    for streamDir in /run/opengl-driver/share/wayland-eglstream /usr/share/wayland-eglstream /usr/local/share/wayland-eglstream; do
      if [ -d "$streamDir" ]; then
        BWRAP_ARGS+=(--ro-bind "$streamDir" "/run/opengl-driver/share/wayland-eglstream")
        break
      fi
    done

    # 5. Discover and merge host OpenCL vendor manifests
    for oclDir in /run/opengl-driver/etc/OpenCL/vendors /etc/OpenCL/vendors /usr/share/OpenCL/vendors; do
      FOUND=0
      if [ -d "$oclDir" ]; then
        for f in "$oclDir"/*; do
          if [ -e "$f" ]; then
            fName=$(basename "$f")
            BWRAP_ARGS+=(--ro-bind "$f" "/run/opengl-driver/etc/OpenCL/vendors/$fName")
            FOUND=1
          fi
        done
        if [ "$FOUND" -eq 1 ]; then
          break
        fi
      fi
    done
  fi

  # Set environment variables inside sandbox for driver discovery
  BWRAP_ARGS+=(
    --setenv LIBGL_DRIVERS_PATH "/run/opengl-driver/lib/dri"
    --setenv __EGL_VENDOR_LIBRARY_DIRS "/run/opengl-driver/share/glvnd/egl_vendor.d"
    --setenv __EGL_EXTERNAL_PLATFORM_CONFIG_DIRS "/run/opengl-driver/share/egl/egl_external_platform.d"
    --setenv VK_DRIVER_FILES "/run/opengl-driver/share/vulkan/icd.d"
    --setenv VK_LAYER_PATH "/run/opengl-driver/share/vulkan/explicit_layer.d:/run/opengl-driver/share/vulkan/implicit_layer.d"
    --setenv OCL_ICD_VENDORS "/run/opengl-driver/etc/OpenCL/vendors"
    --setenv LD_LIBRARY_PATH "/run/opengl-driver/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
  )
fi

BWRAP_ARGS+=("${EXTRA_BWRAP_ARGS[@]}")

if [ "${#COMMAND[@]}" -gt 0 ]; then
  exec bwrap "${BWRAP_ARGS[@]}" "${COMMAND[@]}"
else
  exec bwrap "${BWRAP_ARGS[@]}"
fi
