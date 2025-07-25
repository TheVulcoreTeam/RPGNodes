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

# WIP: work in progress

@icon("res://addons/rpg_nodes/icons/RPGItem.png")

extends RPGNode

class_name RPGWeightItem

signal item_name_changed(new_name)
signal description_changed(new_description)
signal weight_updated(new_weight)
signal weight_decreased()
signal weight_increased()


var item_name := "":
	set(value):
		item_name = value
		item_name_changed.emit(value)
	get:
		return item_name

# Item description
var description := "":
	set(value):
		description = value
		description_changed.emit(value)
	get:
		return description

# Item Weight in the inventory
var weight := 1:
	set(value):
		if weight > value:
			weight_increased.emit()
		elif weight < value:
			weight_decreased.emit()
		
		weight = value
		weight_updated.emit(value)
		

var buy_price := 2
var sell_price := 1
