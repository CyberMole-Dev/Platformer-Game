extends Node2D

const IDLE_DURATION = 1.0

export var move_to = Vector2.RIGHT * 64
export var speed = 1.3

var follow = Vector2.ZERO

onready var platform = $Platform
onready var tween = $MoveTween
onready var sprite = $Platform/AnimatedSprite
onready var endTrigger = $EndTrigger/End

func _ready():
	_init_tween()
	endTrigger.position = move_to 

func _init_tween():
	var duration = move_to.length() / float(speed * 32)
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_OUT, IDLE_DURATION)
	tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_OUT, duration + IDLE_DURATION * 2)
	tween.start()

func _physics_process(_delta):
	platform.position = platform.position.linear_interpolate(follow, 0.5)

func _on_StartTrigger_area_exited(_area):
	sprite.play("On", false)

func _on_EndTrigger_area_exited(_area):
	sprite.play("On", true)

func _on_Trigger_area_entered(_area):
	sprite.play("Off")
