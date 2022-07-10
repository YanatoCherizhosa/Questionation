extends TextureRect

var playerHealth
var time = 0
const TIME_PERIOD = 0.5

func _ready():
	playerHealth = get_node("/root/Global").playerHealth
	yield(get_tree(), "idle_frame");
	self.rect_size = Vector2(64*playerHealth,64)#64,128,192
#	self.rect_scale = Vector2(0.5,0.5);
#
#func _process(delta):
#	time += delta
#	if time > TIME_PERIOD:
#		self.rect_size = Vector2(64*playerHealth,64)#64,128,192
#		self.rect_scale = Vector2(0.5,0.5);
#		time = 0
#	pass
