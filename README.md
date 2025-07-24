# How to add your game

The project loads games from "res://games/", create a new folder there and make sure it has a scene named "game.tscn". This is the root scene that will be loaded.

All of your files should be contained within "res://games/[your_game]/".

End your game with `minigame.end_game([TYPE])`, for other functions you can use check out "res://games/example_game_howto/".

Feel free to look into or duplicate the example_game_2d / example_game_3d folders and continue from there.


PS remember to follow naming conventions.
eg. if you are naming a variable in GDScript use snake_case, if you are using C# name it with camelCase.

read full standardisation at:
https://docs.godotengine.org/en/4.4/tutorials/scripting/gdscript/gdscript_styleguide.html
https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions