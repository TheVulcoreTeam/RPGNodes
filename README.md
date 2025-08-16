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

### RPGCharacter

TODO

### RPGDialog

TODO

### RPGWeightInventory

TODO

### RPGWeightItem

TODO
