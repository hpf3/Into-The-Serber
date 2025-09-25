[![status-badge](https://woodpecker.riftwalkerdev.com/api/badges/5/status.svg)](https://woodpecker.riftwalkerdev.com/repos/5)
# Into The Serber (Title WIP)

The serber is in trouble and it is your job to dive into the virtual world and save it, find minawans along your journey and use their powers to fight off the hords of enemies and travel deeper into the serber.

try the latest build at https://hpf3.github.io/Into-The-Serber/

## Development Workflow (VS Code)
- Open the folder in VS Code and use `Terminal → Run Task…` → `download-godot` to fetch the matching editor and export templates. The script currently targets Linux (`Godot_v4.5-stable_linux.x86_64`);
- Launch the project via the built-in run configurations (`Run and Debug` panel):
  - `Launch Editor` opens the Godot editor on `src/project.godot`.
  - `Launch Game` runs the project directly using the editor
  - `Launch Web Server` builds the project and starts a python web server (requires that python is installed and on the PATH)


  >windows configuration may come in the future if requested, but i dont have a windows machine to test on
  > -- Hpf3

## Repository Layout
- `src/` – Godot project files
- `.vscode/` – launch configs and helper scripts
- `.woodpecker/` – CI workflow and export preset template used for headless builds.
- `build/` – generated web export output (ignored by Git).

## Automation & Deployment
Woodpecker CI (`.woodpecker/main.yml`) runs the same export script inside a container and, when provided with a `GH_TOKEN`, pushes the contents of `build/web/` to the `gh-pages` branch. Add the token as a repository secret and push to `main` to publish automatically.
