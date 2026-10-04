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
  if ! [ -e "/run/opengl-driver" ]; then
    BWRAP_ARGS+=(--tmpfs /run)
    for entry in /run/*; do
      if [ -e "$entry" ]; then
        BWRAP_ARGS+=(--bind-try "$entry" "$entry")
      fi
    done

    IS_NVIDIA=0
    if [ -e "/proc/driver/nvidia" ] || [ -e "/sys/module/nvidia" ] || (command -v ldconfig >/dev/null 2>&1 && ldconfig -p 2>/dev/null | grep -q "libGLX_nvidia"); then
      IS_NVIDIA=1
    fi

    if [ "$IS_NVIDIA" -eq 1 ]; then
      BWRAP_ARGS+=(
        --dir "/run/opengl-driver"
        --dir "/run/opengl-driver/lib"
        --dir "/run/opengl-driver/lib/dri"
        --dir "/run/opengl-driver/share"
        --dir "/run/opengl-driver/share/vulkan/icd.d"
        --dir "/run/opengl-driver/share/vulkan/implicit_layer.d"
        --dir "/run/opengl-driver/share/vulkan/explicit_layer.d"
        --dir "/run/opengl-driver/share/glvnd/egl_vendor.d"
        --dir "/run/opengl-driver/etc/OpenCL/vendors"
      )

      # Mount DRI driver directory
      for driDir in /usr/lib/dri /usr/lib64/dri /usr/lib/x86_64-linux-gnu/dri /usr/local/lib/dri; do
        if [ -d "$driDir" ]; then
          BWRAP_ARGS+=(--ro-bind "$driDir" "/run/opengl-driver/lib/dri")
          break
        fi
      done

      # Mount VDPAU directory if present
      for vdpauDir in /usr/lib/vdpau /usr/lib64/vdpau /usr/lib/x86_64-linux-gnu/vdpau; do
        if [ -d "$vdpauDir" ]; then
          BWRAP_ARGS+=(--ro-bind "$vdpauDir" "/run/opengl-driver/lib/vdpau")
          break
        fi
      done

      # Mount GBM directory if present
      for gbmDir in /usr/lib/gbm /usr/lib64/gbm /usr/lib/x86_64-linux-gnu/gbm; do
        if [ -d "$gbmDir" ]; then
          BWRAP_ARGS+=(--ro-bind "$gbmDir" "/run/opengl-driver/lib/gbm")
          break
        fi
      done

      # Discover and mount host driver libraries + X11/xcb runtime dependencies via ldconfig
      FOUND_DRIVER_LIBS=()
      if command -v ldconfig >/dev/null 2>&1; then
        while IFS= read -r libPath; do
          if [ -f "$libPath" ]; then
            FOUND_DRIVER_LIBS+=("$libPath")
          fi
        done < <(ldconfig -p 2>/dev/null | grep -E "x86-64|libc6,x86-64" | grep -E "libGLX_|libEGL_|libnvidia-|libcuda|libvulkan|libgallium|libglapi|libgbm|libOpenGL|libGLESv|libnvoptix|libX11\.|libX11-xcb|libXext\.|libxcb\.|libXau\.|libXdmcp\.|libdrm\.|libvdpau_" | awk '{print $NF}' | sort -u)
      fi

      # Fallback globbing if ldconfig found nothing
      if [ "${#FOUND_DRIVER_LIBS[@]}" -eq 0 ]; then
        for libDir in /usr/lib/x86_64-linux-gnu /usr/lib64 /usr/lib; do
          if [ -d "$libDir" ]; then
            for f in "$libDir"/libGLX_*.so* "$libDir"/libEGL_*.so* "$libDir"/libnvidia-*.so* "$libDir"/libcuda*.so* "$libDir"/libvulkan*.so* "$libDir"/libX11*.so* "$libDir"/libXext*.so* "$libDir"/libxcb*.so*; do
              if [ -f "$f" ]; then
                FOUND_DRIVER_LIBS+=("$f")
              fi
            done
            break
          fi
        done
      fi

      # Bind both SONAME and canonical realpath to prevent broken symlinks
      for libFile in "${FOUND_DRIVER_LIBS[@]}"; do
        baseName=$(basename "$libFile")
        BWRAP_ARGS+=(--ro-bind "$libFile" "/run/opengl-driver/lib/$baseName")

        realPath=$(realpath "$libFile" 2>/dev/null || true)
        if [ -n "$realPath" ] && [ -f "$realPath" ] && [ "$realPath" != "$libFile" ]; then
          realBase=$(basename "$realPath")
          BWRAP_ARGS+=(--ro-bind "$realPath" "/run/opengl-driver/lib/$realBase")
        fi
      done

      # Look for and merge all host Vulkan ICD manifests individually
      for vkDir in /usr/share/vulkan/icd.d /etc/vulkan/icd.d /usr/local/share/vulkan/icd.d; do
        if [ -d "$vkDir" ]; then
          for f in "$vkDir"/*.json; do
            if [ -f "$f" ]; then
              fName=$(basename "$f")
              BWRAP_ARGS+=(--ro-bind "$f" "/run/opengl-driver/share/vulkan/icd.d/$fName")
            fi
          done
        fi
      done

      # Look for and merge all host Vulkan implicit layers
      for layDir in /usr/share/vulkan/implicit_layer.d /etc/vulkan/implicit_layer.d /usr/local/share/vulkan/implicit_layer.d; do
        if [ -d "$layDir" ]; then
          for f in "$layDir"/*.json; do
            if [ -f "$f" ]; then
              fName=$(basename "$f")
              BWRAP_ARGS+=(--ro-bind "$f" "/run/opengl-driver/share/vulkan/implicit_layer.d/$fName")
            fi
          done
        fi
      done

      # Look for and merge all host Vulkan explicit layers
      for layDir in /usr/share/vulkan/explicit_layer.d /etc/vulkan/explicit_layer.d /usr/local/share/vulkan/explicit_layer.d; do
        if [ -d "$layDir" ]; then
          for f in "$layDir"/*.json; do
            if [ -f "$f" ]; then
              fName=$(basename "$f")
              BWRAP_ARGS+=(--ro-bind "$f" "/run/opengl-driver/share/vulkan/explicit_layer.d/$fName")
            fi
          done
        fi
      done

      # Look for and merge all host EGL vendor manifests
      for eglDir in /usr/share/glvnd/egl_vendor.d /etc/glvnd/egl_vendor.d /usr/local/share/glvnd/egl_vendor.d; do
        if [ -d "$eglDir" ]; then
          for f in "$eglDir"/*.json; do
            if [ -f "$f" ]; then
              fName=$(basename "$f")
              BWRAP_ARGS+=(--ro-bind "$f" "/run/opengl-driver/share/glvnd/egl_vendor.d/$fName")
            fi
          done
        fi
      done

      # Look for and merge all host OpenCL vendor manifests
      for oclDir in /etc/OpenCL/vendors /usr/share/OpenCL/vendors; do
        if [ -d "$oclDir" ]; then
          for f in "$oclDir"/*; do
            if [ -f "$f" ]; then
              fName=$(basename "$f")
              BWRAP_ARGS+=(--ro-bind "$f" "/run/opengl-driver/etc/OpenCL/vendors/$fName")
            fi
          done
        fi
      done
    else
      # AMD / Intel / Software / Virtualized GPU:
      # Bind pure Mesa drivers from Nix store directly as /run/opengl-driver
      if [ -n "$MESA_PATH" ] && [ -d "$MESA_PATH" ]; then
        BWRAP_ARGS+=(--ro-bind "$MESA_PATH" "/run/opengl-driver")
      fi
    fi

    # Set environment variables inside sandbox for driver discovery
    BWRAP_ARGS+=(
      --setenv LIBGL_DRIVERS_PATH "/run/opengl-driver/lib/dri"
      --setenv __EGL_VENDOR_LIBRARY_DIRS "/run/opengl-driver/share/glvnd/egl_vendor.d"
      --setenv VK_DRIVER_FILES "/run/opengl-driver/share/vulkan/icd.d"
      --setenv VK_LAYER_PATH "/run/opengl-driver/share/vulkan/explicit_layer.d:/run/opengl-driver/share/vulkan/implicit_layer.d"
      --setenv OCL_ICD_VENDORS "/run/opengl-driver/etc/OpenCL/vendors"
      --setenv LD_LIBRARY_PATH "/run/opengl-driver/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
    )
  fi
fi

BWRAP_ARGS+=("${EXTRA_BWRAP_ARGS[@]}")

if [ "${#COMMAND[@]}" -gt 0 ]; then
  exec bwrap "${BWRAP_ARGS[@]}" "${COMMAND[@]}"
else
  exec bwrap "${BWRAP_ARGS[@]}"
fi
