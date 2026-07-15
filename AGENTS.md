# Repository Guidelines

## Project Structure & Module Organization

`flake.nix` is the entry point and composes the project through flake-parts. Public NixOS, Home Manager, and flake modules live under `modules/`; reusable option definitions are in `submodules/`. Package entry points belong in `packages/`, lower-level derivation helpers in `builders/`, and shared Nix functions in `lib/`. Version manifests, lock data, and update scripts are kept in `sources/`. Documentation sources live in `docs/`, while `tests/interactive/` contains the current manual client-instance test configuration.

## Build, Test, and Development Commands

- `nix flake check` evaluates the flake and catches module or output errors.
- `nix build .#client` builds the client package; use `.#server` or `.#auth` for the other primary packages.
- `nix develop` enters the devenv-backed development shell with documentation tooling.
- `devenv tasks run docs:build` regenerates option documentation and builds the mdBook site.
- `devenv up open-docs` serves documentation on port 4000 and opens it locally.

Run commands from the repository root. Source-update helpers are exposed through `legacyPackages.x86_64-linux.runInRepoRoot`; inspect `nix flake show` before invoking one.

## Coding Style & Naming Conventions

Use two-space indentation in Nix files and follow the existing compact module style. Format attribute sets consistently, prefer descriptive camelCase Nix names such as `clientInstanceModule`, and use kebab-case for task and package names such as `update-modloader-locks`. Python scripts use four-space indentation and snake_case identifiers. No formatter or linter is currently declared, so keep changes consistent with adjacent files and review diffs carefully.

## Testing Guidelines

There is no automated coverage requirement. Always run `nix flake check` and build each affected package. For runtime changes, evaluate and run `tests/interactive/default.nix` through the flake context, then manually verify the relevant Minecraft instances. Name new test directories by test type and keep reusable configuration in a neighboring `config.nix`.

## Commit & Pull Request Guidelines

Recent history uses short, imperative, lowercase subjects, often scoped with a prefix such as `readme: update ...`. Keep commits focused and explain the user-visible reason for a change. Pull requests should summarize behavior, list validation commands, link related issues, and call out regenerated lock or manifest files. Include screenshots only for documentation or launcher UI changes.

## Security & Generated Data

Never commit Microsoft refresh tokens or writable account files. Treat JSON locks, manifests, and generated option docs as derived data: update them with repository helpers and include the corresponding source change in the same pull request.
