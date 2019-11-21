execute at @s run setblock ~ ~1 ~ minecraft:blue_wool
execute at @s at @e[distance=..3,tag=Edge] run tag @e[distance=..3,tag=Node] remove Free
team join Blu @s
