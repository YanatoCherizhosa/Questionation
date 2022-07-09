extends TextureRect

func _ready():
	yield(get_tree(), "idle_frame");
	self.rect_size = Vector2(192,64)#64,128,192
	self.rect_scale = Vector2(0.5,0.5);
