extends CanvasLayer

onready var player = $AnimationPlayer

func change_scene(target: String, type: String = 'wipe') -> void:
	if type == 'dissolve':
		transition_dissolve(target)
	if type == 'wipe':
		transition_wipe(target)
	
func transition_dissolve(target:String) -> void:	
	player.play("dissolve")
	yield(player, "animation_finished")
	get_tree().change_scene(target)
	player.play_backwards("dissolve")
	
func transition_wipe(target:String) -> void:
	$ColorRect2.show()
	player.play("diamond")	
	yield(player, "animation_finished")
	get_tree().change_scene(target)
	player.play_backwards("diamond")
	yield(player, "animation_finished")
	$ColorRect2.hide()
