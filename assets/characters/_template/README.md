# Character asset template

To add a new character:

1. Duplicate this whole `_template` folder.
2. Rename the copy to the character's name in `snake_case`, e.g. `assets/characters/alice/`.
3. Delete this README from the copy.
4. Drop portrait files inside using this pattern:

   `<character_name>_<expression>.png` ; e.g. `alice_neutral.png`, `alice_happy.png`, `alice_sad.png`

5. Every portrait for a character must share the **same canvas size** (same width/height, transparent
   padding included) so the character doesn't visually jump around when Dialogic switches expressions.
   See the main project README's "Sprite & asset sizing" section for the agreed canvas size.
6. Create the matching Dialogic character resource (`.dch`) in `story/characters/`, named
   `<character_name>.dch`, and point its portraits at these files.

Full naming/sizing rules live in the root `README.md`; this file is just a local reminder.
