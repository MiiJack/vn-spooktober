extends Node
## Global game state singleton (autoload name: "GameState").
##
## Holds cross-scene state that isn't already covered by Dialogic's own
## variable system (Dialogic > Variables tab). Reach for a Dialogic variable
## first — only add something here if a *non-story* system (menus, settings,
## save/load) needs to read or write it.
##
## Keep this file small. If it starts growing into several unrelated
## responsibilities, split those into their own autoloads instead of
## piling onto this one.

# Example placeholder — replace with real state once the team needs it.
var current_chapter: String = "chapter_01"
