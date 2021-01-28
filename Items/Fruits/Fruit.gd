extends Area2D

export(String, "Apple", "Banana", "Cherry", "Kiwi", 
"Melon", "Orange", "Pineapple", "Strawberry") var anim_name

onready var sprite = $AnimatedSprite
onready var animationPlayer = $AnimationPlayer

func _ready():
	sprite.play(anim_name)

func _on_Fruit_body_entered(_body):
	animationPlayer.play("Collect")
	set_collision_mask_bit(0, false)

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
