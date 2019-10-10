extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_pressed("click_izquierdo"):#si presiono click izquierdo
		get_tree().change_scene("res://escenas/Escena_principal.tscn")#cambiamos a la escena preincipal
	if Input.is_action_pressed("iniciar_touch"):#si presiono click izquierdo
		get_tree().change_scene("res://escenas/Escena_principal.tscn")#cambiamos a la escena preincipal

	