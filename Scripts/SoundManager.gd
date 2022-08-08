extends Node


var buttonEnterStream

var musicList = []
var musicListPath = "res://music/"
var currentBackgroundMusic
var backgoundMusicSP
var backgroundVolume = 0
var backgroundPausedVolume = -5

var interfaceVolume = 0

func _ready():
	backgoundMusicSP = get_node("BackgroundMusic")
#	var dir = Directory.new()
	#if dir.open("res://music/") == OK:
#	if dir.open(musicListPath) == OK:
#		dir.list_dir_begin()
#		var file = dir.get_next()
#		while (file != ""):
#			if file.ends_with("ogg"):
#				musicList.append(file.get_basename()+".ogg")
#				#print(file.get_basename())
#				print(file.get_file())
#			file = dir.get_next()
#
#		if musicList.size() > 0:
#			print(musicList)
#		else:
#			print("Файлы не загружены")
#	else:
#		print("Проблемы с открытием папки")
	
	musicList.append("stellarisdeepspace.ogg")
	musicList.append("stellarisfasterthanlight.ogg")
	musicList.append("stellarisgenesis.ogg")
	musicList.append("stellarisgravitationalconstant.ogg")
	musicList.append("stellarisinsearchoflife.ogg")
	
#	backgoundMusicSP.set_pause_mode(Node.PAUSE_MODE_PROCESS) 
#	backgoundMusicSP.stream = load(musicListPath+"stellarisdeepspace.ogg")
#	print(musicListPath+"stellarisdeepspace.ogg")
#	backgoundMusicSP.volume_db = backgroundVolume
#	backgoundMusicSP.play()	
	BackgroundMusic()
	
func BackgroundMusic():
	print("Size Mlist: "+str(musicList.size()))
	if musicList.size() > 0:
		currentBackgroundMusic = musicList.size()-1
		backgoundMusicSP.set_pause_mode(Node.PAUSE_MODE_PROCESS) 
		backgoundMusicSP.connect("finished", self, "PlayNextBackgoundMusic")
		backgoundMusicSP.stream = load(musicListPath+musicList[currentBackgroundMusic-1])
		backgoundMusicSP.volume_db = backgroundVolume
		backgoundMusicSP.play()
	else:
		print("Ошибка воспроизведения")
	
func PlayNextBackgoundMusic():
	if currentBackgroundMusic <= 0:
		currentBackgroundMusic = musicList.size()-1
		backgoundMusicSP.stream = load(musicListPath+musicList[currentBackgroundMusic])
		backgoundMusicSP.play()
	else:
		currentBackgroundMusic-=1
		backgoundMusicSP.stream = load(musicListPath+musicList[currentBackgroundMusic])
		backgoundMusicSP.play()

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

