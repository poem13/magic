extends Node


var item_data: Dictionary


# Called when the node enters the scene tree for the first time.
func _ready():
	item_data = LoadData("res://scenes/inventory/Data/ItemData.json")


func LoadData(file_path):
	var json_data
	var file_data = File.new()
	
	file_data.open(file_path, File.READ)
	json_data = JSON.parse(file_data.get_as_text())
	file_data.close()
	print(json_data.result)
	return json_data.result
