# MIT License
#
# Copyright (c) 2026 Matías Muñoz Espinoza
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


extends Node

class_name RPGHotbar


signal item_consumed(slot_index, item)
signal hotbar_changed(hotbar_index, item)

@export var reference_inventory: RPGInventory
@export var slot_amount := 5
## Debe guardar solo RPGItems
var slots := [null, null, null, null, null]


func _ready() -> void:
	slots.resize(slot_amount)


func equip_item(slot, item) -> bool:
	if slot > slot_amount:
		return false
	
	slots[slot] = item
	
	hotbar_changed.emit(slot, item)
	
	return true


func unequip_item(slot) -> bool:
	if slot > slot_amount:
		return false
	
	slots[slot] = null
	
	hotbar_changed.emit(slot, slots[slot])
	
	return true


func consume(slot_index) -> bool:
	if not slots[slot_index]:
		return false
	
	if not slots[slot_index].has_method("consume"):
		return false
	
	# Se consume el item
	slots[slot_index].consume(DataManager.player_data)
	# Se emite señal de que el item fue consumido
	item_consumed.emit(slot_index, slots[slot_index])
	# Se elimina item después de ser consumido
	slots[slot_index] = null
	
	return true


func get_item(idx: int):
	return slots[idx]
