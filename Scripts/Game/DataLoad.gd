extends Control

export (ButtonGroup) var answersButtonGroup

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_path = "res://Databases/main.db"
var massive
var playerHealth


func _ready():
	massive = get_node("/root/Global").question_massive
	playerHealth = get_node("/root/Global").playerHealth
	print("Player HP: "+ str(get_node("/root/Global").playerHealth))

	#Load questions if question massive is empty
	if massive.size() > 0:
		pass 
	else:
		GetQuestionsFromDB();

	for i in answersButtonGroup.get_buttons():
		i.connect("pressed", self, "answerButtonUp")
		
#	print("MASSIVE: ") 
#	print(massive)
#	print("\n")
#	print("GLOBAL: ")
#	print(get_node("/root/Global").question_massive)
#	print("\n")

	CreateQuestion()

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
			"true_answer" : [db.query_result[i]["true_answer"],0],
			"w1" : [db.query_result[i]["w1"],1],
			"w2" : [db.query_result[i]["w2"],1],
			"w3" : [db.query_result[i]["w3"],1],
		}
		massive.append(quest_dict)
	
func CreateQuestion():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var randq = rng.randi_range(0, massive.size()-1)
	get_node("MarginContainer/VBoxContainer/VBoxQuestion/Question").text = massive[randq]["quest"]
	
	get_node("MarginContainer/VBoxContainer/VBoxAnswers/Answer1").text = massive[randq]["true_answer"][0]
	get_node("MarginContainer/VBoxContainer/VBoxAnswers/Answer1").hp_influence = int(massive[randq]["true_answer"][1])
	print(get_node("MarginContainer/VBoxContainer/VBoxAnswers/Answer1").hp_influence)
	
	get_node("MarginContainer/VBoxContainer/VBoxAnswers/Answer2").text = massive[randq]["w1"][0]
	get_node("MarginContainer/VBoxContainer/VBoxAnswers/Answer2").hp_influence = int(massive[randq]["w1"][1])
	print(get_node("MarginContainer/VBoxContainer/VBoxAnswers/Answer2").hp_influence)
	
	get_node("MarginContainer/VBoxContainer/VBoxAnswers/Answer3").text = massive[randq]["w2"][0]
	get_node("MarginContainer/VBoxContainer/VBoxAnswers/Answer3").hp_influence = int(massive[randq]["w2"][1])
	print(get_node("MarginContainer/VBoxContainer/VBoxAnswers/Answer3").hp_influence)
	
	get_node("MarginContainer/VBoxContainer/VBoxAnswers/Answer4").text = massive[randq]["w3"][0]
	get_node("MarginContainer/VBoxContainer/VBoxAnswers/Answer4").hp_influence = int(massive[randq]["w3"][1])
	print(get_node("MarginContainer/VBoxContainer/VBoxAnswers/Answer4").hp_influence)


func answerButtonUp():
	print("Player bi HP: "+ str(get_node("/root/Global").playerHealth))
	get_node("/root/Global").playerHealth = get_node("/root/Global").playerHealth - answersButtonGroup.get_pressed_button().hp_influence
	print("Player ai HP: "+ str(get_node("/root/Global").playerHealth))
	get_node("MarginContainer/VBoxContainer/HealthBar").rect_size = Vector2(64 * float(get_node("/root/Global").playerHealth), 64)
	print(answersButtonGroup.get_pressed_button())
	CreateQuestion()

func _on_GoBack_button_up():
	if get_tree().change_scene("res://Scenes/Menu.tscn") != OK:
		print("Error occured when trying to switch to the Menu.tscn")
		
		
	# Remove the current level
	#var root = get_tree().get_root()
	#level = root.get_node()
	#root.remove_child(level)
	#level.call_deferred("free")

	# Add the next level
	#var next_level_resource = load("res://path/Scenes/Game.tscn")
	
	#var next_level = next_level_resource.instance()
	#root.add_child(next_level)
