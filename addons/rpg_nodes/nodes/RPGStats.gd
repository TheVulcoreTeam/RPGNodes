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

# Description: Statistics that a character can use, such as strength, dexterity,
#   health, etc.

@icon("res://addons/rpg_nodes/icons/RPGStats.png")

class_name RPGStats extends RPGNode

var stats: Dictionary = {}
var base_stats: Dictionary = {}

@export var stats_points_per_level: int = 3
var available_points: int = 0

func _init() -> void:
	stats = {
		"strength": 0,
		"dexterity": 0,
		"health": 0
	}
	base_stats = stats.duplicate(true)

func add_stat(stat_name: String, initial_value: int = 0) -> void:
	if not stats.has(stat_name):
		stats[stat_name] = initial_value
		base_stats[stat_name] = initial_value

func get_stat(stat_name: String) -> int:
	return stats.get(stat_name, 0)

func set_stat(stat_name: String, value: int) -> void:
	if stats.has(stat_name):
		stats[stat_name] = value

var strength: int:
	get:
		return stats.get("strength", 0)
	set(value):
		set_stat("strength", value)

var dexterity: int:
	get:
		return stats.get("dexterity", 0)
	set(value):
		set_stat("dexterity", value)

var health: int:
	get:
		return stats.get("health", 0)
	set(value):
		set_stat("health", value)

func add_stat_points(points: int) -> void:
	available_points += points

func allocate_points(stat_name: String, points: int) -> bool:
	if points <= 0 or available_points < points or not stats.has(stat_name):
		return false
	
	stats[stat_name] += points
	available_points -= points
	return true

func reset_stats() -> void:
	var total_current_points = 0
	for stat_name in stats:
		total_current_points += stats[stat_name]
	
	available_points = total_current_points
	
	for stat_name in stats:
		stats[stat_name] = base_stats.get(stat_name, 0)

func get_total_allocated_points() -> int:
	var total_current = 0
	var total_base = 0
	
	for stat_name in stats:
		total_current += stats[stat_name]
		total_base += base_stats.get(stat_name, 0)
	
	return total_current - total_base

func to_dict() -> Dictionary:
	return {
		"stats": stats.duplicate(true),
		"available_points": available_points,
		"stats_points_per_level": stats_points_per_level,
		"base_stats": base_stats.duplicate(true)
	}

func from_dict(data: Dictionary) -> void:
	stats = data.get("stats", {"strength": 0, "dexterity": 0, "health": 0}).duplicate(true)
	available_points = data.get("available_points", 0)
	stats_points_per_level = data.get("stats_points_per_level", 3)
	base_stats = data.get("base_stats", {"strength": 0, "dexterity": 0, "health": 0}).duplicate(true)
