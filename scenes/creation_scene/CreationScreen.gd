extends Node2D

onready var gender = 0
onready var body = $Player/body
onready var eyes = $Player/eyes
onready var hair = $Player/hair
onready var skin_count = 1
onready var eyes_count = 1
onready var hair_count = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_Male_pressed():
	gender = 0
	body.play("idle_male_1")


func _on_Female_pressed():
	gender = 1
	body.play("idle_female_1")


func _on_SkinButton_pressed():
	if gender == 0:
		if skin_count >= 3:
			skin_count = 1
			body.play("idle_male_" + str(skin_count))
		else:
			skin_count += 1
			body.play("idle_male_" + str(skin_count))
			print(skin_count)
	if gender == 1:
		if skin_count >= 3:
			skin_count = 1
			body.play("idle_female_" + str(skin_count))
		else:
			skin_count += 1
			body.play("idle_female_" + str(skin_count))


func _on_EyesButton_pressed():
	if eyes_count >= 4:
		eyes_count = 1
		eyes.play("eyes_" + str(eyes_count))
	else:
		eyes_count += 1
		eyes.play("eyes_" + str(eyes_count))


func _on_HairButton_pressed():
	if hair_count >= 7:
		hair_count = 1
		hair.play("hair_" + str(hair_count))
	else:
		hair_count += 1
		hair.play("hair_" + str(hair_count))


func _on_BackButton_pressed():
	SceneTransition.change_scene("res://menus/mainmenu/MainMenu.tscn", "dissolve")


func _on_ContinueButton_pressed():
	Global.skin = skin_count
	Global.hair = hair_count
	Global.eyes = eyes_count
	Global.gender = gender
	print("gender is: " + str(Global.gender))
	print("eyes is: " + str(Global.eyes))
	print("skin is:" + str(Global.skin))
	SceneTransition.change_scene("res://scenes/creation_scene/SetName.tscn", "dissolve")
