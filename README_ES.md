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

El proyecto es usable, aunque algunos nodos están incompletos.
Las pruebas unitarias están escritas con [GUT](https://github.com/bitwes/Gut/).

![](addons/rpg_nodes/icons/RPGCharacter.png) **RPGCharacter:** ¡Muy usable y probado con tests unitarios (GUT)!

![](addons/rpg_nodes/icons/RPGDialog.png) **RPGDialog:** Usable – probado en una escena dentro del proyecto.

![](addons/rpg_nodes/icons/RPGWeightItem.png) **RPGWeightItem:** Muy usable y probado junto con `RPGWeightInventory` usando tests unitarios (GUT).

![](addons/rpg_nodes/icons/RPGWeightInventory.png) **RPGWeightInventory:** Muy usable y probado con tests unitarios (GUT).

### TODO o no usable

![](addons/rpg_nodes/icons/RPGSlotInventory.png) **RPGSlotInventory:** TODO o no usable.

**RPGSlotItem** Todo o no usable.

![](addons/rpg_nodes/icons/RPGStats.png) **RPGStats:** TODO o no usable.


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
