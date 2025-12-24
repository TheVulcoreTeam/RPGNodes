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

@icon("res://addons/rpg_nodes/icons/RPGItem.png")

class_name RPGWeapon extends RPGWeightItem


signal damage_changed(old_value, new_value)
signal attack_speed_changed(old_value, new_value)
signal crit_chance_changed(old_value, new_value)


## Weapon damage
@export var damage := 0:
	set(value):
		if damage != value:
			damage_changed.emit(damage, value)
			damage = value
	get:
		return damage


## Weapon attack speed
@export var attack_speed := 1.0:
	set(value):
		if attack_speed != value:
			attack_speed_changed.emit(attack_speed, value)
			attack_speed = value
	get:
		return attack_speed


## Weapon critical chance
@export var crit_chance := 0.0:
	set(value):
		if crit_chance != value:
			crit_chance_changed.emit(crit_chance, value)
			crit_chance = value
	get:
		return crit_chance
