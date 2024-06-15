extends Control

#Guard
# 1 points
#Claw Sharpening: Increase melee damage by 10%
@onready var upgrade_guard_1 = $HBoxContainer/VBoxContainerGUARD/HBoxContainer/VBoxContainer/UpgradeGuard1
#Silent Predator: Reduced noise from attacks. 
@onready var upgrade_guard_2 = $HBoxContainer/VBoxContainerGUARD/HBoxContainer/VBoxContainer/UpgradeGuard2
# 3 points
#Enhanced Claws: Further increase melee damage by 20%. 
@onready var upgrade_guard_3 = $HBoxContainer/VBoxContainerGUARD/HBoxContainer/VBoxContainer/UpgradeGuard3
#Enhanced Range: Attack range increased by 20% 
@onready var upgrade_guard_4 = $HBoxContainer/VBoxContainerGUARD/HBoxContainer/VBoxContainer/UpgradeGuard4
# 5 points
#Razor Fangs: Additional 30% increase in melee damage. 
@onready var upgrade_guard_5 = $HBoxContainer/VBoxContainerGUARD/HBoxContainer/VBoxContainer/UpgradeGuard5
#Lethal Precision: Guaranteed critical hits on unaware targets. 
@onready var upgrade_guard_6 = $HBoxContainer/VBoxContainerGUARD/HBoxContainer/VBoxContainer/UpgradeGuard6

#Lab
# 2 points
#Resilient Exoskeleton: Increase maximum health by 15%. 
@onready var upgrade_lab_1 = $HBoxContainer/VBoxContainer2LAB/HBoxContainer2/VBoxContainer/UpgradeLab1
#Quick Reflexes: Reduce dash cooldown by 10%. 
@onready var upgrade_lab_2 = $HBoxContainer/VBoxContainer2LAB/HBoxContainer2/VBoxContainer/UpgradeLab2
# 4 points
#Reinforced Exoskeleton: Further increase maximum health by 25%. 
@onready var upgrade_lab_3 = $HBoxContainer/VBoxContainer2LAB/HBoxContainer2/VBoxContainer/UpgradeLab3
#Accelerated Metabolism: Reduce dash cooldown by 20%. 
@onready var upgrade_lab_4 = $HBoxContainer/VBoxContainer2LAB/HBoxContainer2/VBoxContainer/UpgradeLab4
#Eagle Vision: Reduce vision ability cooldown by 10%. 
@onready var upgrade_lab_5 = $HBoxContainer/VBoxContainer2LAB/HBoxContainer2/VBoxContainer/UpgradeLab5
# 6 points
#Fortified Exoskeleton: Additional 35% increase in maximum health. 
@onready var upgrade_lab_6 = $HBoxContainer/VBoxContainer2LAB/HBoxContainer2/VBoxContainer/UpgradeLab6
#Flash Dash: Reduce dash cooldown by 30%. 
@onready var upgrade_lab_7 = $HBoxContainer/VBoxContainer2LAB/HBoxContainer2/VBoxContainer/UpgradeLab7
#Supreme Vision: Reduce vision ability cooldown by 20%. 
@onready var upgrade_lab_8 = $HBoxContainer/VBoxContainer2LAB/HBoxContainer2/VBoxContainer/UpgradeLab8

#upgrade Info
@onready var upgrade_info = %Upgrade_info
var tooltipToLabel : String

#player info
@onready var player = $"../../PlayerCharacterBody3D"
@onready var label_guard_dna_amount = $VBoxContainer/HBoxContainer/LabelGuardDNAAmount
@onready var label_lab_dna_amount = $VBoxContainer/HBoxContainer2/LabelLabDNAAmount
#upgrades
var upgrades_applied = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	upgrade_guard_1.grab_focus();
	label_guard_dna_amount.set_text(str(player.guard_points))
	label_lab_dna_amount.set_text(str(player.lab_points))
	_update_upgrade_buttons()
#TODO: Get current player state. DNA and the already "toggled" upgrades.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#TODO: Keep track of the upgrades done
# Update the upgrade buttons based on player's points and applied upgrades
func _update_upgrade_buttons():
	var guard_points = player.guard_points
	var lab_points = player.lab_points

	# Enable/Disable Guard upgrade buttons
	upgrade_guard_1.disabled = guard_points < 1 or "guard_1" in upgrades_applied
	upgrade_guard_2.disabled = guard_points < 1 or "guard_2" in upgrades_applied
	upgrade_guard_3.disabled = guard_points < 3 or "guard_3" in upgrades_applied
	upgrade_guard_4.disabled = guard_points < 3 or "guard_4" in upgrades_applied
	upgrade_guard_5.disabled = guard_points < 5 or "guard_5" in upgrades_applied
	upgrade_guard_6.disabled = guard_points < 5 or "guard_6" in upgrades_applied

	# Enable/Disable Lab upgrade buttons
	upgrade_lab_1.disabled = lab_points < 2 or "lab_1" in upgrades_applied
	upgrade_lab_2.disabled = lab_points < 2 or "lab_2" in upgrades_applied
	upgrade_lab_3.disabled = lab_points < 4 or "lab_3" in upgrades_applied
	upgrade_lab_4.disabled = lab_points < 4 or "lab_4" in upgrades_applied
	upgrade_lab_5.disabled = lab_points < 4 or "lab_5" in upgrades_applied
	upgrade_lab_6.disabled = lab_points < 6 or "lab_6" in upgrades_applied
	upgrade_lab_7.disabled = lab_points < 6 or "lab_7" in upgrades_applied
	upgrade_lab_8.disabled = lab_points < 6 or "lab_8" in upgrades_applied

func _on_upgrade_guard_1_focus_entered():
	tooltipToLabel = upgrade_guard_1.get_tooltip_text()
	upgrade_info.set_text(tooltipToLabel)
	

func _on_upgrade_guard_2_focus_entered():
	tooltipToLabel = upgrade_guard_2.get_tooltip_text()
	upgrade_info.set_text(tooltipToLabel)

func _on_upgrade_guard_3_focus_entered():
	tooltipToLabel = upgrade_guard_3.get_tooltip_text()
	upgrade_info.set_text(tooltipToLabel)

func _on_upgrade_guard_4_focus_entered():
	tooltipToLabel = upgrade_guard_4.get_tooltip_text()
	upgrade_info.set_text(tooltipToLabel)

func _on_upgrade_guard_5_focus_entered():
	tooltipToLabel = upgrade_guard_5.get_tooltip_text()
	upgrade_info.set_text(tooltipToLabel)

func _on_upgrade_guard_6_focus_entered():
	tooltipToLabel = upgrade_guard_6.get_tooltip_text()
	upgrade_info.set_text(tooltipToLabel)

func _on_upgrade_lab_1_focus_entered():
	tooltipToLabel = upgrade_lab_1.get_tooltip_text()
	upgrade_info.set_text(tooltipToLabel)

func _on_upgrade_lab_2_focus_entered():
	tooltipToLabel = upgrade_lab_2.get_tooltip_text()
	upgrade_info.set_text(tooltipToLabel)

func _on_upgrade_lab_3_focus_entered():
	tooltipToLabel = upgrade_lab_3.get_tooltip_text()
	upgrade_info.set_text(tooltipToLabel)

func _on_upgrade_lab_4_focus_entered():
	tooltipToLabel = upgrade_lab_4.get_tooltip_text()
	upgrade_info.set_text(tooltipToLabel)

func _on_upgrade_lab_5_focus_entered():
	tooltipToLabel = upgrade_lab_5.get_tooltip_text()
	upgrade_info.set_text(tooltipToLabel)

func _on_upgrade_lab_6_focus_entered():
	tooltipToLabel = upgrade_lab_6.get_tooltip_text()
	upgrade_info.set_text(tooltipToLabel)

func _on_upgrade_lab_7_focus_entered():
	tooltipToLabel = upgrade_lab_7.get_tooltip_text()
	upgrade_info.set_text(tooltipToLabel)

func _on_upgrade_lab_8_focus_entered():
	tooltipToLabel = upgrade_lab_8.get_tooltip_text()
	upgrade_info.set_text(tooltipToLabel)


func _on_button_pressed():
	player._evolutionMenu()

# zegmaar on ready()
func _on_mouse_entered():
	label_guard_dna_amount.set_text(str(player.guard_points))
	label_lab_dna_amount.set_text(str(player.lab_points))
	_update_upgrade_buttons()


func _on_upgrade_guard_1_pressed():
	if player.guard_points >= 1 and "guard_1" not in upgrades_applied:
		player.guard_points -= 1
		upgrades_applied["guard_1"] = true
		player.damage *= 1.10
		_update_upgrade_buttons()

func _on_upgrade_guard_2_pressed():
	if player.guard_points >= 1 and "guard_2" not in upgrades_applied:
		player.guard_points -= 1
		upgrades_applied["guard_2"] = true
		# reduce sound
		_update_upgrade_buttons()
		
func _on_upgrade_guard_3_pressed():
	if player.guard_points >= 3 and "guard_3" not in upgrades_applied:
		player.guard_points -= 3
		upgrades_applied["guard_3"] = true
		player.damage *= 1.20
		_update_upgrade_buttons()

func _on_upgrade_guard_4_pressed():
	if player.guard_points >= 3 and "guard_4" not in upgrades_applied:
		player.guard_points -= 3
		upgrades_applied["guard_4"] = true
		player.attack_range *= 1.2 # Increase attack range by 20%
		_update_upgrade_buttons()

func _on_upgrade_guard_5_pressed():
	if player.guard_points >= 5 and "guard_5" not in upgrades_applied:
		player.guard_points -= 5
		upgrades_applied["guard_5"] = true
		player.damage *= 1.3 # Additional 30% increase in melee damage
		_update_upgrade_buttons()
		
func _on_upgrade_guard_6_pressed():
	if player.guard_points >= 5 and "guard_6" not in upgrades_applied:
		player.guard_points -= 5
		upgrades_applied["guard_6"] = true
		player.crit_on_unaware = true
		_update_upgrade_buttons()

func _on_upgrade_lab_1_pressed():
	if player.lab_points >= 2 and "lab_1" not in upgrades_applied:
		player.lab_points -= 2
		upgrades_applied["lab_1"] = true
		print(player.max_health)
		player.max_health *= 1.15
		print(player.max_health)		
		_update_upgrade_buttons()

func _on_upgrade_lab_2_pressed():
	if player.lab_points >= 2 and "lab_2" not in upgrades_applied:
		player.lab_points -= 2
		upgrades_applied["lab_2"] = true
		player.dash_cooldown_timer.wait_time *= 0.9
		_update_upgrade_buttons()

func _on_upgrade_lab_3_pressed():
	if player.lab_points >= 4 and "lab_3" not in upgrades_applied:
		player.lab_points -= 4
		upgrades_applied["lab_3"] = true
		player.max_health *= 1.25
		_update_upgrade_buttons()

func _on_upgrade_lab_4_pressed():
	if player.lab_points >= 4 and "lab_4" not in upgrades_applied:
		player.lab_points -= 4
		upgrades_applied["lab_4"] = true
		player.dash_cooldown_timer.wait_time *= 0.8
		_update_upgrade_buttons()

func _on_upgrade_lab_5_pressed():
	if player.lab_points >= 4 and "lab_5" not in upgrades_applied:
		player.lab_points -= 4
		upgrades_applied["lab_5"] = true
		player.Sense_Cooldown.wait_time *= 0.9
		_update_upgrade_buttons()

func _on_upgrade_lab_6_pressed():
	if player.lab_points >= 6 and "lab_6" not in upgrades_applied:
		player.lab_points -= 6
		upgrades_applied["lab_6"] = true
		player.max_health *= 1.35
		_update_upgrade_buttons()

func _on_upgrade_lab_7_pressed():
	if player.lab_points >= 6 and "lab_7" not in upgrades_applied:
		player.lab_points -= 6
		upgrades_applied["lab_7"] = true
		player.dash_cooldown_timer.wait_time *= 0.7
		_update_upgrade_buttons()

func _on_upgrade_lab_8_pressed():
	if player.lab_points >= 6 and "lab_8" not in upgrades_applied:
		player.lab_points -= 6
		upgrades_applied["lab_8"] = true
		player.Sense_Cooldown.wait_time *= 0.8
		_update_upgrade_buttons()
