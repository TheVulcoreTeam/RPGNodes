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

# Description: A slot inventory is a Diablo-style inventory in which each slot 
#  item has a specific position on the slot inventory grid.

@icon("res://addons/rpg_nodes/icons/RPGSlotInventory.png")

extends RPGNode

class_name RPGSlotInventory

# Error constants
const INVALID_DIMENSIONS = "Item dimensions must be at least 1x1"
const OUT_OF_BOUNDS = "Item would exceed grid boundaries"
const SLOT_OCCUPIED = "One or more slots are already occupied"
const ITEM_NOT_FOUND = "Item not found in inventory"
const NO_SPACE_AVAILABLE = "No available space for item"

# Signals
signal item_added(item: RPGSlotItem, position: Vector2i)
signal item_removed(item: RPGSlotItem)
signal item_position_changed(item: RPGSlotItem, old_position: Vector2i, new_position: Vector2i)
signal placement_failed(item: RPGSlotItem, reason: String)

# Grid configuration
@export var grid_width := 10:
	set(value):
		if value < 1:
			value = 1
		grid_width = value
		_initialize_grid()

@export var grid_height := 10:
	set(value):
		if value < 1:
			value = 1
		grid_height = value
		_initialize_grid()

# Internal storage
var _slot_grid: Array[Array] = []  # 2D array storing item references
var _slot_items: Array[RPGSlotItem] = []


func _ready() -> void:
	_initialize_grid()


# Initialize the grid with null values
func _initialize_grid() -> void:
	_slot_grid.clear()
	for y in range(grid_height):
		var row: Array = []
		for x in range(grid_width):
			row.append(null)
		_slot_grid.append(row)


# Special value for auto-positioning
const AUTO_POSITION = Vector2i(-1, -1)

# Add item to inventory (auto-position if position is AUTO_POSITION)
func add_item(item: RPGSlotItem, position: Vector2i = AUTO_POSITION) -> bool:
	if not _validate_item_dimensions(item):
		placement_failed.emit(item, INVALID_DIMENSIONS)
		return false
	
	var target_position: Vector2i
	if position == AUTO_POSITION:
		target_position = _find_first_available_position(item.get_size())
		if target_position == AUTO_POSITION:
			placement_failed.emit(item, NO_SPACE_AVAILABLE)
			return false
	else:
		target_position = position
		if not _can_place_at(target_position, item.get_size()):
			placement_failed.emit(item, SLOT_OCCUPIED)
			return false
	
	_place_item(item, target_position)
	return true


# Remove item from inventory by UUID
func remove_item(uuid: int) -> bool:
	var item = get_item(uuid)
	if item == null:
		return false
	
	_remove_item(item)
	return true


# Get item by UUID
func get_item(uuid: int) -> RPGSlotItem:
	for item: RPGSlotItem in _slot_items:
		if item.get_instance_id() == uuid:
			return item
	return null


# Check if position is available for item of given size
func _can_place_at(position: Vector2i, item_size: Vector2i) -> bool:
	if position.x < 0 or position.y < 0:
		return false
	if position.x + item_size.x > grid_width:
		return false
	if position.y + item_size.y > grid_height:
		return false
	
	for y in range(item_size.y):
		for x in range(item_size.x):
			if _slot_grid[position.y + y][position.x + x] != null:
				return false
	
	return true


# Find first available position (left to right, top to bottom)
func _find_first_available_position(item_size: Vector2i) -> Vector2i:
	for y in range(grid_height):
		for x in range(grid_width):
			var test_pos = Vector2i(x, y)
			if _can_place_at(test_pos, item_size):
				return test_pos
	return AUTO_POSITION


# Place item at specific position
func _place_item(item: RPGSlotItem, position: Vector2i) -> void:
	item.position = position
	
	for y in range(item.height):
		for x in range(item.width):
			_slot_grid[position.y + y][position.x + x] = item
	
	_slot_items.append(item)
	item_added.emit(item, position)


# Remove item from inventory
func _remove_item(item: RPGSlotItem) -> void:
	var position = item.position
	
	for y in range(item.height):
		for x in range(item.width):
			_slot_grid[position.y + y][position.x + x] = null
	
	_slot_items.erase(item)
	item_removed.emit(item)


# Validate item dimensions
func _validate_item_dimensions(item: RPGSlotItem) -> bool:
	return item.width >= 1 and item.height >= 1


# Get all available positions for item of given size
func get_available_positions(item_size: Vector2i) -> Array[Vector2i]:
	var positions: Array[Vector2i] = []
	for y in range(grid_height):
		for x in range(grid_width):
			var test_pos = Vector2i(x, y)
			if _can_place_at(test_pos, item_size):
				positions.append(test_pos)
	return positions


# Check if grid is completely full
func is_grid_full() -> bool:
	return _find_first_available_position(Vector2i(1, 1)) == AUTO_POSITION


# Get all occupied slots
func get_occupied_slots() -> Array[Vector2i]:
	var occupied: Array[Vector2i] = []
	for y in range(grid_height):
		for x in range(grid_width):
			if _slot_grid[y][x] != null:
				occupied.append(Vector2i(x, y))
	return occupied


# Get items at specific position
func get_items_at_position(position: Vector2i) -> Array[RPGSlotItem]:
	var items: Array[RPGSlotItem] = []
	if position.x >= 0 and position.x < grid_width and position.y >= 0 and position.y < grid_height:
		var item = _slot_grid[position.y][position.x]
		if item != null and items.find(item) == -1:
			items.append(item)
	return items
