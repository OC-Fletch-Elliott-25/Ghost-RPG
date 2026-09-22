extends Control

#Declaring variables for use later in the program
#Sets the maximum health of the player to 200 and the enemy to 400
var player_max_health: int = 200
var enemy_max_health: int = 600
#sets the current health of the player and enemy to their max health
var enemy_health: int = enemy_max_health
var player_health: int = player_max_health
#sets the damage coefficient to 1.0 for both the player and enemy.
#The player and enemy will take 1x as much damage.
var player_damage_coefficient: float = 1.0
var enemy_damage_coefficient: float = 1.0
var enemy_hidden = 0

#This function is called when the scene enters the tree (when the player enters the battle)
func _ready() -> void:
	#The max value of the health bar of the player is set to the player's max health
	#and the current value is set to their current health.
	$HBoxContainer/VBoxContainer/Health_Bar.max_value = player_max_health
	$HBoxContainer/VBoxContainer/Health_Bar.value = player_health
	#The same is done for the enemy.
	$VBoxContainer/Enemy_health_Bar.max_value = enemy_max_health
	$VBoxContainer/Enemy_health_Bar.value = enemy_health
	#The damage coefficient labels are also set to the player's and enemy's damage coefficient.
	$HBoxContainer/Damage_Label.text = str(player_damage_coefficient)
	$VBoxContainer/Enemy_Damage_Label.text = str(enemy_damage_coefficient)
	#The number of turns the player is hidden for is also updated.
	$Hide_Label.text = "Hidden for: " + str(enemy_hidden) + " turns."

#This function is called when the player attacks.
func player_attack_1():
	#The player's choice is communicated to them through a label.
	$Player_Attack_Label.text = "You attack!"
	#After a short wait, the player rolls damage which can be anything from 5 damage to 50 damage.
	await get_tree().create_timer(1).timeout
	var player_damage_roll = randi_range(5, 50)
	#This is multiplied by the enemy's damage coefficient before being subtracted from the enemy's health.
	#If the enemy is hidden then they take half damage.
	if enemy_hidden > 0:
		$Player_Attack_Label.text = "You bumble around in the dark and graze it!"
		await get_tree().create_timer(0.5).timeout
		var player_damage = ((player_damage_roll * enemy_damage_coefficient) / 2)
		enemy_health = enemy_health - player_damage
	else:
		var player_damage = (player_damage_roll * enemy_damage_coefficient)
		$Player_Attack_Label.text = "Enemy damaged!"
		enemy_health = enemy_health - player_damage
		await get_tree().create_timer(0.5).timeout
	#This is shown in the enemy's health bar and a label is shown.
	$VBoxContainer/Enemy_health_Bar.value = enemy_health
	#A timer is played before the enemy starts their turn, which is called from the button signal.
	await get_tree().create_timer(1).timeout

#This function is called when the player presses the "Energy Drink" button.
func player_item_1():
	#The player's choice is reflected in a label.
	$Player_Attack_Label.text = "You use ENERGY DRINK!"
	#After a timer, the player is given 45 hit points.
	await get_tree().create_timer(1).timeout
	player_health = player_health + 45
	#If the player's health goes over their max health (overheal,) the player's health is reduced to their max health.
	if player_health > player_max_health:
		player_health = player_max_health
	#The player's health is then reflected in their health bar.
	$HBoxContainer/VBoxContainer/Health_Bar.value = player_health
	$Player_Attack_Label.text = "HEALTH regained!"
	#A timer is then introduced to space out the enemy's turn.
	await get_tree().create_timer(1).timeout

#This function is called when the player presses the "Lucky Trinket" button.
func player_item_2():
	#This choice is reflected in a label and a timer.
	$Player_Attack_Label.text = "You use LUCKY TRINKET!"
	await get_tree().create_timer(1).timeout
	#The enemy's damage coefficient is then increased by 20%.
	enemy_damage_coefficient = enemy_damage_coefficient *1.2
	#This is updated in the enemy's damage coefficient label.
	$VBoxContainer/Enemy_Damage_Label.text = str(enemy_damage_coefficient)
	#The player is given a message and a timer is induced to space out the turns.
	$Player_Attack_Label.text = "DAMAGE increased!"
	await get_tree().create_timer(1).timeout

#This function is played when the player presses the "defend" button.
func player_defend():
	#The player's choice is reflected using a label and a timer is induced.
	$Player_Attack_Label.text = "You Defended!"
	await get_tree().create_timer(1).timeout
	#The player's damage coefficient is then reduced by 20%.
	player_damage_coefficient = player_damage_coefficient * 0.8
	if player_damage_coefficient < 0.5:
		player_damage_coefficient = 0.5
		$Player_Attack_Label.text = "You cannot DEFEND any more!"
		await get_tree().create_timer(1).timeout
	else:
		$Player_Attack_Label.text = "Damage against you decreased!"
		await get_tree().create_timer(1).timeout
	#This change is then updated in the player's damage coefficient label.
	$HBoxContainer/Damage_Label.text = str(player_damage_coefficient)

#This function is called whenever the player's turn ends for the enemy turn.
func enemy_turn():
	#If the enemy's is not KO-ed, they will take their turn.
	if enemy_health > 0:
		#if the player has been hidden, the hidden counter goes down.
		if enemy_hidden > 0:
			enemy_hidden = enemy_hidden - 1
		$Hide_Label.text = "Hidden for: " + str(enemy_hidden) + " turns."
		#The enemy then chooses their move randomly (50% chance of attacking, 33.3% chance of defending, 16.7% chance of cursing player.)
		var enemy_choice = randi_range(1, 6)
		if enemy_choice == 1:
			enemy_attack()
		if enemy_choice == 2:
			enemy_attack()
		if enemy_choice == 3:
			enemy_attack()
		if enemy_choice == 4:
			enemy_blind()
		if enemy_choice == 5:
			enemy_blind()
		if enemy_choice == 6:
			enemy_hide()
		#If the enemy starts their turn dead, the player is informed of this.
	else:
		$VBoxContainer/Sprite2D.hide()
		$Enemy_Attack_Label.text = "the Will O The Wisp is defeated!"
		await get_tree().create_timer(1).timeout
		#The player would then be put into the overworld here but I don't have an overworld yet.
		#They are put into the main menu instead.
		get_tree().change_scene_to_file("res://Scenes/battle_5.tscn")

#This function is called when the enemy attacks.
func enemy_attack():
	#This choice is reflected in a label and a timer.
	$Enemy_Attack_Label.text = "The Will O The Wisp attacks!"
	await get_tree().create_timer(1).timeout
	#The enemy then rolls damage which can be anywhere from 5 to 50 damage.
	var enemy_damage_roll = randi_range(5, 50)
	#The damage is multiplied by the player's damage coefficient and subrtracted from the player's health.
	var enemy_damage = (enemy_damage_roll  * player_damage_coefficient)
	player_health = player_health - enemy_damage
	#The player's health bar is updated to show this change.
	$HBoxContainer/VBoxContainer/Health_Bar.value = player_health
	#The enemy's label and the player's GUI is reset so the player can take their turn.
	$Enemy_Attack_Label.text = ""
	show_buttons()
	#If the player died from the attack, the fight is hopefully restarted.
	#If I test this and it breaks I'll set it to the main menu again.
	if player_health <= 0:
		get_tree().change_scene_to_file("res://Scenes/Battle_2.tscn")

#This function is called when the enemy wants to defend.
func enemy_blind():
	#This choice is reflected in a label and a timer.
	$Enemy_Attack_Label.text = "The Will O The Wisp blinds you!"
	await get_tree().create_timer(1).timeout
	#The enemy's damage coefficient is then decreased by 10% and a short timer is used to space out the dialogue.
	player_damage_coefficient = player_damage_coefficient * 1.1
	await get_tree().create_timer(0.5).timeout
	#The player is reminded what DEFEND does and the change in damage coefficient is updated.
	$Enemy_Attack_Label.text = "DAMAGE against you increased!"
	$HBoxContainer/Damage_Label.text = str(player_damage_coefficient)
	#The player then gets their GUI back and the label is reset to avoid confusion.
	$Enemy_Attack_Label.text = ""
	show_buttons()

#This function is called whenever the enemy wants to hide.
func enemy_hide():
	#This is shown through a label and a timer.
	$Enemy_Attack_Label.text = "The Will O The Wisp hides for 3 turns!"
	await get_tree().create_timer(1).timeout
	#The number of turns that the player is hidden for is set to 3.
	enemy_hidden = 3
	#This is shown in the enemy's hidden label.
	$Hide_Label.text = "Hidden for: " + str(enemy_hidden) + " turns."
	#The player then gets their GUI back and the label is reset to avoid confusion.
	$Enemy_Attack_Label.text = ""
	show_buttons()

#This function is called when the player presses the ATTACK button.
func _on_attack_1_button_pressed() -> void:
	#The player's GUI is hidden first so that the player can't mash the button and break the action economy.
	hide_buttons()
	#The player attack function is then called.
	player_attack_1()
	#After a short timer, the player's label is reset and the enemy's turn begins.
	await get_tree().create_timer(1.6).timeout
	$Player_Attack_Label.text = ""
	enemy_turn()

#This function is called when the player presses the ENERGY DRINK button.
func _on_item_1_button_pressed() -> void:
	#The player's GUI is hidden first so that the player can't mash the button and break the action economy.
	hide_buttons()
	#The player heal function is then called.
	player_item_1()
	#After a short timer, the player's label is reset and the enemy's turn begins.
	await get_tree().create_timer(1.6).timeout
	$Player_Attack_Label.text = ""
	enemy_turn()

#This function is called when the player presses the LUCKY TRINKET button.
func _on_item_2_button_pressed() -> void:
	#The player's GUI is hidden first so that the player can't mash the button and break the action economy.
	hide_buttons()
	#The player damage increase function is then called.
	player_item_2()
	#After a short timer, the player's label is reset and the enemy's turn begins.
	await get_tree().create_timer(1.6).timeout
	$Player_Attack_Label.text = ""
	enemy_turn()

#This function is called when the player presses the DEFEND button.
func _on_defend_button_pressed() -> void:
	#The player's GUI is hidden first so that the player can't mash the button and break the action economy.
	hide_buttons()
	#The player defend function is then called.
	player_defend()
	#After a short timer, the player's label is reset and the enemy's turn begins.
	await get_tree().create_timer(1.6).timeout
	$Player_Attack_Label.text = ""
	enemy_turn()

#This function hides the player's GUI when called so I don't have to write these lines of code over and over.
func hide_buttons():
	$HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/Attack_1_Button.hide()
	$HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Item_1_Button.hide()
	$HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Item_2_Button.hide()
	$HBoxContainer/VBoxContainer/HBoxContainer/Defend_Button.hide()

#This function shows the player's GUI when called so I don't have to write these lines of code over and over.
func show_buttons():
	$HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/Attack_1_Button.show()
	$HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Item_1_Button.show()
	$HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Item_2_Button.show()
	$HBoxContainer/VBoxContainer/HBoxContainer/Defend_Button.show()


func _on_attack_1_button_mouse_entered() -> void:
	$Info_Label.text = "Deal damage to the opponent, decreasing their health."


func _on_attack_1_button_mouse_exited() -> void:
	$Info_Label.text = ""


func _on_item_1_button_mouse_entered() -> void:
	$Info_Label.text = "Restore your health."


func _on_item_1_button_mouse_exited() -> void:
	$Info_Label.text = ""


func _on_item_2_button_mouse_entered() -> void:
	$Info_Label.text = "Increase the damage done to the opponent by 20%."


func _on_item_2_button_mouse_exited() -> void:
	$Info_Label.text = ""


func _on_defend_button_mouse_entered() -> void:
	$Info_Label.text = "Decrease the opponent's damage to you by 20%."


func _on_defend_button_mouse_exited() -> void:
	$Info_Label.text = ""
