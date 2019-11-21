function demo:clear

tag @e[tag=Edge] add Free
tag @e[tag=Node] add Free
team join White @e[tag=Edge]
team join White @e[tag=Node]

execute as @e[tag=Node,sort=random,limit=1] run function demo:play/init/red
execute as @e[tag=Node,sort=random,limit=1] run function demo:play/init/green
execute as @e[tag=Node,sort=random,limit=1] run function demo:play/init/blue
execute as @e[tag=Node,sort=random,limit=1] run function demo:play/init/yellow
execute as @e[tag=Node,sort=random,limit=1] run function demo:play/init/yellow
execute as @e[tag=Node,sort=random,limit=1] run function demo:play/init/blue
execute as @e[tag=Node,sort=random,limit=1] run function demo:play/init/green
execute as @e[tag=Node,sort=random,limit=1] run function demo:play/init/red
