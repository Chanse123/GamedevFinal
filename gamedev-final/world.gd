extends Node2D

var scrap = 0

func add_scrap():
	scrap += 1
	print("add_scrap called, scrap is now: ", scrap)
	$UI/Label.text = "Scrap: " + str(scrap)
