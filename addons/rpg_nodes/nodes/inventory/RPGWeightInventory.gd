# MIT License
#
# Copyright (c) 2018 - 2026 Matías Muñoz Espinoza
# Copyright (c) 2018 Jovani Pérez
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Description: Inventory weight based

@icon("res://addons/rpg_nodes/icons/RPGWeightInventory.png")

extends RPGInventory
class_name RPGWeightInventory

const CANT_ADD = "You can't add this item: "
const ITEM_WEIGHT = "Item weight: "
const WEIGHT_INVETORY = "Weight Inventory: "
const FULL_INVENTORY = "The Weight Inventory is full"
const ITEM_NOT_EXIST = "The RPGWeightItem not exist"


signal weight_filled()
signal weight_changed(old_value: int, new_value: int)

signal weight_item_added(item_added: RPGWeightItem)
signal weight_item_droped(item_droped: RPGWeightItem)
signal weight_item_removed(item_removed: RPGWeightItem)


var _weight_inventory: Array[RPGWeightItem] = []:
	set(value):
		pass
	get:
		return _weight_inventory


var _weight := 0:
	set(value):
		if _weight != value:
			weight_changed.emit(_weight, value)
			_weight = value
			
			if _weight == max_weight:
				weight_filled.emit()
	get:
		return _weight


var max_weight := 100:
	set(value):
		max_weight = value
	get:
		return max_weight


## Add item
func add_item(item: RPGItem) -> bool:
	# Guard
	if not item:
		#self._print(ITEM_NOT_EXIST)
		return false
	
	if item.weight + _weight <= max_weight:
		_weight_inventory.append(item)
		weight_item_added.emit(item)
		_weight += item.weight
		return true
	else:
		#self._print(
			#str(
				#CANT_ADD + item.item_name,
				#FULL_INVENTORY,
				#ITEM_WEIGHT + str(item.weight),
				#WEIGHT_INVETORY + str(_weight)
			#)
		#)
		return false

## Retrieve an item from the inventory based on its UUID. if not found, 
## returns null.
func get_item(uuid: int) -> RPGWeightItem:
	for item: RPGWeightItem in _weight_inventory:
		if item.get_instance_id() == uuid:
			return item
	
	return null


## Removes an item by its UUID. Returns true if the removal succeeded,
## otherwise returns false.
func remove_item(uuid: int) -> bool:
	for idx: int in _weight_inventory.size():
		if _weight_inventory[idx].get_instance_id() == uuid:
			_weight -= _weight_inventory[idx].weight
			_weight_inventory.remove_at(idx)
			return true
	
	return false


## Moves an item from this inventory to another.
## Returns true if the move was successful, false otherwise.
func move(item: RPGWeightItem, target_inventory: RPGWeightInventory) -> bool:
	if not item or not target_inventory:
		return false
		
	if target_inventory == self:
		return false
		
	var idx := _weight_inventory.find(item)
	if idx == -1:
		return false
		
	if target_inventory.add_item(item):
		_weight -= item.weight
		_weight_inventory.remove_at(idx)
		weight_item_removed.emit(item)
		return true
		
	return false


## Apila los items del mismo tipo según su nombre (item_name).
## Retorna un diccionario donde la clave es el nombre del item, y el valor
## es un diccionario con el "item" base, la cantidad "amount", y una lista "items".
func get_stacked_items() -> Dictionary:
	var stacked := {}
	
	for item: RPGWeightItem in _weight_inventory:
		var key := item.item_name
		
		if stacked.has(key):
			stacked[key]["amount"] += 1
			stacked[key]["items"].append(item)
		else:
			var items_array: Array[RPGWeightItem] = [item]
			stacked[key] = {
				"item": item,
				"amount": 1,
				"items": items_array
			}
			
	return stacked
