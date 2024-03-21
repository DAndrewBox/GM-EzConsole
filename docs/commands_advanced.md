> [!IMPORTANT]
> This section is only valid for `v1.3.0+` version of the extension. If you are using a version released before, it will not work.

## Your first command using arguments with options

In this section, you will learn how to create a command with arguments that have options. This is useful when you want to create a command that can receive different types of arguments and you want to validate them.

We will recreate the base command `game`.

To create your first command with arguments with options, you can do so by following these steps:

1. Open the `ezConsole_custom_commands` script file in your project.
2. Create the logic for the callback function for the command you want to add.

For the logic of the callback function, you can use the following code:

```js
/// @func	console_command_base_game(args)
/// @param	{array}	args
/// @desc	Execute game actions
function console_command_base_game(_args) {
  switch (_args[0]) {
    case "reset":
      game_restart();
      break;

    case "end":
      game_end();
      break;

    default:
      // TO-DO: Add error message
      break;
  }
}
```

On this code, we are using a `switch` statement to check the first argument of the command. If the argument is `reset`, we will restart the game. If the argument is `end`, we will end the game. If the argument is anything else, we will show an error message. You can use this logic as a base for your command.

To show an error message, we need to check for an invalid parameter or argument. For this we will use one of the default messages from the `EZ_CONSOLE_MSG` enumerator. You can see the list of default messages on the [enumerators page](./Enumerators).

Using the `console_get_message` function, we can get the message and add the argument that caused the error. The first argument of the function is the message from the `EZ_CONSOLE_MSG` enumerator, the second argument is the name of the command, the third argument is the number of arguments received, the fourth argument is the minimum number of arguments required, and the fifth argument is the maximum number of arguments required.

Then we add the argument that caused the error. The following code shows how to use the `console_get_message` function to get the message for an invalid parameter:

```js
var _invalid_param =
  console_get_message(
    EZ_CONSOLE_MSG.INVALID_PARAM,
    "game",
    array_length(_args),
    1,
    1
  ) + _args[0];
ezConsole_error(_invalid_param);
```

The logic for the callback function is now complete and will look like this:

```js
/// @func	console_command_base_game(args)
/// @param	{array}	args
/// @desc	Execute game actions
function console_command_base_game(_args) {
  switch (_args[0]) {
    case "reset":
      game_restart();
      break;

    case "end":
      game_end();
      break;

    default:
      var _invalid_param =
        console_get_message(
          EZ_CONSOLE_MSG.INVALID_PARAM,
          "game",
          array_length(_args),
          1,
          1
        ) + _args[0];
      ezConsole_error(_invalid_param);
      break;
  }
}
```

3. Now you should create a new console command using the constructor `EzConsoleCommand`. To add you arguments to the command, you should use the constructor `EzConsoleArgument` or `EzConsoleArgumentWithOptions`. You can see the meaning of each parameter on the [constructors page](./Constructors).

This command constructor has the following format:

```js
new EzConsoleCommand(
  "game",
  "",
  "Choose to end or restart the game.",
  console_command_base_game,
  [
    new EzConsoleArgumentWithOptions("action", "Action to execute", [
      "reset",
      "end",
    ]),
  ]
);
```

4. Once you have created the command, it would automatically be added to the list of commands. You can now run your project and type `game` on the console, followed by an `action`. If everything went well, you should see the game restarting or ending.

Now you have created your first command with arguments with options. You can use this logic to create more complex commands with different types of arguments.

Check the `ezConsole_base_commands_logic` script for more examples of commands with arguments with options.

---

## Create your first command with asset-typed arguments

On this section, you will learn how to create a command with typed arguments. This is useful when you want to create a command that can receive any type of asset and you want to validate them.

We will recreate the base command `create`. This command will create an object on the room with `x`, `y` and `depth` arguments being optional.

To create your first command with asset-typed arguments, you can do so by following these steps:

1. Open the `ezConsole_custom_commands` script file in your project.
2. Create the logic for the callback function for the command you want to add.

This will be the end result of the callback function, we will explain the logic behind it:

```js
/// @func	console_command_base_create(args)
/// @param	{array}	args
/// @desc	Creates an instance
function console_command_base_create(_args) {
  var _asset = asset_get_index(_args[0]);
  var _params_len = array_length(_args);

  try {
    var _x = _params_len > 1 ? real(_args[1]) : mouse_x;
    var _y = _params_len > 2 ? real(_args[2]) : mouse_y;
    var _depth = _params_len > 3 ? real(_args[3]) : -100;
  } catch (e) {
    ezConsole_error(e.message);
    return -1;
  }

  if (_asset == -1) {
    ezConsole_error("There's no object named \"" + _args[0] + '"!');
  } else {
    var _inst = instance_create_depth(_x, _y, _depth, _asset);
    ezConsole_info("Instance created with id " + string(_inst.id) + ".");
  }
}
```

On this code, we are using the `asset_get_index` function to get the index of the object asset. Then we will get the `x`, `y` and `depth` arguments. If the arguments are not valid, we will show an error message. That can be visualized on the `try-catch` block.

We assign the default values for `x`, `y` and `depth` if they are not provided as `mouse_x`, `mouse_y` and `-100` respectively. Then we check if the asset is valid.

If the asset is not valid (`_asset == -1`), we will show an error message saying that _the object "`_args[0]`" doesn't exists_. If the asset is valid, we will create the instance and show an informational message.

3. Now you should create a new console command using the constructor `EzConsoleCommand`. To add you arguments to the command, you must use the constructor `EzConsoleArgument`. You can see the meaning of each parameter on the [constructors page](./Constructors).

This command constructor has the following format:

```js
new EzConsoleCommand(
  "create",
  "",
  "Create an object on position.",
  console_command_base_create,
  [
    new EzConsoleArgument(
      "object_name",
      "Object to create",
      true,
      ezConsole_type_object
    ),
    new EzConsoleArgument("x", "X position", false),
    new EzConsoleArgument("y", "Y position", false),
    new EzConsoleArgument("depth", "Depth", false),
  ]
);
```

It's important to note that the `object_name` argument is of type `ezConsole_type_object`. This is a special type that will allow the user to select an object from the list of objects on the project. You can see the list of types on the [constructors page](./Constructors).

4. Once you have created the command, it would automatically be added to the list of commands. You can now run your project and type `create` on the console, followed by an `object_name`. If everything went well, you should see the object being created on the room.

Now you have created your first command with asset-typed arguments. You can use this logic to create more complex commands with different types of arguments.

Here is an example of a command that validates all types of assets and is included on the `ezConsole_custom_commands` script file:

```js
new EzConsoleCommand(
		"types",,
		"Check types",
		function (_args) {
			show_message(_args);
		},
		[
			new EzConsoleCommandArgument("sprite",, true, ezConsole_type_sprite),
			new EzConsoleCommandArgument("object",, true, ezConsole_type_object),
			new EzConsoleCommandArgument("sound",, true, ezConsole_type_sound),
			new EzConsoleCommandArgument("font",, true, ezConsole_type_font),
			new EzConsoleCommandArgument("room",, true, ezConsole_type_room),
			new EzConsoleCommandArgument("script",, true, ezConsole_type_script),
			new EzConsoleCommandArgument("instance",, true, ezConsole_type_instance),
		]
	);
```
