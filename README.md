![](fleeca%20heist.png)

# rtk_fleeca
Fleeca heist convert from ESX to VRPEX, with some bonuses.<br>
We have a [Discord](https://discord.gg/V9MT4zr) server to discuss, or if you need help!  
[![Discord](https://img.shields.io/discord/736977037591576636?color=blueviolet&label=Discord)](https://discord.gg/V9MT4zr)

## About
Fleeca bank robbery script, with mini game, synced money props and police notify.

## Preview
https://streamable.com/q2xhuc

## Dependencies
* utk_fingerprint and utk_hackdependency: [get here](https://github.com/utkuali/Finger-Print-Hacking-Game)
* VRPEX based on creative: [get here](https://github.com/contatosummerz/vrpex) or similar.

## Installation


Very easy! Just extract the rtk_fleeca to your fivem resources folder and add it to server.cfg:

``
ensure rtk_fleeca
``

## Config

Open config.lua and change as you like:

|       Variable         |Description                          |
|----------------|-------------------------------|
|timer|`countdown to secure lock in seconds`            |
|hacktime|`first door open delay to make time for police to arrive and roleplay in miliseconds`            |
|maxcash|`maximum amount of cash a pile can hold`            |
|mincash|`minimum amount of cash a pile holds`            |
|black|`true or false - if true the player takes the dirty money item, if false takes clean money directly from the wallet`            |
|cooldown|`amount of time to do the heist again in seconds`            |
|mincops|`minimum required cops to start heist`            |
|item1|`item needed to open the first door and start the heist`            |
|item2|`item needed to open the second door`            |

* **ATTENTION:** Just tweak the other settings if you know what you're doing

## Credits

* Original [Fleeca Heist](https://github.com/utkuali/Fleeca-Bank-Heists) for ESX by [utkuali](https://github.com/utkuali)
* Conversion and adaptation to VRPEX - '𝗥𝗜𝗦𝗧𝗨𝗞𝗜 気 グ 雲# 0001
