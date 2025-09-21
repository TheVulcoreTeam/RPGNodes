extends GutTest

var inventory : RPGWeightInventory

func before_each():
	# Se ejecuta antes de cada test.
	inventory = RPGWeightInventory.new()
	inventory.max_weight = 10   # valor de prueba (puedes cambiarlo)


# Test: agregar un item cuando hay espacio suficiente
func test_add_item_success():
	var item = RPGWeightItem.new()
	item.weight = 3
	item.item_name = "Poción"

	# Se espera que el método devuelva true (o que no haya error)
	inventory.add_item(item)

	assert_eq(inventory._weight_inventory.size(), 1, "El inventario debe contener un item")
	assert_eq(inventory._weight, 3, "Peso total del inventario debería ser 3")


# Test: no se puede agregar si supera el peso máximo
func test_add_item_overflow():
	var item = RPGWeightItem.new()
	item.weight = 15   # > max_weight (10)
	item.item_name = "Armadura"
	
	inventory.add_item(item)
	
	assert_eq(inventory._weight_inventory.size(), 0, "No debe añadirse el item")


# Test: eliminar por UUID
func test_remove_item_by_uuid():
	var item1 = RPGWeightItem.new()
	item1.weight = 2
	inventory.add_item(item1)

	var uuid = item1.get_instance_id()
	assert_true(inventory.remove_item(uuid), "El método debe devolver true")
	assert_eq(inventory._weight_inventory.size(), 0, "Inventario vacío después de remover")


# Test: obtener un item por UUID
func test_get_item_by_uuid():
	var item2 = RPGWeightItem.new()
	item2.weight = 4
	item2.item_name = "Sword"
	inventory.add_item(item2)

	var uuid = item2.get_instance_id()
	var item_found = inventory.get_item(uuid)
	assert_not_null(item_found, "Debe encontrar el item")
	assert_eq(item_found.item_name, item2.item_name, "El nombre debe coincidir")


# Test: señal `weight_changed` se emite correctamente
func test_weight_changed_signal():
	watch_signals(inventory)
	
	var test_weight_changed = func(old_value, new_value):
		assert_eq(old_value, 0)
		assert_eq(new_value, 5)
	
	inventory.connect("weight_changed", test_weight_changed)
	
	var item3 = RPGWeightItem.new()
	item3.weight = 5
	inventory.add_item(item3)
	
	assert_signal_emitted(inventory, "weight_changed", "La señal weight_changed debe haberse emitido")


# Test: señal `weight_filled` cuando alcanza el límite exacto
func test_weight_filled_signal():
	watch_signals(inventory)
	
	var item4 = RPGWeightItem.new()
	item4.weight = 10   # igual a max_weight
	inventory.add_item(item4)
	
	assert_signal_emitted(inventory, "weight_filled", "La señal weight_filled debe haberse emitido")
