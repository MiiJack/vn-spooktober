## Requirements

- **Godot 4.5+** — the bundled Dialogic build (`2.0-Alpha-20`) requires it.
- **Git LFS** — install once per machine: [git-lfs.com](https://git-lfs.com), then run
  `git lfs install` before your first clone/commit. This repo's `.gitattributes` already
  routes images/audio/fonts through LFS; you just need the LFS client present.

## Getting started

1. Install Git LFS (see above), then clone the repo.
2. Open the project folder in Godot 4.7+ (`project.godot`).
3. Godot will detect and enable the Dialogic plugin automatically (it's already listed
   under `editor_plugins` in `project.godot`). If not, enable it manually via
   **Project > Project Settings > Plugins**.
4. You should see a "Dialogic" tab appear at the top of the editor. You're ready to go.

## Folder structure

```
├── addons/dialogic/     Third-party plugin. Never hand-edit.
├── autoloads/           Global singletons (Project Settings > Autoload).
├── story/               Everything authored *inside* the Dialogic editor.
│   ├── timelines/        One subfolder per chapter, plus shared/ for reusable snippets.
│   └── characters/       Dialogic character resources (.dch).
├── assets/              Raw, engine-agnostic art & audio files.
│   ├── characters/       One subfolder per character (see _template/).
│   ├── backgrounds/
│   ├── cg/               Full-screen event illustrations.
│   ├── ui/               Buttons, frames, icons, cursors.
│   ├── audio/            music/, sfx/, voice/
│   └── fonts/
├── scenes/              One subfolder per screen; scene + its script live together.
├── resources/           Custom Resource types NOT owned by Dialogic (save data, settings).
└── docs/                Design docs / notes. Ignored by Godot's importer (.gdignore).
```

**`story/` is separate from `assets/`.**
Writers and narrative designers spend their time in the Dialogic editor producing
timelines and character definitions (plain-text `.dtl` / `.dch` files). Artists spend
their time producing raw image/audio files. `story/timelines/` is split by chapter.

**`assets/characters/<name>/` groups each character's own art together, but
shared media (music, fonts) sits in one place by type.**
This follows Godot's own project-organization guidance: keep files close to the specific
thing they belong to when they *do* belong to one thing (a character's portraits belong
to that character and nothing else), but keep genuinely shared, engine-wide media in a
single predictable spot instead of scattering copies. A `_template/` folder is included
under `assets/characters/` : duplicate it to create a new character with the right
sub-structure and naming pattern already in place.

**`scenes/<feature>/` keeps a scene's `.tscn` and its `.gd` script in the same folder,
rather than a global `scenes/` pile and a global `scripts/` pile.**
This is also straight from Godot's official project-organization guidance: grouping assets/scripts close to the scene that uses them scales better than sorting by file type.

**`addons/dialogic/` is committed as-is and never modified by hand.**
Godot's own guidance is to keep third-party plugins in a top-level `addons/` folder
regardless of whether they're editor tools. Treat this folder as read-only: if the look
of a Dialogic layout needs changing, use Dialogic's "Make Custom" feature (which copies
the relevant scene out of `addons/` for you) rather than editing files inside `addons/` directly.

**`autoloads/` and `resources/` are deliberately small and separate from Dialogic.**
Dialogic already has its own variable system for story-state (flags, relationship values,
etc.); reach for that before writing custom code. `autoloads/` and `resources/` exist
for the handful of things that genuinely aren't story state: which scene to load next, save-file format, settings.

## Naming conventions

These follow Godot's own [GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
and [project organization guide](https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html).

| Thing | Convention | Example |
|---|---|---|
| Folders | `snake_case`, all lowercase | `assets/characters/` |
| Scene files (`.tscn`) | `snake_case`, matches root node | `main_menu.tscn` |
| Script files (`.gd`) | `snake_case`, matches the scene/class it belongs to | `main_menu.gd` |
| Root node of a scene | `PascalCase` | `MainMenu` |
| Classes (`class_name`) | `PascalCase` | `class_name InventoryItem` |
| Variables & functions | `snake_case` | `current_chapter`, `go_to()` |
| Constants | `UPPER_SNAKE_CASE` | `MAX_SAVE_SLOTS` |
| Signals | `snake_case`, past tense | `chapter_finished` |
| Dialogic timelines | `snake_case`, prefixed by chapter | `ch01_intro.dtl` |
| Dialogic characters | `snake_case`, matches character's asset folder | `alice.dch` |
| Character portrait files | `<character_name>_<expression>.png` | `alice_happy.png` |

## Sprite & asset sizing

Pin these down **once, at the start**, and put the agreed numbers in this section.

- **Base game resolution:** 1920×1080 (16:9), using Godot's `canvas_items` stretch mode.
- **Backgrounds:** exported at 1920×1080. PNG if any transparency is needed, otherwise
  JPG > a lossy format here noticeably helps clone time
- **Character portraits/sprites:** every expression for the same character must share
  **one fixed canvas size** (agree on this number as a team, e.g. 1500×2000), with the
  character's feet/baseline at the same position in every file.
  Export as PNG (alpha transparency required).
- **CGs (full-screen event art):** same 1920×1080 canvas as backgrounds, PNG or JPG depending on transparency needs.
- **UI elements/icons:** no fixed rule beyond internal consistency — pick sizes that are
  multiples of each other within a single UI set (e.g. all icons 64×64) so they don't
  need per-instance scaling.

**File formats by asset type:**

| Asset | Format | Why |
|---|---|---|
| Backgrounds / CGs (no transparency) | `.jpg` | Smaller repo size |
| Backgrounds / CGs (with transparency) | `.png` | Needs alpha |
| Character portraits | `.png` | Needs alpha |
| Music | `.ogg` | Godot's native streaming format; loops well |
| SFX | `.wav` | Short, low-latency playback |
| Fonts | `.ttf` / `.otf` | Standard |

## Working with Git on this project

- **`addons/dialogic/`, `.tscn`, `.tres`, `.gd`, `.dtl`, `.dch` are all plain text** :
  normal `git diff` and merges work on them. Binary assets (images/audio/fonts) go
  through **Git LFS**, configured in `.gitattributes`, so make sure LFS is installed
  before you start committing art.
- **`.godot/` is gitignored** : it's a local editor cache, fully regenerated on open.
  If you ever see merge conflicts inside it, something's misconfigured; don't try to resolve them by hand, just delete the folder and reopen the project.
- If two people need to edit the *same* binary file (e.g. the same background), talk
  to each other first; binary files can't be merged, only overwritten. GitHub's LFS   file locking can help here if it becomes a recurring problem.
- Design docs, script drafts, and meeting notes can live in `docs/` without Godot trying to import them (there's an empty `.gdignore` file in there).

## What not to do

- Don't hand-edit anything inside `addons/dialogic/` : use "Make Custom" in the Dialogic
  editor instead.
- Don't put raw art files inside `story/` or Dialogic resources inside `assets/` : keep the writer/artist split described above.
- Don't create a second top-level folder for "scripts" or "misc" : if something doesn't obviously fit one of the folders above, that's worth a quick team conversation rather than a new folder no one else knows to look in.
