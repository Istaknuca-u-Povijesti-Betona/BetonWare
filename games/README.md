correct game structure is "res://games/[your_game]/game.tscn",
then any other files you need should go under "res://games/[your_game]/"
you may name files whatever you like with the exception of the root scene which should remain as "game.tscn"
feel free to duplicate the example_game_2d / example_game_3d folders and continue from there
do not change node structure outside your minigame (eg do not try to .get_parent() from your root node or you are going to break shit)

PS remember to follow the Godot / GDScript naming conventions

the exception to this is that we will be using British English to piss off the Americans

snake_case     -  file names, functions, variables, signals
PascalCase     -  class names, node names, enum names
CONSTANT_CASE  -  constants, enum members

read full standardisation at
https://docs.godotengine.org/en/4.4/tutorials/scripting/gdscript/gdscript_styleguide.html
