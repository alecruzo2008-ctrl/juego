extends SceneTree

func _init() -> void:
	var raiz := CharacterBody2D.new()
	raiz.name = "Jugador"
	raiz.set_script(load("res://scripts/jugador.gd"))
	var sprite := Sprite2D.new()
	sprite.name = "Sprite"
	sprite.texture = load("res://assets/animals/oso.png")
	raiz.add_child(sprite)
	sprite.owner = raiz
	var forma := CollisionShape2D.new()
	forma.name = "Colision"
	var capsula := CapsuleShape2D.new()
	capsula.radius = 12.0
	capsula.height = 28.0
	forma.shape = capsula
	raiz.add_child(forma)
	forma.owner = raiz
	var camara := Camera2D.new()
	camara.name = "Camara"
	camara.enabled = true
	raiz.add_child(camara)
	camara.owner = raiz
	var escena := PackedScene.new()
	escena.pack(raiz)
	ResourceSaver.save(escena, "res://scenes/jugador.tscn")
	quit()

