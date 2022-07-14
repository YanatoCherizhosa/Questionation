extends Node

var globalSounds
var buttonEnterStream = AudioStreamPlayer.new()

func _ready():
	pass
	
func ShortSoundPlayOnce(var path):
	var shortSound = AudioStreamPlayer.new()
	self.add_child(shortSound)
	shortSound.stream = load(path)
	shortSound.volume_db = -15
	shortSound.play()

func buttonEnter():
	print("buttonEntered")
	ShortSoundPlayOnce("res://Sounds/button_entered.ogg")


