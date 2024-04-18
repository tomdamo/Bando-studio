extends Button

@onready var save_label = $HBoxContainer/SaveLabel
# In the SAVE_ICON_BUTTON class
signal button_toggled(button)

func _on_toggled(toggled_on):
	if toggled_on:
		emit_signal("button_toggled", self)
