extends GutTest

var rpg_stats: RPGStats


func before_each():
	rpg_stats = RPGStats.new()


func after_each():
	rpg_stats = null


# Test default stats initialization
func test_default_stats_initialization():
	assert_eq(rpg_stats.get_stat("strength"), 0, "strength should be 0 by default")
	assert_eq(rpg_stats.get_stat("dexterity"), 0, "dexterity should be 0 by default")
	assert_eq(rpg_stats.get_stat("health"), 0, "health should be 0 by default")
	assert_eq(rpg_stats.available_points, 0, "available_points should be 0 by default")
	assert_eq(rpg_stats.stats_points_per_level, 3, "stats_points_per_level should be 3 by default")


func test_default_base_stats():
	assert_eq(rpg_stats.base_stats["strength"], 0, "base strength should be 0")
	assert_eq(rpg_stats.base_stats["dexterity"], 0, "base dexterity should be 0")
	assert_eq(rpg_stats.base_stats["health"], 0, "base health should be 0")


# Test add_stat() method for dynamic stats
func test_add_stat_creates_new_stat():
	rpg_stats.add_stat("intelligence", 5)
	assert_eq(rpg_stats.get_stat("intelligence"), 5, "intelligence should be set to 5")
	assert_true(rpg_stats.base_stats.has("intelligence"), "base_stats should contain intelligence")


func test_add_stat_with_default_value():
	rpg_stats.add_stat("wisdom")
	assert_eq(rpg_stats.get_stat("wisdom"), 0, "wisdom should default to 0")


func test_add_stat_ignores_duplicate():
	rpg_stats.add_stat("charisma", 3)
	rpg_stats.add_stat("charisma", 10)
	assert_eq(rpg_stats.get_stat("charisma"), 3, "Should not overwrite existing stat")


# Test get_stat() and set_stat() methods
func test_get_stat_returns_0_for_nonexistent():
	assert_eq(rpg_stats.get_stat("nonexistent"), 0, "Should return 0 for nonexistent stat")


func test_set_stat_updates_existing_stat():
	rpg_stats.add_stat("test_stat", 2)
	rpg_stats.set_stat("test_stat", 7)
	assert_eq(rpg_stats.get_stat("test_stat"), 7, "Stat should be updated")


func test_set_stat_ignores_nonexistent():
	rpg_stats.set_stat("nonexistent", 5)
	assert_eq(rpg_stats.get_stat("nonexistent"), 0, "Should not create new stat")


# Test backward compatibility properties
func test_backward_compatibility_strength():
	rpg_stats.strength = 10
	assert_eq(rpg_stats.get_stat("strength"), 10, "Strength property should work")
	assert_eq(rpg_stats.strength, 10, "Strength getter should work")


func test_backward_compatibility_dexterity():
	rpg_stats.dexterity = 8
	assert_eq(rpg_stats.get_stat("dexterity"), 8, "Dexterity property should work")
	assert_eq(rpg_stats.dexterity, 8, "Dexterity getter should work")


func test_backward_compatibility_health():
	rpg_stats.health = 15
	assert_eq(rpg_stats.get_stat("health"), 15, "Health property should work")
	assert_eq(rpg_stats.health, 15, "Health getter should work")


# Test allocate_points() method
func test_allocate_points_success():
	rpg_stats.add_stat_points(5)
	var result = rpg_stats.allocate_points("strength", 3)
	
	assert_true(result, "Should allocate points successfully")
	assert_eq(rpg_stats.get_stat("strength"), 3, "Strength should increase by 3")
	assert_eq(rpg_stats.available_points, 2, "Should deduct points from available")


func test_allocate_points_insufficient_points():
	rpg_stats.add_stat_points(2)
	var result = rpg_stats.allocate_points("dexterity", 3)
	
	assert_false(result, "Should fail with insufficient points")
	assert_eq(rpg_stats.get_stat("dexterity"), 0, "Dexterity should not change")
	assert_eq(rpg_stats.available_points, 2, "Should not deduct points")


func test_allocate_points_nonexistent_stat():
	rpg_stats.add_stat_points(3)
	var result = rpg_stats.allocate_points("nonexistent", 2)
	
	assert_false(result, "Should fail for nonexistent stat")
	assert_eq(rpg_stats.available_points, 3, "Should not deduct points")


func test_allocate_points_zero_or_negative():
	rpg_stats.add_stat_points(5)
	
	assert_false(rpg_stats.allocate_points("strength", 0), "Should fail with 0 points")
	assert_false(rpg_stats.allocate_points("strength", -1), "Should fail with negative points")


# Test reset_stats() method
func test_reset_stats_returns_allocated_points():
	rpg_stats.add_stat_points(5)
	rpg_stats.allocate_points("strength", 2)
	rpg_stats.allocate_points("dexterity", 1)
	
	rpg_stats.reset_stats()
	
	assert_eq(rpg_stats.available_points, 3, "Should return allocated points")
	assert_eq(rpg_stats.get_stat("strength"), 0, "Strength should reset to base")
	assert_eq(rpg_stats.get_stat("dexterity"), 0, "Dexterity should reset to base")


func test_reset_stats_with_custom_base_values():
	rpg_stats.add_stat("custom_stat", 5)
	rpg_stats.base_stats["custom_stat"] = 3
	
	rpg_stats.set_stat("custom_stat", 8)
	rpg_stats.reset_stats()
	
	assert_eq(rpg_stats.get_stat("custom_stat"), 3, "Should reset to base value")


# Test to_dict() and from_dict() serialization
func test_to_dict_returns_correct_structure():
	rpg_stats.add_stat("intelligence", 4)
	rpg_stats.allocate_points("strength", 2)
	
	var dict = rpg_stats.to_dict()
	
	assert_has(dict, "stats", "Should have stats key")
	assert_has(dict, "available_points", "Should have available_points key")
	assert_has(dict, "stats_points_per_level", "Should have stats_points_per_level key")
	assert_has(dict, "base_stats", "Should have base_stats key")


func test_to_dict_preserves_values():
	rpg_stats.add_stat("test_stat", 7)
	rpg_stats.add_stat_points(3)
	rpg_stats.allocate_points("test_stat", 1)
	
	var dict = rpg_stats.to_dict()
	
	assert_eq(dict["stats"]["test_stat"], 8, "Should preserve current stat value")
	assert_eq(dict["available_points"], 2, "Should preserve available points")
	assert_eq(dict["stats_points_per_level"], 3, "Should preserve points per level")


func test_from_dict_restores_values():
	var test_dict = {
		"stats": {"strength": 5, "dexterity": 3, "custom": 7},
		"available_points": 4,
		"stats_points_per_level": 2,
		"base_stats": {"strength": 2, "dexterity": 1, "custom": 5}
	}
	
	rpg_stats.from_dict(test_dict)
	
	assert_eq(rpg_stats.get_stat("strength"), 5, "Should restore strength")
	assert_eq(rpg_stats.get_stat("dexterity"), 3, "Should restore dexterity")
	assert_eq(rpg_stats.get_stat("custom"), 7, "Should restore custom stat")
	assert_eq(rpg_stats.available_points, 4, "Should restore available points")
	assert_eq(rpg_stats.stats_points_per_level, 2, "Should restore points per level")


func test_from_dict_handles_missing_keys():
	var incomplete_dict = {
		"stats": {"strength": 10},
		"available_points": 1
	}
	
	rpg_stats.from_dict(incomplete_dict)
	
	assert_eq(rpg_stats.get_stat("strength"), 10, "Should restore existing stat")
	assert_eq(rpg_stats.stats_points_per_level, 3, "Should use default for missing value")


# Test get_total_allocated_points() method
func test_get_total_allocated_points():
	rpg_stats.add_stat_points(6)
	rpg_stats.allocate_points("strength", 2)
	rpg_stats.allocate_points("dexterity", 1)
	rpg_stats.allocate_points("health", 3)
	
	var allocated = rpg_stats.get_total_allocated_points()
	assert_eq(allocated, 6, "Should return sum of allocated points")


func test_get_total_allocated_points_with_custom_base():
	rpg_stats.add_stat("custom", 5)
	rpg_stats.base_stats["custom"] = 2
	
	rpg_stats.set_stat("custom", 8)
	var allocated = rpg_stats.get_total_allocated_points()
	
	assert_eq(allocated, 6, "Should calculate based on base values")


# Test edge cases and error conditions
func test_add_stat_points_negative():
	var initial_points = rpg_stats.available_points
	rpg_stats.add_stat_points(-5)
	assert_eq(rpg_stats.available_points, initial_points - 5, "Should allow negative points")


func test_multiple_dynamic_stats():
	rpg_stats.add_stat("strength", 3)
	rpg_stats.add_stat("intelligence", 4)
	rpg_stats.add_stat("wisdom", 2)
	rpg_stats.add_stat("charisma", 5)
	
	rpg_stats.add_stat_points(10)
	rpg_stats.allocate_points("strength", 2)
	rpg_stats.allocate_points("intelligence", 3)
	rpg_stats.allocate_points("wisdom", 1)
	rpg_stats.allocate_points("charisma", 4)
	
	assert_eq(rpg_stats.get_stat("strength"), 2, "Strength should be 2 (0 base + 2 allocated)")
	assert_eq(rpg_stats.get_stat("intelligence"), 7, "Intelligence should be 7")
	assert_eq(rpg_stats.get_stat("wisdom"), 3, "Wisdom should be 3")
	assert_eq(rpg_stats.get_stat("charisma"), 9, "Charisma should be 9")
	assert_eq(rpg_stats.available_points, 0, "All points should be allocated")


func test_roundtrip_serialization():
	rpg_stats.add_stat("test", 3)
	rpg_stats.add_stat_points(5)
	rpg_stats.allocate_points("test", 2)
	
	var dict = rpg_stats.to_dict()
	var new_stats = RPGStats.new()
	new_stats.from_dict(dict)
	
	assert_eq(new_stats.get_stat("test"), rpg_stats.get_stat("test"), "Should preserve stat value")
	assert_eq(new_stats.available_points, rpg_stats.available_points, "Should preserve available points")
	assert_eq(new_stats.stats_points_per_level, rpg_stats.stats_points_per_level, "Should preserve points per level")
