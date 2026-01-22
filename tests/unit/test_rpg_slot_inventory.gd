extends GutTest

var inventory : RPGSlotInventory


func before_each():
	inventory = RPGSlotInventory.new()
	inventory.grid_width = 10
	inventory.grid_height = 10
	add_child_autofree(inventory)  # Limpieza automática para tests


# Test: agregar item con auto-posicionamiento
func test_add_item_auto_position():
	var item = RPGSlotItem.new()
	item.width = 2
	item.height = 2
	item.item_name = "Espada Larga"
	
	var result = inventory.add_item(item)
	
	assert_true(result, "El item debería agregarse exitosamente")
	assert_eq(inventory._slot_items.size(), 1, "El inventario debe contener un item")
	assert_eq(item.position, Vector2i(0, 0), "El item debería posicionarse en (0, 0)")


# Test: agregar item en posición específica
func test_add_item_specific_position():
	var item = RPGSlotItem.new()
	item.width = 1
	item.height = 1
	item.item_name = "Poción"
	
	var result = inventory.add_item(item, Vector2i(5, 5))
	
	assert_true(result, "El item debería agregarse exitosamente")
	assert_eq(item.position, Vector2i(5, 5), "El item debería posicionarse en (5, 5)")


# Test: fallo por espacio insuficiente
func test_add_item_no_space():
	var large_item = RPGSlotItem.new()
	large_item.width = 11
	large_item.height = 1
	large_item.item_name = "Item Grande"
	
	var result = inventory.add_item(large_item)
	
	assert_false(result, "No debería agregarse un item que no cabe")
	assert_eq(inventory._slot_items.size(), 0, "El inventario debe estar vacío")


# Test: remover item por UUID
func test_remove_item_by_uuid():
	var item = RPGSlotItem.new()
	item.width = 1
	item.height = 1
	item.item_name = "Escudo"
	
	inventory.add_item(item)
	var uuid = item.get_instance_id()
	
	var result = inventory.remove_item(uuid)
	
	assert_true(result, "El item debería removerse exitosamente")
	assert_eq(inventory._slot_items.size(), 0, "El inventario debe estar vacío")


# Test: obtener item por UUID
func test_get_item_by_uuid():
	var item = RPGSlotItem.new()
	item.width = 1
	item.height = 1
	item.item_name = "Armadura"
	
	inventory.add_item(item)
	var uuid = item.get_instance_id()
	
	var found_item = inventory.get_item(uuid)
	
	assert_not_null(found_item, "Debería encontrar el item")
	assert_eq(found_item.item_name, item.item_name, "El nombre debe coincidir")


# Test: signal item_added emitida correctamente
func test_item_added_signal():
	watch_signals(inventory)
	
	var item = RPGSlotItem.new()
	item.width = 1
	item.height = 1
	item.item_name = "Anillo"
	
	inventory.add_item(item)
	
	assert_signal_emitted(inventory, "item_added", "La señal item_added debe emitirse")


# Test: signal placement_failed emitida correctamente
func test_placement_failed_signal():
	watch_signals(inventory)
	
	var large_item = RPGSlotItem.new()
	large_item.width = 15
	large_item.height = 15
	large_item.item_name = "Item Gigante"
	
	inventory.add_item(large_item)
	
	assert_signal_emitted(inventory, "placement_failed", "La señal placement_failed debe emitirse")


# Test: validación de límites del grid
func test_grid_bounds_validation():
	var item = RPGSlotItem.new()
	item.width = 5
	item.height = 5
	item.item_name = "Caja"
	
	# Intentar colocar fuera de los límites
	var result = inventory.add_item(item, Vector2i(8, 8))
	
	assert_false(result, "No debería colocar un item fuera de los límites")


# Test: detección de colisiones
func test_collision_detection():
	var item1 = RPGSlotItem.new()
	item1.width = 2
	item1.height = 2
	item1.item_name = "Item1"
	
	var item2 = RPGSlotItem.new()
	item2.width = 2
	item2.height = 2
	item2.item_name = "Item2"
	
	# Colocar primer item
	inventory.add_item(item1, Vector2i(0, 0))
	
	# Intentar colocar segundo item en la misma posición
	var result = inventory.add_item(item2, Vector2i(1, 1))
	
	assert_false(result, "No debería permitir colisión de items")


# Test: obtener posiciones disponibles
func test_get_available_positions():
	var item = RPGSlotItem.new()
	item.width = 2
	item.height = 2
	item.item_name = "Item Ocupante"
	
	inventory.add_item(item, Vector2i(0, 0))
	
	var available = inventory.get_available_positions(Vector2i(1, 1))
	
	assert_true(available.size() > 0, "Debería haber posiciones disponibles")
	assert_false(available.has(Vector2i(0, 0)), "La posición (0,0) no debería estar disponible")


# Test: verificar si el grid está lleno
func test_is_grid_full():
	var small_inventory = RPGSlotInventory.new()
	small_inventory.grid_width = 2
	small_inventory.grid_height = 2
	
	# Llenar el inventario
	for i in range(4):
		var item = RPGSlotItem.new()
		item.width = 1
		item.height = 1
		item.item_name = "Item" + str(i)
		small_inventory.add_item(item)
	
	assert_true(small_inventory.is_grid_full(), "El inventario debería estar lleno")


# Test: obtener slots ocupados
func test_get_occupied_slots():
	var item = RPGSlotItem.new()
	item.width = 2
	item.height = 3
	item.item_name = "Item Grande"
	
	inventory.add_item(item, Vector2i(1, 1))
	
	var occupied = inventory.get_occupied_slots()
	
	assert_eq(occupied.size(), 6, "Debería haber 6 slots ocupados (2x3)")


# Test: obtener items en posición específica
func test_get_items_at_position():
	var item = RPGSlotItem.new()
	item.width = 2
	item.height = 2
	item.item_name = "Item Multi-Slot"
	
	inventory.add_item(item, Vector2i(3, 3))
	
	var items_at_3_3 = inventory.get_items_at_position(Vector2i(3, 3))
	var items_at_4_4 = inventory.get_items_at_position(Vector2i(4, 4))
	var items_at_0_0 = inventory.get_items_at_position(Vector2i(0, 0))
	
	assert_eq(items_at_3_3.size(), 1, "Debería haber un item en (3,3)")
	assert_eq(items_at_4_4.size(), 1, "Debería haber un item en (4,4)")
	assert_eq(items_at_0_0.size(), 0, "No debería haber items en (0,0)")


# Test: auto-posicionamiento izquierda a derecha, arriba a abajo
func test_auto_positioning_order():
	var items: Array[RPGSlotItem] = []
	
	# Agregar varios items pequeños
	for i in range(5):
		var item = RPGSlotItem.new()
		item.width = 1
		item.height = 1
		item.item_name = "Item" + str(i)
		items.append(item)
		inventory.add_item(item)
	
	# Verificar que se posicionaron en orden correcto
	assert_eq(items[0].position, Vector2i(0, 0), "Primer item en (0,0)")
	assert_eq(items[1].position, Vector2i(1, 0), "Segundo item en (1,0)")
	assert_eq(items[2].position, Vector2i(2, 0), "Tercer item en (2,0)")
	assert_eq(items[3].position, Vector2i(3, 0), "Cuarto item en (3,0)")
	assert_eq(items[4].position, Vector2i(4, 0), "Quinto item en (4,0)")


# Test: signal item_removed emitida correctamente
func test_item_removed_signal():
	watch_signals(inventory)
	
	var item = RPGSlotItem.new()
	item.width = 1
	item.height = 1
	item.item_name = "Item Removible"
	
	inventory.add_item(item)
	inventory.remove_item(item.get_instance_id())
	
	assert_signal_emitted(inventory, "item_removed", "La señal item_removed debe emitirse")
