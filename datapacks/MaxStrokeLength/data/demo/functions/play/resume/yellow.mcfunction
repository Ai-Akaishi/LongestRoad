execute at @e[tag=Edge,team=Yel] run tag @e[distance=..3,tag=Node,tag=Free] add Cand
execute at @e[tag=Edge,team=Yel] at @e[distance=..3,tag=Node,team=!Red,team=!Gre,team=!Blu] run tag @e[distance=..3,tag=Edge,tag=Free] add Cand
tag @e[tag=Edge,team=Yel,limit=19] add Count
execute if entity @e[tag=Edge,team=Yel,tag=!Count] run tag @e[tag=Edge] remove Cand
tag @e[tag=Count] remove Count
execute at @e[tag=Cand,sort=random,limit=1] run tag @e[distance=1..,tag=Cand] remove Cand
execute as @e[tag=Cand,tag=Node] run function demo:play/city/yellow
execute as @e[tag=Cand,tag=Edge] run function demo:play/road/yellow
tag @e[tag=Cand] remove Cand
