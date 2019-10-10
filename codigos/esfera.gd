extends RigidBody

export var velocidad = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	


func _physics_process(delta):
	
	print(linear_velocity)
	
	
	if get_tree().get_nodes_in_group("Escena_principal")[0].muerto == false:#mientras no este muerto puedo ejecutar esto 	
		#esto es para mover la esfera y hacerla rotar cuando presionamos las teclas
		if Input.is_action_pressed("d") or Input.is_action_pressed("touch_derecha"): #si presiono la tecla D
			linear_velocity.x = velocidad #aplico una lineal velocidad en el eje X de 1
		if Input.is_action_pressed("a")or Input.is_action_pressed("touch_izquierda"): #si presiono la tecla D
			linear_velocity.x = -velocidad #aplico una lineal velocidad en el eje X de 1
		if Input.is_action_pressed("s")or Input.is_action_pressed("touch_abajo"): #si presiono la tecla D
			linear_velocity.z = velocidad #aplico una lineal velocidad en el eje X de 1
		if Input.is_action_pressed("w")or Input.is_action_pressed("touch_arriba"): #si presiono la tecla D
			linear_velocity.z = -velocidad #aplico una lineal velocidad en el eje X de 1
		
		#si soltas una tecla
		if Input.is_action_just_released("a") or Input.is_action_just_released("d") or Input.is_action_just_released("s") or Input.is_action_just_released("w"):#si suelto algunas de esas teclas
			linear_velocity.z = lerp(linear_velocity.z,0,0.5) #la esfera no se mueve en el eje z y uso una interpolación para que el movimiento a estatico no sea tan brusco
			linear_velocity.x = lerp(linear_velocity.x,0,0.5) #la esfera no se mueve en el eje x y uso una interpolación para que el movimiento a estatico no sea tan brusco
		#si soltas un touch
		if Input.is_action_just_released("touch_derecha") or Input.is_action_just_released("click_izquierdo") or Input.is_action_just_released("touch_abajo") or Input.is_action_just_released("touch_arriba"):#si suelto algunas de esas teclas
			linear_velocity.z = lerp(linear_velocity.z,0,0.5) #la esfera no se mueve en el eje z y uso una interpolación para que el movimiento a estatico no sea tan brusco
			linear_velocity.x = lerp(linear_velocity.x,0,0.5) #la esfera no se mueve en el eje x y uso una interpolación para que el movimiento a estatico no sea tan brusco

		
