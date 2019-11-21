#############################################################
###  最長交易路を計算します。
###  function縛りのべた書きです。
###  (2)から(20)は、全く同じものの繰り返し。
###
###  必要コマンド実行数(n = playerの街道設置可能数)
###  18 + (n + 22) * (n - 1) + 4
###  n=15 : 540 (オリジナルカタンの上限)
###  n=20 : 820 (これ)
###  n=30 : 1530 (これだけあればまず大丈夫？)
###  n=72 : 6696 (街道塗り潰し)
###
###  使用エンティティ
###  Node : 開拓地候補アマスタ
###  Edge : 街道候補アマスタ
###  Double : 真上と真下を向いた２つのアマスタ
###
###  使用タイルエンティティ
###  開拓地 Y0 : 開拓地jukebox
###  街道 Y0 & Y1 : 街道jukebox(前用&後用)
###  0 0-3 0 : 各色用jukebox(纏めてもok)
#############################################################

team join White @e[tag=Node]
team join White @e[tag=Edge]
execute as @e[team=White] at @s if block ~ ~1 ~ minecraft:red_wool run team join Red @s
execute as @e[team=White] at @s if block ~ ~1 ~ minecraft:green_wool run team join Gre @s
execute as @e[team=White] at @s if block ~ ~1 ~ minecraft:blue_wool run team join Blu @s
execute as @e[team=White] at @s if block ~ ~1 ~ minecraft:yellow_wool run team join Yel @s

scoreboard players set @e[tag=Edge] PathNumber 0
execute positioned 0 0 0 as @e[tag=Edge,team=Red] store result score @s PathNumber if entity @e[tag=Edge,team=Red,scores={PathNumber=0}]
execute positioned 0 0 0 as @e[tag=Edge,team=Gre] store result score @s PathNumber if entity @e[tag=Edge,team=Gre,scores={PathNumber=0}]
execute positioned 0 0 0 as @e[tag=Edge,team=Blu] store result score @s PathNumber if entity @e[tag=Edge,team=Blu,scores={PathNumber=0}]
execute positioned 0 0 0 as @e[tag=Edge,team=Yel] store result score @s PathNumber if entity @e[tag=Edge,team=Yel,scores={PathNumber=0}]

execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 run data modify block ~ ~ ~ RecordItem.tag set value {Cand:[]}
execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 store result block ~ ~ ~ RecordItem.tag.Number int 1 run scoreboard players get @s PathNumber
execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 run data modify block ~ ~ ~ RecordItem.tag.Cand[].Pass append from block ~ ~ ~ RecordItem.tag.Number

# 保存(1)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 0 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 1 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 2 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 3 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass

# 開拓地へ(2)
execute as @e[tag=Node] at @s run data modify block ~ 0 ~ RecordItem.tag set value {Red:[],Gre:[],Blu:[],Yel:[]}
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Red append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Red append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Gre append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Gre append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Blu append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Blu append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Yel append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Yel append from block ~ ~1 ~ RecordItem.tag.Cand[]

# 街道へ(2)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Red
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Red
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Gre
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Gre
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Blu
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Blu
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Yel
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Yel

execute as @e[tag=Edge,scores={PathNumber=01}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[1]}]
execute as @e[tag=Edge,scores={PathNumber=02}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[2]}]
execute as @e[tag=Edge,scores={PathNumber=03}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[3]}]
execute as @e[tag=Edge,scores={PathNumber=04}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[4]}]
execute as @e[tag=Edge,scores={PathNumber=05}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[5]}]
execute as @e[tag=Edge,scores={PathNumber=06}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[6]}]
execute as @e[tag=Edge,scores={PathNumber=07}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[7]}]
execute as @e[tag=Edge,scores={PathNumber=08}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[8]}]
execute as @e[tag=Edge,scores={PathNumber=09}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[9]}]
execute as @e[tag=Edge,scores={PathNumber=10}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[10]}]
execute as @e[tag=Edge,scores={PathNumber=11}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[11]}]
execute as @e[tag=Edge,scores={PathNumber=12}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[12]}]
execute as @e[tag=Edge,scores={PathNumber=13}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[13]}]
execute as @e[tag=Edge,scores={PathNumber=14}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[14]}]
execute as @e[tag=Edge,scores={PathNumber=15}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[15]}]
execute as @e[tag=Edge,scores={PathNumber=16}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[16]}]
execute as @e[tag=Edge,scores={PathNumber=17}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[17]}]
execute as @e[tag=Edge,scores={PathNumber=18}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[18]}]
execute as @e[tag=Edge,scores={PathNumber=19}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[19]}]
execute as @e[tag=Edge,scores={PathNumber=20}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[20]}]

execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block ~ ~ ~ RecordItem.tag.Cand[].Pass append from block ~ ~ ~ RecordItem.tag.Number

# 保存(2)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 0 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 1 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 2 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 3 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass

# 開拓地へ(3)
execute as @e[tag=Node] at @s run data modify block ~ 0 ~ RecordItem.tag set value {Red:[],Gre:[],Blu:[],Yel:[]}
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Red append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Red append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Gre append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Gre append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Blu append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Blu append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Yel append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Yel append from block ~ ~1 ~ RecordItem.tag.Cand[]

# 街道へ(3)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Red
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Red
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Gre
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Gre
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Blu
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Blu
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Yel
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Yel

execute as @e[tag=Edge,scores={PathNumber=01}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[1]}]
execute as @e[tag=Edge,scores={PathNumber=02}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[2]}]
execute as @e[tag=Edge,scores={PathNumber=03}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[3]}]
execute as @e[tag=Edge,scores={PathNumber=04}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[4]}]
execute as @e[tag=Edge,scores={PathNumber=05}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[5]}]
execute as @e[tag=Edge,scores={PathNumber=06}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[6]}]
execute as @e[tag=Edge,scores={PathNumber=07}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[7]}]
execute as @e[tag=Edge,scores={PathNumber=08}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[8]}]
execute as @e[tag=Edge,scores={PathNumber=09}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[9]}]
execute as @e[tag=Edge,scores={PathNumber=10}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[10]}]
execute as @e[tag=Edge,scores={PathNumber=11}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[11]}]
execute as @e[tag=Edge,scores={PathNumber=12}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[12]}]
execute as @e[tag=Edge,scores={PathNumber=13}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[13]}]
execute as @e[tag=Edge,scores={PathNumber=14}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[14]}]
execute as @e[tag=Edge,scores={PathNumber=15}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[15]}]
execute as @e[tag=Edge,scores={PathNumber=16}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[16]}]
execute as @e[tag=Edge,scores={PathNumber=17}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[17]}]
execute as @e[tag=Edge,scores={PathNumber=18}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[18]}]
execute as @e[tag=Edge,scores={PathNumber=19}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[19]}]
execute as @e[tag=Edge,scores={PathNumber=20}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[20]}]

execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block ~ ~ ~ RecordItem.tag.Cand[].Pass append from block ~ ~ ~ RecordItem.tag.Number

# 保存(3)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 0 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 1 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 2 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 3 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass

# 開拓地へ(4)
execute as @e[tag=Node] at @s run data modify block ~ 0 ~ RecordItem.tag set value {Red:[],Gre:[],Blu:[],Yel:[]}
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Red append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Red append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Gre append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Gre append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Blu append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Blu append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Yel append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Yel append from block ~ ~1 ~ RecordItem.tag.Cand[]

# 街道へ(4)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Red
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Red
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Gre
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Gre
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Blu
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Blu
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Yel
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Yel

execute as @e[tag=Edge,scores={PathNumber=01}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[1]}]
execute as @e[tag=Edge,scores={PathNumber=02}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[2]}]
execute as @e[tag=Edge,scores={PathNumber=03}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[3]}]
execute as @e[tag=Edge,scores={PathNumber=04}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[4]}]
execute as @e[tag=Edge,scores={PathNumber=05}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[5]}]
execute as @e[tag=Edge,scores={PathNumber=06}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[6]}]
execute as @e[tag=Edge,scores={PathNumber=07}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[7]}]
execute as @e[tag=Edge,scores={PathNumber=08}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[8]}]
execute as @e[tag=Edge,scores={PathNumber=09}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[9]}]
execute as @e[tag=Edge,scores={PathNumber=10}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[10]}]
execute as @e[tag=Edge,scores={PathNumber=11}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[11]}]
execute as @e[tag=Edge,scores={PathNumber=12}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[12]}]
execute as @e[tag=Edge,scores={PathNumber=13}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[13]}]
execute as @e[tag=Edge,scores={PathNumber=14}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[14]}]
execute as @e[tag=Edge,scores={PathNumber=15}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[15]}]
execute as @e[tag=Edge,scores={PathNumber=16}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[16]}]
execute as @e[tag=Edge,scores={PathNumber=17}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[17]}]
execute as @e[tag=Edge,scores={PathNumber=18}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[18]}]
execute as @e[tag=Edge,scores={PathNumber=19}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[19]}]
execute as @e[tag=Edge,scores={PathNumber=20}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[20]}]

execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block ~ ~ ~ RecordItem.tag.Cand[].Pass append from block ~ ~ ~ RecordItem.tag.Number

# 保存(4)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 0 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 1 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 2 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 3 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass

# 開拓地へ(5)
execute as @e[tag=Node] at @s run data modify block ~ 0 ~ RecordItem.tag set value {Red:[],Gre:[],Blu:[],Yel:[]}
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Red append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Red append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Gre append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Gre append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Blu append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Blu append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Yel append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Yel append from block ~ ~1 ~ RecordItem.tag.Cand[]

# 街道へ(5)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Red
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Red
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Gre
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Gre
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Blu
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Blu
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Yel
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Yel

execute as @e[tag=Edge,scores={PathNumber=01}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[1]}]
execute as @e[tag=Edge,scores={PathNumber=02}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[2]}]
execute as @e[tag=Edge,scores={PathNumber=03}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[3]}]
execute as @e[tag=Edge,scores={PathNumber=04}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[4]}]
execute as @e[tag=Edge,scores={PathNumber=05}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[5]}]
execute as @e[tag=Edge,scores={PathNumber=06}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[6]}]
execute as @e[tag=Edge,scores={PathNumber=07}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[7]}]
execute as @e[tag=Edge,scores={PathNumber=08}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[8]}]
execute as @e[tag=Edge,scores={PathNumber=09}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[9]}]
execute as @e[tag=Edge,scores={PathNumber=10}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[10]}]
execute as @e[tag=Edge,scores={PathNumber=11}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[11]}]
execute as @e[tag=Edge,scores={PathNumber=12}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[12]}]
execute as @e[tag=Edge,scores={PathNumber=13}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[13]}]
execute as @e[tag=Edge,scores={PathNumber=14}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[14]}]
execute as @e[tag=Edge,scores={PathNumber=15}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[15]}]
execute as @e[tag=Edge,scores={PathNumber=16}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[16]}]
execute as @e[tag=Edge,scores={PathNumber=17}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[17]}]
execute as @e[tag=Edge,scores={PathNumber=18}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[18]}]
execute as @e[tag=Edge,scores={PathNumber=19}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[19]}]
execute as @e[tag=Edge,scores={PathNumber=20}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[20]}]

execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block ~ ~ ~ RecordItem.tag.Cand[].Pass append from block ~ ~ ~ RecordItem.tag.Number

# 保存(5)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 0 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 1 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 2 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 3 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass

# 開拓地へ(6)
execute as @e[tag=Node] at @s run data modify block ~ 0 ~ RecordItem.tag set value {Red:[],Gre:[],Blu:[],Yel:[]}
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Red append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Red append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Gre append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Gre append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Blu append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Blu append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Yel append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Yel append from block ~ ~1 ~ RecordItem.tag.Cand[]

# 街道へ(6)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Red
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Red
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Gre
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Gre
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Blu
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Blu
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Yel
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Yel

execute as @e[tag=Edge,scores={PathNumber=01}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[1]}]
execute as @e[tag=Edge,scores={PathNumber=02}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[2]}]
execute as @e[tag=Edge,scores={PathNumber=03}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[3]}]
execute as @e[tag=Edge,scores={PathNumber=04}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[4]}]
execute as @e[tag=Edge,scores={PathNumber=05}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[5]}]
execute as @e[tag=Edge,scores={PathNumber=06}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[6]}]
execute as @e[tag=Edge,scores={PathNumber=07}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[7]}]
execute as @e[tag=Edge,scores={PathNumber=08}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[8]}]
execute as @e[tag=Edge,scores={PathNumber=09}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[9]}]
execute as @e[tag=Edge,scores={PathNumber=10}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[10]}]
execute as @e[tag=Edge,scores={PathNumber=11}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[11]}]
execute as @e[tag=Edge,scores={PathNumber=12}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[12]}]
execute as @e[tag=Edge,scores={PathNumber=13}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[13]}]
execute as @e[tag=Edge,scores={PathNumber=14}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[14]}]
execute as @e[tag=Edge,scores={PathNumber=15}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[15]}]
execute as @e[tag=Edge,scores={PathNumber=16}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[16]}]
execute as @e[tag=Edge,scores={PathNumber=17}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[17]}]
execute as @e[tag=Edge,scores={PathNumber=18}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[18]}]
execute as @e[tag=Edge,scores={PathNumber=19}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[19]}]
execute as @e[tag=Edge,scores={PathNumber=20}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[20]}]

execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block ~ ~ ~ RecordItem.tag.Cand[].Pass append from block ~ ~ ~ RecordItem.tag.Number

# 保存(6)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 0 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 1 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 2 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 3 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass

# 開拓地へ(7)
execute as @e[tag=Node] at @s run data modify block ~ 0 ~ RecordItem.tag set value {Red:[],Gre:[],Blu:[],Yel:[]}
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Red append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Red append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Gre append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Gre append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Blu append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Blu append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Yel append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Yel append from block ~ ~1 ~ RecordItem.tag.Cand[]

# 街道へ(7)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Red
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Red
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Gre
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Gre
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Blu
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Blu
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Yel
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Yel

execute as @e[tag=Edge,scores={PathNumber=01}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[1]}]
execute as @e[tag=Edge,scores={PathNumber=02}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[2]}]
execute as @e[tag=Edge,scores={PathNumber=03}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[3]}]
execute as @e[tag=Edge,scores={PathNumber=04}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[4]}]
execute as @e[tag=Edge,scores={PathNumber=05}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[5]}]
execute as @e[tag=Edge,scores={PathNumber=06}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[6]}]
execute as @e[tag=Edge,scores={PathNumber=07}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[7]}]
execute as @e[tag=Edge,scores={PathNumber=08}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[8]}]
execute as @e[tag=Edge,scores={PathNumber=09}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[9]}]
execute as @e[tag=Edge,scores={PathNumber=10}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[10]}]
execute as @e[tag=Edge,scores={PathNumber=11}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[11]}]
execute as @e[tag=Edge,scores={PathNumber=12}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[12]}]
execute as @e[tag=Edge,scores={PathNumber=13}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[13]}]
execute as @e[tag=Edge,scores={PathNumber=14}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[14]}]
execute as @e[tag=Edge,scores={PathNumber=15}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[15]}]
execute as @e[tag=Edge,scores={PathNumber=16}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[16]}]
execute as @e[tag=Edge,scores={PathNumber=17}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[17]}]
execute as @e[tag=Edge,scores={PathNumber=18}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[18]}]
execute as @e[tag=Edge,scores={PathNumber=19}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[19]}]
execute as @e[tag=Edge,scores={PathNumber=20}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[20]}]

execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block ~ ~ ~ RecordItem.tag.Cand[].Pass append from block ~ ~ ~ RecordItem.tag.Number

# 保存(7)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 0 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 1 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 2 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 3 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass

# 開拓地へ(8)
execute as @e[tag=Node] at @s run data modify block ~ 0 ~ RecordItem.tag set value {Red:[],Gre:[],Blu:[],Yel:[]}
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Red append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Red append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Gre append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Gre append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Blu append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Blu append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Yel append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Yel append from block ~ ~1 ~ RecordItem.tag.Cand[]

# 街道へ(8)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Red
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Red
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Gre
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Gre
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Blu
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Blu
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Yel
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Yel

execute as @e[tag=Edge,scores={PathNumber=01}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[1]}]
execute as @e[tag=Edge,scores={PathNumber=02}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[2]}]
execute as @e[tag=Edge,scores={PathNumber=03}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[3]}]
execute as @e[tag=Edge,scores={PathNumber=04}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[4]}]
execute as @e[tag=Edge,scores={PathNumber=05}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[5]}]
execute as @e[tag=Edge,scores={PathNumber=06}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[6]}]
execute as @e[tag=Edge,scores={PathNumber=07}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[7]}]
execute as @e[tag=Edge,scores={PathNumber=08}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[8]}]
execute as @e[tag=Edge,scores={PathNumber=09}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[9]}]
execute as @e[tag=Edge,scores={PathNumber=10}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[10]}]
execute as @e[tag=Edge,scores={PathNumber=11}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[11]}]
execute as @e[tag=Edge,scores={PathNumber=12}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[12]}]
execute as @e[tag=Edge,scores={PathNumber=13}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[13]}]
execute as @e[tag=Edge,scores={PathNumber=14}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[14]}]
execute as @e[tag=Edge,scores={PathNumber=15}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[15]}]
execute as @e[tag=Edge,scores={PathNumber=16}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[16]}]
execute as @e[tag=Edge,scores={PathNumber=17}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[17]}]
execute as @e[tag=Edge,scores={PathNumber=18}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[18]}]
execute as @e[tag=Edge,scores={PathNumber=19}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[19]}]
execute as @e[tag=Edge,scores={PathNumber=20}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[20]}]

execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block ~ ~ ~ RecordItem.tag.Cand[].Pass append from block ~ ~ ~ RecordItem.tag.Number

# 保存(8)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 0 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 1 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 2 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 3 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass

# 開拓地へ(9)
execute as @e[tag=Node] at @s run data modify block ~ 0 ~ RecordItem.tag set value {Red:[],Gre:[],Blu:[],Yel:[]}
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Red append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Red append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Gre append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Gre append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Blu append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Blu append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Yel append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Yel append from block ~ ~1 ~ RecordItem.tag.Cand[]

# 街道へ(9)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Red
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Red
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Gre
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Gre
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Blu
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Blu
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Yel
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Yel

execute as @e[tag=Edge,scores={PathNumber=01}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[1]}]
execute as @e[tag=Edge,scores={PathNumber=02}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[2]}]
execute as @e[tag=Edge,scores={PathNumber=03}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[3]}]
execute as @e[tag=Edge,scores={PathNumber=04}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[4]}]
execute as @e[tag=Edge,scores={PathNumber=05}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[5]}]
execute as @e[tag=Edge,scores={PathNumber=06}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[6]}]
execute as @e[tag=Edge,scores={PathNumber=07}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[7]}]
execute as @e[tag=Edge,scores={PathNumber=08}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[8]}]
execute as @e[tag=Edge,scores={PathNumber=09}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[9]}]
execute as @e[tag=Edge,scores={PathNumber=10}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[10]}]
execute as @e[tag=Edge,scores={PathNumber=11}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[11]}]
execute as @e[tag=Edge,scores={PathNumber=12}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[12]}]
execute as @e[tag=Edge,scores={PathNumber=13}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[13]}]
execute as @e[tag=Edge,scores={PathNumber=14}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[14]}]
execute as @e[tag=Edge,scores={PathNumber=15}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[15]}]
execute as @e[tag=Edge,scores={PathNumber=16}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[16]}]
execute as @e[tag=Edge,scores={PathNumber=17}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[17]}]
execute as @e[tag=Edge,scores={PathNumber=18}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[18]}]
execute as @e[tag=Edge,scores={PathNumber=19}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[19]}]
execute as @e[tag=Edge,scores={PathNumber=20}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[20]}]

execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block ~ ~ ~ RecordItem.tag.Cand[].Pass append from block ~ ~ ~ RecordItem.tag.Number

# 保存(9)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 0 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 1 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 2 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 3 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass

# 開拓地へ(10)
execute as @e[tag=Node] at @s run data modify block ~ 0 ~ RecordItem.tag set value {Red:[],Gre:[],Blu:[],Yel:[]}
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Red append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Red append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Gre append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Gre append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Blu append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Blu append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Yel append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Yel append from block ~ ~1 ~ RecordItem.tag.Cand[]

# 街道へ(10)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Red
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Red
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Gre
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Gre
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Blu
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Blu
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Yel
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Yel

execute as @e[tag=Edge,scores={PathNumber=01}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[1]}]
execute as @e[tag=Edge,scores={PathNumber=02}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[2]}]
execute as @e[tag=Edge,scores={PathNumber=03}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[3]}]
execute as @e[tag=Edge,scores={PathNumber=04}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[4]}]
execute as @e[tag=Edge,scores={PathNumber=05}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[5]}]
execute as @e[tag=Edge,scores={PathNumber=06}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[6]}]
execute as @e[tag=Edge,scores={PathNumber=07}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[7]}]
execute as @e[tag=Edge,scores={PathNumber=08}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[8]}]
execute as @e[tag=Edge,scores={PathNumber=09}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[9]}]
execute as @e[tag=Edge,scores={PathNumber=10}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[10]}]
execute as @e[tag=Edge,scores={PathNumber=11}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[11]}]
execute as @e[tag=Edge,scores={PathNumber=12}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[12]}]
execute as @e[tag=Edge,scores={PathNumber=13}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[13]}]
execute as @e[tag=Edge,scores={PathNumber=14}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[14]}]
execute as @e[tag=Edge,scores={PathNumber=15}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[15]}]
execute as @e[tag=Edge,scores={PathNumber=16}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[16]}]
execute as @e[tag=Edge,scores={PathNumber=17}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[17]}]
execute as @e[tag=Edge,scores={PathNumber=18}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[18]}]
execute as @e[tag=Edge,scores={PathNumber=19}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[19]}]
execute as @e[tag=Edge,scores={PathNumber=20}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[20]}]

execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block ~ ~ ~ RecordItem.tag.Cand[].Pass append from block ~ ~ ~ RecordItem.tag.Number

# 保存(10)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 0 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 1 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 2 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 3 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass

# 開拓地へ(11)
execute as @e[tag=Node] at @s run data modify block ~ 0 ~ RecordItem.tag set value {Red:[],Gre:[],Blu:[],Yel:[]}
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Red append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Red append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Gre append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Gre append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Blu append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Blu append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Yel append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Yel append from block ~ ~1 ~ RecordItem.tag.Cand[]

# 街道へ(11)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Red
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Red
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Gre
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Gre
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Blu
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Blu
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Yel
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Yel

execute as @e[tag=Edge,scores={PathNumber=01}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[1]}]
execute as @e[tag=Edge,scores={PathNumber=02}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[2]}]
execute as @e[tag=Edge,scores={PathNumber=03}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[3]}]
execute as @e[tag=Edge,scores={PathNumber=04}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[4]}]
execute as @e[tag=Edge,scores={PathNumber=05}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[5]}]
execute as @e[tag=Edge,scores={PathNumber=06}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[6]}]
execute as @e[tag=Edge,scores={PathNumber=07}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[7]}]
execute as @e[tag=Edge,scores={PathNumber=08}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[8]}]
execute as @e[tag=Edge,scores={PathNumber=09}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[9]}]
execute as @e[tag=Edge,scores={PathNumber=10}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[10]}]
execute as @e[tag=Edge,scores={PathNumber=11}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[11]}]
execute as @e[tag=Edge,scores={PathNumber=12}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[12]}]
execute as @e[tag=Edge,scores={PathNumber=13}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[13]}]
execute as @e[tag=Edge,scores={PathNumber=14}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[14]}]
execute as @e[tag=Edge,scores={PathNumber=15}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[15]}]
execute as @e[tag=Edge,scores={PathNumber=16}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[16]}]
execute as @e[tag=Edge,scores={PathNumber=17}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[17]}]
execute as @e[tag=Edge,scores={PathNumber=18}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[18]}]
execute as @e[tag=Edge,scores={PathNumber=19}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[19]}]
execute as @e[tag=Edge,scores={PathNumber=20}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[20]}]

execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block ~ ~ ~ RecordItem.tag.Cand[].Pass append from block ~ ~ ~ RecordItem.tag.Number

# 保存(11)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 0 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 1 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 2 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 3 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass

# 開拓地へ(12)
execute as @e[tag=Node] at @s run data modify block ~ 0 ~ RecordItem.tag set value {Red:[],Gre:[],Blu:[],Yel:[]}
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Red append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Red append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Gre append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Gre append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Blu append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Blu append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Yel append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Yel append from block ~ ~1 ~ RecordItem.tag.Cand[]

# 街道へ(12)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Red
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Red
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Gre
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Gre
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Blu
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Blu
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Yel
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Yel

execute as @e[tag=Edge,scores={PathNumber=01}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[1]}]
execute as @e[tag=Edge,scores={PathNumber=02}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[2]}]
execute as @e[tag=Edge,scores={PathNumber=03}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[3]}]
execute as @e[tag=Edge,scores={PathNumber=04}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[4]}]
execute as @e[tag=Edge,scores={PathNumber=05}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[5]}]
execute as @e[tag=Edge,scores={PathNumber=06}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[6]}]
execute as @e[tag=Edge,scores={PathNumber=07}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[7]}]
execute as @e[tag=Edge,scores={PathNumber=08}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[8]}]
execute as @e[tag=Edge,scores={PathNumber=09}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[9]}]
execute as @e[tag=Edge,scores={PathNumber=10}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[10]}]
execute as @e[tag=Edge,scores={PathNumber=11}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[11]}]
execute as @e[tag=Edge,scores={PathNumber=12}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[12]}]
execute as @e[tag=Edge,scores={PathNumber=13}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[13]}]
execute as @e[tag=Edge,scores={PathNumber=14}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[14]}]
execute as @e[tag=Edge,scores={PathNumber=15}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[15]}]
execute as @e[tag=Edge,scores={PathNumber=16}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[16]}]
execute as @e[tag=Edge,scores={PathNumber=17}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[17]}]
execute as @e[tag=Edge,scores={PathNumber=18}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[18]}]
execute as @e[tag=Edge,scores={PathNumber=19}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[19]}]
execute as @e[tag=Edge,scores={PathNumber=20}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[20]}]

execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block ~ ~ ~ RecordItem.tag.Cand[].Pass append from block ~ ~ ~ RecordItem.tag.Number

# 保存(12)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 0 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 1 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 2 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 3 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass

# 開拓地へ(13)
execute as @e[tag=Node] at @s run data modify block ~ 0 ~ RecordItem.tag set value {Red:[],Gre:[],Blu:[],Yel:[]}
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Red append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Red append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Gre append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Gre append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Blu append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Blu append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Yel append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Yel append from block ~ ~1 ~ RecordItem.tag.Cand[]

# 街道へ(13)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Red
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Red
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Gre
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Gre
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Blu
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Blu
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Yel
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Yel

execute as @e[tag=Edge,scores={PathNumber=01}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[1]}]
execute as @e[tag=Edge,scores={PathNumber=02}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[2]}]
execute as @e[tag=Edge,scores={PathNumber=03}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[3]}]
execute as @e[tag=Edge,scores={PathNumber=04}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[4]}]
execute as @e[tag=Edge,scores={PathNumber=05}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[5]}]
execute as @e[tag=Edge,scores={PathNumber=06}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[6]}]
execute as @e[tag=Edge,scores={PathNumber=07}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[7]}]
execute as @e[tag=Edge,scores={PathNumber=08}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[8]}]
execute as @e[tag=Edge,scores={PathNumber=09}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[9]}]
execute as @e[tag=Edge,scores={PathNumber=10}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[10]}]
execute as @e[tag=Edge,scores={PathNumber=11}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[11]}]
execute as @e[tag=Edge,scores={PathNumber=12}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[12]}]
execute as @e[tag=Edge,scores={PathNumber=13}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[13]}]
execute as @e[tag=Edge,scores={PathNumber=14}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[14]}]
execute as @e[tag=Edge,scores={PathNumber=15}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[15]}]
execute as @e[tag=Edge,scores={PathNumber=16}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[16]}]
execute as @e[tag=Edge,scores={PathNumber=17}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[17]}]
execute as @e[tag=Edge,scores={PathNumber=18}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[18]}]
execute as @e[tag=Edge,scores={PathNumber=19}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[19]}]
execute as @e[tag=Edge,scores={PathNumber=20}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[20]}]

execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block ~ ~ ~ RecordItem.tag.Cand[].Pass append from block ~ ~ ~ RecordItem.tag.Number

# 保存(13)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 0 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 1 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 2 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 3 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass

# 開拓地へ(14)
execute as @e[tag=Node] at @s run data modify block ~ 0 ~ RecordItem.tag set value {Red:[],Gre:[],Blu:[],Yel:[]}
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Red append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Red append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Gre append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Gre append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Blu append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Blu append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Yel append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Yel append from block ~ ~1 ~ RecordItem.tag.Cand[]

# 街道へ(14)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Red
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Red
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Gre
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Gre
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Blu
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Blu
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Yel
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Yel

execute as @e[tag=Edge,scores={PathNumber=01}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[1]}]
execute as @e[tag=Edge,scores={PathNumber=02}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[2]}]
execute as @e[tag=Edge,scores={PathNumber=03}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[3]}]
execute as @e[tag=Edge,scores={PathNumber=04}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[4]}]
execute as @e[tag=Edge,scores={PathNumber=05}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[5]}]
execute as @e[tag=Edge,scores={PathNumber=06}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[6]}]
execute as @e[tag=Edge,scores={PathNumber=07}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[7]}]
execute as @e[tag=Edge,scores={PathNumber=08}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[8]}]
execute as @e[tag=Edge,scores={PathNumber=09}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[9]}]
execute as @e[tag=Edge,scores={PathNumber=10}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[10]}]
execute as @e[tag=Edge,scores={PathNumber=11}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[11]}]
execute as @e[tag=Edge,scores={PathNumber=12}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[12]}]
execute as @e[tag=Edge,scores={PathNumber=13}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[13]}]
execute as @e[tag=Edge,scores={PathNumber=14}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[14]}]
execute as @e[tag=Edge,scores={PathNumber=15}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[15]}]
execute as @e[tag=Edge,scores={PathNumber=16}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[16]}]
execute as @e[tag=Edge,scores={PathNumber=17}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[17]}]
execute as @e[tag=Edge,scores={PathNumber=18}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[18]}]
execute as @e[tag=Edge,scores={PathNumber=19}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[19]}]
execute as @e[tag=Edge,scores={PathNumber=20}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[20]}]

execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block ~ ~ ~ RecordItem.tag.Cand[].Pass append from block ~ ~ ~ RecordItem.tag.Number

# 保存(14)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 0 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 1 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 2 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 3 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass

# 開拓地へ(15)
execute as @e[tag=Node] at @s run data modify block ~ 0 ~ RecordItem.tag set value {Red:[],Gre:[],Blu:[],Yel:[]}
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Red append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Red append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Gre append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Gre append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Blu append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Blu append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Yel append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Yel append from block ~ ~1 ~ RecordItem.tag.Cand[]

# 街道へ(15)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Red
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Red
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Gre
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Gre
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Blu
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Blu
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Yel
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Yel

execute as @e[tag=Edge,scores={PathNumber=01}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[1]}]
execute as @e[tag=Edge,scores={PathNumber=02}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[2]}]
execute as @e[tag=Edge,scores={PathNumber=03}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[3]}]
execute as @e[tag=Edge,scores={PathNumber=04}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[4]}]
execute as @e[tag=Edge,scores={PathNumber=05}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[5]}]
execute as @e[tag=Edge,scores={PathNumber=06}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[6]}]
execute as @e[tag=Edge,scores={PathNumber=07}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[7]}]
execute as @e[tag=Edge,scores={PathNumber=08}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[8]}]
execute as @e[tag=Edge,scores={PathNumber=09}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[9]}]
execute as @e[tag=Edge,scores={PathNumber=10}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[10]}]
execute as @e[tag=Edge,scores={PathNumber=11}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[11]}]
execute as @e[tag=Edge,scores={PathNumber=12}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[12]}]
execute as @e[tag=Edge,scores={PathNumber=13}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[13]}]
execute as @e[tag=Edge,scores={PathNumber=14}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[14]}]
execute as @e[tag=Edge,scores={PathNumber=15}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[15]}]
execute as @e[tag=Edge,scores={PathNumber=16}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[16]}]
execute as @e[tag=Edge,scores={PathNumber=17}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[17]}]
execute as @e[tag=Edge,scores={PathNumber=18}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[18]}]
execute as @e[tag=Edge,scores={PathNumber=19}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[19]}]
execute as @e[tag=Edge,scores={PathNumber=20}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[20]}]

execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block ~ ~ ~ RecordItem.tag.Cand[].Pass append from block ~ ~ ~ RecordItem.tag.Number

# 保存(15)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 0 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 1 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 2 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 3 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass

# 開拓地へ(16)
execute as @e[tag=Node] at @s run data modify block ~ 0 ~ RecordItem.tag set value {Red:[],Gre:[],Blu:[],Yel:[]}
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Red append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Red append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Gre append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Gre append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Blu append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Blu append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Yel append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Yel append from block ~ ~1 ~ RecordItem.tag.Cand[]

# 街道へ(16)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Red
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Red
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Gre
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Gre
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Blu
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Blu
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Yel
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Yel

execute as @e[tag=Edge,scores={PathNumber=01}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[1]}]
execute as @e[tag=Edge,scores={PathNumber=02}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[2]}]
execute as @e[tag=Edge,scores={PathNumber=03}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[3]}]
execute as @e[tag=Edge,scores={PathNumber=04}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[4]}]
execute as @e[tag=Edge,scores={PathNumber=05}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[5]}]
execute as @e[tag=Edge,scores={PathNumber=06}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[6]}]
execute as @e[tag=Edge,scores={PathNumber=07}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[7]}]
execute as @e[tag=Edge,scores={PathNumber=08}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[8]}]
execute as @e[tag=Edge,scores={PathNumber=09}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[9]}]
execute as @e[tag=Edge,scores={PathNumber=10}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[10]}]
execute as @e[tag=Edge,scores={PathNumber=11}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[11]}]
execute as @e[tag=Edge,scores={PathNumber=12}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[12]}]
execute as @e[tag=Edge,scores={PathNumber=13}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[13]}]
execute as @e[tag=Edge,scores={PathNumber=14}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[14]}]
execute as @e[tag=Edge,scores={PathNumber=15}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[15]}]
execute as @e[tag=Edge,scores={PathNumber=16}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[16]}]
execute as @e[tag=Edge,scores={PathNumber=17}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[17]}]
execute as @e[tag=Edge,scores={PathNumber=18}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[18]}]
execute as @e[tag=Edge,scores={PathNumber=19}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[19]}]
execute as @e[tag=Edge,scores={PathNumber=20}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[20]}]

execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block ~ ~ ~ RecordItem.tag.Cand[].Pass append from block ~ ~ ~ RecordItem.tag.Number

# 保存(16)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 0 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 1 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 2 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 3 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass

# 開拓地へ(17)
execute as @e[tag=Node] at @s run data modify block ~ 0 ~ RecordItem.tag set value {Red:[],Gre:[],Blu:[],Yel:[]}
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Red append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Red append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Gre append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Gre append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Blu append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Blu append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Yel append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Yel append from block ~ ~1 ~ RecordItem.tag.Cand[]

# 街道へ(17)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Red
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Red
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Gre
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Gre
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Blu
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Blu
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Yel
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Yel

execute as @e[tag=Edge,scores={PathNumber=01}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[1]}]
execute as @e[tag=Edge,scores={PathNumber=02}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[2]}]
execute as @e[tag=Edge,scores={PathNumber=03}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[3]}]
execute as @e[tag=Edge,scores={PathNumber=04}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[4]}]
execute as @e[tag=Edge,scores={PathNumber=05}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[5]}]
execute as @e[tag=Edge,scores={PathNumber=06}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[6]}]
execute as @e[tag=Edge,scores={PathNumber=07}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[7]}]
execute as @e[tag=Edge,scores={PathNumber=08}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[8]}]
execute as @e[tag=Edge,scores={PathNumber=09}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[9]}]
execute as @e[tag=Edge,scores={PathNumber=10}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[10]}]
execute as @e[tag=Edge,scores={PathNumber=11}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[11]}]
execute as @e[tag=Edge,scores={PathNumber=12}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[12]}]
execute as @e[tag=Edge,scores={PathNumber=13}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[13]}]
execute as @e[tag=Edge,scores={PathNumber=14}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[14]}]
execute as @e[tag=Edge,scores={PathNumber=15}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[15]}]
execute as @e[tag=Edge,scores={PathNumber=16}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[16]}]
execute as @e[tag=Edge,scores={PathNumber=17}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[17]}]
execute as @e[tag=Edge,scores={PathNumber=18}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[18]}]
execute as @e[tag=Edge,scores={PathNumber=19}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[19]}]
execute as @e[tag=Edge,scores={PathNumber=20}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[20]}]

execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block ~ ~ ~ RecordItem.tag.Cand[].Pass append from block ~ ~ ~ RecordItem.tag.Number

# 保存(17)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 0 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 1 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 2 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 3 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass

# 開拓地へ(18)
execute as @e[tag=Node] at @s run data modify block ~ 0 ~ RecordItem.tag set value {Red:[],Gre:[],Blu:[],Yel:[]}
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Red append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Red append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Gre append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Gre append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Blu append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Blu append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Yel append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Yel append from block ~ ~1 ~ RecordItem.tag.Cand[]

# 街道へ(18)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Red
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Red
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Gre
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Gre
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Blu
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Blu
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Yel
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Yel

execute as @e[tag=Edge,scores={PathNumber=01}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[1]}]
execute as @e[tag=Edge,scores={PathNumber=02}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[2]}]
execute as @e[tag=Edge,scores={PathNumber=03}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[3]}]
execute as @e[tag=Edge,scores={PathNumber=04}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[4]}]
execute as @e[tag=Edge,scores={PathNumber=05}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[5]}]
execute as @e[tag=Edge,scores={PathNumber=06}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[6]}]
execute as @e[tag=Edge,scores={PathNumber=07}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[7]}]
execute as @e[tag=Edge,scores={PathNumber=08}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[8]}]
execute as @e[tag=Edge,scores={PathNumber=09}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[9]}]
execute as @e[tag=Edge,scores={PathNumber=10}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[10]}]
execute as @e[tag=Edge,scores={PathNumber=11}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[11]}]
execute as @e[tag=Edge,scores={PathNumber=12}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[12]}]
execute as @e[tag=Edge,scores={PathNumber=13}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[13]}]
execute as @e[tag=Edge,scores={PathNumber=14}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[14]}]
execute as @e[tag=Edge,scores={PathNumber=15}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[15]}]
execute as @e[tag=Edge,scores={PathNumber=16}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[16]}]
execute as @e[tag=Edge,scores={PathNumber=17}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[17]}]
execute as @e[tag=Edge,scores={PathNumber=18}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[18]}]
execute as @e[tag=Edge,scores={PathNumber=19}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[19]}]
execute as @e[tag=Edge,scores={PathNumber=20}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[20]}]

execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block ~ ~ ~ RecordItem.tag.Cand[].Pass append from block ~ ~ ~ RecordItem.tag.Number

# 保存(18)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 0 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 1 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 2 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 3 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass

# 開拓地へ(19)
execute as @e[tag=Node] at @s run data modify block ~ 0 ~ RecordItem.tag set value {Red:[],Gre:[],Blu:[],Yel:[]}
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Red append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Red append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Gre append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Gre append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Blu append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Blu append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Yel append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Yel append from block ~ ~1 ~ RecordItem.tag.Cand[]

# 街道へ(19)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Red
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Red
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Gre
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Gre
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Blu
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Blu
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Yel
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Yel

execute as @e[tag=Edge,scores={PathNumber=01}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[1]}]
execute as @e[tag=Edge,scores={PathNumber=02}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[2]}]
execute as @e[tag=Edge,scores={PathNumber=03}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[3]}]
execute as @e[tag=Edge,scores={PathNumber=04}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[4]}]
execute as @e[tag=Edge,scores={PathNumber=05}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[5]}]
execute as @e[tag=Edge,scores={PathNumber=06}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[6]}]
execute as @e[tag=Edge,scores={PathNumber=07}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[7]}]
execute as @e[tag=Edge,scores={PathNumber=08}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[8]}]
execute as @e[tag=Edge,scores={PathNumber=09}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[9]}]
execute as @e[tag=Edge,scores={PathNumber=10}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[10]}]
execute as @e[tag=Edge,scores={PathNumber=11}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[11]}]
execute as @e[tag=Edge,scores={PathNumber=12}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[12]}]
execute as @e[tag=Edge,scores={PathNumber=13}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[13]}]
execute as @e[tag=Edge,scores={PathNumber=14}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[14]}]
execute as @e[tag=Edge,scores={PathNumber=15}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[15]}]
execute as @e[tag=Edge,scores={PathNumber=16}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[16]}]
execute as @e[tag=Edge,scores={PathNumber=17}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[17]}]
execute as @e[tag=Edge,scores={PathNumber=18}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[18]}]
execute as @e[tag=Edge,scores={PathNumber=19}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[19]}]
execute as @e[tag=Edge,scores={PathNumber=20}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[20]}]

execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block ~ ~ ~ RecordItem.tag.Cand[].Pass append from block ~ ~ ~ RecordItem.tag.Number

# 保存(19)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 0 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 1 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 2 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 3 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass

# 開拓地へ(20)
execute as @e[tag=Node] at @s run data modify block ~ 0 ~ RecordItem.tag set value {Red:[],Gre:[],Blu:[],Yel:[]}
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Red append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Red] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Gre,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Red append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Gre append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Gre] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Blu,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Gre append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Blu append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Blu] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Yel] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Blu append from block ~ ~1 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^2. if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^2. RecordItem.tag.Yel append from block ~ ~0 ~ RecordItem.tag.Cand[]
execute as @e[tag=Edge,team=Yel] at @s positioned ^ ^ ^-2 if entity @e[distance=..1,team=!Red,team=!Gre,team=!Blu] positioned as @s positioned ~ 0 ~ run data modify block ^ ^ ^-2 RecordItem.tag.Yel append from block ~ ~1 ~ RecordItem.tag.Cand[]

# 街道へ(20)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Red
execute as @e[tag=Edge,team=Red] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Red
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Gre
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Gre
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Blu
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Blu
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~0 ~ RecordItem.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Yel
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 0 ~ run data modify block ~ ~1 ~ RecordItem.tag.Cand set from block ^ ^ ^2. RecordItem.tag.Yel

execute as @e[tag=Edge,scores={PathNumber=01}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[1]}]
execute as @e[tag=Edge,scores={PathNumber=02}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[2]}]
execute as @e[tag=Edge,scores={PathNumber=03}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[3]}]
execute as @e[tag=Edge,scores={PathNumber=04}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[4]}]
execute as @e[tag=Edge,scores={PathNumber=05}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[5]}]
execute as @e[tag=Edge,scores={PathNumber=06}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[6]}]
execute as @e[tag=Edge,scores={PathNumber=07}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[7]}]
execute as @e[tag=Edge,scores={PathNumber=08}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[8]}]
execute as @e[tag=Edge,scores={PathNumber=09}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[9]}]
execute as @e[tag=Edge,scores={PathNumber=10}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[10]}]
execute as @e[tag=Edge,scores={PathNumber=11}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[11]}]
execute as @e[tag=Edge,scores={PathNumber=12}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[12]}]
execute as @e[tag=Edge,scores={PathNumber=13}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[13]}]
execute as @e[tag=Edge,scores={PathNumber=14}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[14]}]
execute as @e[tag=Edge,scores={PathNumber=15}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[15]}]
execute as @e[tag=Edge,scores={PathNumber=16}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[16]}]
execute as @e[tag=Edge,scores={PathNumber=17}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[17]}]
execute as @e[tag=Edge,scores={PathNumber=18}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[18]}]
execute as @e[tag=Edge,scores={PathNumber=19}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[19]}]
execute as @e[tag=Edge,scores={PathNumber=20}] at @s positioned ~ 1 ~ rotated as @e[tag=Double] run data remove block ^ ^ ^0.5 RecordItem.tag.Cand[{Pass:[20]}]

execute as @e[tag=Edge] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block ~ ~ ~ RecordItem.tag.Cand[].Pass append from block ~ ~ ~ RecordItem.tag.Number

# 保存(20)
execute as @e[tag=Edge,team=Red] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 0 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Gre] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 1 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Blu] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 2 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass
execute as @e[tag=Edge,team=Yel] at @s positioned ~ 1 ~ rotated as @e[tag=Double] positioned ^ ^ ^0.5 if data block ~ ~ ~ RecordItem.tag.Cand[0] run data modify block 0 3 0 RecordItem.tag.MaxPath set from block ~ ~ ~ RecordItem.tag.Cand[].Pass

# 表示
execute store result score 赤 MaxPathLength run data get block 0 0 0 RecordItem.tag.MaxPath
execute store result score 緑 MaxPathLength run data get block 0 1 0 RecordItem.tag.MaxPath
execute store result score 青 MaxPathLength run data get block 0 2 0 RecordItem.tag.MaxPath
execute store result score 黄 MaxPathLength run data get block 0 3 0 RecordItem.tag.MaxPath
