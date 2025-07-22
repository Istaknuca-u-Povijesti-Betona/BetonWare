correct game structure is "res://Games/[YOUR_GAME]/Game.tscn",
then any other files you need should go under "res://Games/[YOUR_GAME]/"
you may name files whatever you like with the exception of the Root scene which should remain as "Game.tscn"
feel free to duplicate the ExampleGame folder and continue from there
do not change Node structure outside your minigame (eg do not try to .get_parent() from your root node or you are going to break shit)

PS remember to follow Godots naming conventions
vars should be in PascalCase and functions should be in snake_case
.my_awesome_function(MyAwesomeParameter)
