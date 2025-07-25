# MIT License
#
# Copyright (c) 2018 - 2025 Matías Muñoz Espinoza
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

# WIP: work in progress

@icon("res://addons/rpg_nodes/icons/RPGWeightInventory.png")

extends RPGNode

class_name RPGWeightInventory


const CANT_ADD = "You can't add this item: "
const ITEM_WEIGHT = "Item weight: "
const WEIGHT_INVETORY  = "Weight Inventory: "
const FULL_INVENTORY = "The Weight Inventory is full"

signal weight_filled()
signal weight_changed(new_value : int)

var _weight_inventory : Array[RPGWeightItem] = []

var weight := 0:
	get:
		return weight

var max_weight := 100:
	set(value):
		max_weight = value
	get:
		return max_weight


# Add item
func add_item(item : RPGWeightItem):
	if item.weight + weight <= max_weight:
		_weight_inventory.append(item)
		weight += item.weight
		weight_changed.emit(weight)
		
		if weight == max_weight:
			weight_filled.emit()
	else:
		self._print(
			str(
				CANT_ADD + item.item_name,
				FULL_INVENTORY,
				ITEM_WEIGHT + str(item.weight),
				WEIGHT_INVETORY + str(weight)
			)
		)


# Get item by item_name
func get_item(item_name : String):
	return _weight_inventory.filter(
		func(item): 
			return item.item_name == item_name
	)[0]


# Remove a item by item_name
func remove_item(item_name : String):
	for item in _weight_inventory:
		if item.item_name == item_name:
			weight -= item.weight
			_weight_inventory.remove_at(_weight_inventory.find(item))
			weight_changed.emit(weight)
			break
