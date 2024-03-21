## Create your first command

On this section, you will learn how to create your first command. This command will be called `trace` and will print a message on the console.

To create your first command, you can do so by following these steps:

1. Open the `ezConsole_custom_commands` script file in your project.

2. Create a new function inside this file with the following name `console_command_alert`.

```js
/// @func   console_command_alert(args)
/// @param	{array}	args
function console_command_alert(_args) {
  show_message_async(_args[0]);
}
```

3. As you can see, the function should start with `console_command_` followed by the command name. In this case, the command name is `alert`. The `_args` parameter is an array of strings that contains the arguments passed to the command. You can access the arguments by using the `_args` array. For example, if you want to access the first argument, you can do so by using `_args[0]`.

4. Now you should create a new console command using the constructor `EzConsoleCommand`. To add you arguments to the command, you should use the constructor `EzConsoleArgument` or `EzConsoleArgumentWithOptions`. You can see the meaning of each parameter on the [constructors page](./Constructors).

This command constructor has the following format:

```js
new EzConsoleCommand(
  "alert",
  "",
  "Shows an alert on screen.",
  console_command_alert,
  [new EzConsoleCommandArgument("message", "Message to show")]
);
```

5. Once you have created the command, it would automatically be added to the list of commands. You can now run your project and type `alert` on the console, followed by a `message`. If everything went well, you should see the alert with your message on screen.

You can also skip the step 4 by adding the commands via file. You can see how to do that on the next section.

---

## Import base commands

By default, the extension comes with a set of base commands that you can use to test the extension.
The commands are imported automatically when the extension is imported into your project and are saved in the `default_commands.json` file.

> **Sidenote:** If you want to disable the import of the base commands, you can do so by removing `"default_commands.json"` from the `ezConsole_files` array on the `ezConsole_configurations` script and deleting the `default_commands.json` file.

The following table shows the list of base commands included on the `default_commands.json` file:

| Command    | Description                                        | Arguments                           | Required arguments          |
| ---------- | -------------------------------------------------- | ----------------------------------- | --------------------------- |
| help       | Show the list of commands.                         | [command]                           | [false]                     |
| message    | Shows a message on screen and pauses the game.     | [message]                           | [true]                      |
| fullscreen | Toggles fullscreen mode.                           | [false/true]                        | [true]                      |
| game       | Choose to end or restart the game.                 | [end/reset]                         | [true]                      |
| create     | Create an object.                                  | [object_name, x, y, depth]          | [true, false, false, false] |
| instances  | Show the list of active instances.                 | [object_name]                       | [true]                      |
| clear      | Clear the console.                                 |                                     |                             |
| set        | Set a variable on an instance.                     | [instance_id, variable_name, value] | [true, true]                |
| get        | Gets a variable or all variables from an instance. | [instance_id, variable_name]        | [false]                     |
| delete     | Delete an instance.                                | [instance_id]                       | [true]                      |
| fps        | Shows or toggles the current FPS.                  | [false/true]                        | [false]                     |
| debug_view | Shows or hides the debug views.                    | [false/true]                        | [false]                     |

---

## Import custom commands from file

If you want to import custom commands from a file, you can do so by following these steps:

1. Create a new file with the `.json` extension on the included console folder.
2. Add and create the commands you want to import to the file.
3. Open the script `ezConsole_configurations`.
4. Add the filename of the file into the `ezConsole_files` array on the script.
5. Create a callback function for each command you want to import on the `ezConsole_custom_commands` script. _(Or elsewhere, but remember which is the callback for the command)._
6. Run your project and press `F1` (_by default_) to open the console.
7. Type `help` to see the list of commands.

You should see the commands you imported. If you don't, check if you followed the steps correctly and the file is in the correct folder.

Remember that the commands should have this format:

```json
{
  "name": "command_name",
  "alias": "command_short_name",
  "desc": "Short description of the command",
  "args": [
    {
      "name": "argument_name",
      "desc": "Short description of the argument",
      "required": "true or false",
      "type": "asset type of the argument by following the table on the previous section",
      "options": ["array", "with", "options"]
    }
  ],
  "callback": "Function to call when the command is executed"
}
```

> [!IMPORTANT]
> The `short` field was changed to `alias` in versions 1.3.0+. If you have a command with a short name, you should use the `alias` field instead.

You can see some examples of a command on the `default_commands.json` file. The following table shows the meaning of each field:

| Field         | Description                                                         | Required               |
| ------------- | ------------------------------------------------------------------- | ---------------------- |
| name          | The name of the command.                                            | Yes                    |
| alias         | The alias of the command. (`short` before v1.3.0)                   | No (use "" to disable) |
| desc          | The description of the command.                                     | No                     |
| args          | An array of arguments of the command.                               | No                     |
| args.name     | The name of the argument.                                           | Yes                    |
| args.desc     | The description of the argument.                                    | No                     |
| args.required | True if the argument is required, false otherwise.                  | No                     |
| args.type     | The asset type of the argument.                                     | No                     |
| args.options  | An array with the options available. Only valid if type is `option` | No                     |
| callback      | The function to call when the command is executed.                  | Yes                    |

---

## Import custom commands from code

If you want to import custom commands from code, you can do so by following these steps:

1. Open the `ezConsole_custom_commands` script.
2. Create the logic for the callback functions for the commands you want to add.
3. In the second `#region`, use the `EzConsoleCommand()` constructor as shown on the step 3 of the [first section](#create-your-first-command).
4. Run your project and press `F1` (_by default_) to open the console.
5. Type `help` to see the list of commands.

Now you should see the commands you imported. If you don't, check if you followed the steps correctly.

---
