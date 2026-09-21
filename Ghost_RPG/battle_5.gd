extends Control

#Declaring variables for use later in the program
#Sets the maximum health of the player to 200 and the enemy to 400
var player_max_health: int = 200
var enemy_max_health: int = 200
#sets the current health of the player and enemy to their max health
var enemy_health: int = enemy_max_health
var player_health: int = player_max_health
#sets the damage coefficient to 1.0 for both the player and enemy.
#The player and enemy will take 1x as much damage.
var player_damage_coefficient: float = 1.0
var enemy_damage_coefficient: float = 1.0

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

#This function is called when the player attacks.
func player_attack_1():
	#The player's choice is communicated to them through a label.
	$Player_Attack_Label.text = "You attack!"
	#After a short wait, the player rolls damage which can be anything from 5 damage to 50 damage.
	await get_tree().create_timer(1).timeout
	var player_damage_roll = randi_range(5, 50)
	#This is multiplied by the enemy's damage coefficient before being subtracted from the enemy's health.
	var player_damage = (player_damage_roll * enemy_damage_coefficient)
	enemy_health = enemy_health - player_damage
	#This is shown in the enemy's health bar.
	$VBoxContainer/Enemy_health_Bar.value = enemy_health
	#The player is then told that the enemy was damaged.
	$Player_Attack_Label.text = "Enemy damaged!"

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
	#The player is then informed what ENERGY DRINK actually does.
	$Player_Attack_Label.text = "HEALTH regained!"

#This function is called when the player presses the "Lucky Trinket" button.
func player_item_2():
	#This choice is reflected in a label and a timer.
	$Player_Attack_Label.text = "You use LUCKY TRINKET!"
	await get_tree().create_timer(1).timeout
	#The enemy's damage coefficient is then increased by 20%.
	enemy_damage_coefficient = enemy_damage_coefficient * 1.2
	#This is updated in the enemy's damage coefficient label.
	$VBoxContainer/Enemy_Damage_Label.text = str(enemy_damage_coefficient)
	#The player is given a message saying what LUCKY TRINKET actually does.
	$Player_Attack_Label.text = "DAMAGE increased!"

#This function is played when the player presses the "defend" button.
func player_defend():
	#The player's choice is reflected using a label and a timer is induced.
	$Player_Attack_Label.text = "You Defended!"
	await get_tree().create_timer(1).timeout
	#The player's damage coefficient is then reduced by 20%.
	player_damage_coefficient = player_damage_coefficient * 0.8
	#This change is then updated in the player's damage coefficient label.
	$HBoxContainer/Damage_Label.text = str(player_damage_coefficient)
	#A label is shown displaying what DEFEND actually does.
	$Player_Attack_Label.text = "Damage against you decreased!"

#This function is called whenever the player's turn ends for the enemy turn.
func enemy_turn():
	#If the enemy's health is above the trigger to end the battle at 50% health, the enemy will take their turn.
	if enemy_health > 0:
		#A timer is induced to make it feel like the enemy is deciding instead of it being random.
		#The enemy then chooses their move randomly (66.6% chance of attacking, 33.3% chance of defending.)
		var enemy_choice = randi_range(1, 6)
		if enemy_choice == 1:
			enemy_steal("steel chair")
		if enemy_choice == 2:
			enemy_steal("energy drink")
		if enemy_choice == 3:
			enemy_steal("bottle")
		if enemy_choice == 4:
			enemy_steal("longsword")
		if enemy_choice == 5:
			enemy_steal("shield")
		if enemy_choice == 6:
			enemy_steal("book")	
		if enemy_choice == 7:
			enemy_steal("bookshelf")
		if enemy_choice == 8:
			enemy_steal("lucky trinket")
	#if the enemy is below 50% health, they'll say they're bored then despawn.
	else:
		await get_tree().create_timer(2).timeout
		$VBoxContainer/Sprite2D.hide()
		$Enemy_Attack_Label.text = "The Poltergeist is defeated!"
		await get_tree().create_timer(2).timeout
		$Enemy_Attack_Label.text = "You win!"
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")

#This function is called when the enemy uses an object.
func enemy_steal(item):
	#I will list the stats of items here.
	#Steel chair: does 45-60 damage
	#Energy drink: heals 45 hit points
	#Bottle: does 5-15 damage
	#Longsword: does 15-55 damage
	#Shield: reduces damage coefficient by 15%
	#Book: useless but funny
	#Bookshelf: reduces damage coefficient by 25%
	#Lucky Trinket: increases player damage coefficient by 20%
	if item == "steel chair":
		#if the item is a steel chair this is reflected in a label and a timer.
		$Enemy_Attack_Label.text = "The poltergeist throws a steel chair!"
		await get_tree().create_timer(1).timeout
		#The player then takes 45-60 damage.
		var enemy_damage = randi_range(45, 60)
		player_health = player_health - (enemy_damage * player_damage_coefficient)
		$Enemy_Attack_Label.text = "player damaged!"
		#The player's health bar is updated to show this change.
		$HBoxContainer/VBoxContainer/Health_Bar.value = player_health
	if item == "energy drink":
		#if the item is an energy drink this is reflected in a label and a timer.
		$Enemy_Attack_Label.text = "The poltergeist steals your energy drink!"
		await get_tree().create_timer(1).timeout
		#The enemy then heals for 45 hit points.
		enemy_health = enemy_health + 45
		$Enemy_Attack_Label.text = "Poltergeist heals!"
		#The enemy's health bar is updated to show this change.
		$VBoxContainer/Enemy_health_Bar.value = enemy_health
	if item == "bottle":
		#if the item is a bottle this is reflected in a label and a timer.
		$Enemy_Attack_Label.text = "The poltergeist throws a bottle!"
		await get_tree().create_timer(1).timeout
		#The player then takes 5-15 damage.
		var enemy_damage = randi_range(5, 15)
		player_health = player_health - (enemy_damage * player_damage_coefficient)
		$Enemy_Attack_Label.text = "Player damaged!"
		#The player's health bar is updated to show this change.
		$HBoxContainer/VBoxContainer/Health_Bar.value = player_health
	if item == "longsword":
		#if the item is a longsword this is reflected in a label and a timer.
		$Enemy_Attack_Label.text = "The poltergeist stabs you with a longsword!"
		await get_tree().create_timer(1).timeout
		#The player then takes 15-45 damage.
		var enemy_damage = randi_range(15, 45)
		player_health = player_health - (enemy_damage * player_damage_coefficient)
		$Enemy_Attack_Label.text = "player damaged!"
		#The player's health bar is updated to show this change.
		$HBoxContainer/VBoxContainer/Health_Bar.value = player_health
	if item == "shield":
		#if the item is a shield this is reflected in a label and a timer.
		$Enemy_Attack_Label.text = "The poltergeist grabs a shield!"
		await get_tree().create_timer(1).timeout
		#The enemy then decreases damage coefficient by 15%.
		enemy_damage_coefficient = enemy_damage_coefficient * 0.85
		$Enemy_Attack_Label.text = "Player damage decreased!"
		#The player's health bar is updated to show this change.
		$VBoxContainer/Enemy_Damage_Label.text = str(enemy_damage_coefficient)
	if item == "book":
		#if the item is a book this is reflected in a label and a timer.
		$Enemy_Attack_Label.text = "The poltergeist grabs a book and starts reading it!"
		await get_tree().create_timer(1).timeout
		$Enemy_Attack_Label.text = "The Poltergeist learns a valuable life lesson!"
		await get_tree().create_timer(1).timeout
	if item == "bookshelf":
		#if the item is a shield this is reflected in a label and a timer.
		$Enemy_Attack_Label.text = "The poltergeist grabs a bookshelf!"
		await get_tree().create_timer(1).timeout
		#The enemy then decreases damage coefficient by 15%.
		enemy_damage_coefficient = enemy_damage_coefficient * 0.75
		$Enemy_Attack_Label.text = "Player damage decreased!"
		#The player's health bar is updated to show this change.
		$VBoxContainer/Enemy_Damage_Label.text = str(enemy_damage_coefficient)
	if item == "lucky trinket":
		#if the item is a shield this is reflected in a label and a timer.
		$Enemy_Attack_Label.text = "The poltergeist steals your lucky trinket!"
		await get_tree().create_timer(1).timeout
		#The enemy then decreases damage coefficient by 15%.
		player_damage_coefficient = player_damage_coefficient * 1.2
		$Enemy_Attack_Label.text = "Damage to player increased!"
		#The player's health bar is updated to show this change.
		$HBoxContainer/Damage_Label.text = str(player_damage_coefficient)
	#The enemy's label and the player's GUI is reset so the player can take their turn.
	$Enemy_Attack_Label.text = ""
	show_buttons()
	#If the player died from the attack, the fight is hopefully restarted.
	#If I test this and it breaks I'll set it to the main menu again.
	if player_health <= 0:
		get_tree().change_scene_to_file("res://Scenes/Battle_1.tscn")

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
