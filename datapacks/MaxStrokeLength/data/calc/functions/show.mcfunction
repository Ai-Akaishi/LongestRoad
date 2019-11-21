execute at @e[tag=Edge] positioned ~ ~1 ~ run fill ^ ^ ^1 ^ ^ ^1 minecraft:air
execute at @e[tag=Edge] positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^-1 minecraft:air

execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~ ~ RecordItem.tag.MaxPath set from block 0 0 0 RecordItem.tag.MaxPath
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~ ~ RecordItem.tag.MaxPath set from block 0 1 0 RecordItem.tag.MaxPath
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~ ~ RecordItem.tag.MaxPath set from block 0 2 0 RecordItem.tag.MaxPath
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~ ~ RecordItem.tag.MaxPath set from block 0 3 0 RecordItem.tag.MaxPath

execute at @e[tag=Edge,scores={PathNumber=01}] if block ~ 0 ~ minecraft:jukebox{RecordItem:{tag:{MaxPath:[1]}}} positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^1 minecraft:white_concrete keep
execute at @e[tag=Edge,scores={PathNumber=02}] if block ~ 0 ~ minecraft:jukebox{RecordItem:{tag:{MaxPath:[2]}}} positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^1 minecraft:white_concrete keep
execute at @e[tag=Edge,scores={PathNumber=03}] if block ~ 0 ~ minecraft:jukebox{RecordItem:{tag:{MaxPath:[3]}}} positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^1 minecraft:white_concrete keep
execute at @e[tag=Edge,scores={PathNumber=04}] if block ~ 0 ~ minecraft:jukebox{RecordItem:{tag:{MaxPath:[4]}}} positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^1 minecraft:white_concrete keep
execute at @e[tag=Edge,scores={PathNumber=05}] if block ~ 0 ~ minecraft:jukebox{RecordItem:{tag:{MaxPath:[5]}}} positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^1 minecraft:white_concrete keep
execute at @e[tag=Edge,scores={PathNumber=06}] if block ~ 0 ~ minecraft:jukebox{RecordItem:{tag:{MaxPath:[6]}}} positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^1 minecraft:white_concrete keep
execute at @e[tag=Edge,scores={PathNumber=07}] if block ~ 0 ~ minecraft:jukebox{RecordItem:{tag:{MaxPath:[7]}}} positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^1 minecraft:white_concrete keep
execute at @e[tag=Edge,scores={PathNumber=08}] if block ~ 0 ~ minecraft:jukebox{RecordItem:{tag:{MaxPath:[8]}}} positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^1 minecraft:white_concrete keep
execute at @e[tag=Edge,scores={PathNumber=09}] if block ~ 0 ~ minecraft:jukebox{RecordItem:{tag:{MaxPath:[9]}}} positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^1 minecraft:white_concrete keep
execute at @e[tag=Edge,scores={PathNumber=10}] if block ~ 0 ~ minecraft:jukebox{RecordItem:{tag:{MaxPath:[10]}}} positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^1 minecraft:white_concrete keep
execute at @e[tag=Edge,scores={PathNumber=11}] if block ~ 0 ~ minecraft:jukebox{RecordItem:{tag:{MaxPath:[11]}}} positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^1 minecraft:white_concrete keep
execute at @e[tag=Edge,scores={PathNumber=12}] if block ~ 0 ~ minecraft:jukebox{RecordItem:{tag:{MaxPath:[12]}}} positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^1 minecraft:white_concrete keep
execute at @e[tag=Edge,scores={PathNumber=13}] if block ~ 0 ~ minecraft:jukebox{RecordItem:{tag:{MaxPath:[13]}}} positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^1 minecraft:white_concrete keep
execute at @e[tag=Edge,scores={PathNumber=14}] if block ~ 0 ~ minecraft:jukebox{RecordItem:{tag:{MaxPath:[14]}}} positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^1 minecraft:white_concrete keep
execute at @e[tag=Edge,scores={PathNumber=15}] if block ~ 0 ~ minecraft:jukebox{RecordItem:{tag:{MaxPath:[15]}}} positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^1 minecraft:white_concrete keep
execute at @e[tag=Edge,scores={PathNumber=16}] if block ~ 0 ~ minecraft:jukebox{RecordItem:{tag:{MaxPath:[16]}}} positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^1 minecraft:white_concrete keep
execute at @e[tag=Edge,scores={PathNumber=17}] if block ~ 0 ~ minecraft:jukebox{RecordItem:{tag:{MaxPath:[17]}}} positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^1 minecraft:white_concrete keep
execute at @e[tag=Edge,scores={PathNumber=18}] if block ~ 0 ~ minecraft:jukebox{RecordItem:{tag:{MaxPath:[18]}}} positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^1 minecraft:white_concrete keep
execute at @e[tag=Edge,scores={PathNumber=19}] if block ~ 0 ~ minecraft:jukebox{RecordItem:{tag:{MaxPath:[19]}}} positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^1 minecraft:white_concrete keep
execute at @e[tag=Edge,scores={PathNumber=20}] if block ~ 0 ~ minecraft:jukebox{RecordItem:{tag:{MaxPath:[20]}}} positioned ~ ~1 ~ run fill ^ ^ ^-1 ^ ^ ^1 minecraft:white_concrete keep

execute as @e[tag=Edge,team=Red] at @s positioned ~ ~1 ~ run fill ^-1 ^ ^-1 ^1 ^ ^1 minecraft:red_concrete replace minecraft:white_concrete
execute as @e[tag=Edge,team=Gre] at @s positioned ~ ~1 ~ run fill ^-1 ^ ^-1 ^1 ^ ^1 minecraft:green_concrete replace minecraft:white_concrete
execute as @e[tag=Edge,team=Blu] at @s positioned ~ ~1 ~ run fill ^-1 ^ ^-1 ^1 ^ ^1 minecraft:blue_concrete replace minecraft:white_concrete
execute as @e[tag=Edge,team=Yel] at @s positioned ~ ~1 ~ run fill ^-1 ^ ^-1 ^1 ^ ^1 minecraft:yellow_concrete replace minecraft:white_concrete
