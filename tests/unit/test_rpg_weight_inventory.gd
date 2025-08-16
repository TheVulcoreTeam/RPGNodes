extends GutTest

var inventory : RPGWeightInventory

func before_each():
	# Se ejecuta antes de cada test.
	inventory = RPGWeightInventory.new()
	inventory.max_weight = 10   # valor de prueba (puedes cambiarlo)

# ------------------------------------------------------------------
# Test: agregar un item cuando hay espacio suficiente
func test_add_item_success():
	var item = RPGWeightItem.new()
	item.weight = 3
	item.item_name = "Poción"

	# Se espera que el método devuelva true (o que no haya error)
	inventory.add_item(item)

	assert_eq(inventory._weight_inventory.size(), 1, "El inventario debe contener un item")
	assert_eq(inventory.weight, 3, "Peso total del inventario debería ser 3")

# ------------------------------------------------------------------
# Test: no se puede agregar si supera el peso máximo
#func test_add_item_overflow():
	#var item = load("res://src/RPGWeightItem.gd").new()
	#item.weight = 15   # > max_weight (10)
	#item.item_name = "Armadura"
#
	## Capturamos la impresión de consola para verificar el mensaje
	#var printed_texts = []
	#inventory.connect("weight_changed", func(val): pass)  # no hacer nada
	#inventory.connect("weight_filled", func(): pass)
#
	## GUT permite interceptar `print` con un callback
	#var original_print = print
	#print = func():
		#printed_texts.append(str(...))
#
	#inventory.add_item(item)
#
	## Restauramos la función original de print
	#print = original_print
#
	#assert_eq(inventory._weight_inventory.size(), 0, "No debe añadirse el item")
	#assert_ne(printed_texts.size(), 0, "Debe haber un mensaje de error")
#
## ------------------------------------------------------------------
## Test: eliminar por UUID
#func test_remove_item_by_uuid():
	#var item1 = load("res://src/RPGWeightItem.gd").new()
	#item1.weight = 2
	#inventory.add_item(item1)
#
	#var uuid = item1.get_instance_id()
	#assert_true(inventory.remove_item(uuid), "El método debe devolver true")
	#assert_eq(inventory._weight_inventory.size(), 0, "Inventario vacío después de remover")
#
## ------------------------------------------------------------------
## Test: obtener un item por UUID
#func test_get_item_by_uuid():
	#var item2 = load("res://src/RPGWeightItem.gd").new()
	#item2.weight = 4
	#inventory.add_item(item2)
#
	#var uuid = item2.get_instance_id()
	#var found = inventory.get_item(uuid)
	#assert_not_null(found, "Debe encontrar el item")
	#assert_eq(found.item_name, item2.item_name, "El nombre debe coincidir")
#
## ------------------------------------------------------------------
## Test: señal `weight_changed` se emite correctamente
#func test_weight_changed_signal():
	#var called = false
	#inventory.connect("weight_changed", func(new_val):
		#called = true
		#assert_eq(new_val, 5)
	#)
#
	#var item3 = load("res://src/RPGWeightItem.gd").new()
	#item3.weight = 5
	#inventory.add_item(item3)
#
	#assert_true(called, "La señal weight_changed debe haberse emitido")
#
## ------------------------------------------------------------------
## Test: señal `weight_filled` cuando alcanza el límite exacto
#func test_weight_filled_signal():
	#var called = false
	#inventory.connect("weight_filled", func():
		#called = true
	#)
#
	#var item4 = load("res://src/RPGWeightItem.gd").new()
	#item4.weight = 10   # igual a max_weight
	#inventory.add_item(item4)
#
	#assert_true(called, "La señal weight_filled debe haberse emitido")
