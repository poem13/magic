extends Control

signal textbox_closed

export(Resource) var enemy = null
export(Resource) var enemy2 = null
var current_player_health = 0
var current_enemy_health = 0
var is_defending = false
var magic
var added = false
var success
var current_person
var description

# Called when the node enters the scene tree for the first time.
func _ready():
	$ActionsPanel/sidepic.play("skin" + str(Global.skin))
	$ActionsPanel/sidepic/hair.play("sidehair-" + str(Global.hair))
	current_person = Global.playerName
	$TextureRect/name.text = current_person
	set_health($EnemyContainer/ProgressBar2, enemy.health, enemy.health)
	set_health($PlayerPanel/ProgressBar, State.current_health, State.max_health)
	
	current_player_health = State.current_health
	current_enemy_health = enemy.health
	
	$Magic.hide()
	$Textbox.hide()
	$ActionsPanel.hide()
	
	display_text("A wild %s appears!" % enemy.name.to_upper())
	yield(self, "textbox_closed")
	yield(get_tree().create_timer(0.2), "timeout")
	$ActionsPanel.show()
	$ActionsPanel/levelText.text = "Level " + str(Global.level)
	
func set_health(progress_bar, health, max_health):
	progress_bar.value = health	
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP: %d/%d" % [health, max_health]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func attack_normally():
	display_text("You dealt %d damage!" % State.damage)
	yield(self, "textbox_closed")
	yield(get_tree().create_timer(0.2), "timeout")
	
	if current_enemy_health == 0:
		display_text("%s was defeated!" % enemy.name.to_upper())
		yield(self, "textbox_closed")
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().quit()

	enemy_turn()		

func enemy_turn():
	display_text("%s launches at you fiercely!" % enemy.name.to_upper())
	yield(self, "textbox_closed")
	yield(get_tree().create_timer(0.2), "timeout")
	
	if is_defending:
		is_defending = false
		display_text("You defended successfully!")
		yield(self, "textbox_closed")	
		yield(get_tree().create_timer(0.2), "timeout")
	else:
		current_player_health = max(0, current_player_health - enemy.damage)
		set_health($PlayerPanel/ProgressBar, current_player_health, State.max_health)
		
		display_text("%s dealt %d damage!" % [enemy.name.to_upper(), enemy.damage])
		yield(self, "textbox_closed")
		yield(get_tree().create_timer(0.2), "timeout")
		
		if current_player_health == 0:
			display_text("You got defeated!")
			yield(self, "textbox_closed")
			yield(get_tree().create_timer(0.5), "timeout")
			get_tree().quit()			
	$ActionsPanel.show()	

func _input(event):
	if (Input.is_mouse_button_pressed(BUTTON_LEFT)) and $Textbox.visible:
		$Textbox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$ActionsPanel.hide()
	$Textbox.show()
	$Textbox/Label.text = text


func _on_Run_pressed():
	var percent = randf()
	if(percent > 0.6):
		display_text("You can't escape!")
		yield(self, "textbox_closed")
		yield(get_tree().create_timer(0.2), "timeout")
		enemy_turn()	
	else:
		display_text("You got away safely!")
		yield(self, "textbox_closed")
		get_tree().quit()


func _on_Attack_pressed():
	display_text("You swing your sword!")
	yield(self, "textbox_closed")
	yield(get_tree().create_timer(0.2), "timeout")
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($EnemyContainer/ProgressBar2, current_enemy_health, enemy.health)
	
	$AnimatedSprite.play("slash")
	$EnemyContainer/snake.play("damaged")
	display_text("You dealt %d damage!" % State.damage)
	yield(self, "textbox_closed")
	$AnimatedSprite.play("default")
	$EnemyContainer/snake.play("default")
	
	if current_enemy_health == 0:
		display_text("%s was defeated!" % enemy.name.to_upper())
		yield(self, "textbox_closed")
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().quit()

	enemy_turn()


func _on_Defend_pressed():
	is_defending = true
	display_text("You prepared for an attack")
	yield(self, "textbox_closed")
	yield(get_tree().create_timer(0.25), "timeout")
	$ActionsPanel.show()	


func _on_Magic_pressed():
	$Magic.show()
	for move in State.moves:
		if(!State.moves[move].empty()):
			print(State.moves[move])
			print("move exists")


func _on_Light_pressed():
	check_moves("Light")
		
func check_moves(magic):
	if(State.moves[magic].empty()):
		display_text("You don't have any %s spells" % magic)
		yield(self, "textbox_closed")	
		yield(get_tree().create_timer(0.2), "timeout")
		$ActionsPanel.show()
	else:
		$Magic/MagicContainer.hide()	
		$Magic/movesContainer.show()
		if added == false:
			for move in State.moves[magic]:
				print("Creating button...")
				var button = Button.new()
				button.name = move
				button.text = move
				print(button.name)
				button.connect("pressed", self, "pressed_%s" % button.name)
				$Magic/movesContainer/VBoxContainer.add_child(button)
				added = true
				
func magicAttack(move):
	match move:
		"Shock":
			display_text("You send a wave of shock to the enemy!")
		"Pyrotorch":
			display_text("Tiny fire flames come out of your finger tips!")

func _on_Elemental_pressed():
	check_moves("Elemental")


func _on_closeButton_pressed():
	$Magic.hide()


func _on_mainButton_pressed():
	$Magic/movesContainer.hide()
	$Magic/MagicContainer.show()


func _on_Blood_pressed():
	check_moves("Blood")


func _on_Poison_pressed():
	check_moves("Poison")


func _on_Curative_pressed():
	check_moves("Curative")
	
func pressed_Shock():
	print("shock pressed")
	$Magic.hide()
	magicAttack("Shock")
	yield(self, "textbox_closed")
	
	var percent = randf()
	print(percent)
	if(percent > 0.8):
		current_enemy_health = max(0, current_enemy_health - State.damage)
		set_health($EnemyContainer/ProgressBar2, current_enemy_health, enemy.health)
	else:
		display_text("You have a chance for a crit...!")
		yield(self, "textbox_closed")
		yield(get_tree().create_timer(0.5), "timeout")
		$TimedClickBar.show()
		yield(get_node("TimedClickBar"), "click")
		$TimedClickBar.hide()
		current_enemy_health = max(0, current_enemy_health - State.damage)
		set_health($EnemyContainer/ProgressBar2, current_enemy_health, enemy.health)
	
	
	display_text("You dealt %d damage!" % State.damage)
	yield(self, "textbox_closed")
	
	if(Global.pointer_over_target == true):
		State.damage = State.damage / 2
	
	if current_enemy_health == 0:
		display_text("%s was defeated!" % enemy.name.to_upper())
		yield(self, "textbox_closed")
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().quit()
	
	enemy_turn()		

func pressed_Pyrotorch():
	print("pyrotorch pressed")
		

func get_description(name):
	match name:
		"Snake":
			description = "It is strong against POISON and weak against LIGHT magic"	
	return description			


func _on_Analysis_pressed():
	display_text(get_description(enemy.name))
	yield(self, "textbox_closed")
	yield(get_tree().create_timer(0.2), "timeout")
	$ActionsPanel.show()
