extends LineEdit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LineEdit_text_entered(new_text):
	if new_text == "":
		new_text = "Avery"
	$"/root/Global".playerName = new_text	
	print(Global.playerName)
	$"/root/SceneTransition".change_scene("res://scenes/main/Main.tscn")
