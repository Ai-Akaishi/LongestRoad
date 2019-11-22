scoreboard objectives add MaxPathLength dummy {"text":"最大交易路長"}
scoreboard objectives setdisplay sidebar MaxPathLength

team add Red
team add Gre
team add Blu
team add Yel
team add White
team modify Red color red
team modify Gre color green
team modify Blu color blue
team modify Yel color yellow

team join Red 赤
team join Gre 緑
team join Blu 青
team join Yel 黄

scoreboard objectives add PathNumber dummy
scoreboard players set #2 PathNumber 2

setblock 0 0 0 minecraft:bedrock
setblock 0 1 0 minecraft:bedrock
setblock 0 2 0 minecraft:bedrock
setblock 0 3 0 minecraft:bedrock
setblock 0 0 0 minecraft:jukebox{RecordItem:{id:"minecraft:stone",Count:1b,tag:{}}} replace
setblock 0 1 0 minecraft:jukebox{RecordItem:{id:"minecraft:stone",Count:1b,tag:{}}} replace
setblock 0 2 0 minecraft:jukebox{RecordItem:{id:"minecraft:stone",Count:1b,tag:{}}} replace
setblock 0 3 0 minecraft:jukebox{RecordItem:{id:"minecraft:stone",Count:1b,tag:{}}} replace

execute as @e[tag=Edge] at @s run fill ~ 0 ~ ~ 3 ~ minecraft:air
