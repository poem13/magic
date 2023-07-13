extends Control

onready var menu = $VBoxContainer
onready var options = $Options
onready var video = $Video
onready var audio = $Audio
onready var player = $AnimationPlayer

const SAVE_DIR = "user://saves/"
var save_path = SAVE_DIR + "save.dat"
var fullscreen = false

func _ready():
	# This will allow keyboard control
	$VBoxContainer/StartButton.grab_focus()
	
	player.play("moving title")
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var number = rng.randi_range(1, 2)
	print(number)
	# TODO: Add multiple characters to show
	match number:
		1:
			$mainSprite.show()
		2:
			$mainSprite.hide()
	
	
func _process(delta):
	#if Input.is_action_just_pressed("ui_cancel"):
		#toggle()	
	pass



func _on_StartButton_pressed():
	#$AudioStreamPlayer.stop()
	SceneTransition.change_scene("res://scenes/CreationScreen.tscn", "wipe")


func _on_OptionsButton_pressed():
	player.play("transition")
	show_and_hide(options, menu)


func _on_QuitButton_pressed():
	get_tree().quit()
	
func toggle():
	visible = !visible
	get_tree().paused = visible	
	
func show_and_hide(first, second):
	first.show()
	second.hide()	


func _on_Video_pressed():
	show_and_hide(video, options)


func _on_Audio_pressed():
	show_and_hide(audio, options)


func _on_BackButton_pressed():
	player.play("show_menu")
	show_and_hide(menu, options)


func _on_FullScreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
	fullscreen = true


func _on_Borderless_toggled(button_pressed):
	if(fullscreen == false):
		OS.window_borderless = button_pressed


func _on_VSync_toggled(button_pressed):
	OS.vsync_enabled = button_pressed


func _on_BackButtonFromVideo_pressed():
	show_and_hide(options, video)


func _on_Master_value_changed(value):
	volume(0, value)
	
func volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, value)
	if value == -30:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)


func _on_Music_value_changed(value):
	volume(1, value)


func _on_SoundFX_value_changed(value):
	volume(2, value)


func _on_BackButtonFromAudio_pressed():
	show_and_hide(options, audio)


func _on_LoadButton_pressed():
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
