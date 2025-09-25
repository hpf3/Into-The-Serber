# Godot Web Template

Starter project for shipping Godot 4.5 builds to the web. The repo includes cached engine tooling, reproducible exports, and a minimal menu-driven scene so you can focus on your own content.

## Development Workflow (VS Code)
- Open the folder in VS Code and use `Terminal → Run Task…` → `download-godot` to fetch the matching editor and export templates. The script currently targets Linux (`Godot_v4.5-stable_linux.x86_64`);
- Launch the project via the built-in run configurations (`Run and Debug` panel):
  - `Launch Editor` opens the Godot editor on `src/project.godot`.
  - `Launch Game` runs the project directly using the editor
  - `Launch Web Server` builds the project and starts a python web server (requires that python is installed and on the PATH)

## Repository Layout
- `src/` – Godot project files with a sample main menu (`scenes/ui/main_menu.tscn`) and a helper button script.
- `.vscode/` – launch configs and helper scripts that keep the editor/toolchain in sync across teammates and CI.
- `.woodpecker/` – CI workflow and export preset template used for headless builds.
- `build/` – generated web export output (ignored by Git aside from examples).

## Automation & Deployment
Woodpecker CI (`.woodpecker/main.yml`) runs the same export script inside a container and, when provided with a `GH_TOKEN`, pushes the contents of `build/web/` to the `gh-pages` branch. Add the token as a repository secret and push to `main` to publish automatically.

## Before Publishing Publicly
- Replace placeholder scenes/assets with your own content.
- Review CI secrets/branch names if your deployment differs from the default GitHub Pages flow.
