extends GutTest

var character_died : RPGCharacter
var character_random : RPGCharacter

func before_all():
	character_died = RPGCharacter.new()
	add_child(character_died)
	
	character_random = RPGCharacter.new()
	add_child(character_random)


func test_signal_when_died():
	await wait_for_signal(character_died.died, 1)
	character_died.hp -= 9999
	assert_signal_emitted(character_died, "died", "signal_when_died() passed.")
	assert_true(character_died.is_dead)


func test_cant_hp_add_to_character_died():
	assert_true(character_died.is_dead)
	
	if character_died.is_dead:
		await wait_for_signal(character_died.died, 1)
		character_died.hp += 100
		assert_true(character_died.is_dead)
		assert_signal_emitted(character_died, "message", "cant_hp_add_to_character_died() passed.")


func test_revive():
	assert_true(character_died.is_dead)
	
	await wait_for_signal(character_died.revived, 1)
	character_died.revive()
	assert_signal_emitted(character_died, "revived", "revive() passed.")
	
	assert_false(character_died.is_dead)


func test_remove_hp_to_character():
	assert_false(character_died.is_dead)
	
	await wait_for_signal(character_died.hp_removed, 1)
	character_died.hp -= 5
	assert_signal_emitted(character_died, "hp_removed", "test_remove_hp_to_character() passed.")


func test_set_hp_to_zero():
	assert_false(character_died.is_dead)
	
	await wait_for_signal(character_died.died, 1)
	character_died.hp = 0
	assert_signal_emitted(character_died, "hp_removed", "test_set_hp_to_zero() passed.")
	assert_signal_emitted(character_died, "died", "test_set_hp_to_zero() passed.")


func test_xp_added():
	await wait_for_signal(character_random.xp_added, 1)
	character_random.xp += 2
	assert_signal_emitted(character_random, "xp_added", "xp_added() passed.")


func test_can_level_up():
	await wait_for_signal(character_random.level_increased, 1)
	character_random.xp += 10
	assert_signal_emitted(character_random, "level_increased", "test_can_level_up() passed.")


func test_get_xp_for_next_level():
	var xp_objective = character_random.xp_required_to_level(character_random.level + 1)
	
	assert_eq(xp_objective, 19)


func test_too_much_xp():
	character_random.xp += 1_000_000
	assert_eq(character_random.level, character_random.level_max)


func test_reset_xp_to_zero():
	character_random.reset_stats()
	
	assert_eq(character_random.xp, 0)
	assert_eq(character_random.xp_total, 0)
	assert_eq(character_random.xp_required, 0)
	assert_eq(character_random.level, 0)
