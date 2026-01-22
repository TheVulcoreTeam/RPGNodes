# MIT License
#
# Copyright (c) 2025 Matías Muñoz Espinoza
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
#
# Description: A slot item can have one or certain specific positions in a slot 
#   inventory.

@icon("res://addons/rpg_nodes/icons/RPGItem.png")

class_name RPGSlotItem extends RPGItem


signal dimensions_changed(old_width: int, old_height: int, new_width: int, new_height: int)
signal position_changed(old_position: Vector2i, new_position: Vector2i)


## Item width in the slot grid (minimum 1)
@export var width := 1:
	set(value):
		if value < 1:
			value = 1
		if width != value:
			dimensions_changed.emit(width, height, value, height)
			width = value
	get:
		return width


## Item height in the slot grid (minimum 1)
@export var height := 1:
	set(value):
		if value < 1:
			value = 1
		if height != value:
			dimensions_changed.emit(width, height, width, value)
			height = value
	get:
		return height


## Current position in the slot inventory (managed by RPGSlotInventory)
var position: Vector2i:
	set(value):
		if position != value:
			position_changed.emit(position, value)
			position = value
	get:
		return position


## Get item size as Vector2i
func get_size() -> Vector2i:
	return Vector2i(width, height)


## Get all grid cells occupied by this item
func get_occupied_cells() -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for y in range(height):
		for x in range(width):
			cells.append(position + Vector2i(x, y))
	return cells


## Check if this item can be placed at the given position within grid bounds
func can_place_at(grid_position: Vector2i, grid_size: Vector2i) -> bool:
	if grid_position.x < 0 or grid_position.y < 0:
		return false
	if grid_position.x + width > grid_size.x:
		return false
	if grid_position.y + height > grid_size.y:
		return false
	return true
