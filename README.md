# RPGNodes

![logo](RPGNodes.png)

**RPGNodes** is an addon that simplifies logic for building RPG games using custom nodes.

## Summary

RPGNodes provides a generic solution for the typical logic found in RPGs.  
For example:

* **`RPGCharacter`** can represent a character’s logic – adding experience, health, energy or mana.
* **`RPGItem`** or **`RPGWeightItem`** represents an item with common attributes (item_name, description, amount, buy_price, sell_price, etc.).
* **`RGPWeightInventory`** stores and manages items that have weight, meaning each item can have a different weight.

## Project Status

The project is usable, though some nodes are still incomplete.  
Unit tests are written with [GUT](https://github.com/bitwes/Gut/).

![](addons/rpg_nodes/icons/RPGCharacter.png) **RPGCharacter:** Very usable – tested with unit tests (GUT)!!

![](addons/rpg_nodes/icons/RPGDialog.png) **RPGDialog:** Usable – tested in a scene within the project.

![](addons/rpg_nodes/icons/RPGWeightItem.png) **RPGWeightItem:** Very usable and tested together with `RPGWeightInventory` using unit tests (GUT).

![](addons/rpg_nodes/icons/RPGWeightInventory.png) **RPGWeightInventory:** Very usable and tested with unit tests (GUT).

![](addons/rpg_nodes/icons/RPGSlotInventory.png) **RPGSlotInventory:** TODO or not usable.

![](addons/rpg_nodes/icons/RPGStats.png) **RPGStats:** TODO or not usable.

## Installation & Usage

We recommend downloading the latest release from GitHub:  
[https://github.com/TheVulcoreTeam/RPGNodes/releases](https://github.com/TheVulcoreTeam/RPGNodes/releases)

### Want to test the plugin?

Clone the repository and open it with **Godot 4.4.x**.  
If you actually want to use it, it’s best to download the released version from GitHub.

### Want to use the plugin in a project?

Using the plugin requires the following steps:

1. Download the release:  
   <https://github.com/TheVulcoreTeam/RPGNodes/releases>
2. Copy the `rpg_nodes` folder and place it inside your project's `addons` directory. If you don’t have an `addons` folder at the root of your project, create one.
3. Open Godot’s editor and enable the plugin under  
   **Project → Project Settings → Plugins**

## Custom Nodes

Below is a brief description of each custom node.  
If you have questions about how a particular method works, open a GitHub issue or read the source code for that node.  
All methods are in English, and comments are written in English as well.

# RPG Nodes Documentation

## RPGCharacter.gd

An extended RPG actor class that represents a playable character with leveling, energy, and stamina systems.

### Properties

- `level_max: int` - Maximum achievable level (default: 30)
- `energy: int` - Current energy/mana points (default: 20)
- `energy_max: int` - Maximum energy capacity (default: 20)
- `stamina: float` - Current stamina points (default: 20.0)
- `stamine_max: float` - Maximum stamina capacity (default: 20.0)
- `stamine_regen_per_second: float` - Stamina regeneration rate per second (default: 2.0)
- `base_attack: int` - Base attack value (default: 1)
- `experience_base: float` - Base constant for experience progression (default: 100.0)
- `experience_factor: float` - Factor to adjust the leveling curve (default: 1.5)
- `current_exp: float` - Current experience points
- `current_level: int` - Current character level (default: 1)

### Signals

- `level_increased(new_level)` - Emitted when character levels up
- `experience_gained(amount)` - Emitted when experience is gained
- `energy_replenished(amount)` - Emitted when energy is restored
- `energy_used(amount)` - Emitted when energy is consumed
- `energy_reached_full()` - Emitted when energy reaches maximum
- `energy_depleted()` - Emitted when energy drops to zero
- `stamina_replenished(amount)` - Emitted when stamina is restored
- `stamina_used(amount)` - Emitted when stamina is consumed
- `stamina_reached_full()` - Emitted when stamina reaches maximum
- `stamina_depleted()` - Emitted when stamina is completely exhausted

### Functions

- `revive(custom_hp, revive_with_max_hp)` - Revives the character when dead
- `get_exp_for_level(level)` - Calculates experience required for a specific level
- `get_total_exp_to_current_level()` - Gets total experience accumulated to current level
- `get_exp_to_next_level()` - Gets experience needed for the next level
- `add_experience(amount)` - Adds experience and handles level ups
- `get_level_progress()` - Returns progress percentage toward next level (0.0-1.0)
- `reset_level_stats()` - Resets level and experience to initial values

---

## RPGDialog.gd

A dialog system for managing conversations with NPCs, supporting character names, messages, and avatars.

### Properties

- `text: NodePath` - Path to RichTextLabel for dialog text
- `title_name: NodePath` - Path to RichTextLabel for character name
- `avatar: NodePath` - Path to TextureRect for character avatar
- `dialogue: Array` - Array storing dialog sections
- `timer` - Timer reference for dialog timing
- `next_pressed: bool` - Flag for next button state

### Signals

- `character_name_changed(old_name, new_name)` - Emitted when character name changes
- `avatar_changed(old_image, new_image)` - Emitted when avatar changes
- `dialog_started()` - Emitted when dialog begins
- `section_ended(idx)` - Emitted when a dialog section ends
- `dialog_ended()` - Emitted when entire dialog concludes
- `dialog_cleaned` - Emitted when dialog is cleared

### Functions

- `add_section(character_name, message, avatar_image)` - Adds a new dialog section
- `next_dialog()` - Advances to next dialog or starts dialog sequence
- `reset_index()` - Resets dialog index to restart from beginning
- `clear_dialog()` - Clears all dialog sections

---

## RPGItem.gd

Base resource class for representing items in the RPG system with basic properties.

### Properties

- `item_name: String` - Name of the item
- `description: String` - Item description text
- `buy_price: int` - Price to purchase the item (default: 2)
- `sell_price: int` - Price when selling the item (default: 1)

### Signals

- `item_name_changed(new_name)` - Emitted when item name is modified
- `description_changed(new_description)` - Emitted when description changes
- `buy_price_changed(new_value)` - Emitted when buy price is updated
- `sell_price_changed(new_value)` - Emitted when sell price is updated

---

## RPGWeightInventory.gd

A weight-based inventory system that manages items with weight constraints.

### Properties

- `max_weight: int` - Maximum weight capacity (default: 100)
- `_weight_inventory: Array[RPGWeightItem]` - Array of items in inventory
- `_weight: int` - Current total weight of inventory

### Signals

- `weight_filled()` - Emitted when inventory reaches maximum weight
- `weight_changed(new_value)` - Emitted when total weight changes

### Functions

- `add_item(item)` - Adds an item to inventory if weight allows
- `get_item(uuid)` - Retrieves an item by its UUID, returns null if not found
- `remove_item(uuid)` - Removes an item by UUID, returns true if successful

### Constants

- `CANT_ADD` - Error message for failed item addition
- `ITEM_WEIGHT` - Label for item weight display
- `WEIGHT_INVETORY` - Label for inventory weight display
- `FULL_INVENTORY` - Message when inventory is at capacity

---

## RPGWeightItem.gd

Extended RPGItem class that adds weight properties for use in weight-based inventory systems.

### Properties

- `weight: int` - Weight value of the item in inventory (default: 1)

### Signals

- `weight_updated(new_weight)` - Emitted when item weight is modified

This class inherits all properties, signals, and functionality from RPGItem, adding weight management specifically for inventory systems that track carrying capacity.
