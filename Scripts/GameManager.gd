extends Node

var score: int = 0
@onready var coins = %Coins

func add_point():
	score += 1
	coins.text = "Coins: " + str(score)
	if score == 7:
		coins.text = "Hola muñeca, quieres una fruta?"
		
