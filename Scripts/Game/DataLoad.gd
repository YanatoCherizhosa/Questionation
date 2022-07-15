extends Control

export (ButtonGroup) var answersButtonGroup

var randomQuestions = []
var randomAnswers = []
var currentQuestion

func _ready():
	soundsForButtons()
	get_node("CanvasLayer/Pause").visible = false
	get_node("MarginContainer/TrueAnswers").text = "Правильные ответы: " + str(Player.rightAnswers)
	
	#load questions if question massive is empty
	if Data.questionsArray.size() > 0:
		pass
	else:
		GetQuestionsFromDB();
	#create start quiz
	CreateNewQuiz()
	#bind signal to answer buttons
	for i in answersButtonGroup.get_buttons():
		i.connect("pressed", self, "answerButtonPressed")

func GetQuestionsFromDB():
	Data.db = Data.SQLite.new()
	Data.db.read_only = true
	Data.db.path = Data.db_path
	Data.db.open_db()
	
	var tableName = "questions"
	Data.db.query("SELECT question as quest, trueanswer as true_answer, wrong1 as w1, " +
	"wrong2 as w2, wrong3 as w3 FROM "+tableName+";")
	
	#filling the data dictionary
	for i in range(0, Data.db.query_result.size()):
		var quest_dict = {
			"id" : i,
			"quest" : Data.db.query_result[i]["quest"],
			0: [Data.db.query_result[i]["true_answer"],0],
			1 : [Data.db.query_result[i]["w1"],1],
			2 : [Data.db.query_result[i]["w2"],1],
			3 : [Data.db.query_result[i]["w3"],1],
		}
		Data.questionsArray.append(quest_dict)

func CreateNewQuiz():
	currentQuestion = int(0)
	Player.rightAnswers = 0
	get_node("MarginContainer/TrueAnswers").text = "Правильные ответы: " + str(Player.rightAnswers)
	Player.currentHealth = Player.maxHealth
	get_tree().get_nodes_in_group("HPBar")[0].value = Player.currentHealth
	randomQuestions.clear()
	randomAnswers.clear()
	#creating random arrays of questions and answers
	randomize() #randomize seed using a number, based on time

	for i in Data.questionsArray.size():
		randomQuestions.append(int(i))
	randomQuestions.shuffle()
	for i in 4:
		randomAnswers.append(int(i))
	randomAnswers.shuffle()
	CreateQuestion(currentQuestion)
	
func CreateQuestion(var randQ):
	get_node("MarginContainer/VBoxContainer/VBoxQuestion/Question/").text = "Вопрос №"+str(currentQuestion+1)+": " + Data.questionsArray[randomQuestions[randQ]]["quest"]
	for i in 4:
		answersButtonGroup.get_buttons()[i].text = Data.questionsArray[randomQuestions[randQ]][randomAnswers[i]][0]
		answersButtonGroup.get_buttons()[i].hp_influence = int(Data.questionsArray[randomQuestions[randQ]][randomAnswers[i]][1])
				
func answerButtonPressed():
	#HP
	Player.currentHealth = Player.currentHealth - answersButtonGroup.get_pressed_button().hp_influence
	get_tree().get_nodes_in_group("HPBar")[0].value = Player.currentHealth
	#right answers
	if answersButtonGroup.get_pressed_button().hp_influence == 0:
		Player.rightAnswers+=1
		get_node("MarginContainer/TrueAnswers").text = "Правильные ответы: " + str(Player.rightAnswers)
	
	#Win/Lose
	if Player.currentHealth < 1:
		get_node("CanvasLayer/Pause").visible = true
		for node in get_tree().get_nodes_in_group("Lose"):
			node.visible = true
		CreateNewQuiz()
	else:
		if currentQuestion >= randomQuestions.size()-1:
			get_tree().paused = true
			#get_tree().current_scene.pause_mode = true
			get_node("CanvasLayer/Pause").visible = true
			var rightAns = Player.rightAnswers
			get_node("CanvasLayer/Pause/MarginContainer/Menues/WinMenu/AnsCount").text = "Вы ответили на "+str(rightAns) + " вопросов"
			for node in get_tree().get_nodes_in_group("Win"):
				node.visible = true
				Player.currentHealth = 3
			CreateNewQuiz()
			get_node("MarginContainer/TrueAnswers").text = "Правильные ответы: " + str(rightAns)
		else:
			currentQuestion+=1
			if currentQuestion < randomQuestions.size():
				randomAnswers.shuffle()
				CreateQuestion(currentQuestion)

func soundsForButtons():
	for node in get_tree().get_nodes_in_group("Button"):
		node.connect("mouse_entered", self, "ButtonEntered")
func ButtonEntered():
	GlobalSounds.buttonEnter()

func _on_Menu_pressed():
	get_tree().paused = true
	GlobalSounds.backgoundMusicSP.volume_db = GlobalSounds.backgroundPausedVolume
	get_node("CanvasLayer/Pause").visible = true
	for node in get_tree().get_nodes_in_group("Pause"):
		node.visible = true
				
func _on_Continue_pressed():
	get_tree().paused = false
	GlobalSounds.backgoundMusicSP.volume_db = GlobalSounds.backgroundVolume
	get_node("CanvasLayer/Pause").visible = false
	for node in get_tree().get_nodes_in_group("AllPause"):
		node.visible = false
	
func _on_Restart_pressed():
	get_tree().paused = false
	GlobalSounds.backgoundMusicSP.volume_db = GlobalSounds.backgroundVolume
	get_node("CanvasLayer/Pause").visible = false
	for node in get_tree().get_nodes_in_group("AllPause"):
		node.visible = false
	CreateNewQuiz()
	
func _on_Exit_pressed():
	get_tree().paused = false
	GlobalSounds.backgoundMusicSP.volume_db = GlobalSounds.backgroundVolume
	for node in get_tree().get_nodes_in_group("AllPause"):
		node.visible = false
		Player.currentHealth = 3
	if get_tree().change_scene("res://Scenes/Menu.tscn") != OK:
		print("Error occured when trying to switch to the Menu.tscn")
