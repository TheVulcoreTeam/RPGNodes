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

@icon("res://addons/rpg_nodes/icons/RPGItem.png")

@abstract class_name RPGItem extends Resource


signal item_name_changed(old_name, new_name)
signal description_changed(old_description, new_description)

signal buy_price_changed(old_value, new_value)
signal sell_price_changed(old_value, new_value)


## Item name
var item_name := "":
	set(value):
		if item_name != value:
			item_name_changed.emit(item_name, value)
			item_name = value
	get:
		return item_name


## Item description
var description := "":
	set(value):
		if description != value:
			description_changed.emit(description, value)
			description = value
	get:
		return description


## Item buy price
var buy_price := 2:
	set(value):
		if buy_price != value:
			buy_price_changed.emit(buy_price, value)
			buy_price = value
	get:
		return buy_price


## Item sell price
var sell_price := 1:
	set(value):
		if sell_price != value:
			sell_price_changed.emit(sell_price, value)
			sell_price = value
	get:
		return sell_price
