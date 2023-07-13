extends Control

var is_paused = false setget set_is_paused
const SAVE_DIR = "user://saves/"
var save_path = SAVE_DIR + "save.dat"


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ResumeGame_pressed():
	self.is_paused = false


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_Save_pressed():
	Global.scene = get_tree().current_scene.filename
	print(Global.scene)
	var data = {
		"hair" : Global.hair,
		"eyes" : Global.eyes,
		"body" : Global.skin,
		"scene": Global.scene,
		"gender": Global.gender,
		"player_pos": Global.player_pos,
		"inventory": PlayerInventory.inventory,
	}
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	var file = File.new()
	#you can encrypt file with file.open_encrypted_with_pass below (ADD THIRD PARAMETER "password")
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		file.store_var(data)
		file.close()
	print("data saved")
	print(PlayerInventory.inventory)


func _on_Load_pressed():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path, File.READ)
		if error == OK:
			var player_data = file.get_var()
			file.close()
			Global.clicked_load_btn = true
			Global.hair = player_data["hair"]
			Global.eyes = player_data["eyes"]
			Global.skin = player_data["body"]
			Global.gender = player_data["gender"]
			Global.player_pos = player_data["player_pos"]
			PlayerInventory.inventory = player_data["inventory"]
			SceneTransition.change_scene(player_data["scene"], 'dissolve')
			print(player_data)
	print("data loaded")


func _on_MainMenu_pressed():
	get_tree().change_scene("res://menus/mainmenu/MainMenu.tscn")
