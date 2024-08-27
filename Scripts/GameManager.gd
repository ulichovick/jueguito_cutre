extends Node

var score: int = 0
@onready var coins = $"../Counter/Control/CenterContainer/Coins"

func add_point():
	score += 1
	coins.text = "Coins: " + str(score)
