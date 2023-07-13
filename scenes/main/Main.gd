extends Node2D


const SAVE_DIR = "user://saves/"
var save_path = SAVE_DIR + "save.dat"

var holding_item = null

func _input(event):
	if event.is_action_pressed("use"):
		print("equip")
	if event.is_action_pressed("inventory"):
		$GUI/Inventory.visible = !$GUI/Inventory.visible
		$GUI/Inventory.initialize_inventory()
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_down()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_up()

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.clicked_load_btn == true:
		$Player.position = Global.player_pos
		print("data loaded")
		Global.clicked_load_btn = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Global.player_pos = $Player.position


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/Battle/TestBattle.tscn")
