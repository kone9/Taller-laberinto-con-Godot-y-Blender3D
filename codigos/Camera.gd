extends Camera

# Declare member variables here. Examples:
# var a = 2
var escena_principal

# Called when the node enters the scene tree for the first time.
func _ready():
	escena_principal = get_tree().get_nodes_in_group("Escena_principal")[0]

func _physics_process(delta):
	if escena_principal.muerto == false:#la camara sigue a la esfera solo cuando esta viva la esfera
		translation.z = get_tree().get_nodes_in_group("esfera")[0].translation.z #la posicion en z de la camara es igual a la de la esfera
		translation.x = get_tree().get_nodes_in_group("esfera")[0].translation.x #la posicion en x de la camara es igual a la de la esfera

