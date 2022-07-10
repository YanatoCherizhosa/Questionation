extends Control

export (ButtonGroup) var answersButtonGroup

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_path = "res://Databases/main.db"
var massive
var playerHealth
var randomQuestions = []
var randomAnswers = []
var qnumber = 0

func _ready():
	massive = get_node("/root/Global").question_massive
	playerHealth = get_node("/root/Global").playerHealth
	print("Player HP: "+ str(get_node("/root/Global").playerHealth))

	#Load questions if question massive is empty
	if massive.size() > 0:
		pass 
	else:
		GetQuestionsFromDB();
	
	for i in massive.size():
		randomQuestions.append(int(i))
	randomQuestions.shuffle()
	for i in 4:
		randomAnswers.append(int(i))
	randomAnswers.shuffle()
	
	for i in answersButtonGroup.get_buttons():
		i.connect("pressed", self, "answerButtonUp")
	print(randomAnswers)
	print("\n")

	CreateQuestion(qnumber)

func GetQuestionsFromDB():
	db = SQLite.new()
	db.path = db_path
	db.open_db()
	
	var tableName = "questions"
	db.query("SELECT question as quest, trueanswer as true_answer, wrong1 as w1, " +
	"wrong2 as w2, wrong3 as w3 FROM "+tableName+";")
	
	for i in range(0, db.query_result.size()):
		var quest_dict = {
			"id" : i,
			"quest" : db.query_result[i]["quest"],
			0: [db.query_result[i]["true_answer"],0],
			1 : [db.query_result[i]["w1"],1],
			2 : [db.query_result[i]["w2"],1],
			3 : [db.query_result[i]["w3"],1],
		}
		massive.append(quest_dict)
	
func CreateQuestion(var randQ):
	get_node("MarginContainer/VBoxContainer/VBoxQuestion/Question").text = massive[randomQuestions[randQ]]["quest"]
	for i in 4:
		answersButtonGroup.get_buttons()[i].text = massive[randomQuestions[randQ]][randomAnswers[i]][0]
		answersButtonGroup.get_buttons()[i].hp_influence = int(massive[randomQuestions[randQ]][randomAnswers[i]][1])
				
func answerButtonUp():
	print("HP influence: "+str(answersButtonGroup.get_pressed_button().hp_influence))
	print("Player bi HP: "+ str(get_node("/root/Global").playerHealth))
	
	get_node("/root/Global").playerHealth = get_node("/root/Global").playerHealth - answersButtonGroup.get_pressed_button().hp_influence
	
	print("HP influence: "+str(answersButtonGroup.get_pressed_button().hp_influence))
	print("Player ai HP: "+ str(get_node("/root/Global").playerHealth))
	get_node("MarginContainer/VBoxContainer/HealthBar").rect_size = Vector2(64 * get_node("/root/Global").playerHealth, 64)

	if qnumber >= randomQuestions.size()-1:
		print("Победа!")
		qnumber = 0
	else:
		qnumber+=1
		print("Next Question :"+str(qnumber))
		if qnumber < randomQuestions.size():
			randomAnswers.shuffle()
			CreateQuestion(qnumber)

func _on_GoBack_button_up():
	if get_tree().change_scene("res://Scenes/Menu.tscn") != OK:
		print("Error occured when trying to switch to the Menu.tscn")

