extends Node


var part_sprite = "res://assets/ui/abilities/screwdriver.png"
var title = "Double damage"
var discription = """Deal more damage"""
var background_sprite = null


func affect(entity):
	entity.damage *= 2
