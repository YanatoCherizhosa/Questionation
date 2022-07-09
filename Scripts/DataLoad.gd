extends Control

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_path = "res://Databases/main.db"

func _ready():
	db = SQLite.new()
	db.path = db_path
	db.open_db()
	var tableName = "questions"
	var dict : Dictionary = Dictionary()
	db.query("select * from"+tableName+";")
	var result = db.query_result_by_reference()

