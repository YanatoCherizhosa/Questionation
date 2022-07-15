extends Node


var buttonEnterStream

var musicList = []
var musicListPath = "res://Music/"
var currentBackgroundMusic
var backgoundMusicSP
var backgroundVolume = 0
var backgroundPausedVolume = -5

var interfaceVolume = 0

func _ready():
	backgoundMusicSP = get_node("BackgroundMusic")
	var dir = Directory.new()
	if dir.open("res://Music") == OK:
		dir.list_dir_begin()
		var file = dir.get_next()
		while (file != ""):
			if file.ends_with("ogg"):
				musicList.append(file)
			file = dir.get_next()
	print(musicList)
	BackgroundMusic()
	
func BackgroundMusic():
	if musicList.size() > 0:
		print("Music list size: "+ str(musicList.size()))
		currentBackgroundMusic = musicList.size()-1
		#self.add_child(backgoundMusicSP)
		backgoundMusicSP.set_pause_mode(Node.PAUSE_MODE_PROCESS) 
		#backgoundMusicSP.connect("finished", self, "PlayNextBackgoundMusic", [currentBackgroundMusic])
		backgoundMusicSP.connect("finished", self, "PlayNextBackgoundMusic")
		print("Current soundtrack: #" + str(currentBackgroundMusic+1) + " " + str(musicList[currentBackgroundMusic]))
		backgoundMusicSP.stream = load(musicListPath+musicList[currentBackgroundMusic-1])
		backgoundMusicSP.volume_db = backgroundVolume
		backgoundMusicSP.play()
	else:
		print("Error")
	
func PlayNextBackgoundMusic():
	if currentBackgroundMusic <= 0:
		currentBackgroundMusic = musicList.size()-1
		backgoundMusicSP.stream = load(musicListPath+musicList[currentBackgroundMusic])
		backgoundMusicSP.play()
	else:
		currentBackgroundMusic-=1
		backgoundMusicSP.stream = load(musicListPath+musicList[currentBackgroundMusic])
		backgoundMusicSP.play()
	print("Current soundtrack: #" + str(currentBackgroundMusic+1) + " " + str(musicList[currentBackgroundMusic]))
#func PlayNextBackgoundMusic(var currentBackgroundMusic):
#	currentBackgroundMusic = currentBackgroundMusic - 1
#	if currentBackgroundMusic < 0:
#		currentBackgroundMusic = musicList.size()-1
#	else:
#		backgoundMusicSP.connect("finished", self, "PlayNextBackgoundMusic", [currentBackgroundMusic])
#		print("Current soundtrack: #" + str(currentBackgroundMusic+1) + " " + str(musicList[currentBackgroundMusic]))
#		backgoundMusicSP.stream = load("res://Music/"+musicList[currentBackgroundMusic-1])
#		backgoundMusicSP.volume_db = backgroundVolume
#		backgoundMusicSP.play()
#		print("3: "+str(currentBackgroundMusic))
#
#		backgoundMusicSP.connect("finished", self, "PlayNextBackgoundMusic", [currentBackgroundMusic])

func ShortSoundPlayOnce(var path):
	var shortSoundSP = AudioStreamPlayer.new()
	self.add_child(shortSoundSP)
	shortSoundSP.connect("finished", self, "removeAudioStreamPlayer", [shortSoundSP])
	shortSoundSP.stream = load(path)
	shortSoundSP.volume_db = interfaceVolume
	shortSoundSP.play()
	
func buttonEnter():
	ShortSoundPlayOnce("res://Sounds/button_entered.ogg")
	
func removeAudioStreamPlayer(name):
	name.queue_free()

