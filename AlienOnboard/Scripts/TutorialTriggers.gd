extends Node3D
#All tutorial stuff..
@onready var TutorialPanel = $Control/TutorialPanel
@onready var WalkLabel = $Control/TutorialPanel/HowToWalkLabel
@onready var GettingStartedLabel = $Control/TutorialPanel/GettingStartedLabel
@onready var DashLabel = $Control/TutorialPanel/HowToDashLabel
@onready var SenseLabel = $Control/TutorialPanel/HowToSenseLabel
@onready var JumpLabel = $Control/TutorialPanel/HowToJumpLabel
@onready var QuestPanel = $Control/QuestPanel
@onready var QuestLabel = $Control/QuestPanel/currentQuestlabel
@onready var Quest1Label = $Control/QuestPanel/Quest1
@onready var QuestTipLabel = $Control/QuestPanel/Tip
@onready var WatchoutLabel = $Control/TutorialPanel/WatchOutLabel
@onready var QuestTimer = $Control/QuestPanel/FinishTimer

#Storage Door switch open after quest
@onready var ClosedStorageDoor = $"../Gates/GateClosedStorage"
@onready var OpenStorageDoor = $"../Gates/GateOpenStorage2"
@onready var closedColl = $"../Gates/GateClosedStorage/StaticBody3D/CollisionShape3D"

var quest1Done = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if QuestTimer.is_stopped() and quest1Done:
		QuestPanel.hide()
		QuestLabel.hide()
		Quest1Label.hide()
		ClosedStorageDoor.hide()
		closedColl.disabled = true
		OpenStorageDoor.show()


func _on_how_to_walk_area_area_entered(area):
	TutorialPanel.show()
	GettingStartedLabel.show()
	WalkLabel.show()


func _on_how_to_walk_area_area_exited(area):
	TutorialPanel.hide()
	GettingStartedLabel.hide()
	WalkLabel.hide()
	



func _on_how_to_jump_area_area_entered(area):
	TutorialPanel.show()
	GettingStartedLabel.show()
	JumpLabel.show()

func _on_how_to_jump_area_area_exited(area):
	TutorialPanel.hide()
	GettingStartedLabel.hide()
	JumpLabel.hide()


func _on_how_to_sense_area_area_entered(area):
	TutorialPanel.show()
	WatchoutLabel.show()
	SenseLabel.show()


func _on_how_to_sense_area_area_exited(area):
	TutorialPanel.hide()
	WatchoutLabel.hide()
	SenseLabel.hide()


func _on_quest_trigger_area_entered(area):
	QuestPanel.show()
	QuestLabel.show()
	Quest1Label.show()


func _on_quest_finish_trigger_area_entered(area):
	QuestTipLabel.show()
	QuestTimer.start()
	quest1Done = true
	
