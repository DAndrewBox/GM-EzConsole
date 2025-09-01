# 📚 Documentation

This is the offline version of the official and up-to-date documentation for **GameMaker's ezConsole**. Here you will find all the information you need to start using the tool in your projects.

## Table of Contents

- [Definitions](#definitions)
  - [Enumerators](#enumerators)
    - [EZ_CONSOLE_MSG](#ez_console_msg)
    - [EZ_CONSOLE_MSG_TYPE](#ez_console_msg_type)
    - [EZ_CONSOLE_ANCHOR](#ez_console_anchor)
  - [Asset Types](#asset-types)
- [Constructors](#constructors)
  - [EzConsoleCommand](#ezconsolecommand)
    - [EzConsoleCommandArgument](#ezconsolecommandargument)
    - [EzConsoleCommandArgumentWithOptions](#ezconsolecommandargumentwithoptions)
  - [EzConsoleSkin](#ezconsoleskin)
    - [EzConsoleSkinOwnership](#ezconsoleskinownership)
    - [EzConsoleSkinSize](#ezconsoleskinsize)
    - [EzConsoleSkinBackground](#ezconsoleskinbackground)
    - [EzConsoleSkinText](#ezconsoleskintext)
    - [EzConsoleSkinBar](#ezconsoleskinbar)
    - [EzConsoleSkinMisc](#ezconsoleskinmisc)
- [User Functions](#user-functions)
  - [ezConsole_log](#ezconsole_log)
  - [ezConsole_error](#ezconsole_error)
  - [ezConsole_warn](#ezconsole_warn)
  - [ezConsole_info](#ezconsole_info)
  - [ezConsole_is_open](#ezconsole_is_open)
  - [ezConsole_is_visible](#ezconsole_is_visible)
  - [ezConsole_set_visible](#ezconsole_set_visible)
  - [ezConsole_set_hidden](#ezconsole_set_hidden)
- [Customization](#customization)
  - [Using a theme](#using-a-theme)
  - [Create your own theme (file)](#create-your-own-theme-using-skin-files)
  - [Create your own theme (code)](#create-your-own-theme-via-code)
  - [Change console styles](#change-console-styles-not-recommended-but-possible)
  - [Change key bindings](#change-key-bindings)

---

## Definitions
This section contains all the definitions you will need to understand the constructors and functions of this extension. Some of these definitions are used as parameters for the constructors and functions and are not needed to be created manually or used on your own code.

### Enumerators ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)

#### EZ_CONSOLE_MSG ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)
Enumerator for default console messages.

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

## EZ_CONSOLE_MSG_TYPE ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)
Enumerator for the type of log message.

| Name      | INT | Description            |
| --------- | --- | ---------------------- |
| `COMMON`  | 0   | Log message.           |
| `ERROR`   | 1   | Error message.         |
| `WARNING` | 2   | Warning message.       |
| `INFO`    | 3   | Informational message. |

---

## EZ_CONSOLE_ANCHOR ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)
Enumerator for the console anchor.

| Name           | INT | Description                      |
| -------------- | --- | -------------------------------- |
| `TOP_LEFT`     | 0   | Top left corner.                 |
| `TOP_RIGHT`    | 1   | Top right corner.                |
| `BOTTOM_LEFT`  | 2   | Bottom left corner.              |
| `BOTTOM_RIGHT` | 3   | Bottom right corner.             |
| `NONE`         | 4   | No anchor. (Console as a window) |

---

### Asset Types ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)
> [!NOTE]
> The `ezConsole_type_option` is used to define the type of the argument for type-ahead suggestions when the argument has pre-defined options to choose. Cannot be set via code, only on the json file. If you want an argument to have pre-defined options, you should use the `EzConsoleCommandArgumentWithOptions` constructor instead of `EzConsoleCommandArgument`.

The asset types are used to define the type of the argument for type-ahead suggestions. The following table shows the ezConsole types supported and their respective values.

| Type macro on code        | Type string on json |
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

## Constructors

### EzConsoleCommand ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)
Creates a new console command.

```ts
new EzConsoleCommand(name: String, [alias: String], [description: String], [callback: Function | Asset.GMScript], [args: Array<EzConsoleCommandArgument | EzConsoleArgumentWithOptions>]) -> EzConsoleCommand
```

| Parameter   | Description                                                                       | Required | Default value  |
| ----------- | --------------------------------------------------------------------------------- | -------- | -------------- |
| name        | The name of the command.                                                          | Yes      |                |
| alias       | The shorter alias for the command to be called.                                   | No       | _empty string_ |
| description | The description of the command.                                                   | No       | _empty string_ |
| callback    | The function to call when the command is executed.                                | No       | `noone`        |
| args        | An array of `EzConsoleCommandArgument` or `EzConsoleArgumentWithOptions` objects. | No       | _empty array_  |

---

#### EzConsoleCommandArgument ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)
Use this constructor to define a basic argument for a command. Arguments are used to pass data to the command callback.

```ts
new EzConsoleCommandArgument(name: String, [description: String], [required: Boolean], [type: Asset.GMAsset | noone]) -> EzConsoleCommandArgument
```

| Parameter   | Description                                            | Required | Default value  |
| ----------- | ------------------------------------------------------ | -------- | -------------- |
| name        | The name of the argument.                              | Yes      |                |
| description | The description of the argument.                       | No       | _empty string_ |
| required    | True if the argument is required, false otherwise.     | No       | `true`         |
| type        | The type of the argument. (For type-ahead suggestions) | No       | `noone`        |

---

#### EzConsoleCommandArgumentWithOptions ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)
Used to define an argument for a command with pre-defined options to choose. Arguments are used to pass data to the command callback. Options should be a `Array<String>`, you should handle the logic in your own scripts.

```ts
new EzConsoleCommandArgumentWithOptions(name: String, [description: String], [required: Boolean], [options: Array<String>]) -> EzConsoleCommandArgumentWithOptions
```

| Parameter   | Description                                                       | Required | Default value  |
| ----------- | ----------------------------------------------------------------- | -------- | -------------- |
| name        | The name of the argument.                                         | Yes      |                |
| description | The description of the argument.                                  | No       | _empty string_ |
| required    | `true` if the argument is required, `false` otherwise.            | No       | `true`         |
| options     | An array with the options available. (For type-ahead suggestions) | No       | `[]`           |

---

### EzConsoleSkin ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)
Used to create a new skin for the console. You can use this to create your own skins and load them via code.

```ts
new EzConsoleSkin(ownership: EzConsoleSkinOwnership, size: EzConsoleSkinSize, background: EzConsoleSkinBackground, text: EzConsoleSkinText, input_bar: EzConsoleSkinBar, misc: EzConsoleSkinMisc) -> EzConsoleSkin
```

| Parameter  | Type                      | Description                               | Required | Default value |
| ---------- | ------------------------- | ----------------------------------------- | -------- | ------------- |
| ownership  | `EzConsoleSkinOwnership`  | The ownership of the skin.                | Yes      | -             |
| size       | `EzConsoleSkinSize`       | The size of the skin.                     | Yes      | -             |
| background | `EzConsoleSkinBackground` | The background of the skin.               | Yes      | -             |
| text       | `EzConsoleSkinText`       | The text properties of the skin.          | Yes      | -             |
| input_bar  | `EzConsoleSkinBar`        | The bar properties of the skin.           | Yes      | -             |
| misc       | `EzConsoleSkinMisc`       | The miscellaneous properties of the skin. | Yes      | -             |

---

#### EzConsoleSkinOwnership ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)
Used to define the ownership properties and metadata of a skin. Must be as a parameter of `EzConsoleSkin`.

```ts
new EzConsoleSkinOwnership(name: String, author: String, version: String, description: String) -> EzConsoleSkinOwnership
```

| Parameter | Description              | Required | Default value         |
| --------- | ------------------------ | -------- | --------------------- |
| name      | The name of the skin.    | Yes      |                       |
| author    | The author of the skin.  | No       | "unknown"             |
| version   | The version of the skin. | No       | `<ezConsole_version>` |

---

#### EzConsoleSkinSize ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)
Used to define the size properties of a skin. Must be as a parameter of `EzConsoleSkin`.

```ts
new EzConsoleSkinSize(width: Number, height: Number, [anchor: Number]) -> EzConsoleSkinSize
```

| Parameter | Description                                                              | Required | Default value                |
| --------- | ------------------------------------------------------------------------ | -------- | ---------------------------- |
| width     | The width of the skin.                                                   | Yes      |                              |
| height    | The height of the skin.                                                  | Yes      |                              |
| anchor    | The anchor of the skin. (Check [`EZ_CONSOLE_ANCHOR`](#Enumerators) enum) | No       | `EZ_CONSOLE_ANCHOR.TOP_LEFT` |

---

#### EzConsoleSkinBackground ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)
Used to define the background properties of a skin. Must be as a parameter of `EzConsoleSkin`.

```ts
new EzConsoleSkinBackground(bg_color: String, [border_color: String], [bg_alpha: Number], [border_alpha: Number], [blur_amount: Number]) -> EzConsoleSkinBackground
```

| Parameter    | Description                          | Required | Default value |
| ------------ | ------------------------------------ | -------- | ------------- |
| bg_color     | The color of the skin.               | Yes      |               |
| border_color | The color of the border of the skin. | No       | `#000000`     |
| bg_alpha     | The alpha of the skin.               | No       | `1`           |
| border_alpha | The alpha of the border of the skin. | No       | `0`           |
| blur_amount  | The amount of blur of the skin.      | No       | `0.20`        |

---

#### EzConsoleSkinText ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)
Used to define the text properties of a skin. Must be as a parameter of `EzConsoleSkin`.

```ts
new EzConsoleSkinText(text_font: Asset.GMFont, text_font_xoff: Number, text_font_yoff: Number, text_color_common: String, text_color_error: String, text_color_warn: String, text_color_info: String, text_alpha: Number) -> EzConsoleSkinText
```

| Parameter         | Description                  | Required |
| ----------------- | ---------------------------- | -------- |
| text_font         | The font of the skin.        | Yes      |
| text_font_xoff    | The x offset of the font.    | Yes      |
| text_font_yoff    | The y offset of the font.    | Yes      |
| text_color_common | The main color of the font.  | Yes      |
| text_color_error  | The error color of the font. | Yes      |
| text_color_warn   | The warn color of the font.  | Yes      |
| text_color_info   | The info color of the font.  | Yes      |
| text_alpha        | The alpha of the font.       | Yes      |

---

#### EzConsoleSkinBar ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)
Used to define the input bar properties of a skin. Must be as a parameter of `EzConsoleSkin`.

```ts
new EzConsoleSkinBar(bar_height: Number, bar_color: String, bar_color_highlight: String, bar_xpad: Number, bar_ypad: Number, bar_inset: Number) -> EzConsoleSkinBar
```

| Parameter           | Description                                                     | Required |
| ------------------- | --------------------------------------------------------------- | -------- |
| bar_height          | The height of the bar.                                          | Yes      |
| bar_color           | The color of the bar.                                           | Yes      |
| bar_color_highlight | The highlight color of the bar. (Used during type-ahead events) | Yes      |
| bar_xpad            | The x padding of the bar.                                       | Yes      |
| bar_ypad            | The y padding of the bar.                                       | Yes      |
| bar_inset           | The inset of the bar.                                           | Yes      |

---

#### EzConsoleSkinMisc ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)
Used to define the miscellaneous properties of a skin. Must be as a parameter of `EzConsoleSkin`.

```ts
new EzConsoleSkinMisc(text_blink_char: String, text_blink_rate: Number, text_start_char: String, screenfill_color: String, screenfill_alpha: Number, typeahead_text_color: String, typeahead_text_color_highlight: String) -> EzConsoleSkinMisc
```

| Parameter                      | Description                                         | Required | Default value |
| ------------------------------ | --------------------------------------------------- | -------- | ------------- |
| text_blink_char                | The character to use for the blinking cursor.       | No       | "\_"          |
| text_blink_rate                | The speed of the blinking cursor.                   | No       | `1`           |
| text_start_char                | The character to use for the start of the text.     | No       | ">"           |
| screenfill_color               | The color to use for the screen fill.               | No       | `#eeeeee`     |
| screenfill_alpha               | The alpha to use for the screen fill.               | No       | `0.33`        |
| typeahead_text_color           | The color to use for the type-ahead text.           | No       | `#eeeeee`     |
| typeahead_text_color_highlight | The highlight color to use for the type-ahead text. | No       | `#0f0f3c`     |

---

## User Functions
This section contains all the functions that you can use and call on your own GameMaker code to interact with the console.

### ezConsole_log
Log a message to the console as if it was an user input (includes current timestamp).

```ts
ezConsole_log(message: String, no_output: Boolean) -> None
```

| Argument  | Type    | Description                                                      |
| :-------- | :------ | :--------------------------------------------------------------- |
| message   | String  | The message to log.                                              |
| no_output | Boolean | If `true`, the message will not be output to the IDE output tab. |

---

### ezConsole_error
Log an error message to the console.

```ts
ezConsole_error(message: String, no_output: Boolean) -> None
```

| Argument  | Type    | Description                                                      |
| :-------- | :------ | :--------------------------------------------------------------- |
| message   | String  | The message to log.                                              |
| no_output | Boolean | If `true`, the message will not be output to the IDE output tab. |

---

### ezConsole_warn
Log a warning message to the console.

```ts
ezConsole_warn(message: String, no_output: Boolean) -> None
```

| Argument  | Type    | Description                                                      |
| :-------- | :------ | :--------------------------------------------------------------- |
| message   | String  | The message to log.                                              |
| no_output | Boolean | If `true`, the message will not be output to the IDE output tab. |

---

### ezConsole_info
Log an informational message to the console.

```ts
ezConsole_info(message: String, no_output: Boolean) -> None
```

| Argument  | Type    | Description                                                      |
| :-------- | :------ | :--------------------------------------------------------------- |
| message   | String  | The message to log.                                              |
| no_output | Boolean | If `true`, the message will not be output to the IDE output tab. |

---

### ezConsole_is_open ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)
> [!IMPORTANT]
> This function will always return `true` if the console is not in window mode and is visible. If your console is not in window mode, use `ezConsole_is_visible()` instead.

Check if the console is open on console window mode. Returns a boolean.

```ts
ezConsole_is_open() -> Boolean
```

---

### ezConsole_is_visible ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)
Check if the console is visible. Returns a boolean.

```ts
ezConsole_is_visible() -> Boolean
```

---

### ezConsole_set_visible ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)
Set the console to be visible.

```ts
ezConsole_set_visible() -> None
```

---

### ezConsole_set_invisible ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)
> [!IMPORTANT]
>  No console command will not be executed while the console is invisible.

Set the console to be hidden.

```ts
ezConsole_set_invisible() -> None
```

---

## Customization ![](https://img.shields.io/badge/v1.2.0-d2ff00?style=flat)

## Using a theme
> [!NOTE]
> Since version v1.2.0, the console supports themes. You can use a theme by changing the value of the `ezConsole_skin_selected` variable in the `ezConsole_configurations` script for the name of the theme you want to use (see [Features customization](./Getting-Started#features-customization)).

The themes files should be located in the `GM-EzConsole` folder on your `Included Files`.

The following themes are available by default:

- `default-dark.skin`
- `default-light.skin`

---

### Create your own theme (using .skin files) ![](https://img.shields.io/badge/v1.2.0-d2ff00?style=flat)
> [!NOTE]
> Since version 1.2.0, you can create your own theme using a `JSON` struct. To do so, you can create a new file in the `GM-EzConsole` folder with the `.skin` extension.

> [!IMPORTANT]
> Since version 1.3.0, some fields were removed since they are not used anymore. This could cause problems if you are using a theme created for version 1.3+ on version 1.2.0. Please be sure your theme is compatible with the version you are using.

The theme format is very simple, it is just a JSON file with the following structure:

```json
{
  "name": "",
  "author": "",
  "version": "",
  "width": 0,
  "height": 0,
  "anchor": 0,
  "bg_color": "",
  "bg_alpha": 0,
  "text_font": "",
  "text_font_xoff": 0,
  "text_font_yoff": 0,
  "text_color_common": "",
  "text_color_error": "",
  "text_color_warning": "",
  "text_color_info": "",
  "text_alpha": 0,
  "text_blink_char": "",
  "text_blink_rate": 0,
  "text_start_char": "",
  "bar_height": 0,
  "bar_color": "",
  "bar_color_highlight": "",
  "bar_xpad": 0,
  "bar_ypad": 0,
  "blur_amount": 0,
  "screenfill_color": "",
  "screenfill_alpha": 0,
  "typeahead_text_color": "",
  "typeahead_text_color_highlight": ""
}
```

The following table describes the meaning of each field:

| Field                          | Type   | Description                                                                                                                  |
| :----------------------------- | :----- | :--------------------------------------------------------------------------------------------------------------------------- |
| name                           | String | The name of the theme.                                                                                                       |
| author                         | String | The author of the theme.                                                                                                     |
| version                        | String | The version of the theme.                                                                                                    |
| width                          | Number | The width of the console. (If you use a size from 0 to 1 it will use a x% of the window. Ex: 0.50 = 50% of window's width)   |
| height                         | Number | The height of the console. (If you use a size from 0 to 1 it will use a x% of the window. Ex: 0.50 = 50% of window's height) |
| anchor                         | Number | The anchor of the console. (0: Top-Left, 1: Top-Right, 2: Bottom-Left, 3: Bottom-right)                                      |
| bg_color                       | String | The hexadecimal background color of the console. (ex: "#FFFFFF")                                                             |
| bg_alpha                       | Number | The alpha of the background color of the console.                                                                            |
| text_font                      | String | The font of the text in the console. This font should exist on your project with the same name.                              |
| text_font_xoff                 | Number | The horizontal offset of the text in the console.                                                                            |
| text_font_yoff                 | Number | The vertical offset of the text in the console.                                                                              |
| text_color_common              | String | The hexadecimal color of the text in the console. (ex: "#FFFFFF")                                                            |
| text_color_error               | String | The hexadecimal color of the error text in the console. (ex: "#FF0000")                                                      |
| text_color_warning             | String | The hexadecimal color of the warning text in the console. (ex: "#FFFF00")                                                    |
| text_color_info                | String | The hexadecimal color of the info text in the console. (ex: "#00FF00")                                                       |
| text_alpha                     | Number | The alpha of the text in the console.                                                                                        |
| text_blink_char                | String | The character that will blink when the console is waiting for input.                                                         |
| text_blink_rate                | Number | The rate of the blinking character will appear every second.                                                                 |
| text_start_char                | String | The character that will be shown at the start of the console.                                                                |
| bar_height                     | Number | The height of the bar that shows the current command.                                                                        |
| bar_color                      | String | The hexadecimal color of the bar that shows the current command. (ex: "#FFFFFF")                                             |
| bar_color_highlight            | String | The hexadecimal color of the bar that shows the current command when the user selects a typeahead command. (ex: "#FFFFFF")   |
| bar_xpad                       | Number | The horizontal padding of the bar that shows the current command.                                                            |
| bar_ypad                       | Number | The vertical padding of the bar that shows the current command.                                                              |
| blur_amount                    | Number | The amount of the blur effect. (From 0 to 1 recommended.)                                                                    |
| screenfill_color               | String | The hexadecimal color of the screenfill. (ex: "#FFFFFF")                                                                     |
| screenfill_alpha               | Number | The alpha of the screenfill.                                                                                                 |
| typeahead_text_color           | String | The hexadecimal color of the text in the typeahead suggestions. (ex: "#FFFFFF")                                              |
| typeahead_text_color_highlight | String | The hexadecimal color of the text in the typeahead suggestions when highlighted. (ex: "#FFFFFF")                             |

---

### Create your own theme (via code) ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)
> [!IMPORTANT]
> You must create the theme inside the `ezConsole_custom_themes` script.


You can also create your own theme using code. To do so, you can use just a few lines of code. The following code is an example on how to recreate the `default-dark.skin` theme using code:

```js
new EzConsoleSkin(
		new EzConsoleSkinOwnership("default-dark-example", "DAndrëwBox", "1.3"),
		new EzConsoleSkinSize(1, .33, 0),
		new EzConsoleSkinBackground(#07071e, #000000, .66, .0),
		new EzConsoleSkinText(fnt_ezConsole_Smooth, 0, 0, #eeeeee, #ff004d, #ffec27, #8396bc, 1.),
		new EzConsoleSkinBar(16, #0f0f3c, #ffa040, 4, 4),
		new EzConsoleSkinMisc("_", 1, ">", #07071e, .33, #eeeeee, #0f0f3c),
	);
```

The `EzConsoleSkin` object is a helper object that will create a theme for you. It receives the following parameters:

| Parameter  | Type                      | Description                                                                                                                                                                                   |
| :--------- | :------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ownership  | `EzConsoleSkinOwnership`  | The ownership of the theme. It receives the name, author, and version of the theme.                                                                                                           |
| size       | `EzConsoleSkinSize`       | The size of the console. It receives the width, height, and anchor of the console.                                                                                                            |
| background | `EzConsoleSkinBackground` | The background of the console. It receives the color and alpha of the background.                                                                                                             |
| text       | `EzConsoleSkinText`       | The text of the console. It receives the font, x offset, y offset, common color, error color, warning color, info color, and alpha of the text.                                               |
| bar        | `EzConsoleSkinBar`        | The bar of the console. It receives the height, color, highlight color, x padding, and y padding of the bar.                                                                                  |
| misc       | `EzConsoleSkinMisc`       | The miscellaneous of the console. It receives the blink character, blink rate, start character, screenfill color, screenfill alpha, typeahead text color, and typeahead text color highlight. |

The `EzConsoleSkinOwnership`, `EzConsoleSkinSize`, `EzConsoleSkinBackground`, `EzConsoleSkinText`, `EzConsoleSkinBar`, and `EzConsoleSkinMisc` objects are helper objects that will create the theme for you. These constructors are explained in the [constructors](#constructors) reference section.

---

### Change console styles (Not Recommended but possible)
> [!CAUTION]
> Changing the console styles directly is not recommended because it could break the console. If you want to change the console styles, I recommend creating a new theme using the `.skin` file or using the `EzConsoleSkin` object.

The console is very customizable using themes, but if you want to change some properties that are not available in the theme file, you can do so by changing the values of the variables in the `__EzConsole__` object create event.

The following table shows the available style variables:

| Variable                               | Description                                                                                    |
| :------------------------------------- | :--------------------------------------------------------------------------------------------- |
| console_width                          | The width in pixels of the console.                                                            |
| console_height                         | The height in pixels of the console.                                                           |
| console_bg_color                       | The background color of the console.                                                           |
| console_bg_alpha                       | The background alpha of the console.                                                           |
| console_text_font                      | The font of the text in the console.                                                           |
| console_text_font_xoff                 | The x offset of the text in the console.                                                       |
| console_text_font_yoff                 | The y offset of the text in the console.                                                       |
| console_text_alpha                     | The alpha of the text in the console.                                                          |
| console_text_blink_char                | The character that will blink when the console is waiting for input.                           |
| console_bar_height                     | The height in pixels of the bar that shows the current command.                                |
| console_bar_color                      | The color of the bar that shows the current command.                                           |
| console_bar_color_highlight            | The color of the bar that shows the current command when the user selects a typeahead command. |
| console_bar_max_chars                  | The maximum number of characters that can be shown in the bar.                                 |
| console_log_xpad                       | The horizontal padding of the log.                                                             |
| console_log_ypad                       | The vertical padding of the log.                                                               |
| console_blur_amount                    | The amount of blur that will be applied to the game behind the console.                        |
| console_screenfill_color               | The color of the screenfill.                                                                   |
| console_screenfill_alpha               | The alpha of the screenfill.                                                                   |
| console_typeahead_text_color           | The color of the text in the typeahead suggestions.                                            |
| console_typeahead_text_color_highlight | The color of the text in the typeahead suggestions when highlighted.                           |

**I do not recommend changing style variables that are not listed here**, because they are used by the console to work properly.

---

### Change key bindings ![](https://img.shields.io/badge/v1.3.0-ffd200?style=flat)

In the script file named `ezConsole_configurations` you can change the key bindings of the console by changing the values of the macros:

| Variable                    | Description                                                                                      | Default    |
| :-------------------------- | :----------------------------------------------------------------------------------------------- | :--------- |
| ezConsole_key_nav_up        | The key that will move the cursor up in the command history or the typeahead list of commands.   | `vk_up`    |
| ezConsole_key_nav_down      | The key that will move the cursor down in the command history or the typeahead list of commands. | `vk_down`  |
| ezConsole_key_nav_left      | The key that will move the cursor left in the command.                                           | `vk_left`  |
| ezConsole_key_nav_right     | The key that will move the cursor right in the command.                                          | `vk_right` |
| ezConsole_key_toggle        | The key that will toggle the console visibility.                                                 | `vk_f1`    |
| ezConsole_key_auto_complete | They key that will autocomplete the current type-ahead & suggestions                             | `vk_tab`   |
| ezConsole_key_send_line     | The key that will send the current command.                                                      | `vk_enter` |

---