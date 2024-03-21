## `EzConsoleCommand`

> Creates a new command for the console.

| Parameter | Description                                                                       | Required | Default value  |
| --------- | --------------------------------------------------------------------------------- | -------- | -------------- |
| name      | The name of the command.                                                          | Yes      |                |
| short     | The short name of the command.                                                    | No       | _empty string_ |
| desc      | The description of the command.                                                   | No       | _empty string_ |
| callback  | The function to call when the command is executed.                                | Yes      | -1             |
| args      | An array of `EzConsoleCommandArgument` or `EzConsoleArgumentWithOptions` objects. | No       | _empty array_  |

---

## `EzConsoleCommandArgument`

> Used to define an argument for a command. Arguments are used to pass data to the command callback.

| Parameter | Description                                            | Required | Default value  |
| --------- | ------------------------------------------------------ | -------- | -------------- |
| name      | The name of the argument.                              | Yes      |                |
| desc      | The description of the argument.                       | No       | _empty string_ |
| required  | True if the argument is required, false otherwise.     | No       | `true`         |
| type      | The type of the argument. (For type-ahead suggestions) | No       | `noone`        |

---

## `EzConsoleCommandArgumentWithOptions`

> Used to define an argument for a command with pre-defined options to choose. Arguments are used to pass data to the command callback.

| Parameter | Description                                                       | Required | Default value  |
| --------- | ----------------------------------------------------------------- | -------- | -------------- |
| name      | The name of the argument.                                         | Yes      |                |
| desc      | The description of the argument.                                  | No       | _empty string_ |
| required  | True if the argument is required, false otherwise.                | No       | `true`         |
| options   | An array with the options available. (For type-ahead suggestions) | No       | `[]`           |

---

## Asset types for arguments

> [!NOTE]
> The `ezConsole_type_option` is used to define the type of the argument for type-ahead suggestions when the argument has pre-defined options to choose. Cannot be set via code, only on the json file. If you want an argument to have pre-defined options, you should use the `EzConsoleCommandArgumentWithOptions` constructor instead of `EzConsoleCommandArgument`.

> The asset types are used to define the type of the argument for type-ahead suggestions. The following table shows the ezConsole types supported and their respective values.

| Type on code              | Type on json        |
| ------------------------- | ------------------- |
| `noone`                   | "" (_empty string_) |
| `ezConsole_type_sprite`   | "sprite"            |
| `ezConsole_type_object`   | "object"            |
| `ezConsole_type_sound`    | "sound"             |
| `ezConsole_type_font`     | "font"              |
| `ezConsole_type_script`   | "script"            |
| `ezConsole_type_room`     | "room"              |
| `ezConsole_type_instance` | "instance"          |
| `ezConsole_type_option`   | "option"            |

---

> [!NOTE]
> The next constructors were added on version 1.3.0 of the extension. If you are using a previous version, please update to the latest version to use these constructors.

## `EzConsoleSkin`

> Creates a new skin for the console.

| Parameter                 | Description                               | Required | Default value |
| ------------------------- | ----------------------------------------- | -------- | ------------- |
| `EzConsoleSkinOwnership`  | The ownership of the skin.                | Yes      | -             |
| `EzConsoleSkinSize`       | The size of the skin.                     | Yes      | -             |
| `EzConsoleSkinBackground` | The background of the skin.               | Yes      | -             |
| `EzConsoleSkinText`       | The text properties of the skin.          | Yes      | -             |
| `EzConsoleSkinBar`        | The bar properties of the skin.           | Yes      | -             |
| `EzConsoleSkinMisc`       | The miscellaneous properties of the skin. | Yes      | -             |

---

## `EzConsoleSkinOwnership`

> Creates a new ownership reference for the console skin. Must be as a parameter of `EzConsoleSkin`.

| Parameter | Description              | Required | Default value         |
| --------- | ------------------------ | -------- | --------------------- |
| name      | The name of the skin.    | Yes      |                       |
| author    | The author of the skin.  | No       | "unknown"             |
| version   | The version of the skin. | No       | `<ezConsole_version>` |

---

## `EzConsoleSkinSize`

> Creates a new size reference for the console skin. Must be as a parameter of `EzConsoleSkin`.

| Parameter | Description                                             | Required | Default value |
| --------- | ------------------------------------------------------- | -------- | ------------- |
| width     | The width of the skin.                                  | Yes      |               |
| height    | The height of the skin.                                 | Yes      |               |
| anchor    | The anchor of the skin. (Check [`EZ_CONSOLE_ANCHOR`](./Enumerators) enum) | No       | `0`           |

---

## `EzConsoleSkinBackground`

> Creates a new background reference for the console skin. Must be as a parameter of `EzConsoleSkin`.

| Parameter    | Description                          | Required | Default value |
| ------------ | ------------------------------------ | -------- | ------------- |
| bg_color     | The color of the skin.               | Yes      |               |
| border_color | The color of the border of the skin. | No       | `#000000`     |
| bg_alpha     | The alpha of the skin.               | No       | `1`           |
| border_alpha | The alpha of the border of the skin. | No       | `0`           |
| blur_amount  | The amount of blur of the skin.      | No       | `0.20`        |

---

## `EzConsoleSkinText`

> Creates a new reference for text properties for the console skin. Must be as a parameter of `EzConsoleSkin`.

| Parameter         | Description                   | Required |
| ----------------- | ----------------------------- | -------- |
| text_font         | The font of the skin.         | Yes      |
| text_font_xoff    | The x offset of the font.     | Yes      |
| text_font_yoff    | The y offset of the font.     | Yes      |
| text_color_common | The common color of the font. | Yes      |
| text_color_error  | The error color of the font.  | Yes      |
| text_color_warn   | The warn color of the font.   | Yes      |
| text_color_info   | The info color of the font.   | Yes      |
| text_alpha        | The alpha of the font.        | Yes      |

---

## `EzConsoleSkinBar`

> Creates a new reference for the text bar properties for the console skin. Must be as a parameter of `EzConsoleSkin`.

| Parameter           | Description                                                     | Required |
| ------------------- | --------------------------------------------------------------- | -------- |
| bar_height          | The height of the bar.                                          | Yes      |
| bar_color           | The color of the bar.                                           | Yes      |
| bar_color_highlight | The highlight color of the bar. (Used during type-ahead events) | Yes      |
| bar_xpad            | The x padding of the bar.                                       | Yes      |
| bar_ypad            | The y padding of the bar.                                       | Yes      |
| bar_inset           | The inset of the bar.                                           | Yes      |

---

## `EzConsoleSkinMisc`

> Creates a new reference for the miscellaneous properties for the console skin. Must be as a parameter of `EzConsoleSkin`.

| Parameter                      | Description                                         | Required | Default value |
| ------------------------------ | --------------------------------------------------- | -------- | ------------- |
| text_blink_char                | The character to use for the blinking cursor.       | No       | "\_"          |
| text_blink_rate                | The speed of the blinking cursor.                   | No       | `1`           |
| text_start_char                | The character to use for the start of the text.     | No       | ">"           |
| screenfill_color               | The color to use for the screen fill.               | No       | `#eeeeee`     |
| screenfill_alpha               | The alpha to use for the screen fill.               | No       | `0.33`        |
| typeahead_text_color           | The color to use for the type-ahead text.           | No       | `#eeeeee`     |
| typeahead_text_color_highlight | The highlight color to use for the type-ahead text. | No       | `#0f0f3c`     |
