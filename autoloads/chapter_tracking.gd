## tracks the current chapter, the different ending and ending paths

extends Node
signal next_chapter

var chapter_index: Dictionary = {
	Chapter_01_Intro = 1
}


var current_chapter: int = 0
var human_meeting: bool = false
var monster_meeting: bool = false

var chapter_idx: int = 0

	
func chapter_done() -> void:
	if Dialogic.VAR.human_meeting == true and Dialogic.VAR.monster_meeting == false:
		current_chapter += 1
		chapter_idx += 1
		next_chapter.emit()
		human_meeting = false
		monster_meeting = false

func show_chapter(chapter_idx: int) -> void:
	pass
