extends Node

export(String, "Blue", "Brown", "Gray", "Green", 
"Pink", "Purple", "Yellow") var background_texture
export(float) var scroll_speed = 0.4

func _ready():
	change_texture()
	self.material.set_shader_param("scroll_speed", scroll_speed)

func change_texture():
	if background_texture == "Blue":
		self.texture = preload("res://Assets/Background/Blue.png")
	elif background_texture == "Brown":
		self.texture = preload("res://Assets/Background/Brown.png")
	elif background_texture == "Gray":
		self.texture = preload("res://Assets/Background/Gray.png")
	elif background_texture == "Green":
		self.texture = preload("res://Assets/Background/Green.png")
	elif background_texture == "Pink":
		self.texture = preload("res://Assets/Background/Pink.png")
	elif background_texture == "Purple":
		self.texture = preload("res://Assets/Background/Purple.png")
	elif background_texture == "Yellow":
		self.texture = preload("res://Assets/Background/Yellow.png")
