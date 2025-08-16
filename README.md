# RPGNodes

![logo](RPGNodes.png)

RPGNodes es un addons que facilita la lógica para crear juegos RPG a través de nodos personalizados.

## Resumen

RPGNodes es una solución genérica a la lógica que presentan los juegos RPG.

Por ejemplo: Con el nodo RPGCharacter podrá representar la lógica de un personaje, como podría ser el añadirle experiencia, vida, energía o mana; Con el nodo RPGItem o RPGWeightItem podrá representar un item del juego, tiene todas las características comúnes de un item (item_name, description, amount, buy_price, sell_price, etc.); RGPWeightInventory es para almacenar y tratar items con peso, es decir que cada item puede tener diferente peso

## Estado del proyecto

El proyecto si se puede usar, pero hay nodos que no están completos aún. Hay test unitarios con [GUT](https://github.com/bitwes/Gut/)

![](addons/rpg_nodes/icons/RPGCharacter.png) **RPGCharacter:** Muy usable: Testeado con pruebas unitarias (GUT)!!

![](addons/rpg_nodes/icons/RPGDialog.png) **RPGDialog:** Usable: Testeado en una escena en el proyecto.

![](addons/rpg_nodes/icons/RPGWeightItem.png) **RPGWeightItem:** Muy usable: y testeado junto a RPGWeightInventory con pruebas unitarias (GUT)

![](addons/rpg_nodes/icons/RPGWeightInventory.png) **RPGWeightInventory:** Muy usable: y testeado con pruebas unitarias (GUT)

![](addons/rpg_nodes/icons/RPGSlotInventory.png) **RPGSlotInventory:** TODO o no usable

![](addons/rpg_nodes/icons/RPGStats.png) **RPGStats:** TODO o no usable

## Instalación y uso

Recomendamos [descargar el último release en github](https://github.com/TheVulcoreTeam/RPGNodes/releases)

### Deseo testear el plugin

Para testear el plugin puedes clonar el repositorio y abrirlo con **Godot 4.4.x**. Pero si lo deseas utilizar realmente, es mejor decargar la versión que esta en release en Github.

### Deseo usar el plugin en un proyecto

Para usar el plugin en un proyecto requiere hacer los siguientes pasos:

1) [Descargar el release](https://github.com/TheVulcoreTeam/RPGNodes/releases)

2) Copiar la carpeta rpg_nodes y dejarlo dentro de la carpeta addons de tu proyecto. Si no tienes la carpeta addons en la raiz de tu proyecto debes crearla.

3) Abrir el editor y activar el plugin en **proyectos >> ajustes del proyecto >> plugins**

## Nodos personalizados

A continuación se describira el uso de los nodos personalizados, si tiene dudas del funcionamiento de algún método puedes levantar un issue de github o puede consultar el código fuente del respectivo nodo que estas utilizando. Los métodos estan en inglés y los comentarios igual.

### RPGCharacter

TODO

### RPGDialog

TODO

### RPGWeightInventory

TODO

### RPGWeightItem

TODO
