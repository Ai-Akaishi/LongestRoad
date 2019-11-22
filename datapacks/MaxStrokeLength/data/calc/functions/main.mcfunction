#############################################################
###  最長交易路を計算します。
###  function縛りのべた書きです。
###  (2)から(20)は、全く同じものの繰り返し。
###
###  必要コマンド実行数(n = playerの街道設置可能数)
###  15 + (n + 5) * (n - 1) + 5 (道表示有なら + (n + 6))
###  n=15 : 300 (オリジナルカタンの上限)
###  n=20 : 495 (これ)
###  n=30 : 1035 (これだけあればまず大丈夫？)
###  n=72 : 5487 (街道塗り潰し)
###
###  使用エンティティ
###  Node : 開拓地候補アマスタ
###  Edge : 街道候補アマスタ
###  Arrow : 通過候補アイテム
###
###  使用タイルエンティティ
###  開拓地 Y0-3 : 開拓地jukebox(各色)
###  0 0-3 0 : 最長パス保存jukebox(各色)
#############################################################

execute as @e[tag=Node] at @s run fill ~ 0 ~ ~ 3 ~ minecraft:bedrock
execute as @e[tag=Node] at @s unless block ~ ~1 ~ minecraft:green_wool unless block ~ ~1 ~ minecraft:blue_wool unless block ~ ~1 ~ minecraft:yellow_wool run setblock ~ 0 ~ minecraft:jukebox{RecordItem:{id:"minecraft:stone",Count:1b,tag:{Routes:[]}}}
execute as @e[tag=Node] at @s unless block ~ ~1 ~ minecraft:red_wool unless block ~ ~1 ~ minecraft:blue_wool unless block ~ ~1 ~ minecraft:yellow_wool run setblock ~ 1 ~ minecraft:jukebox{RecordItem:{id:"minecraft:stone",Count:1b,tag:{Routes:[]}}}
execute as @e[tag=Node] at @s unless block ~ ~1 ~ minecraft:red_wool unless block ~ ~1 ~ minecraft:green_wool unless block ~ ~1 ~ minecraft:yellow_wool run setblock ~ 2 ~ minecraft:jukebox{RecordItem:{id:"minecraft:stone",Count:1b,tag:{Routes:[]}}}
execute as @e[tag=Node] at @s unless block ~ ~1 ~ minecraft:red_wool unless block ~ ~1 ~ minecraft:green_wool unless block ~ ~1 ~ minecraft:blue_wool run setblock ~ 3 ~ minecraft:jukebox{RecordItem:{id:"minecraft:stone",Count:1b,tag:{Routes:[]}}}

execute as @e[tag=Edge] at @s if block ~ ~1 ~ minecraft:red_wool as @e[tag=Node,limit=2] run summon minecraft:item ~ 0.5 ~ {NoGravity:true,Tags:[Arrow],Item:{id:"minecraft:diamond_sword",Count:1b,tag:{Cand:[]}}}
execute as @e[tag=Edge] at @s if block ~ ~1 ~ minecraft:green_wool as @e[tag=Node,limit=2] run summon minecraft:item ~ 1.5 ~ {NoGravity:true,Tags:[Arrow],Item:{id:"minecraft:diamond_sword",Count:1b,tag:{Cand:[]}}}
execute as @e[tag=Edge] at @s if block ~ ~1 ~ minecraft:blue_wool as @e[tag=Node,limit=2] run summon minecraft:item ~ 2.5 ~ {NoGravity:true,Tags:[Arrow],Item:{id:"minecraft:diamond_sword",Count:1b,tag:{Cand:[]}}}
execute as @e[tag=Edge] at @s if block ~ ~1 ~ minecraft:yellow_wool as @e[tag=Node,limit=2] run summon minecraft:item ~ 3.5 ~ {NoGravity:true,Tags:[Arrow],Item:{id:"minecraft:diamond_sword",Count:1b,tag:{Cand:[]}}}
execute as @e[tag=Edge] at @s positioned ~ 0 ~ as @e[dy=3,tag=Arrow] positioned as @s run tp @s ~ ~ ~ ~ ~
execute as @e[tag=Edge] at @s positioned ~ 0 ~ as @e[dy=3,tag=Arrow,limit=1] positioned as @s run tp @s ~ ~ ~ ~180 ~

execute as @e[x=0,y=0,z=0,tag=Arrow,sort=nearest] at @s store result score @e[distance=0,tag=Arrow] PathNumber align y if entity @e[x=0,z=0,dx=20,dz=40,tag=Arrow,scores={PathNumber=0..}]
execute as @e[tag=Arrow] store result entity @s Item.tag.Number int 1 run scoreboard players operation @s PathNumber /= #2 PathNumber
execute as @e[tag=Arrow] run data modify entity @s Item.tag.Cand[].Path append from entity @s Item.tag.Number

# 保存(1)
execute as @e[tag=Arrow] at @s if data entity @s Item.tag.Cand[0] run data modify block 0 ~ 0 RecordItem.tag.MaxPath set from entity @s Item.tag.Cand[].Path

# 開拓地へ(2)
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag set value {Routes:[]}
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag.Routes append from entity @s Item.tag.Cand[]

# 街道へ(2)
execute as @e[tag=Arrow] at @s run data modify entity @s Item.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Routes
execute as @e[tag=Arrow,scores={PathNumber=01}] run data remove entity @s Item.tag.Cand[{Path:[1]}]
execute as @e[tag=Arrow,scores={PathNumber=02}] run data remove entity @s Item.tag.Cand[{Path:[2]}]
execute as @e[tag=Arrow,scores={PathNumber=03}] run data remove entity @s Item.tag.Cand[{Path:[3]}]
execute as @e[tag=Arrow,scores={PathNumber=04}] run data remove entity @s Item.tag.Cand[{Path:[4]}]
execute as @e[tag=Arrow,scores={PathNumber=05}] run data remove entity @s Item.tag.Cand[{Path:[5]}]
execute as @e[tag=Arrow,scores={PathNumber=06}] run data remove entity @s Item.tag.Cand[{Path:[6]}]
execute as @e[tag=Arrow,scores={PathNumber=07}] run data remove entity @s Item.tag.Cand[{Path:[7]}]
execute as @e[tag=Arrow,scores={PathNumber=08}] run data remove entity @s Item.tag.Cand[{Path:[8]}]
execute as @e[tag=Arrow,scores={PathNumber=09}] run data remove entity @s Item.tag.Cand[{Path:[9]}]
execute as @e[tag=Arrow,scores={PathNumber=10}] run data remove entity @s Item.tag.Cand[{Path:[10]}]
execute as @e[tag=Arrow,scores={PathNumber=11}] run data remove entity @s Item.tag.Cand[{Path:[11]}]
execute as @e[tag=Arrow,scores={PathNumber=12}] run data remove entity @s Item.tag.Cand[{Path:[12]}]
execute as @e[tag=Arrow,scores={PathNumber=13}] run data remove entity @s Item.tag.Cand[{Path:[13]}]
execute as @e[tag=Arrow,scores={PathNumber=14}] run data remove entity @s Item.tag.Cand[{Path:[14]}]
execute as @e[tag=Arrow,scores={PathNumber=15}] run data remove entity @s Item.tag.Cand[{Path:[15]}]
execute as @e[tag=Arrow,scores={PathNumber=16}] run data remove entity @s Item.tag.Cand[{Path:[16]}]
execute as @e[tag=Arrow,scores={PathNumber=17}] run data remove entity @s Item.tag.Cand[{Path:[17]}]
execute as @e[tag=Arrow,scores={PathNumber=18}] run data remove entity @s Item.tag.Cand[{Path:[18]}]
execute as @e[tag=Arrow,scores={PathNumber=19}] run data remove entity @s Item.tag.Cand[{Path:[19]}]
execute as @e[tag=Arrow,scores={PathNumber=20}] run data remove entity @s Item.tag.Cand[{Path:[20]}]
execute as @e[tag=Arrow] if data entity @s Item.tag.Cand[0] run data modify entity @s Item.tag.Cand[].Path append from entity @s Item.tag.Number

# 保存(2)
execute as @e[tag=Arrow] at @s if data entity @s Item.tag.Cand[0] run data modify block 0 ~ 0 RecordItem.tag.MaxPath set from entity @s Item.tag.Cand[].Path

# 開拓地へ(3)
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag set value {Routes:[]}
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag.Routes append from entity @s Item.tag.Cand[]

# 街道へ(3)
execute as @e[tag=Arrow] at @s run data modify entity @s Item.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Routes
execute as @e[tag=Arrow,scores={PathNumber=01}] run data remove entity @s Item.tag.Cand[{Path:[1]}]
execute as @e[tag=Arrow,scores={PathNumber=02}] run data remove entity @s Item.tag.Cand[{Path:[2]}]
execute as @e[tag=Arrow,scores={PathNumber=03}] run data remove entity @s Item.tag.Cand[{Path:[3]}]
execute as @e[tag=Arrow,scores={PathNumber=04}] run data remove entity @s Item.tag.Cand[{Path:[4]}]
execute as @e[tag=Arrow,scores={PathNumber=05}] run data remove entity @s Item.tag.Cand[{Path:[5]}]
execute as @e[tag=Arrow,scores={PathNumber=06}] run data remove entity @s Item.tag.Cand[{Path:[6]}]
execute as @e[tag=Arrow,scores={PathNumber=07}] run data remove entity @s Item.tag.Cand[{Path:[7]}]
execute as @e[tag=Arrow,scores={PathNumber=08}] run data remove entity @s Item.tag.Cand[{Path:[8]}]
execute as @e[tag=Arrow,scores={PathNumber=09}] run data remove entity @s Item.tag.Cand[{Path:[9]}]
execute as @e[tag=Arrow,scores={PathNumber=10}] run data remove entity @s Item.tag.Cand[{Path:[10]}]
execute as @e[tag=Arrow,scores={PathNumber=11}] run data remove entity @s Item.tag.Cand[{Path:[11]}]
execute as @e[tag=Arrow,scores={PathNumber=12}] run data remove entity @s Item.tag.Cand[{Path:[12]}]
execute as @e[tag=Arrow,scores={PathNumber=13}] run data remove entity @s Item.tag.Cand[{Path:[13]}]
execute as @e[tag=Arrow,scores={PathNumber=14}] run data remove entity @s Item.tag.Cand[{Path:[14]}]
execute as @e[tag=Arrow,scores={PathNumber=15}] run data remove entity @s Item.tag.Cand[{Path:[15]}]
execute as @e[tag=Arrow,scores={PathNumber=16}] run data remove entity @s Item.tag.Cand[{Path:[16]}]
execute as @e[tag=Arrow,scores={PathNumber=17}] run data remove entity @s Item.tag.Cand[{Path:[17]}]
execute as @e[tag=Arrow,scores={PathNumber=18}] run data remove entity @s Item.tag.Cand[{Path:[18]}]
execute as @e[tag=Arrow,scores={PathNumber=19}] run data remove entity @s Item.tag.Cand[{Path:[19]}]
execute as @e[tag=Arrow,scores={PathNumber=20}] run data remove entity @s Item.tag.Cand[{Path:[20]}]
execute as @e[tag=Arrow] if data entity @s Item.tag.Cand[0] run data modify entity @s Item.tag.Cand[].Path append from entity @s Item.tag.Number

# 保存(3)
execute as @e[tag=Arrow] at @s if data entity @s Item.tag.Cand[0] run data modify block 0 ~ 0 RecordItem.tag.MaxPath set from entity @s Item.tag.Cand[].Path

# 開拓地へ(4)
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag set value {Routes:[]}
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag.Routes append from entity @s Item.tag.Cand[]

# 街道へ(4)
execute as @e[tag=Arrow] at @s run data modify entity @s Item.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Routes
execute as @e[tag=Arrow,scores={PathNumber=01}] run data remove entity @s Item.tag.Cand[{Path:[1]}]
execute as @e[tag=Arrow,scores={PathNumber=02}] run data remove entity @s Item.tag.Cand[{Path:[2]}]
execute as @e[tag=Arrow,scores={PathNumber=03}] run data remove entity @s Item.tag.Cand[{Path:[3]}]
execute as @e[tag=Arrow,scores={PathNumber=04}] run data remove entity @s Item.tag.Cand[{Path:[4]}]
execute as @e[tag=Arrow,scores={PathNumber=05}] run data remove entity @s Item.tag.Cand[{Path:[5]}]
execute as @e[tag=Arrow,scores={PathNumber=06}] run data remove entity @s Item.tag.Cand[{Path:[6]}]
execute as @e[tag=Arrow,scores={PathNumber=07}] run data remove entity @s Item.tag.Cand[{Path:[7]}]
execute as @e[tag=Arrow,scores={PathNumber=08}] run data remove entity @s Item.tag.Cand[{Path:[8]}]
execute as @e[tag=Arrow,scores={PathNumber=09}] run data remove entity @s Item.tag.Cand[{Path:[9]}]
execute as @e[tag=Arrow,scores={PathNumber=10}] run data remove entity @s Item.tag.Cand[{Path:[10]}]
execute as @e[tag=Arrow,scores={PathNumber=11}] run data remove entity @s Item.tag.Cand[{Path:[11]}]
execute as @e[tag=Arrow,scores={PathNumber=12}] run data remove entity @s Item.tag.Cand[{Path:[12]}]
execute as @e[tag=Arrow,scores={PathNumber=13}] run data remove entity @s Item.tag.Cand[{Path:[13]}]
execute as @e[tag=Arrow,scores={PathNumber=14}] run data remove entity @s Item.tag.Cand[{Path:[14]}]
execute as @e[tag=Arrow,scores={PathNumber=15}] run data remove entity @s Item.tag.Cand[{Path:[15]}]
execute as @e[tag=Arrow,scores={PathNumber=16}] run data remove entity @s Item.tag.Cand[{Path:[16]}]
execute as @e[tag=Arrow,scores={PathNumber=17}] run data remove entity @s Item.tag.Cand[{Path:[17]}]
execute as @e[tag=Arrow,scores={PathNumber=18}] run data remove entity @s Item.tag.Cand[{Path:[18]}]
execute as @e[tag=Arrow,scores={PathNumber=19}] run data remove entity @s Item.tag.Cand[{Path:[19]}]
execute as @e[tag=Arrow,scores={PathNumber=20}] run data remove entity @s Item.tag.Cand[{Path:[20]}]
execute as @e[tag=Arrow] if data entity @s Item.tag.Cand[0] run data modify entity @s Item.tag.Cand[].Path append from entity @s Item.tag.Number

# 保存(4)
execute as @e[tag=Arrow] at @s if data entity @s Item.tag.Cand[0] run data modify block 0 ~ 0 RecordItem.tag.MaxPath set from entity @s Item.tag.Cand[].Path

# 開拓地へ(5)
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag set value {Routes:[]}
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag.Routes append from entity @s Item.tag.Cand[]

# 街道へ(5)
execute as @e[tag=Arrow] at @s run data modify entity @s Item.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Routes
execute as @e[tag=Arrow,scores={PathNumber=01}] run data remove entity @s Item.tag.Cand[{Path:[1]}]
execute as @e[tag=Arrow,scores={PathNumber=02}] run data remove entity @s Item.tag.Cand[{Path:[2]}]
execute as @e[tag=Arrow,scores={PathNumber=03}] run data remove entity @s Item.tag.Cand[{Path:[3]}]
execute as @e[tag=Arrow,scores={PathNumber=04}] run data remove entity @s Item.tag.Cand[{Path:[4]}]
execute as @e[tag=Arrow,scores={PathNumber=05}] run data remove entity @s Item.tag.Cand[{Path:[5]}]
execute as @e[tag=Arrow,scores={PathNumber=06}] run data remove entity @s Item.tag.Cand[{Path:[6]}]
execute as @e[tag=Arrow,scores={PathNumber=07}] run data remove entity @s Item.tag.Cand[{Path:[7]}]
execute as @e[tag=Arrow,scores={PathNumber=08}] run data remove entity @s Item.tag.Cand[{Path:[8]}]
execute as @e[tag=Arrow,scores={PathNumber=09}] run data remove entity @s Item.tag.Cand[{Path:[9]}]
execute as @e[tag=Arrow,scores={PathNumber=10}] run data remove entity @s Item.tag.Cand[{Path:[10]}]
execute as @e[tag=Arrow,scores={PathNumber=11}] run data remove entity @s Item.tag.Cand[{Path:[11]}]
execute as @e[tag=Arrow,scores={PathNumber=12}] run data remove entity @s Item.tag.Cand[{Path:[12]}]
execute as @e[tag=Arrow,scores={PathNumber=13}] run data remove entity @s Item.tag.Cand[{Path:[13]}]
execute as @e[tag=Arrow,scores={PathNumber=14}] run data remove entity @s Item.tag.Cand[{Path:[14]}]
execute as @e[tag=Arrow,scores={PathNumber=15}] run data remove entity @s Item.tag.Cand[{Path:[15]}]
execute as @e[tag=Arrow,scores={PathNumber=16}] run data remove entity @s Item.tag.Cand[{Path:[16]}]
execute as @e[tag=Arrow,scores={PathNumber=17}] run data remove entity @s Item.tag.Cand[{Path:[17]}]
execute as @e[tag=Arrow,scores={PathNumber=18}] run data remove entity @s Item.tag.Cand[{Path:[18]}]
execute as @e[tag=Arrow,scores={PathNumber=19}] run data remove entity @s Item.tag.Cand[{Path:[19]}]
execute as @e[tag=Arrow,scores={PathNumber=20}] run data remove entity @s Item.tag.Cand[{Path:[20]}]
execute as @e[tag=Arrow] if data entity @s Item.tag.Cand[0] run data modify entity @s Item.tag.Cand[].Path append from entity @s Item.tag.Number

# 保存(5)
execute as @e[tag=Arrow] at @s if data entity @s Item.tag.Cand[0] run data modify block 0 ~ 0 RecordItem.tag.MaxPath set from entity @s Item.tag.Cand[].Path

# 開拓地へ(6)
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag set value {Routes:[]}
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag.Routes append from entity @s Item.tag.Cand[]

# 街道へ(6)
execute as @e[tag=Arrow] at @s run data modify entity @s Item.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Routes
execute as @e[tag=Arrow,scores={PathNumber=01}] run data remove entity @s Item.tag.Cand[{Path:[1]}]
execute as @e[tag=Arrow,scores={PathNumber=02}] run data remove entity @s Item.tag.Cand[{Path:[2]}]
execute as @e[tag=Arrow,scores={PathNumber=03}] run data remove entity @s Item.tag.Cand[{Path:[3]}]
execute as @e[tag=Arrow,scores={PathNumber=04}] run data remove entity @s Item.tag.Cand[{Path:[4]}]
execute as @e[tag=Arrow,scores={PathNumber=05}] run data remove entity @s Item.tag.Cand[{Path:[5]}]
execute as @e[tag=Arrow,scores={PathNumber=06}] run data remove entity @s Item.tag.Cand[{Path:[6]}]
execute as @e[tag=Arrow,scores={PathNumber=07}] run data remove entity @s Item.tag.Cand[{Path:[7]}]
execute as @e[tag=Arrow,scores={PathNumber=08}] run data remove entity @s Item.tag.Cand[{Path:[8]}]
execute as @e[tag=Arrow,scores={PathNumber=09}] run data remove entity @s Item.tag.Cand[{Path:[9]}]
execute as @e[tag=Arrow,scores={PathNumber=10}] run data remove entity @s Item.tag.Cand[{Path:[10]}]
execute as @e[tag=Arrow,scores={PathNumber=11}] run data remove entity @s Item.tag.Cand[{Path:[11]}]
execute as @e[tag=Arrow,scores={PathNumber=12}] run data remove entity @s Item.tag.Cand[{Path:[12]}]
execute as @e[tag=Arrow,scores={PathNumber=13}] run data remove entity @s Item.tag.Cand[{Path:[13]}]
execute as @e[tag=Arrow,scores={PathNumber=14}] run data remove entity @s Item.tag.Cand[{Path:[14]}]
execute as @e[tag=Arrow,scores={PathNumber=15}] run data remove entity @s Item.tag.Cand[{Path:[15]}]
execute as @e[tag=Arrow,scores={PathNumber=16}] run data remove entity @s Item.tag.Cand[{Path:[16]}]
execute as @e[tag=Arrow,scores={PathNumber=17}] run data remove entity @s Item.tag.Cand[{Path:[17]}]
execute as @e[tag=Arrow,scores={PathNumber=18}] run data remove entity @s Item.tag.Cand[{Path:[18]}]
execute as @e[tag=Arrow,scores={PathNumber=19}] run data remove entity @s Item.tag.Cand[{Path:[19]}]
execute as @e[tag=Arrow,scores={PathNumber=20}] run data remove entity @s Item.tag.Cand[{Path:[20]}]
execute as @e[tag=Arrow] if data entity @s Item.tag.Cand[0] run data modify entity @s Item.tag.Cand[].Path append from entity @s Item.tag.Number

# 保存(6)
execute as @e[tag=Arrow] at @s if data entity @s Item.tag.Cand[0] run data modify block 0 ~ 0 RecordItem.tag.MaxPath set from entity @s Item.tag.Cand[].Path

# 開拓地へ(7)
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag set value {Routes:[]}
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag.Routes append from entity @s Item.tag.Cand[]

# 街道へ(7)
execute as @e[tag=Arrow] at @s run data modify entity @s Item.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Routes
execute as @e[tag=Arrow,scores={PathNumber=01}] run data remove entity @s Item.tag.Cand[{Path:[1]}]
execute as @e[tag=Arrow,scores={PathNumber=02}] run data remove entity @s Item.tag.Cand[{Path:[2]}]
execute as @e[tag=Arrow,scores={PathNumber=03}] run data remove entity @s Item.tag.Cand[{Path:[3]}]
execute as @e[tag=Arrow,scores={PathNumber=04}] run data remove entity @s Item.tag.Cand[{Path:[4]}]
execute as @e[tag=Arrow,scores={PathNumber=05}] run data remove entity @s Item.tag.Cand[{Path:[5]}]
execute as @e[tag=Arrow,scores={PathNumber=06}] run data remove entity @s Item.tag.Cand[{Path:[6]}]
execute as @e[tag=Arrow,scores={PathNumber=07}] run data remove entity @s Item.tag.Cand[{Path:[7]}]
execute as @e[tag=Arrow,scores={PathNumber=08}] run data remove entity @s Item.tag.Cand[{Path:[8]}]
execute as @e[tag=Arrow,scores={PathNumber=09}] run data remove entity @s Item.tag.Cand[{Path:[9]}]
execute as @e[tag=Arrow,scores={PathNumber=10}] run data remove entity @s Item.tag.Cand[{Path:[10]}]
execute as @e[tag=Arrow,scores={PathNumber=11}] run data remove entity @s Item.tag.Cand[{Path:[11]}]
execute as @e[tag=Arrow,scores={PathNumber=12}] run data remove entity @s Item.tag.Cand[{Path:[12]}]
execute as @e[tag=Arrow,scores={PathNumber=13}] run data remove entity @s Item.tag.Cand[{Path:[13]}]
execute as @e[tag=Arrow,scores={PathNumber=14}] run data remove entity @s Item.tag.Cand[{Path:[14]}]
execute as @e[tag=Arrow,scores={PathNumber=15}] run data remove entity @s Item.tag.Cand[{Path:[15]}]
execute as @e[tag=Arrow,scores={PathNumber=16}] run data remove entity @s Item.tag.Cand[{Path:[16]}]
execute as @e[tag=Arrow,scores={PathNumber=17}] run data remove entity @s Item.tag.Cand[{Path:[17]}]
execute as @e[tag=Arrow,scores={PathNumber=18}] run data remove entity @s Item.tag.Cand[{Path:[18]}]
execute as @e[tag=Arrow,scores={PathNumber=19}] run data remove entity @s Item.tag.Cand[{Path:[19]}]
execute as @e[tag=Arrow,scores={PathNumber=20}] run data remove entity @s Item.tag.Cand[{Path:[20]}]
execute as @e[tag=Arrow] if data entity @s Item.tag.Cand[0] run data modify entity @s Item.tag.Cand[].Path append from entity @s Item.tag.Number

# 保存(7)
execute as @e[tag=Arrow] at @s if data entity @s Item.tag.Cand[0] run data modify block 0 ~ 0 RecordItem.tag.MaxPath set from entity @s Item.tag.Cand[].Path

# 開拓地へ(8)
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag set value {Routes:[]}
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag.Routes append from entity @s Item.tag.Cand[]

# 街道へ(8)
execute as @e[tag=Arrow] at @s run data modify entity @s Item.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Routes
execute as @e[tag=Arrow,scores={PathNumber=01}] run data remove entity @s Item.tag.Cand[{Path:[1]}]
execute as @e[tag=Arrow,scores={PathNumber=02}] run data remove entity @s Item.tag.Cand[{Path:[2]}]
execute as @e[tag=Arrow,scores={PathNumber=03}] run data remove entity @s Item.tag.Cand[{Path:[3]}]
execute as @e[tag=Arrow,scores={PathNumber=04}] run data remove entity @s Item.tag.Cand[{Path:[4]}]
execute as @e[tag=Arrow,scores={PathNumber=05}] run data remove entity @s Item.tag.Cand[{Path:[5]}]
execute as @e[tag=Arrow,scores={PathNumber=06}] run data remove entity @s Item.tag.Cand[{Path:[6]}]
execute as @e[tag=Arrow,scores={PathNumber=07}] run data remove entity @s Item.tag.Cand[{Path:[7]}]
execute as @e[tag=Arrow,scores={PathNumber=08}] run data remove entity @s Item.tag.Cand[{Path:[8]}]
execute as @e[tag=Arrow,scores={PathNumber=09}] run data remove entity @s Item.tag.Cand[{Path:[9]}]
execute as @e[tag=Arrow,scores={PathNumber=10}] run data remove entity @s Item.tag.Cand[{Path:[10]}]
execute as @e[tag=Arrow,scores={PathNumber=11}] run data remove entity @s Item.tag.Cand[{Path:[11]}]
execute as @e[tag=Arrow,scores={PathNumber=12}] run data remove entity @s Item.tag.Cand[{Path:[12]}]
execute as @e[tag=Arrow,scores={PathNumber=13}] run data remove entity @s Item.tag.Cand[{Path:[13]}]
execute as @e[tag=Arrow,scores={PathNumber=14}] run data remove entity @s Item.tag.Cand[{Path:[14]}]
execute as @e[tag=Arrow,scores={PathNumber=15}] run data remove entity @s Item.tag.Cand[{Path:[15]}]
execute as @e[tag=Arrow,scores={PathNumber=16}] run data remove entity @s Item.tag.Cand[{Path:[16]}]
execute as @e[tag=Arrow,scores={PathNumber=17}] run data remove entity @s Item.tag.Cand[{Path:[17]}]
execute as @e[tag=Arrow,scores={PathNumber=18}] run data remove entity @s Item.tag.Cand[{Path:[18]}]
execute as @e[tag=Arrow,scores={PathNumber=19}] run data remove entity @s Item.tag.Cand[{Path:[19]}]
execute as @e[tag=Arrow,scores={PathNumber=20}] run data remove entity @s Item.tag.Cand[{Path:[20]}]
execute as @e[tag=Arrow] if data entity @s Item.tag.Cand[0] run data modify entity @s Item.tag.Cand[].Path append from entity @s Item.tag.Number

# 保存(8)
execute as @e[tag=Arrow] at @s if data entity @s Item.tag.Cand[0] run data modify block 0 ~ 0 RecordItem.tag.MaxPath set from entity @s Item.tag.Cand[].Path

# 開拓地へ(9)
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag set value {Routes:[]}
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag.Routes append from entity @s Item.tag.Cand[]

# 街道へ(9)
execute as @e[tag=Arrow] at @s run data modify entity @s Item.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Routes
execute as @e[tag=Arrow,scores={PathNumber=01}] run data remove entity @s Item.tag.Cand[{Path:[1]}]
execute as @e[tag=Arrow,scores={PathNumber=02}] run data remove entity @s Item.tag.Cand[{Path:[2]}]
execute as @e[tag=Arrow,scores={PathNumber=03}] run data remove entity @s Item.tag.Cand[{Path:[3]}]
execute as @e[tag=Arrow,scores={PathNumber=04}] run data remove entity @s Item.tag.Cand[{Path:[4]}]
execute as @e[tag=Arrow,scores={PathNumber=05}] run data remove entity @s Item.tag.Cand[{Path:[5]}]
execute as @e[tag=Arrow,scores={PathNumber=06}] run data remove entity @s Item.tag.Cand[{Path:[6]}]
execute as @e[tag=Arrow,scores={PathNumber=07}] run data remove entity @s Item.tag.Cand[{Path:[7]}]
execute as @e[tag=Arrow,scores={PathNumber=08}] run data remove entity @s Item.tag.Cand[{Path:[8]}]
execute as @e[tag=Arrow,scores={PathNumber=09}] run data remove entity @s Item.tag.Cand[{Path:[9]}]
execute as @e[tag=Arrow,scores={PathNumber=10}] run data remove entity @s Item.tag.Cand[{Path:[10]}]
execute as @e[tag=Arrow,scores={PathNumber=11}] run data remove entity @s Item.tag.Cand[{Path:[11]}]
execute as @e[tag=Arrow,scores={PathNumber=12}] run data remove entity @s Item.tag.Cand[{Path:[12]}]
execute as @e[tag=Arrow,scores={PathNumber=13}] run data remove entity @s Item.tag.Cand[{Path:[13]}]
execute as @e[tag=Arrow,scores={PathNumber=14}] run data remove entity @s Item.tag.Cand[{Path:[14]}]
execute as @e[tag=Arrow,scores={PathNumber=15}] run data remove entity @s Item.tag.Cand[{Path:[15]}]
execute as @e[tag=Arrow,scores={PathNumber=16}] run data remove entity @s Item.tag.Cand[{Path:[16]}]
execute as @e[tag=Arrow,scores={PathNumber=17}] run data remove entity @s Item.tag.Cand[{Path:[17]}]
execute as @e[tag=Arrow,scores={PathNumber=18}] run data remove entity @s Item.tag.Cand[{Path:[18]}]
execute as @e[tag=Arrow,scores={PathNumber=19}] run data remove entity @s Item.tag.Cand[{Path:[19]}]
execute as @e[tag=Arrow,scores={PathNumber=20}] run data remove entity @s Item.tag.Cand[{Path:[20]}]
execute as @e[tag=Arrow] if data entity @s Item.tag.Cand[0] run data modify entity @s Item.tag.Cand[].Path append from entity @s Item.tag.Number

# 保存(9)
execute as @e[tag=Arrow] at @s if data entity @s Item.tag.Cand[0] run data modify block 0 ~ 0 RecordItem.tag.MaxPath set from entity @s Item.tag.Cand[].Path

# 開拓地へ(10)
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag set value {Routes:[]}
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag.Routes append from entity @s Item.tag.Cand[]

# 街道へ(10)
execute as @e[tag=Arrow] at @s run data modify entity @s Item.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Routes
execute as @e[tag=Arrow,scores={PathNumber=01}] run data remove entity @s Item.tag.Cand[{Path:[1]}]
execute as @e[tag=Arrow,scores={PathNumber=02}] run data remove entity @s Item.tag.Cand[{Path:[2]}]
execute as @e[tag=Arrow,scores={PathNumber=03}] run data remove entity @s Item.tag.Cand[{Path:[3]}]
execute as @e[tag=Arrow,scores={PathNumber=04}] run data remove entity @s Item.tag.Cand[{Path:[4]}]
execute as @e[tag=Arrow,scores={PathNumber=05}] run data remove entity @s Item.tag.Cand[{Path:[5]}]
execute as @e[tag=Arrow,scores={PathNumber=06}] run data remove entity @s Item.tag.Cand[{Path:[6]}]
execute as @e[tag=Arrow,scores={PathNumber=07}] run data remove entity @s Item.tag.Cand[{Path:[7]}]
execute as @e[tag=Arrow,scores={PathNumber=08}] run data remove entity @s Item.tag.Cand[{Path:[8]}]
execute as @e[tag=Arrow,scores={PathNumber=09}] run data remove entity @s Item.tag.Cand[{Path:[9]}]
execute as @e[tag=Arrow,scores={PathNumber=10}] run data remove entity @s Item.tag.Cand[{Path:[10]}]
execute as @e[tag=Arrow,scores={PathNumber=11}] run data remove entity @s Item.tag.Cand[{Path:[11]}]
execute as @e[tag=Arrow,scores={PathNumber=12}] run data remove entity @s Item.tag.Cand[{Path:[12]}]
execute as @e[tag=Arrow,scores={PathNumber=13}] run data remove entity @s Item.tag.Cand[{Path:[13]}]
execute as @e[tag=Arrow,scores={PathNumber=14}] run data remove entity @s Item.tag.Cand[{Path:[14]}]
execute as @e[tag=Arrow,scores={PathNumber=15}] run data remove entity @s Item.tag.Cand[{Path:[15]}]
execute as @e[tag=Arrow,scores={PathNumber=16}] run data remove entity @s Item.tag.Cand[{Path:[16]}]
execute as @e[tag=Arrow,scores={PathNumber=17}] run data remove entity @s Item.tag.Cand[{Path:[17]}]
execute as @e[tag=Arrow,scores={PathNumber=18}] run data remove entity @s Item.tag.Cand[{Path:[18]}]
execute as @e[tag=Arrow,scores={PathNumber=19}] run data remove entity @s Item.tag.Cand[{Path:[19]}]
execute as @e[tag=Arrow,scores={PathNumber=20}] run data remove entity @s Item.tag.Cand[{Path:[20]}]
execute as @e[tag=Arrow] if data entity @s Item.tag.Cand[0] run data modify entity @s Item.tag.Cand[].Path append from entity @s Item.tag.Number

# 保存(10)
execute as @e[tag=Arrow] at @s if data entity @s Item.tag.Cand[0] run data modify block 0 ~ 0 RecordItem.tag.MaxPath set from entity @s Item.tag.Cand[].Path

# 開拓地へ(11)
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag set value {Routes:[]}
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag.Routes append from entity @s Item.tag.Cand[]

# 街道へ(11)
execute as @e[tag=Arrow] at @s run data modify entity @s Item.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Routes
execute as @e[tag=Arrow,scores={PathNumber=01}] run data remove entity @s Item.tag.Cand[{Path:[1]}]
execute as @e[tag=Arrow,scores={PathNumber=02}] run data remove entity @s Item.tag.Cand[{Path:[2]}]
execute as @e[tag=Arrow,scores={PathNumber=03}] run data remove entity @s Item.tag.Cand[{Path:[3]}]
execute as @e[tag=Arrow,scores={PathNumber=04}] run data remove entity @s Item.tag.Cand[{Path:[4]}]
execute as @e[tag=Arrow,scores={PathNumber=05}] run data remove entity @s Item.tag.Cand[{Path:[5]}]
execute as @e[tag=Arrow,scores={PathNumber=06}] run data remove entity @s Item.tag.Cand[{Path:[6]}]
execute as @e[tag=Arrow,scores={PathNumber=07}] run data remove entity @s Item.tag.Cand[{Path:[7]}]
execute as @e[tag=Arrow,scores={PathNumber=08}] run data remove entity @s Item.tag.Cand[{Path:[8]}]
execute as @e[tag=Arrow,scores={PathNumber=09}] run data remove entity @s Item.tag.Cand[{Path:[9]}]
execute as @e[tag=Arrow,scores={PathNumber=10}] run data remove entity @s Item.tag.Cand[{Path:[10]}]
execute as @e[tag=Arrow,scores={PathNumber=11}] run data remove entity @s Item.tag.Cand[{Path:[11]}]
execute as @e[tag=Arrow,scores={PathNumber=12}] run data remove entity @s Item.tag.Cand[{Path:[12]}]
execute as @e[tag=Arrow,scores={PathNumber=13}] run data remove entity @s Item.tag.Cand[{Path:[13]}]
execute as @e[tag=Arrow,scores={PathNumber=14}] run data remove entity @s Item.tag.Cand[{Path:[14]}]
execute as @e[tag=Arrow,scores={PathNumber=15}] run data remove entity @s Item.tag.Cand[{Path:[15]}]
execute as @e[tag=Arrow,scores={PathNumber=16}] run data remove entity @s Item.tag.Cand[{Path:[16]}]
execute as @e[tag=Arrow,scores={PathNumber=17}] run data remove entity @s Item.tag.Cand[{Path:[17]}]
execute as @e[tag=Arrow,scores={PathNumber=18}] run data remove entity @s Item.tag.Cand[{Path:[18]}]
execute as @e[tag=Arrow,scores={PathNumber=19}] run data remove entity @s Item.tag.Cand[{Path:[19]}]
execute as @e[tag=Arrow,scores={PathNumber=20}] run data remove entity @s Item.tag.Cand[{Path:[20]}]
execute as @e[tag=Arrow] if data entity @s Item.tag.Cand[0] run data modify entity @s Item.tag.Cand[].Path append from entity @s Item.tag.Number

# 保存(11)
execute as @e[tag=Arrow] at @s if data entity @s Item.tag.Cand[0] run data modify block 0 ~ 0 RecordItem.tag.MaxPath set from entity @s Item.tag.Cand[].Path

# 開拓地へ(12)
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag set value {Routes:[]}
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag.Routes append from entity @s Item.tag.Cand[]

# 街道へ(12)
execute as @e[tag=Arrow] at @s run data modify entity @s Item.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Routes
execute as @e[tag=Arrow,scores={PathNumber=01}] run data remove entity @s Item.tag.Cand[{Path:[1]}]
execute as @e[tag=Arrow,scores={PathNumber=02}] run data remove entity @s Item.tag.Cand[{Path:[2]}]
execute as @e[tag=Arrow,scores={PathNumber=03}] run data remove entity @s Item.tag.Cand[{Path:[3]}]
execute as @e[tag=Arrow,scores={PathNumber=04}] run data remove entity @s Item.tag.Cand[{Path:[4]}]
execute as @e[tag=Arrow,scores={PathNumber=05}] run data remove entity @s Item.tag.Cand[{Path:[5]}]
execute as @e[tag=Arrow,scores={PathNumber=06}] run data remove entity @s Item.tag.Cand[{Path:[6]}]
execute as @e[tag=Arrow,scores={PathNumber=07}] run data remove entity @s Item.tag.Cand[{Path:[7]}]
execute as @e[tag=Arrow,scores={PathNumber=08}] run data remove entity @s Item.tag.Cand[{Path:[8]}]
execute as @e[tag=Arrow,scores={PathNumber=09}] run data remove entity @s Item.tag.Cand[{Path:[9]}]
execute as @e[tag=Arrow,scores={PathNumber=10}] run data remove entity @s Item.tag.Cand[{Path:[10]}]
execute as @e[tag=Arrow,scores={PathNumber=11}] run data remove entity @s Item.tag.Cand[{Path:[11]}]
execute as @e[tag=Arrow,scores={PathNumber=12}] run data remove entity @s Item.tag.Cand[{Path:[12]}]
execute as @e[tag=Arrow,scores={PathNumber=13}] run data remove entity @s Item.tag.Cand[{Path:[13]}]
execute as @e[tag=Arrow,scores={PathNumber=14}] run data remove entity @s Item.tag.Cand[{Path:[14]}]
execute as @e[tag=Arrow,scores={PathNumber=15}] run data remove entity @s Item.tag.Cand[{Path:[15]}]
execute as @e[tag=Arrow,scores={PathNumber=16}] run data remove entity @s Item.tag.Cand[{Path:[16]}]
execute as @e[tag=Arrow,scores={PathNumber=17}] run data remove entity @s Item.tag.Cand[{Path:[17]}]
execute as @e[tag=Arrow,scores={PathNumber=18}] run data remove entity @s Item.tag.Cand[{Path:[18]}]
execute as @e[tag=Arrow,scores={PathNumber=19}] run data remove entity @s Item.tag.Cand[{Path:[19]}]
execute as @e[tag=Arrow,scores={PathNumber=20}] run data remove entity @s Item.tag.Cand[{Path:[20]}]
execute as @e[tag=Arrow] if data entity @s Item.tag.Cand[0] run data modify entity @s Item.tag.Cand[].Path append from entity @s Item.tag.Number

# 保存(12)
execute as @e[tag=Arrow] at @s if data entity @s Item.tag.Cand[0] run data modify block 0 ~ 0 RecordItem.tag.MaxPath set from entity @s Item.tag.Cand[].Path

# 開拓地へ(13)
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag set value {Routes:[]}
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag.Routes append from entity @s Item.tag.Cand[]

# 街道へ(13)
execute as @e[tag=Arrow] at @s run data modify entity @s Item.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Routes
execute as @e[tag=Arrow,scores={PathNumber=01}] run data remove entity @s Item.tag.Cand[{Path:[1]}]
execute as @e[tag=Arrow,scores={PathNumber=02}] run data remove entity @s Item.tag.Cand[{Path:[2]}]
execute as @e[tag=Arrow,scores={PathNumber=03}] run data remove entity @s Item.tag.Cand[{Path:[3]}]
execute as @e[tag=Arrow,scores={PathNumber=04}] run data remove entity @s Item.tag.Cand[{Path:[4]}]
execute as @e[tag=Arrow,scores={PathNumber=05}] run data remove entity @s Item.tag.Cand[{Path:[5]}]
execute as @e[tag=Arrow,scores={PathNumber=06}] run data remove entity @s Item.tag.Cand[{Path:[6]}]
execute as @e[tag=Arrow,scores={PathNumber=07}] run data remove entity @s Item.tag.Cand[{Path:[7]}]
execute as @e[tag=Arrow,scores={PathNumber=08}] run data remove entity @s Item.tag.Cand[{Path:[8]}]
execute as @e[tag=Arrow,scores={PathNumber=09}] run data remove entity @s Item.tag.Cand[{Path:[9]}]
execute as @e[tag=Arrow,scores={PathNumber=10}] run data remove entity @s Item.tag.Cand[{Path:[10]}]
execute as @e[tag=Arrow,scores={PathNumber=11}] run data remove entity @s Item.tag.Cand[{Path:[11]}]
execute as @e[tag=Arrow,scores={PathNumber=12}] run data remove entity @s Item.tag.Cand[{Path:[12]}]
execute as @e[tag=Arrow,scores={PathNumber=13}] run data remove entity @s Item.tag.Cand[{Path:[13]}]
execute as @e[tag=Arrow,scores={PathNumber=14}] run data remove entity @s Item.tag.Cand[{Path:[14]}]
execute as @e[tag=Arrow,scores={PathNumber=15}] run data remove entity @s Item.tag.Cand[{Path:[15]}]
execute as @e[tag=Arrow,scores={PathNumber=16}] run data remove entity @s Item.tag.Cand[{Path:[16]}]
execute as @e[tag=Arrow,scores={PathNumber=17}] run data remove entity @s Item.tag.Cand[{Path:[17]}]
execute as @e[tag=Arrow,scores={PathNumber=18}] run data remove entity @s Item.tag.Cand[{Path:[18]}]
execute as @e[tag=Arrow,scores={PathNumber=19}] run data remove entity @s Item.tag.Cand[{Path:[19]}]
execute as @e[tag=Arrow,scores={PathNumber=20}] run data remove entity @s Item.tag.Cand[{Path:[20]}]
execute as @e[tag=Arrow] if data entity @s Item.tag.Cand[0] run data modify entity @s Item.tag.Cand[].Path append from entity @s Item.tag.Number

# 保存(13)
execute as @e[tag=Arrow] at @s if data entity @s Item.tag.Cand[0] run data modify block 0 ~ 0 RecordItem.tag.MaxPath set from entity @s Item.tag.Cand[].Path

# 開拓地へ(14)
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag set value {Routes:[]}
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag.Routes append from entity @s Item.tag.Cand[]

# 街道へ(14)
execute as @e[tag=Arrow] at @s run data modify entity @s Item.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Routes
execute as @e[tag=Arrow,scores={PathNumber=01}] run data remove entity @s Item.tag.Cand[{Path:[1]}]
execute as @e[tag=Arrow,scores={PathNumber=02}] run data remove entity @s Item.tag.Cand[{Path:[2]}]
execute as @e[tag=Arrow,scores={PathNumber=03}] run data remove entity @s Item.tag.Cand[{Path:[3]}]
execute as @e[tag=Arrow,scores={PathNumber=04}] run data remove entity @s Item.tag.Cand[{Path:[4]}]
execute as @e[tag=Arrow,scores={PathNumber=05}] run data remove entity @s Item.tag.Cand[{Path:[5]}]
execute as @e[tag=Arrow,scores={PathNumber=06}] run data remove entity @s Item.tag.Cand[{Path:[6]}]
execute as @e[tag=Arrow,scores={PathNumber=07}] run data remove entity @s Item.tag.Cand[{Path:[7]}]
execute as @e[tag=Arrow,scores={PathNumber=08}] run data remove entity @s Item.tag.Cand[{Path:[8]}]
execute as @e[tag=Arrow,scores={PathNumber=09}] run data remove entity @s Item.tag.Cand[{Path:[9]}]
execute as @e[tag=Arrow,scores={PathNumber=10}] run data remove entity @s Item.tag.Cand[{Path:[10]}]
execute as @e[tag=Arrow,scores={PathNumber=11}] run data remove entity @s Item.tag.Cand[{Path:[11]}]
execute as @e[tag=Arrow,scores={PathNumber=12}] run data remove entity @s Item.tag.Cand[{Path:[12]}]
execute as @e[tag=Arrow,scores={PathNumber=13}] run data remove entity @s Item.tag.Cand[{Path:[13]}]
execute as @e[tag=Arrow,scores={PathNumber=14}] run data remove entity @s Item.tag.Cand[{Path:[14]}]
execute as @e[tag=Arrow,scores={PathNumber=15}] run data remove entity @s Item.tag.Cand[{Path:[15]}]
execute as @e[tag=Arrow,scores={PathNumber=16}] run data remove entity @s Item.tag.Cand[{Path:[16]}]
execute as @e[tag=Arrow,scores={PathNumber=17}] run data remove entity @s Item.tag.Cand[{Path:[17]}]
execute as @e[tag=Arrow,scores={PathNumber=18}] run data remove entity @s Item.tag.Cand[{Path:[18]}]
execute as @e[tag=Arrow,scores={PathNumber=19}] run data remove entity @s Item.tag.Cand[{Path:[19]}]
execute as @e[tag=Arrow,scores={PathNumber=20}] run data remove entity @s Item.tag.Cand[{Path:[20]}]
execute as @e[tag=Arrow] if data entity @s Item.tag.Cand[0] run data modify entity @s Item.tag.Cand[].Path append from entity @s Item.tag.Number

# 保存(14)
execute as @e[tag=Arrow] at @s if data entity @s Item.tag.Cand[0] run data modify block 0 ~ 0 RecordItem.tag.MaxPath set from entity @s Item.tag.Cand[].Path

# 開拓地へ(15)
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag set value {Routes:[]}
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag.Routes append from entity @s Item.tag.Cand[]

# 街道へ(15)
execute as @e[tag=Arrow] at @s run data modify entity @s Item.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Routes
execute as @e[tag=Arrow,scores={PathNumber=01}] run data remove entity @s Item.tag.Cand[{Path:[1]}]
execute as @e[tag=Arrow,scores={PathNumber=02}] run data remove entity @s Item.tag.Cand[{Path:[2]}]
execute as @e[tag=Arrow,scores={PathNumber=03}] run data remove entity @s Item.tag.Cand[{Path:[3]}]
execute as @e[tag=Arrow,scores={PathNumber=04}] run data remove entity @s Item.tag.Cand[{Path:[4]}]
execute as @e[tag=Arrow,scores={PathNumber=05}] run data remove entity @s Item.tag.Cand[{Path:[5]}]
execute as @e[tag=Arrow,scores={PathNumber=06}] run data remove entity @s Item.tag.Cand[{Path:[6]}]
execute as @e[tag=Arrow,scores={PathNumber=07}] run data remove entity @s Item.tag.Cand[{Path:[7]}]
execute as @e[tag=Arrow,scores={PathNumber=08}] run data remove entity @s Item.tag.Cand[{Path:[8]}]
execute as @e[tag=Arrow,scores={PathNumber=09}] run data remove entity @s Item.tag.Cand[{Path:[9]}]
execute as @e[tag=Arrow,scores={PathNumber=10}] run data remove entity @s Item.tag.Cand[{Path:[10]}]
execute as @e[tag=Arrow,scores={PathNumber=11}] run data remove entity @s Item.tag.Cand[{Path:[11]}]
execute as @e[tag=Arrow,scores={PathNumber=12}] run data remove entity @s Item.tag.Cand[{Path:[12]}]
execute as @e[tag=Arrow,scores={PathNumber=13}] run data remove entity @s Item.tag.Cand[{Path:[13]}]
execute as @e[tag=Arrow,scores={PathNumber=14}] run data remove entity @s Item.tag.Cand[{Path:[14]}]
execute as @e[tag=Arrow,scores={PathNumber=15}] run data remove entity @s Item.tag.Cand[{Path:[15]}]
execute as @e[tag=Arrow,scores={PathNumber=16}] run data remove entity @s Item.tag.Cand[{Path:[16]}]
execute as @e[tag=Arrow,scores={PathNumber=17}] run data remove entity @s Item.tag.Cand[{Path:[17]}]
execute as @e[tag=Arrow,scores={PathNumber=18}] run data remove entity @s Item.tag.Cand[{Path:[18]}]
execute as @e[tag=Arrow,scores={PathNumber=19}] run data remove entity @s Item.tag.Cand[{Path:[19]}]
execute as @e[tag=Arrow,scores={PathNumber=20}] run data remove entity @s Item.tag.Cand[{Path:[20]}]
execute as @e[tag=Arrow] if data entity @s Item.tag.Cand[0] run data modify entity @s Item.tag.Cand[].Path append from entity @s Item.tag.Number

# 保存(15)
execute as @e[tag=Arrow] at @s if data entity @s Item.tag.Cand[0] run data modify block 0 ~ 0 RecordItem.tag.MaxPath set from entity @s Item.tag.Cand[].Path

# 開拓地へ(16)
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag set value {Routes:[]}
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag.Routes append from entity @s Item.tag.Cand[]

# 街道へ(16)
execute as @e[tag=Arrow] at @s run data modify entity @s Item.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Routes
execute as @e[tag=Arrow,scores={PathNumber=01}] run data remove entity @s Item.tag.Cand[{Path:[1]}]
execute as @e[tag=Arrow,scores={PathNumber=02}] run data remove entity @s Item.tag.Cand[{Path:[2]}]
execute as @e[tag=Arrow,scores={PathNumber=03}] run data remove entity @s Item.tag.Cand[{Path:[3]}]
execute as @e[tag=Arrow,scores={PathNumber=04}] run data remove entity @s Item.tag.Cand[{Path:[4]}]
execute as @e[tag=Arrow,scores={PathNumber=05}] run data remove entity @s Item.tag.Cand[{Path:[5]}]
execute as @e[tag=Arrow,scores={PathNumber=06}] run data remove entity @s Item.tag.Cand[{Path:[6]}]
execute as @e[tag=Arrow,scores={PathNumber=07}] run data remove entity @s Item.tag.Cand[{Path:[7]}]
execute as @e[tag=Arrow,scores={PathNumber=08}] run data remove entity @s Item.tag.Cand[{Path:[8]}]
execute as @e[tag=Arrow,scores={PathNumber=09}] run data remove entity @s Item.tag.Cand[{Path:[9]}]
execute as @e[tag=Arrow,scores={PathNumber=10}] run data remove entity @s Item.tag.Cand[{Path:[10]}]
execute as @e[tag=Arrow,scores={PathNumber=11}] run data remove entity @s Item.tag.Cand[{Path:[11]}]
execute as @e[tag=Arrow,scores={PathNumber=12}] run data remove entity @s Item.tag.Cand[{Path:[12]}]
execute as @e[tag=Arrow,scores={PathNumber=13}] run data remove entity @s Item.tag.Cand[{Path:[13]}]
execute as @e[tag=Arrow,scores={PathNumber=14}] run data remove entity @s Item.tag.Cand[{Path:[14]}]
execute as @e[tag=Arrow,scores={PathNumber=15}] run data remove entity @s Item.tag.Cand[{Path:[15]}]
execute as @e[tag=Arrow,scores={PathNumber=16}] run data remove entity @s Item.tag.Cand[{Path:[16]}]
execute as @e[tag=Arrow,scores={PathNumber=17}] run data remove entity @s Item.tag.Cand[{Path:[17]}]
execute as @e[tag=Arrow,scores={PathNumber=18}] run data remove entity @s Item.tag.Cand[{Path:[18]}]
execute as @e[tag=Arrow,scores={PathNumber=19}] run data remove entity @s Item.tag.Cand[{Path:[19]}]
execute as @e[tag=Arrow,scores={PathNumber=20}] run data remove entity @s Item.tag.Cand[{Path:[20]}]
execute as @e[tag=Arrow] if data entity @s Item.tag.Cand[0] run data modify entity @s Item.tag.Cand[].Path append from entity @s Item.tag.Number

# 保存(16)
execute as @e[tag=Arrow] at @s if data entity @s Item.tag.Cand[0] run data modify block 0 ~ 0 RecordItem.tag.MaxPath set from entity @s Item.tag.Cand[].Path

# 開拓地へ(17)
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag set value {Routes:[]}
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag.Routes append from entity @s Item.tag.Cand[]

# 街道へ(17)
execute as @e[tag=Arrow] at @s run data modify entity @s Item.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Routes
execute as @e[tag=Arrow,scores={PathNumber=01}] run data remove entity @s Item.tag.Cand[{Path:[1]}]
execute as @e[tag=Arrow,scores={PathNumber=02}] run data remove entity @s Item.tag.Cand[{Path:[2]}]
execute as @e[tag=Arrow,scores={PathNumber=03}] run data remove entity @s Item.tag.Cand[{Path:[3]}]
execute as @e[tag=Arrow,scores={PathNumber=04}] run data remove entity @s Item.tag.Cand[{Path:[4]}]
execute as @e[tag=Arrow,scores={PathNumber=05}] run data remove entity @s Item.tag.Cand[{Path:[5]}]
execute as @e[tag=Arrow,scores={PathNumber=06}] run data remove entity @s Item.tag.Cand[{Path:[6]}]
execute as @e[tag=Arrow,scores={PathNumber=07}] run data remove entity @s Item.tag.Cand[{Path:[7]}]
execute as @e[tag=Arrow,scores={PathNumber=08}] run data remove entity @s Item.tag.Cand[{Path:[8]}]
execute as @e[tag=Arrow,scores={PathNumber=09}] run data remove entity @s Item.tag.Cand[{Path:[9]}]
execute as @e[tag=Arrow,scores={PathNumber=10}] run data remove entity @s Item.tag.Cand[{Path:[10]}]
execute as @e[tag=Arrow,scores={PathNumber=11}] run data remove entity @s Item.tag.Cand[{Path:[11]}]
execute as @e[tag=Arrow,scores={PathNumber=12}] run data remove entity @s Item.tag.Cand[{Path:[12]}]
execute as @e[tag=Arrow,scores={PathNumber=13}] run data remove entity @s Item.tag.Cand[{Path:[13]}]
execute as @e[tag=Arrow,scores={PathNumber=14}] run data remove entity @s Item.tag.Cand[{Path:[14]}]
execute as @e[tag=Arrow,scores={PathNumber=15}] run data remove entity @s Item.tag.Cand[{Path:[15]}]
execute as @e[tag=Arrow,scores={PathNumber=16}] run data remove entity @s Item.tag.Cand[{Path:[16]}]
execute as @e[tag=Arrow,scores={PathNumber=17}] run data remove entity @s Item.tag.Cand[{Path:[17]}]
execute as @e[tag=Arrow,scores={PathNumber=18}] run data remove entity @s Item.tag.Cand[{Path:[18]}]
execute as @e[tag=Arrow,scores={PathNumber=19}] run data remove entity @s Item.tag.Cand[{Path:[19]}]
execute as @e[tag=Arrow,scores={PathNumber=20}] run data remove entity @s Item.tag.Cand[{Path:[20]}]
execute as @e[tag=Arrow] if data entity @s Item.tag.Cand[0] run data modify entity @s Item.tag.Cand[].Path append from entity @s Item.tag.Number

# 保存(17)
execute as @e[tag=Arrow] at @s if data entity @s Item.tag.Cand[0] run data modify block 0 ~ 0 RecordItem.tag.MaxPath set from entity @s Item.tag.Cand[].Path

# 開拓地へ(18)
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag set value {Routes:[]}
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag.Routes append from entity @s Item.tag.Cand[]

# 街道へ(18)
execute as @e[tag=Arrow] at @s run data modify entity @s Item.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Routes
execute as @e[tag=Arrow,scores={PathNumber=01}] run data remove entity @s Item.tag.Cand[{Path:[1]}]
execute as @e[tag=Arrow,scores={PathNumber=02}] run data remove entity @s Item.tag.Cand[{Path:[2]}]
execute as @e[tag=Arrow,scores={PathNumber=03}] run data remove entity @s Item.tag.Cand[{Path:[3]}]
execute as @e[tag=Arrow,scores={PathNumber=04}] run data remove entity @s Item.tag.Cand[{Path:[4]}]
execute as @e[tag=Arrow,scores={PathNumber=05}] run data remove entity @s Item.tag.Cand[{Path:[5]}]
execute as @e[tag=Arrow,scores={PathNumber=06}] run data remove entity @s Item.tag.Cand[{Path:[6]}]
execute as @e[tag=Arrow,scores={PathNumber=07}] run data remove entity @s Item.tag.Cand[{Path:[7]}]
execute as @e[tag=Arrow,scores={PathNumber=08}] run data remove entity @s Item.tag.Cand[{Path:[8]}]
execute as @e[tag=Arrow,scores={PathNumber=09}] run data remove entity @s Item.tag.Cand[{Path:[9]}]
execute as @e[tag=Arrow,scores={PathNumber=10}] run data remove entity @s Item.tag.Cand[{Path:[10]}]
execute as @e[tag=Arrow,scores={PathNumber=11}] run data remove entity @s Item.tag.Cand[{Path:[11]}]
execute as @e[tag=Arrow,scores={PathNumber=12}] run data remove entity @s Item.tag.Cand[{Path:[12]}]
execute as @e[tag=Arrow,scores={PathNumber=13}] run data remove entity @s Item.tag.Cand[{Path:[13]}]
execute as @e[tag=Arrow,scores={PathNumber=14}] run data remove entity @s Item.tag.Cand[{Path:[14]}]
execute as @e[tag=Arrow,scores={PathNumber=15}] run data remove entity @s Item.tag.Cand[{Path:[15]}]
execute as @e[tag=Arrow,scores={PathNumber=16}] run data remove entity @s Item.tag.Cand[{Path:[16]}]
execute as @e[tag=Arrow,scores={PathNumber=17}] run data remove entity @s Item.tag.Cand[{Path:[17]}]
execute as @e[tag=Arrow,scores={PathNumber=18}] run data remove entity @s Item.tag.Cand[{Path:[18]}]
execute as @e[tag=Arrow,scores={PathNumber=19}] run data remove entity @s Item.tag.Cand[{Path:[19]}]
execute as @e[tag=Arrow,scores={PathNumber=20}] run data remove entity @s Item.tag.Cand[{Path:[20]}]
execute as @e[tag=Arrow] if data entity @s Item.tag.Cand[0] run data modify entity @s Item.tag.Cand[].Path append from entity @s Item.tag.Number

# 保存(18)
execute as @e[tag=Arrow] at @s if data entity @s Item.tag.Cand[0] run data modify block 0 ~ 0 RecordItem.tag.MaxPath set from entity @s Item.tag.Cand[].Path

# 開拓地へ(19)
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag set value {Routes:[]}
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag.Routes append from entity @s Item.tag.Cand[]

# 街道へ(19)
execute as @e[tag=Arrow] at @s run data modify entity @s Item.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Routes
execute as @e[tag=Arrow,scores={PathNumber=01}] run data remove entity @s Item.tag.Cand[{Path:[1]}]
execute as @e[tag=Arrow,scores={PathNumber=02}] run data remove entity @s Item.tag.Cand[{Path:[2]}]
execute as @e[tag=Arrow,scores={PathNumber=03}] run data remove entity @s Item.tag.Cand[{Path:[3]}]
execute as @e[tag=Arrow,scores={PathNumber=04}] run data remove entity @s Item.tag.Cand[{Path:[4]}]
execute as @e[tag=Arrow,scores={PathNumber=05}] run data remove entity @s Item.tag.Cand[{Path:[5]}]
execute as @e[tag=Arrow,scores={PathNumber=06}] run data remove entity @s Item.tag.Cand[{Path:[6]}]
execute as @e[tag=Arrow,scores={PathNumber=07}] run data remove entity @s Item.tag.Cand[{Path:[7]}]
execute as @e[tag=Arrow,scores={PathNumber=08}] run data remove entity @s Item.tag.Cand[{Path:[8]}]
execute as @e[tag=Arrow,scores={PathNumber=09}] run data remove entity @s Item.tag.Cand[{Path:[9]}]
execute as @e[tag=Arrow,scores={PathNumber=10}] run data remove entity @s Item.tag.Cand[{Path:[10]}]
execute as @e[tag=Arrow,scores={PathNumber=11}] run data remove entity @s Item.tag.Cand[{Path:[11]}]
execute as @e[tag=Arrow,scores={PathNumber=12}] run data remove entity @s Item.tag.Cand[{Path:[12]}]
execute as @e[tag=Arrow,scores={PathNumber=13}] run data remove entity @s Item.tag.Cand[{Path:[13]}]
execute as @e[tag=Arrow,scores={PathNumber=14}] run data remove entity @s Item.tag.Cand[{Path:[14]}]
execute as @e[tag=Arrow,scores={PathNumber=15}] run data remove entity @s Item.tag.Cand[{Path:[15]}]
execute as @e[tag=Arrow,scores={PathNumber=16}] run data remove entity @s Item.tag.Cand[{Path:[16]}]
execute as @e[tag=Arrow,scores={PathNumber=17}] run data remove entity @s Item.tag.Cand[{Path:[17]}]
execute as @e[tag=Arrow,scores={PathNumber=18}] run data remove entity @s Item.tag.Cand[{Path:[18]}]
execute as @e[tag=Arrow,scores={PathNumber=19}] run data remove entity @s Item.tag.Cand[{Path:[19]}]
execute as @e[tag=Arrow,scores={PathNumber=20}] run data remove entity @s Item.tag.Cand[{Path:[20]}]
execute as @e[tag=Arrow] if data entity @s Item.tag.Cand[0] run data modify entity @s Item.tag.Cand[].Path append from entity @s Item.tag.Number

# 保存(19)
execute as @e[tag=Arrow] at @s if data entity @s Item.tag.Cand[0] run data modify block 0 ~ 0 RecordItem.tag.MaxPath set from entity @s Item.tag.Cand[].Path

# 開拓地へ(20)
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag set value {Routes:[]}
execute as @e[tag=Arrow] at @s run data modify block ^ ^ ^2 RecordItem.tag.Routes append from entity @s Item.tag.Cand[]

# 街道へ(20)
execute as @e[tag=Arrow] at @s run data modify entity @s Item.tag.Cand set from block ^ ^ ^-2 RecordItem.tag.Routes
execute as @e[tag=Arrow,scores={PathNumber=01}] run data remove entity @s Item.tag.Cand[{Path:[1]}]
execute as @e[tag=Arrow,scores={PathNumber=02}] run data remove entity @s Item.tag.Cand[{Path:[2]}]
execute as @e[tag=Arrow,scores={PathNumber=03}] run data remove entity @s Item.tag.Cand[{Path:[3]}]
execute as @e[tag=Arrow,scores={PathNumber=04}] run data remove entity @s Item.tag.Cand[{Path:[4]}]
execute as @e[tag=Arrow,scores={PathNumber=05}] run data remove entity @s Item.tag.Cand[{Path:[5]}]
execute as @e[tag=Arrow,scores={PathNumber=06}] run data remove entity @s Item.tag.Cand[{Path:[6]}]
execute as @e[tag=Arrow,scores={PathNumber=07}] run data remove entity @s Item.tag.Cand[{Path:[7]}]
execute as @e[tag=Arrow,scores={PathNumber=08}] run data remove entity @s Item.tag.Cand[{Path:[8]}]
execute as @e[tag=Arrow,scores={PathNumber=09}] run data remove entity @s Item.tag.Cand[{Path:[9]}]
execute as @e[tag=Arrow,scores={PathNumber=10}] run data remove entity @s Item.tag.Cand[{Path:[10]}]
execute as @e[tag=Arrow,scores={PathNumber=11}] run data remove entity @s Item.tag.Cand[{Path:[11]}]
execute as @e[tag=Arrow,scores={PathNumber=12}] run data remove entity @s Item.tag.Cand[{Path:[12]}]
execute as @e[tag=Arrow,scores={PathNumber=13}] run data remove entity @s Item.tag.Cand[{Path:[13]}]
execute as @e[tag=Arrow,scores={PathNumber=14}] run data remove entity @s Item.tag.Cand[{Path:[14]}]
execute as @e[tag=Arrow,scores={PathNumber=15}] run data remove entity @s Item.tag.Cand[{Path:[15]}]
execute as @e[tag=Arrow,scores={PathNumber=16}] run data remove entity @s Item.tag.Cand[{Path:[16]}]
execute as @e[tag=Arrow,scores={PathNumber=17}] run data remove entity @s Item.tag.Cand[{Path:[17]}]
execute as @e[tag=Arrow,scores={PathNumber=18}] run data remove entity @s Item.tag.Cand[{Path:[18]}]
execute as @e[tag=Arrow,scores={PathNumber=19}] run data remove entity @s Item.tag.Cand[{Path:[19]}]
execute as @e[tag=Arrow,scores={PathNumber=20}] run data remove entity @s Item.tag.Cand[{Path:[20]}]
execute as @e[tag=Arrow] if data entity @s Item.tag.Cand[0] run data modify entity @s Item.tag.Cand[].Path append from entity @s Item.tag.Number

# 保存(20)
execute as @e[tag=Arrow] at @s if data entity @s Item.tag.Cand[0] run data modify block 0 ~ 0 RecordItem.tag.MaxPath set from entity @s Item.tag.Cand[].Path

# 値表示
execute store result score 赤 MaxPathLength run data get block 0 0 0 RecordItem.tag.MaxPath
execute store result score 緑 MaxPathLength run data get block 0 1 0 RecordItem.tag.MaxPath
execute store result score 青 MaxPathLength run data get block 0 2 0 RecordItem.tag.MaxPath
execute store result score 黄 MaxPathLength run data get block 0 3 0 RecordItem.tag.MaxPath

########## 道表示開始(要らない時は飛ばす) ##########
execute as @e[tag=Arrow] at @s align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:air
execute as @e[tag=Arrow] at @s run data modify entity @s Item.tag.MaxPath set from block 0 ~ 0 RecordItem.tag.MaxPath

execute at @e[tag=Arrow,scores={PathNumber=01},nbt={Item:{tag:{MaxPath:[1]}}}] align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:white_concrete
execute at @e[tag=Arrow,scores={PathNumber=02},nbt={Item:{tag:{MaxPath:[2]}}}] align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:white_concrete
execute at @e[tag=Arrow,scores={PathNumber=03},nbt={Item:{tag:{MaxPath:[3]}}}] align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:white_concrete
execute at @e[tag=Arrow,scores={PathNumber=04},nbt={Item:{tag:{MaxPath:[4]}}}] align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:white_concrete
execute at @e[tag=Arrow,scores={PathNumber=05},nbt={Item:{tag:{MaxPath:[5]}}}] align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:white_concrete
execute at @e[tag=Arrow,scores={PathNumber=06},nbt={Item:{tag:{MaxPath:[6]}}}] align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:white_concrete
execute at @e[tag=Arrow,scores={PathNumber=07},nbt={Item:{tag:{MaxPath:[7]}}}] align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:white_concrete
execute at @e[tag=Arrow,scores={PathNumber=08},nbt={Item:{tag:{MaxPath:[8]}}}] align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:white_concrete
execute at @e[tag=Arrow,scores={PathNumber=09},nbt={Item:{tag:{MaxPath:[9]}}}] align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:white_concrete
execute at @e[tag=Arrow,scores={PathNumber=10},nbt={Item:{tag:{MaxPath:[10]}}}] align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:white_concrete
execute at @e[tag=Arrow,scores={PathNumber=11},nbt={Item:{tag:{MaxPath:[11]}}}] align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:white_concrete
execute at @e[tag=Arrow,scores={PathNumber=12},nbt={Item:{tag:{MaxPath:[12]}}}] align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:white_concrete
execute at @e[tag=Arrow,scores={PathNumber=13},nbt={Item:{tag:{MaxPath:[13]}}}] align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:white_concrete
execute at @e[tag=Arrow,scores={PathNumber=14},nbt={Item:{tag:{MaxPath:[14]}}}] align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:white_concrete
execute at @e[tag=Arrow,scores={PathNumber=15},nbt={Item:{tag:{MaxPath:[15]}}}] align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:white_concrete
execute at @e[tag=Arrow,scores={PathNumber=16},nbt={Item:{tag:{MaxPath:[16]}}}] align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:white_concrete
execute at @e[tag=Arrow,scores={PathNumber=17},nbt={Item:{tag:{MaxPath:[17]}}}] align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:white_concrete
execute at @e[tag=Arrow,scores={PathNumber=18},nbt={Item:{tag:{MaxPath:[18]}}}] align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:white_concrete
execute at @e[tag=Arrow,scores={PathNumber=19},nbt={Item:{tag:{MaxPath:[19]}}}] align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:white_concrete
execute at @e[tag=Arrow,scores={PathNumber=20},nbt={Item:{tag:{MaxPath:[20]}}}] align xyz positioned as @e[dy=10,tag=Edge,limit=1] positioned ~ ~1 ~ run setblock ^ ^ ^1 minecraft:white_concrete

execute as @e[tag=Edge] at @s positioned ~ ~1 ~ if block ~ ~ ~ minecraft:red_wool run fill ^-1 ^ ^-1 ^1 ^ ^1 minecraft:red_concrete replace minecraft:white_concrete
execute as @e[tag=Edge] at @s positioned ~ ~1 ~ if block ~ ~ ~ minecraft:green_wool run fill ^-1 ^ ^-1 ^1 ^ ^1 minecraft:green_concrete replace minecraft:white_concrete
execute as @e[tag=Edge] at @s positioned ~ ~1 ~ if block ~ ~ ~ minecraft:blue_wool run fill ^-1 ^ ^-1 ^1 ^ ^1 minecraft:blue_concrete replace minecraft:white_concrete
execute as @e[tag=Edge] at @s positioned ~ ~1 ~ if block ~ ~ ~ minecraft:yellow_wool run fill ^-1 ^ ^-1 ^1 ^ ^1 minecraft:yellow_concrete replace minecraft:white_concrete
########## 道表示終了 ##########

kill @e[tag=Arrow]
