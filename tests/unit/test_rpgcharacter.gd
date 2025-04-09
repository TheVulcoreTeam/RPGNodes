extends GutTest

var character_died : RPGCharacter
var character_test : RPGCharacter

func before_all():
	character_died = RPGCharacter.new()
	add_child(character_died)
	
	character_test = RPGCharacter.new()
	add_child(character_test)


func test_signal_when_died():
	await wait_for_signal(character_died.died, 0.1)
	character_died.hp -= 9999
	assert_signal_emitted(character_died, "died", "signal_when_died() passed.")
	assert_true(character_died.is_dead)


func test_cant_hp_add_to_character_died():
	assert_true(character_died.is_dead)
	
	if character_died.is_dead:
		await wait_for_signal(character_died.died, 0.1)
		character_died.hp += 100
		assert_true(character_died.is_dead)
		assert_signal_emitted(character_died, "message", "cant_hp_add_to_character_died() passed.")


func test_revive():
	assert_true(character_died.is_dead)
	
	await wait_for_signal(character_died.revived, 0.1)
	character_died.revive()
	assert_signal_emitted(character_died, "revived", "revive() passed.")
	
	assert_false(character_died.is_dead)


func test_remove_hp_to_character():
	assert_false(character_died.is_dead)
	
	await wait_for_signal(character_died.hp_removed, 0.1)
	character_died.hp -= 5
	assert_signal_emitted(character_died, "hp_removed", "test_remove_hp_to_character() passed.")


func test_set_hp_to_zero():
	assert_false(character_died.is_dead)
	
	await wait_for_signal(character_died.died, 0.1)
	character_died.hp = 0
	assert_signal_emitted(character_died, "hp_removed", "test_set_hp_to_zero() passed.")
	assert_signal_emitted(character_died, "died", "test_set_hp_to_zero() passed.")


func test_exact_xp_for_level_up():
	watch_signals(character_test)
	var initial_level = character_test.level
	var xp_to_add = character_test.xp_required # Añadimos el XP exacto para subir de nivel
	
	print(character_test.xp_required)
	
	character_test.xp = xp_to_add
	
	assert_eq(character_test.level, initial_level + 1, "El nivel debe incrementar en 1")
	assert_eq(character_test.xp, 0, "El XP debe reiniciarse a 0 después de subir de nivel")
	assert_eq(character_test.xp_total, xp_to_add, "El XP total debe ser igual al XP añadido")
	assert_signal_emitted(character_test, "level_increased", "La señal level_increased debe emitirse")
	assert_signal_emitted(character_test, "xp_added", "La señal xp_added debe emitirse")


func test_add_more_xp_than_needed_for_level_up():
	watch_signals(character_test)
	var initial_level = character_test.level
	var initial_xp_required = character_test.xp_required
	var extra_xp = 5
	var xp_to_add = initial_xp_required + extra_xp # Añadimos más XP del necesario para subir de nivel
	
	character_test.xp = xp_to_add
	
	assert_eq(character_test.level, initial_level + 1, "El nivel debe incrementar en 1")
	assert_eq(character_test.xp, extra_xp, "El XP sobrante debe guardarse")
	assert_eq(character_test.xp_total, xp_to_add, "El XP total debe ser igual al XP añadido")
	assert_signal_emitted(character_test, "level_increased", "La señal level_increased debe emitirse")


func test_multiple_level_ups_with_one_xp_addition():
	watch_signals(character_test)
	var initial_level = character_test.level
	var xp_for_first_level = character_test.xp_required
	var xp_for_second_level = character_test.xp_required_to_level(initial_level + 2)
	var xp_to_add = xp_for_first_level + xp_for_second_level + 10 # XP para subir 2 niveles y algo más
	
	character_test.xp = xp_to_add
	
	assert_eq(character_test.level, initial_level + 2, "El nivel debe incrementar en 2")
	assert_gt(character_test.xp, 0, "Debe quedar XP residual después de subir de nivel")
	assert_eq(character_test.xp_total, xp_to_add, "El XP total debe ser igual al XP añadido")
	assert_signal_emit_count(character_test, "level_increased", 2, "La señal level_increased debe emitirse 2 veces")


func test_level_max_restriction():
	# Establecemos el nivel máximo más bajo para la prueba
	character_test.level_max = 5
	character_test.level = 4
	
	# Calculamos XP necesario para subir varios niveles
	var xp_to_add = character_test.xp_required * 10 # Mucho más XP del necesario
	
	character_test.xp = xp_to_add
	
	assert_eq(character_test.level, 5, "El nivel no debe superar level_max")
	assert_signal_emitted_with_parameters(character_test, "level_increased", [5], "La señal level_increased debe emitirse con nivel 5")


func test_adding_xp_when_dead():
	character_test.is_dead = true
	var initial_xp = character_test.xp
	var initial_level = character_test.level
	
	character_test.xp = 1000
	
	assert_eq(character_test.xp, initial_xp, "El XP no debe cambiar cuando el personaje está muerto")
	assert_eq(character_test.level, initial_level, "El nivel no debe cambiar cuando el personaje está muerto")


func test_correct_xp_calculation():
	var test_levels = [1, 2, 5, 10, 20]
	
	for lvl in test_levels:
		var expected_xp = int(round(pow(lvl, 1.8) + lvl * 4))
		assert_eq(character_test.xp_required_to_level(lvl), expected_xp, "XP requerido para nivel " + str(lvl) + " debe ser calculado correctamente")


func test_multiple_xp_additions():
	watch_signals(character_test)
	var initial_level = character_test.level
	
	# Primera adición - insuficiente para subir de nivel
	character_test.xp = 5
	assert_eq(character_test.level, initial_level, "El nivel no debe cambiar con la primera adición")
	assert_eq(character_test.xp, 5, "El XP debe ser 5")
	
	# Segunda adición - aún insuficiente para subir de nivel
	character_test.xp = 5
	assert_eq(character_test.level, initial_level, "El nivel no debe cambiar con la segunda adición")
	assert_eq(character_test.xp, 10, "El XP debe ser 10")
	
	# Tercera adición - suficiente para subir de nivel
	var remaining_xp_needed = character_test.xp_required - 10
	character_test.xp = remaining_xp_needed + 3 # Añadimos extra para tener residuo
	
	assert_eq(character_test.level, initial_level + 1, "El nivel debe incrementar después de la tercera adición")
	assert_eq(character_test.xp, 3, "El XP residual debe ser 3")
	assert_signal_emitted(character_test, "level_increased", "La señal level_increased debe emitirse")


func test_revive_after_death_preserves_xp():
	character_test.is_dead = true
	var initial_xp_total = 100
	character_test.xp_total = initial_xp_total
	
	character_test.revive()
	character_test.xp = 50 # Intentamos añadir XP después de revivir
	
	assert_eq(character_test.xp_total, initial_xp_total + 50, "El XP total debe actualizarse después de revivir")
	assert_eq(character_test.xp, 50, "El XP debe actualizarse después de revivir")
	assert_false(character_test.is_dead, "El personaje no debe estar muerto después de revivir")


func test_xp_added():
	await wait_for_signal(character_test.xp_added, 0.1)
	character_test.xp += 2
	assert_signal_emitted(character_test, "xp_added", "xp_added() passed.")


func test_can_level_up():
	await wait_for_signal(character_test.level_increased, 0.1)
	character_test.xp += 10
	assert_signal_emitted(character_test, "level_increased", "test_can_level_up() passed.")


func test_get_xp_for_next_level():
	var xp_objective = character_test.xp_required_to_level(character_test.level + 1)
	
	assert_eq(xp_objective, 19)


func test_too_much_xp():
	character_test.xp += 1_000_000
	assert_eq(character_test.level, character_test.level_max)


func test_reset_xp_to_zero():
	character_test.reset_stats()
	
	assert_eq(character_test.xp, 0)
	assert_eq(character_test.xp_total, 0)
	assert_eq(character_test.xp_required, 0)
	assert_eq(character_test.level, 0)


func test_use_stamine():
	await wait_for_signal(character_test.stamine_removed, 0.1)
	character_test.stamine -= 4
	assert_signal_emitted(character_test, "stamine_removed", "test_use_stamine()")
	
	await wait_for_signal(character_test.stamine_added, 0.1)
	character_test.stamine += 4
	assert_signal_emitted(character_test, "stamine_added", "test_use_stamine()")
	
	await wait_for_signal(character_test.stamine_without, 0.1)
	character_test.stamine -= 10
	character_test.stamine -= 5
	character_test.stamine -= 6
	assert_signal_emitted(character_test, "stamine_without", "test_use_stamine()")

	await wait_for_signal(character_test.stamine_is_full, 10.5)
	assert_signal_emitted(character_test, "stamine_is_full", "test_use_stamine()")
	assert_eq(character_test.stamine, character_test.stamine_max)
