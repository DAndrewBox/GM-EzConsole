## `EZ_CONSOLE_MSG`

> Enumerator for default console messages.

| Name                       | INT | Message                                                                                                |
| -------------------------- | --- | ------------------------------------------------------------------------------------------------------ |
| `INTIALIZATION`            | 0   | === GM EzConsole v`ezConsole_version` ===<br>Type "help" to start.                                     |
| `NOT_ENOUGH_PARAMS`        | 1   | `command` must receive at least `min_params` argument(s).<br>(`params_count` were given)               |
| `TOO_MANY_PARAMS`          | 2   | `command` must receive at most `max_params` argument(s).<br>(`params_count` were given)                |
| `INVALID_PARAM`            | 3   | Command "`command`" has no param "`param`".                                                            |
| `HELP_MENU`                | 4   | Type "help <_command_>" to get more information about the command.                                     |
| `COMMAND_DOESNT_EXISTS`    | 5   | Command "`command`" doesn't exists.                                                                    |
| `CALLBACK_DOESNT_EXISTS`   | 6   | Callback for this command is not defined!                                                              |
| `UNDEFINED_COMMANDS_FOUND` | 7   | Undefined commands found after executing "`command`".<br>Please verify the integrity of your commands. |

---

## `EZ_CONSOLE_MSG_TYPE`

> Enumerator for the type of log message.

| Name      | INT | Description            |
| --------- | --- | ---------------------- |
| `COMMON`  | 0   | Log message.           |
| `ERROR`   | 1   | Error message.         |
| `WARNING` | 2   | Warning message.       |
| `INFO`    | 3   | Informational message. |

---

## `EZ_CONSOLE_ANCHOR`

> Enumerator for the console anchor.

| Name           | INT | Description                      |
| -------------- | --- | -------------------------------- |
| `TOP_LEFT`     | 0   | Top left corner.                 |
| `TOP_RIGHT`    | 1   | Top right corner.                |
| `BOTTOM_LEFT`  | 2   | Bottom left corner.              |
| `BOTTOM_RIGHT` | 3   | Bottom right corner.             |
| `NONE`         | 4   | No anchor. (Console as a window) |
