extends Spatial

var tiene_llave = false#si tiene o no tiene la llave de candado
var puerta_abierta = false#si la puerta esta o no abierta

var nodo_animation_candado#esta variable la uso para buscar los nodos en la funcion ready
var nodo_animation_puerta#esta variable la uso para buscar los nodos en la funcion ready
var nodo_Area_candado
var muerto = false#si esta muerto o vivo

export var tiempo_antes_de_conteo = 10#variable para determinar cuantas veces tiene que reproducirse el sonido tiempo conteo
var played_one = false#esta variable es para que se ejecute 1 ves sola el timer conteo en el update ya que el update se ejecuta 60 veses por segundo

# Called when the node enters the scene tree for the first time.
func _ready():
	nodo_animation_candado = get_tree().get_nodes_in_group("animation_candado")[0]#la variable representa el nodo animacion candado que esta en la escena candado
	nodo_animation_puerta = get_tree().get_nodes_in_group("animation_laberinto_cuadrado")[0]#la variable representa el nodo animacion candado que esta en la escena candado
	nodo_Area_candado = get_tree().get_nodes_in_group("Area_candado")[0]#busco el nodo area candado


func _process(delta):#esta funcion se repete 60 veces por segundo
	
	$Interface_UI/tiempo_espera.text = "Tiempo de espera: " + str(int($Timer_espera.time_left) + 1)#cambio el texto de pantalla
	
	if muerto == true:#si esta muerto
		if Input.is_action_just_pressed("click_izquierdo") or Input.is_action_pressed("iniciar_touch"):#si presino click o el centro de la pantalla
			get_tree().change_scene("res://escenas/Menu_principal.tscn")#cambiamos a la escena preincipal
	
	#esto se tiene que ejecutar 1 ves y es para el conteo
	if !$Timer_espera.is_stopped() and int($Timer_espera.time_left) <= tiempo_antes_de_conteo  and !played_one: #si el timer tiempo de espera esta activado y si int tiempo restante es menor o igual a 3 y si nunca se ejecuto
    	$Timer_cuanto_falto.start()#ejecuto el timer para conteo
    	played_one = true#ejectuar 1 ves sola esta linea de codigo
    	
			

		
func _on_Area_candado_body_entered(body):#si un cuerpo entra al area
	if body.is_in_group("esfera"):#si ese cuerpo esta en un grupo esfera
		if tiene_llave == false: #sino tiene la llave
			nodo_animation_candado.play("candado_cerrado")#activa animacion candado cerrado
			$Musica_and_sfx/sfx_puerta_cerrada.playing = true#ejecuta sonido cuando no tenes la llave de la puerta
		if tiene_llave == true: #sino tiene la llave
			desactivar_morir()#desactiva todo lo relacionado a morir
			$Musica_and_sfx/musica_rapida.playing = false#activo musica más rapida
			$Musica_and_sfx/musica_normal.play(30.0)#saca pause de musica normal
			nodo_animation_candado.play("candado_abierto")#activa animacion candado abierto
			$Musica_and_sfx/sfx_puerta_abierta.playing = true #activo sonido puerta abierta
			#esto esta relacionado a abrir la puerta
			yield(nodo_animation_candado, "animation_finished")#cuando termina la animación de candado abierto
			$Musica_and_sfx/sfx_puerta_abierta_2.playing = true#activo efecto sonido puerta 2
			nodo_animation_puerta.play("abrir_puerta")#se abre la puerta
			puerta_abierta = true#ya no puede volverse a abrir porque se abrio
			nodo_Area_candado.queue_free()#esto es para destruir el area donde esta el candado
			$candado.visible = false#esto hace invisible el candado

			
func _on_llave_body_entered(body):
	if body.is_in_group("esfera"):#cuando entra un cuerpo a al area de la llave
		tiene_llave = true	#si entro la esfera tiene la llave
		$Musica_and_sfx/sfx_llave.playing = true #ejecuta sonido agarre llave
		$Musica_and_sfx/musica_normal.playing = false#pauso musica normal
		$Musica_and_sfx/musica_rapida.playing = true#activo musica más rapida
		$Interface_UI/tiempo_espera.visible = true#hace que el texto de espera sea visible
		$Timer_espera.start()
		$llave_y_candado/llave.queue_free()#elimino la llave porque ya la tengo
		$animacion_mundo.play("claridad_mundo")
		


func _on_Timer_espera_timeout():
	$Timer_cuanto_falto.stop()#detengo el timer para conteo final
	$AnimationPlayerPrincipal.play("Game_over_animacion")#activa la animacion Game over
	$Interface_UI/tiempo_espera.visible = false#se deja de ver el texto tiempo de espera
	$personaje/esfera.queue_free()#destruyo la esfera
	$Interface_UI/colorfondoMuerte.visible = true #activa un fondo negro para mostrar que perdiste
	$Musica_and_sfx/musica_rapida.playing = false#desactivo la musica rapida
	$Musica_and_sfx/muerte_sonido.playing = true#activo sonido muerte
	$Musica_and_sfx/lose_sonido.playing = true#activo sonido lose sonido
	muerto = true #si paso el tiempo moriste
	var botones = $botones_tactiles.get_children()#tomo todos los botones
	for i in botones:
		if i.name != "iniciar_touch":#mientras no sea el boton para reiniciar touch hago todos transparentes
			i.visible = false
	

func _on_Timer_cuanto_falto_timeout():#cada ves que pasa 1 segundo en el conteo
	$Musica_and_sfx/conteo_sonido.playing = true#se ejecuta el sonido conteo
	
func desactivar_morir():
	$Timer_cuanto_falto.stop()
	$Timer_espera.stop()
	$animacion_mundo.play_backwards("claridad_mundo")#activa la animación pero al reves
	$Interface_UI/tiempo_espera.visible = false


func _on_area_winner_body_entered(body):
	if body.is_in_group("esfera"):
		$Musica_and_sfx/winner_sonido.playing = true#activa sonido winner
		$Musica_and_sfx/musica_normal.playing = false#desactiva musica normal
		$Interface_UI/Winner_texto.visible = true#hace visible el texto winner
		yield($Musica_and_sfx/winner_sonido,"finished")#detengo el flujo de codigo hasta que termine el sonido
		$Interface_UI/Winner_texto.visible = false#hace visible el texto winner
		$AnimationPlayerPrincipal.play("Game_over_animacion")#activamos la animacion game over ya que teminaste el juego
		$personaje/esfera.sleeping = true
		muerto = true
		var botones = $botones_tactiles.get_children()#tomo todos los botones
		for i in botones:
			if i.name != "iniciar_touch":#mientras no sea el boton para reiniciar touch hago todos transparentes
				i.visible = false
