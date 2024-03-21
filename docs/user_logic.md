## Functions that you can use on EzConsole

### `ezConsole_log(message: string, no_output:bool)`

> Log a message to the console as if it was an user input (includes timestamp).

| Argument  | Type   | Description                                                    |
| --------- | ------ | -------------------------------------------------------------- |
| message   | string | The message to log.                                            |
| no_output | bool   | If true, the message will not be output to the IDE output tab. |

---

### `ezConsole_error(message: string, no_output:bool)`

> Log an error message to the console.

| Argument  | Type   | Description                                                    |
| --------- | ------ | -------------------------------------------------------------- |
| message   | string | The message to log.                                            |
| no_output | bool   | If true, the message will not be output to the IDE output tab. |

---

### `ezConsole_warn(message: string, no_output:bool)`

> Log a warning message to the console.

| Argument  | Type   | Description                                                    |
| --------- | ------ | -------------------------------------------------------------- |
| message   | string | The message to log.                                            |
| no_output | bool   | If true, the message will not be output to the IDE output tab. |

---

### `ezConsole_info(message: string, no_output:bool)`

> Log an informational message to the console.

| Argument  | Type   | Description                                                    |
| --------- | ------ | -------------------------------------------------------------- |
| message   | string | The message to log.                                            |
| no_output | bool   | If true, the message will not be output to the IDE output tab. |

---

### `ezConsole_is_open()`

> Check if the console is open on console window mode. Returns a boolean.

> [!NOTE]
> This function will always return `true` if the console is not in window mode and is visible. If your console is not in window mode, use `ezConsole_is_visible()` instead.

---

### `ezConsole_is_visible()`

> Check if the console is visible. Returns a boolean.

---

### `ezConsole_set_visible()`

> Set the console to be visible.

---

### `ezConsole_set_invisible()`

> Set the console to be invisible. Any console command will not be executed while the console is invisible.
