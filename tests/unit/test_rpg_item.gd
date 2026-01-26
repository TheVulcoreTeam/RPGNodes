extends GutTest

var rpg_item: RPGItem


func before_each():
	rpg_item = RPGItem.new()


func after_each():
	rpg_item = null


# Item Name test
func test_item_name_default_value():
	assert_eq(rpg_item.item_name, "", "item_name should be empty by default")


func test_item_name_can_be_set():
	rpg_item.item_name = "Poción de Salud"
	assert_eq(rpg_item.item_name, "Poción de Salud", "item_name should be set correctly")


func test_item_name_changed_signal_is_emitted():
	watch_signals(rpg_item)
	rpg_item.item_name = "Espada"
	assert_signal_emitted(rpg_item, "item_name_changed", "Signal should be emitted when item_name changes")


func test_item_name_changed_signal_parameters():
	watch_signals(rpg_item)
	rpg_item.item_name = "Inicial"
	rpg_item.item_name = "Cambiado"
	assert_signal_emitted_with_parameters(
		rpg_item, 
		"item_name_changed", 
		["Inicial", "Cambiado"]
	)


func test_item_name_signal_not_emitted_when_same_value():
	watch_signals(rpg_item)
	rpg_item.item_name = "Mismo"
	rpg_item.item_name = "Mismo"
	assert_signal_emit_count(rpg_item, "item_name_changed", 1, "Signal should only emit once")


# Tests para description
func test_description_default_value():
	assert_eq(rpg_item.description, "", "description should be empty by default")


func test_description_can_be_set():
	rpg_item.description = "Una poción que restaura salud"
	assert_eq(rpg_item.description, "Una poción que restaura salud", "description should be set correctly")


func test_description_changed_signal_is_emitted():
	watch_signals(rpg_item)
	rpg_item.description = "Nueva descripción"
	assert_signal_emitted(rpg_item, "description_changed", "Signal should be emitted when description changes")


func test_description_changed_signal_parameters():
	watch_signals(rpg_item)
	rpg_item.description = "Vieja"
	rpg_item.description = "Nueva"
	assert_signal_emitted_with_parameters(
		rpg_item, 
		"description_changed", 
		["Vieja", "Nueva"]
	)


func test_description_signal_not_emitted_when_same_value():
	watch_signals(rpg_item)
	rpg_item.description = "Igual"
	rpg_item.description = "Igual"
	assert_signal_emit_count(rpg_item, "description_changed", 1, "Signal should only emit once")


# Tests para buy_price
func test_buy_price_default_value():
	assert_eq(rpg_item.buy_price, 2, "buy_price should be 2 by default")


func test_buy_price_can_be_set():
	rpg_item.buy_price = 100
	assert_eq(rpg_item.buy_price, 100, "buy_price should be set correctly")


func test_buy_price_changed_signal_is_emitted():
	watch_signals(rpg_item)
	rpg_item.buy_price = 50
	assert_signal_emitted(rpg_item, "buy_price_changed", "Signal should be emitted when buy_price changes")


func test_buy_price_changed_signal_parameters():
	watch_signals(rpg_item)
	rpg_item.buy_price = 25
	rpg_item.buy_price = 75
	assert_signal_emitted_with_parameters(
		rpg_item, 
		"buy_price_changed", 
		[25, 75]
	)


func test_buy_price_signal_not_emitted_when_same_value():
	watch_signals(rpg_item)
	rpg_item.buy_price = 10
	rpg_item.buy_price = 10
	assert_signal_emit_count(rpg_item, "buy_price_changed", 1, "Signal should only emit once")


# Tests para sell_price
func test_sell_price_default_value():
	assert_eq(rpg_item.sell_price, 1, "sell_price should be 1 by default")


func test_sell_price_can_be_set():
	rpg_item.sell_price = 50
	assert_eq(rpg_item.sell_price, 50, "sell_price should be set correctly")


func test_sell_price_changed_signal_is_emitted():
	watch_signals(rpg_item)
	rpg_item.sell_price = 25
	assert_signal_emitted(rpg_item, "sell_price_changed", "Signal should be emitted when sell_price changes")


func test_sell_price_changed_signal_parameters():
	watch_signals(rpg_item)
	rpg_item.sell_price = 10
	rpg_item.sell_price = 30
	assert_signal_emitted_with_parameters(
		rpg_item, 
		"sell_price_changed", 
		[10, 30]
	)


func test_sell_price_signal_not_emitted_when_same_value():
	watch_signals(rpg_item)
	rpg_item.sell_price = 5
	rpg_item.sell_price = 5
	assert_signal_emit_count(rpg_item, "sell_price_changed", 1, "Signal should only emit once")


# Tests para get_dictionary()
func test_get_dictionary_returns_correct_structure():
	rpg_item.item_name = "Espada"
	rpg_item.description = "Una espada afilada"
	rpg_item.buy_price = 100
	rpg_item.sell_price = 50
	
	var dict = rpg_item.to_dict()
	
	assert_has(dict, "ITEM_NAME", "Dictionary should have ITEM_NAME key")
	assert_has(dict, "DESCRIPTION", "Dictionary should have DESCRIPTION key")
	assert_has(dict, "BUY_PRICE", "Dictionary should have BUY_PRICE key")
	assert_has(dict, "SELL_PRICE", "Dictionary should have SELL_PRICE key")


func test_get_dictionary_returns_correct_values():
	rpg_item.item_name = "Poción"
	rpg_item.description = "Cura 50 HP"
	rpg_item.buy_price = 20
	rpg_item.sell_price = 10
	
	var dict = rpg_item.to_dict()
	
	assert_eq(dict["ITEM_NAME"], "Poción", "ITEM_NAME should match")
	assert_eq(dict["DESCRIPTION"], "Cura 50 HP", "DESCRIPTION should match")
	assert_eq(dict["BUY_PRICE"], 20, "BUY_PRICE should match")
	assert_eq(dict["SELL_PRICE"], 10, "SELL_PRICE should match")


func test_get_dictionary_with_default_values():
	var dict = rpg_item.to_dict()
	
	assert_eq(dict["ITEM_NAME"], "", "ITEM_NAME should be empty")
	assert_eq(dict["DESCRIPTION"], "", "DESCRIPTION should be empty")
	assert_eq(dict["BUY_PRICE"], 2, "BUY_PRICE should be 2")
	assert_eq(dict["SELL_PRICE"], 1, "SELL_PRICE should be 1")


# Tests para get_rpgitem_from_dictionary()
func test_get_rpgitem_from_dictionary_creates_item_with_correct_values():
	var dict = {
		"ITEM_NAME": "Escudo",
		"DESCRIPTION": "Protege del daño",
		"BUY_PRICE": 150,
		"SELL_PRICE": 75
	}
	
	var new_item = RPGItem.new()
	new_item.from_dict(dict)
	
	assert_eq(new_item.item_name, "Escudo", "item_name should match")
	assert_eq(new_item.description, "Protege del daño", "description should match")
	assert_eq(new_item.buy_price, 150, "buy_price should match")
	assert_eq(new_item.sell_price, 75, "sell_price should match")


func test_get_rpgitem_from_dictionary_with_invalid_dict_returns_default_item():
	var invalid_dict = {
		"ITEM_NAME": "Incompleto"
	}
	
	var new_item = RPGItem.new()
	new_item.from_dict(invalid_dict)
	
	assert_eq(new_item.item_name, "", "Should return default item with empty name")
	assert_eq(new_item.buy_price, 2, "Should return default item with default buy_price")
	assert_eq(new_item.sell_price, 1, "Should return default item with default sell_price")


func test_get_rpgitem_from_dictionary_with_empty_dict_returns_default_item():
	var empty_dict = {}
	
	var new_item = RPGItem.new()
	new_item.from_dict(empty_dict)
	
	assert_eq(new_item.item_name, "", "Should return default item")
	assert_eq(new_item.description, "", "Should return default item")


func test_get_rpgitem_from_dictionary_roundtrip():
	rpg_item.item_name = "Anillo Mágico"
	rpg_item.description = "Aumenta el poder mágico"
	rpg_item.buy_price = 500
	rpg_item.sell_price = 250
	
	var dict = rpg_item.to_dict()
	var new_item = RPGItem.new()
	new_item.from_dict(dict)
	
	assert_eq(new_item.item_name, rpg_item.item_name, "Roundtrip should preserve item_name")
	assert_eq(new_item.description, rpg_item.description, "Roundtrip should preserve description")
	assert_eq(new_item.buy_price, rpg_item.buy_price, "Roundtrip should preserve buy_price")
	assert_eq(new_item.sell_price, rpg_item.sell_price, "Roundtrip should preserve sell_price")


# Tests para _validate_rpgitem_dict_data()
func test_validate_rpgitem_dict_data_with_valid_dict():
	var valid_dict = {
		"ITEM_NAME": "Test",
		"DESCRIPTION": "Test",
		"BUY_PRICE": 10,
		"SELL_PRICE": 5
	}
	
	assert_true(
		rpg_item._validate_rpgitem_dict_data(valid_dict),
		"Should validate correct dictionary"
	)


func test_validate_rpgitem_dict_data_with_missing_keys():
	var invalid_dict = {
		"ITEM_NAME": "Test",
		"BUY_PRICE": 10
	}
	
	assert_false(
		rpg_item._validate_rpgitem_dict_data(invalid_dict),
		"Should not validate dictionary with missing keys"
	)


func test_validate_rpgitem_dict_data_with_extra_keys():
	var dict_with_extra = {
		"ITEM_NAME": "Test",
		"DESCRIPTION": "Test",
		"BUY_PRICE": 10,
		"SELL_PRICE": 5,
		"EXTRA_KEY": "Extra"
	}
	
	assert_true(
		rpg_item._validate_rpgitem_dict_data(dict_with_extra),
		"Should validate dictionary even with extra keys"
	)


func test_validate_rpgitem_dict_data_with_empty_dict():
	var empty_dict = {}
	
	assert_false(
		rpg_item._validate_rpgitem_dict_data(empty_dict),
		"Should not validate empty dictionary"
	)
