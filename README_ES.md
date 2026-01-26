# RPGNodes

![logo](RPGNodes.png)

**RPGNodes** es un addon que simplifica la lógica para construir juegos RPG usando nodos personalizados.

## Resumen

RPGNodes proporciona una solución genérica para la lógica típica encontrada en los RPGs.
Por ejemplo:

* **`RPGCharacter`** puede representar la lógica de un personaje – añadiendo experiencia, salud, energía o maná.
* **`RPGItem`** o **`RPGWeightItem`** representa un ítem con atributos comunes (item_name, description, amount, buy_price, sell_price, etc.).
* **`RGPWeightInventory`** almacena y gestiona ítems que tienen peso, lo que significa que cada ítem puede tener un peso diferente.

## Estado del Proyecto

El proyecto está listo para producción con gestión de inventarios completa, sistemas de personajes y cobertura de pruebas robusta.
Las pruebas unitarias están escritas con [GUT](https://github.com/bitwes/Gut/).

### Características Listas para Producción

![](addons/rpg_nodes/icons/RPGCharacter.png) **RPGCharacter:** ¡Listo para producción – probado con tests unitarios (GUT) y mejorado con soporte de serialización!

![](addons/rpg_nodes/icons/RPGDialog.png) **RPGDialog:** Usable – probado en una escena dentro del proyecto.

![](addons/rpg_nodes/icons/RPGWeightItem.png) **RPGWeightItem:** Listo para producción y probado junto con `RPGWeightInventory` usando tests unitarios (GUT).

![](addons/rpg_nodes/icons/RPGWeightInventory.png) **RPGWeightInventory:** Listo para producción y probado con tests unitarios (GUT).

![](addons/rpg_nodes/icons/RPGSlotInventory.png) **RPGSlotInventory:** ¡Listo para producción – sistema completo de inventario en cuadrícula con pruebas exhaustivas (GUT)!

![](addons/rpg_nodes/icons/RPGStats.png) **RPGStats:** ¡Listo para producción – sistema completo de gestión de estadísticas de personaje con sistema de asignación y pruebas extensas (GUT)!

### Clases de Soporte

**RPGSlotItem** Clase funcional para inventarios basados en ranuras.

**RPGActor** Clase base abstracta para entidades tipo actor.

**RPGEnemy** Implementación específica para personajes enemigos.


## Instalación y Uso

Recomendamos descargar la última versión desde GitHub:
[https://github.com/TheVulcoreTeam/RPGNodes/releases](https://github.com/TheVulcoreTeam/RPGNodes/releases)

### ¿Quieres probar el plugin?

Clona el repositorio y ábrelo con **Godot 4.5.x**.
Si quieres usarlo realmente, es mejor descargar la versión lanzada desde GitHub.

### ¿Quieres usar el plugin en un proyecto?

Usar el plugin requiere los siguientes pasos:

1. Descarga la versión:
   <https://github.com/TheVulcoreTeam/RPGNodes/releases>
2. Copia la carpeta `rpg_nodes` y colócala dentro del directorio `addons` de tu proyecto. Si no tienes una carpeta `addons` en la raíz de tu proyecto, crea una.
3. Abre el editor de Godot y activa el plugin en
   **Proyecto → Ajustes del Proyecto → Plugins**

## Novedades en v0.10.0

Esta versión principal transforma RPGNodes de un kit de herramientas prometedor a un framework RPG listo para producción:

* **Sistemas Doble de Inventario Completos**: Elige entre inventarios basados en peso o estilo Diablo basados en ranuras
* **Sistema de Estadísticas Listo para Producción**: Gestión completa de estadísticas de personaje con asignación de puntos
* **Arquitectura Mejorada**: Mejor herencia con clases base apropiadas (RPGActor, RPGNode)
* **Pruebas Exhaustivas**: Cobertura extensiva de pruebas unitarias para todas las nuevas características
* **Soporte de Serialización**: Funcionalidad guardar/cargar para sistemas críticos

## Elegir el Sistema de Inventario Adecuado

RPGNodes ahora ofrece dos soluciones completas de inventario:

### Inventario Basado en Peso (`RPGWeightInventory` + `RPGWeightItem`)
* **Ideal para**: Juegos realistas con límites de capacidad de carga
* **Características**: Los ítems tienen peso, gestión de capacidad de peso total
* **Casos de uso**: Juegos de supervivencia, RPGs realistas, juegos de gestión de recursos

### Inventario Basado en Ranuras (`RPGSlotInventory` + `RPGSlotItem`)
* **Ideal para**: RPGs clásicos con inventarios basados en cuadrícula
* **Características**: Diseño en cuadrícula (ancho × alto), los ítems ocupan múltiples ranuras, posicionamiento automático
* **Casos de uso**: Juegos estilo Diablo, RPGs tácticos, juegos con gestión visual de inventario

Ambos sistemas están completamente probados y listos para producción. Elige según los requisitos de diseño de tu juego.

## Nodos Personalizados

A continuación hay una breve descripción de cada nodo personalizado.
Si tienes preguntas sobre cómo funciona un método en particular, abre un issue en GitHub o lee el código fuente de ese nodo.
Todos los métodos están en Inglés, y los comentarios también están escritos en Inglés.

# Documentación de RPG Nodes

## RPGCharacter.gd

Una clase de actor RPG extendida que representa un personaje jugable con sistemas de nivel, energía y resistencia.

### Propiedades

- `level_max: int` - Nivel máximo alcanzable (por defecto: 30)
- `energy: int` - Puntos actuales de energía/maná (por defecto: 20)
- `energy_max: int` - Capacidad máxima de energía (por defecto: 20)
- `stamina: float` - Puntos actuales de resistencia (por defecto: 20.0)
- `stamina_max: float` - Capacidad máxima de resistencia (por defecto: 20.0)
- `stamina_regen_per_second: float` - Tasa de regeneración de resistencia por segundo (por defecto: 2.0)
- `base_attack: int` - Valor base de ataque (por defecto: 1)
- `experience_base: float` - Constante base para la progresión de experiencia (por defecto: 100.0)
- `experience_factor: float` - Factor para ajustar la curva de nivel (por defecto: 1.5)

### Señales

- `level_increased(new_level)` - Emitida cuando el personaje sube de nivel
- `experience_gained(amount)` - Emitida cuando se gana experiencia
- `energy_replenished(amount)` - Emitida cuando la energía se restaura
- `energy_used(amount)` - Emitida cuando la energía se consume
- `energy_reached_full()` - Emitida cuando la energía alcanza el máximo
- `energy_depleted()` - Emitida cuando la energía llega a cero
- `stamina_replenished(amount)` - Emitida cuando la resistencia se restaura
- `stamina_used(amount)` - Emitida cuando la resistencia se consume
- `stamina_reached_full()` - Emitida cuando la resistencia alcanza el máximo
- `stamina_depleted()` - Emitida cuando la resistencia se agota por completo

### Funciones

- `revive(custom_hp, revive_with_max_hp)` - Revive al personaje cuando está muerto
- `get_exp_for_level(level)` - Calcula la experiencia requerida para un nivel específico
- `get_total_exp_to_current_level()` - Obtiene la experiencia total acumulada hasta el nivel actual
- `get_exp_to_next_level()` - Obtiene la experiencia necesaria para el siguiente nivel
- `add_experience(amount)` - Añade experiencia y maneja las subidas de nivel
- `get_level_progress()` - Devuelve el porcentaje de progreso hacia el siguiente nivel (0.0-1.0)
- `reset_level_stats()` - Reinicia el nivel y la experiencia a valores iniciales

---

## RPGDialog.gd

Un sistema de diálogo para gestionar conversaciones con NPCs, soportando nombres de personajes, mensajes y avatares.

### Propiedades

- `text: NodePath` - Ruta al RichTextLabel para el texto del diálogo
- `title_name: NodePath` - Ruta al RichTextLabel para el nombre del personaje
- `avatar: NodePath` - Ruta al TextureRect para el avatar del personaje
- `dialogue: Array` - Array que almacena las secciones del diálogo
- `timer` - Referencia al Timer para los tiempos del diálogo
- `next_pressed: bool` - Bandera para el estado del botón siguiente

### Señales

- `character_name_changed(old_name, new_name)` - Emitida cuando cambia el nombre del personaje
- `avatar_changed(old_image, new_image)` - Emitida cuando cambia el avatar
- `dialog_started()` - Emitida cuando comienza el diálogo
- `section_ended(idx)` - Emitida cuando termina una sección del diálogo
- `dialog_ended()` - Emitida cuando concluye todo el diálogo
- `dialog_cleaned` - Emitida cuando se limpia el diálogo

### Funciones

- `add_section(character_name, message, avatar_image)` - Añade una nueva sección de diálogo
- `next_dialog()` - Avanza al siguiente diálogo o inicia la secuencia
- `reset_index()` - Reinicia el índice del diálogo para empezar desde el principio
- `clear_dialog()` - Limpia todas las secciones del diálogo

---

## RPGItem.gd

Clase base de recurso para representar ítems en el sistema RPG con propiedades básicas.

### Propiedades

- `item_name: String` - Nombre del ítem
- `description: String` - Texto de descripción del ítem
- `buy_price: int` - Precio de compra del ítem (por defecto: 2)
- `sell_price: int` - Precio de venta del ítem (por defecto: 1)

### Señales

- `item_name_changed(old_name, new_name)` - Emitida cuando se modifica el nombre del ítem
- `description_changed(old_description, new_description)` - Emitida cuando cambia la descripción
- `buy_price_changed(old_value, new_value)` - Emitida cuando se actualiza el precio de compra
- `sell_price_changed(old_value, new_value)` - Emitida cuando se actualiza el precio de venta

---

## RPGWeightInventory.gd

Sistema de inventario basado en peso que gestiona ítems con restricciones de carga.

### Propiedades

- `max_weight: int` - Capacidad máxima de peso (por defecto: 100)
- `_weight_inventory: Array[RPGWeightItem]` - Array de ítems en el inventario
- `_weight: int` - Peso total actual del inventario

### Señales

- `weight_filled()` - Emitida cuando el inventario alcanza el peso máximo
- `weight_changed(old_weight, new_value)` - Emitida cuando cambia el peso total

### Funciones

- `add_item(item)` - Añade un ítem al inventario si el peso lo permite
- `get_item(uuid)` - Recupera un ítem por su UUID, devuelve null si no se encuentra
- `remove_item(uuid)` - Elimina un ítem por UUID, devuelve true si tiene éxito

---

## RPGWeightItem.gd

Clase RPGItem extendida que añade propiedades de peso para usar en sistemas de inventario basados en peso.

### Propiedades

- `weight: int` - Valor de peso del ítem en el inventario (por defecto: 1)

### Señales

- `weight_updated(new_weight)` - Emitida cuando se modifica el peso del ítem

Esta clase hereda todas las propiedades, señales y funcionalidades de RPGItem, añadiendo gestión de peso específicamente para sistemas de inventario que rastrean la capacidad de carga.

---

## RPGSlotInventory.gd

Sistema de inventario basado en cuadrícula similar a juegos estilo Diablo donde los ítems ocupan ranuras específicas en un diseño de cuadrícula.

### Propiedades

- `width: int` - Ancho de la cuadrícula en ranuras (por defecto: 10)
- `height: int` - Alto de la cuadrícula en ranuras (por defecto: 10)
- `_slot_inventory: Array[RPGSlotItem]` - Array de ítems en el inventario
- `_grid: Array` - Cuadrícula 2D representando ranuras ocupadas

### Señales

- `slot_item_added(item)` - Emitida cuando se añade un ítem al inventario
- `slot_item_removed(item)` - Emitida cuando se elimina un ítem del inventario
- `slot_item_moved(item, old_position, new_position)` - Emitida cuando un ítem cambia de posición
- `inventory_resized(old_size, new_size)` - Emitida cuando cambian las dimensiones de la cuadrícula

### Funciones

- `add_item(item, position)` - Añade un ítem en posición específica o encuentra espacio disponible
- `remove_item(uuid)` - Elimina un ítem por UUID
- `move_item(uuid, new_position)` - Mueve un ítem a una nueva posición
- `get_available_space(position, item_width, item_height)` - Verifica si hay espacio disponible
- `find_available_position(item_width, item_height)` - Encuentra la primera posición disponible
- `is_position_valid(position, item_width, item_height)` - Valida los límites de la posición

---

## RPGSlotItem.gd

Clase RPGItem extendida que añade propiedades espaciales para sistemas de inventario basados en cuadrícula.

### Propiedades

- `width: int` - Ancho del ítem en ranuras de cuadrícula (por defecto: 1, mínimo: 1)
- `height: int` - Alto del ítem en ranuras de cuadrícula (por defecto: 1, mínimo: 1)
- `position: Vector2i` - Posición actual en la cuadrícula del inventario (por defecto: Vector2i.ZERO)

### Señales

- `dimensions_changed(old_size, new_size)` - Emitida cuando cambia el ancho o alto
- `position_changed(old_position, new_position)` - Emitida cuando cambia la posición

### Funciones

- `get_occupied_cells()` - Devuelve array de celdas de cuadrícula ocupadas por este ítem
- `is_position_valid(inventory_width, inventory_height)` - Verifica si la posición actual es válida
- `would_fit_at(position, inventory_width, inventory_height)` - Verifica si el ítem cabría en la posición

Esta clase hereda todas las propiedades, señales y funcionalidades de RPGItem, añadiendo gestión espacial para sistemas de inventario basados en cuadrícula.

---

## RPGStats.gd

Sistema comprehensivo de gestión de estadísticas de personaje con adición dinámica de estadísticas y asignación de puntos.

### Propiedades

- `stat_points: int` - Puntos de estadística disponibles para asignación (por defecto: 0)
- `_stats: Dictionary` - Diccionario almacenando todas las estadísticas con pares nombre-valor
- `_base_stats: Dictionary` - Diccionario almacenando valores base de estadísticas

### Señales

- `stat_points_changed(old_points, new_points)` - Emitida cuando cambian los puntos de estadística
- `stat_added(stat_name, value)` - Emitida cuando se añade una nueva estadística
- `stat_changed(stat_name, old_value, new_value)` - Emitida cuando cambia el valor de una estadística
- `stat_points_allocated(stat_name, points)` - Emitida cuando se asignan puntos a una estadística

### Funciones

- `add_stat(stat_name, base_value, current_value)` - Añade una nueva estadística al personaje
- `get_stat(stat_name)` - Obtiene el valor actual de una estadística
- `get_base_stat(stat_name)` - Obtiene el valor base de una estadística
- `set_stat(stat_name, value)` - Establece el valor actual de una estadística
- `allocate_stat_points(stat_name, points)` - Asigna puntos de estadística para aumentar una estadística
- `add_stat_points(points)` - Añade puntos de estadística disponibles
- `to_dict()` - Serializa estadísticas a diccionario para guardar
- `from_dict(data)` - Carga estadísticas desde diccionario

---

## RPGActor.gd

Clase base abstracta para todas las entidades tipo actor en el sistema RPG.

### Propiedades

- `character_name: String` - Nombre del actor (por defecto: "Actor")

### Señales

- `character_name_changed(old_name, new_name)` - Emitida cuando cambia el nombre del actor

Esta clase sirve como fundación para todas las clases de personaje y enemigo, proporcionando funcionalidad común de actor y capacidades de nomenclatura.

---

## RPGEnemy.gd

Implementación específica para personajes enemigos heredando de RPGActor.

### Propiedades

- Hereda todas las propiedades de RPGActor
- Se pueden añadir propiedades adicionales específicas de enemigos según sea necesario

Esta clase proporciona un punto de partida para la implementación de personajes enemigos con toda la funcionalidad base de actor heredada de RPGActor.

---

## RPGPotion.gd

Ítem consumible que aplica un efecto a lo largo del tiempo o instantáneamente.

### Propiedades

- `effect_type: PotionEffect` - Tipo de efecto (HEALTH, MANA, SATURATION)
- `value: int` - Magnitud del efecto
- `duration: float` - Duración en segundos

### Señales

- `effect_type_changed(old_value, new_value)`
- `value_changed(old_value, new_value)`
- `duration_changed(old_value, new_value)`

---

## RPGShield.gd

Equipo de protección que proporciona defensa y probabilidad de bloqueo.

### Propiedades

- `defense: int` - Valor de defensa
- `block_chance: float` - Probabilidad de bloquear ataques (0.0 a 1.0)

### Señales

- `defense_changed(old_value, new_value)`
- `block_chance_changed(old_value, new_value)`

---

## RPGWeapon.gd

Ítem ofensivo con propiedades de daño y ataque.

### Propiedades

- `damage: int` - Daño base
- `attack_speed: float` - Ataques por segundo
- `crit_chance: float` - Probabilidad de golpe crítico (0.0 a 1.0)

### Señales

- `damage_changed(old_value, new_value)`
- `attack_speed_changed(old_value, new_value)`
- `crit_chance_changed(old_value, new_value)`
