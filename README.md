# TanKet

#### Video Demo:  https://youtu.be/1gY1vTb6o8s

#### Description:

This is my final project for CS50x 2021 - A 2D game using lua with LOVE.

It is a simple survival game where player is controlling a tank to shoot the attacking
ghosts. Player has to keep shooting all ghosts and survive playing as long as
possible without dying. 

Game starts out easy with enemies doing very little damage, but as the player progresses through the game the enemy damage increases, and the number of enemies in each level increases as well. Health is replenished at the start of each level so that to give player a fighting chance at later levels. That is, game gets difficult with each level. 

There are four different kinds of enemies in the game- two ghosts, a tiny red demon, and a latern holding ghost (I am not sure what kind of ghost it is).
Originally, I wanted the enemies to be soldiers or tank but seeing the Halloween is near, I made the enemies ghosts and demons.

I split the whole program into multiple files so as to have better organisation and
better code structure. I have used [`classic`](https://github.com/rxi/classic) that provides a tiny class module for Lua.

###### `Body.lua`
It defines the Body class that extends the Object class from `classic`. It defines
an object constructor, getter and setters for common properties that all objects in the game have such as speed, position, angular orientation. And common functions i.e render(), which renders the current object on to the screen.

###### `Enemy.lua`
It is a super class to all the enemies in the game. It extends the `Body.lua` with
the methods and properties that all enemies share, and overrides some properties
such as default enemy damage, scale factor for sprite. Also defines a dummy move()
function that will be over-ridden by the each enemy according to its move pattern.

###### `Tank.lua`
The `Tank` object that player will control. It extends `Body`. Adds health, turretAngle, sprite, width, height and scale factor properties. Also defines getters-setters
for most of them. Also defines the functions to control tank movement, and turret. It
overrides the default `render()` function from `Body`

###### `Missile.lua`
The missile object in the game. It extends `Body` by overriding speed, and adding sprite, width and height. Also defines the function for updating missile position depending
on the initial angle (from the shoot angle by the Tank in the main.lua).

###### `Projectile.lua`
Similar to Missile Class but represents the projectiles that enemies shoot towards
the player. It defines a damage property, that indicates the amount of damage player
takes when hit by a projectile object. It has a custom update() function and getter-setter
for direction and damage.
I wanted to integrate this into `Enemy` class but it was buggy and I found out that
doing so I would need to make a considerable change in the whole game. So I
created this for not having to re-write everything again.

###### `Demonio.lua`
A red demon - one of four enemies in the game. Extends generic `Enemy` class.
Overrides the move() function.

###### `Fan350.lua`
A Oval white ghost - one of four enemies in the game. Extends generic `Enemy`
class. Overrides the move() function.

###### `Gantasmito.lua`
A white ghost - one of four enemies in the game. Extends generic `Enemy`
class. Overrides the move() function.

###### `Oscuro.lua`
Oscuro Con Aplo - one of four enemies in the game. Extends generic `Enemy`
class. Overrides the move() function.

###### `EnemyList.lua`
A single file that includes all the enemy modules. This way the `main.lua` needs to include `EnemyList` to include all enemies.

###### `main.lua`
The main file of the program. Contains the main game loop and all the games logic
while it is running such as updating game states, checking for events and calling appropriate function from `utils.lua`, etc.
This file was very big originally, because all the helper functions and such are
defined alongside the game-loop functions (love.load, love.update and love.draw). So I moved those functions and variables into `utils.lua`.

###### `utils.lua`
Contains the functions that help in running the game, such as spawnEnemy - generates enemy on the screen, player_movement - detects key events related to 
player movement, function to check collision, reset gamestate and so on.
Splitting a big main file into `main.lua` and `utils.lua` really simplified some of the code.

###### `THANKS.md`
This file attributes all the people who have provided assets for building this game
such as characters, music, sfx etc.
Note: This project uses a free font.


I really enjoyed doing this project. It was both challenging and fun!