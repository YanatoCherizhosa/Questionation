extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#yield(VisualServer, 'frame_pre_draw')
	yield(get_tree(), "idle_frame");
	self.rect_scale = Vector2(0.5,0.5);


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
