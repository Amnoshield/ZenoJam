extends Node


var part_sprite = "res://assets/ui/abilities/screwdriver.png" #The sprite for the part (idk how this will work)
var title = "Double knockback"
var discription = """Push enemies back more"""
var background_sprite = null #The sprite for the backround (idk how this will work)


func affect(entity): #applay the effect to the entity. ie: entity.damage /= 2
	entity.entity_knockback *= 2
