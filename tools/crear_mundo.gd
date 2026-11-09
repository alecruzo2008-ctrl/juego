extends SceneTree

func _init() -> void:
	var tileset := TileSet.new()
	tileset.tile_size = Vector2i(32, 32)
	tileset.add_physics_layer()
	var fuente := TileSetAtlasSource.new()
	fuente.texture = load("res://assets/environment/tiles.png")
	fuente.texture_region_size = Vector2i(32, 32)
	tileset.add_source(fuente)
	for i in range(4):
		fuente.create_tile(Vector2i(i, 0))
		if i >= 2:
			var datos := fuente.get_tile_data(Vector2i(i, 0), 0)
			datos.add_collision_polygon(0)
			datos.set_collision_polygon_points(0, 0, PackedVector2Array([Vector2(-16, -16), Vector2(16, -16), Vector2(16, 16), Vector2(-16, 16)]))
	ResourceSaver.save(tileset, "res://assets/environment/tileset.tres")
	var raiz := Node2D.new()
	raiz.name = "Mundo"
	raiz.set_script(load("res://scripts/mundo_controlador.gd"))
	var mapa := TileMapLayer.new()
	mapa.name = "Mapa"
	mapa.tile_set = tileset
	raiz.add_child(mapa)
	mapa.owner = raiz
	for y in range(30):
		for x in range(40):
			var borde := x == 0 or y == 0 or x == 39 or y == 29
			var obstaculo := (x in range(8, 13) and y in range(6, 18)) or (x in range(22, 25) and y in range(4, 15)) or (x in range(30, 36) and y in range(19, 23))
			var tile := 2 if borde or obstaculo else (1 if (x + y) % 6 == 0 else 0)
			mapa.set_cell(Vector2i(x, y), 0, Vector2i(tile, 0))
	var jugador: Node2D = load("res://scenes/jugador.tscn").instantiate()
	jugador.position = Vector2(160, 160)
	raiz.add_child(jugador)
	jugador.owner = raiz
	var escena := PackedScene.new()
	escena.pack(raiz)
	ResourceSaver.save(escena, "res://scenes/mundo.tscn")
	raiz.free()
	quit()

