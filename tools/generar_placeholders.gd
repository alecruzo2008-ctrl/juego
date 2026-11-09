extends SceneTree

func _init() -> void:
	DirAccess.make_dir_recursive_absolute("res://assets/animals")
	DirAccess.make_dir_recursive_absolute("res://assets/environment")
	var oso := Image.create(32, 32, false, Image.FORMAT_RGBA8)
	oso.fill(Color("#72513b"))
	oso.save_png("res://assets/animals/oso.png")
	var tiles := Image.create(128, 32, false, Image.FORMAT_RGBA8)
	var colores := [Color("#7eaa60"), Color("#477c3d"), Color("#315b36"), Color("#397c9b")]
	for i in range(4):
		for y in range(32):
			for x in range(32):
				tiles.set_pixel(i * 32 + x, y, colores[i])
	tiles.save_png("res://assets/environment/tiles.png")
	quit()

