extends GutTest

var inventory : RPGWeightInventory


func before_each():
	inventory = RPGWeightInventory.new()


func test_add_and_remove_item():
	var item = RPGWeightItem
