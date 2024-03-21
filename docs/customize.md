## Using a theme

> [!NOTE]
> Since version v1.2.0, the console supports themes. You can use a theme by changing the value of the `ezConsole_skin_selected` variable in the `ezConsole_configurations` script for the name of the theme you want to use (see [Features customization](./Getting-Started#features-customization)).

The themes files should be located in the `GM-EzConsole` folder on your `Included Files`.

The following themes are available by default:

- `default-dark.skin`
- `default-light.skin`

---

## Create your own theme (using .skin files)

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
| name                           | string | The name of the theme.                                                                                                       |
| author                         | string | The author of the theme.                                                                                                     |
| version                        | string | The version of the theme.                                                                                                    |
| width                          | number | The width of the console. (If you use a size from 0 to 1 it will use a x% of the window. Ex: 0.50 = 50% of window's width)   |
| height                         | number | The height of the console. (If you use a size from 0 to 1 it will use a x% of the window. Ex: 0.50 = 50% of window's height) |
| anchor                         | number | The anchor of the console. (0: Top-Left, 1: Top-Right, 2: Bottom-Left, 3: Bottom-right)                                      |
| bg_color                       | string | The hexadecimal background color of the console. (ex: "#FFFFFF")                                                             |
| bg_alpha                       | number | The alpha of the background color of the console.                                                                            |
| text_font                      | string | The font of the text in the console. This font should exist on your project with the same name.                              |
| text_font_xoff                 | number | The horizontal offset of the text in the console.                                                                            |
| text_font_yoff                 | number | The vertical offset of the text in the console.                                                                              |
| text_color_common              | string | The hexadecimal color of the text in the console. (ex: "#FFFFFF")                                                            |
| text_color_error               | string | The hexadecimal color of the error text in the console. (ex: "#FF0000")                                                      |
| text_color_warning             | string | The hexadecimal color of the warning text in the console. (ex: "#FFFF00")                                                    |
| text_color_info                | string | The hexadecimal color of the info text in the console. (ex: "#00FF00")                                                       |
| text_alpha                     | number | The alpha of the text in the console.                                                                                        |
| text_blink_char                | string | The character that will blink when the console is waiting for input.                                                         |
| text_blink_rate                | number | The rate of the blinking character will appear every second.                                                                 |
| text_start_char                | string | The character that will be shown at the start of the console.                                                                |
| bar_height                     | number | The height of the bar that shows the current command.                                                                        |
| bar_color                      | string | The hexadecimal color of the bar that shows the current command. (ex: "#FFFFFF")                                             |
| bar_color_highlight            | string | The hexadecimal color of the bar that shows the current command when the user selects a typeahead command. (ex: "#FFFFFF")   |
| bar_xpad                       | number | The horizontal padding of the bar that shows the current command.                                                            |
| bar_ypad                       | number | The vertical padding of the bar that shows the current command.                                                              |
| blur_amount                    | number | The amount of the blur effect. (From 0 to 1 recommended.)                                                                    |
| screenfill_color               | string | The hexadecimal color of the screenfill. (ex: "#FFFFFF")                                                                     |
| screenfill_alpha               | number | The alpha of the screenfill.                                                                                                 |
| typeahead_text_color           | string | The hexadecimal color of the text in the typeahead suggestions. (ex: "#FFFFFF")                                              |
| typeahead_text_color_highlight | string | The hexadecimal color of the text in the typeahead suggestions when highlighted. (ex: "#FFFFFF")                             |

---

## Create your own theme (via code)

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

The `EzConsoleSkinOwnership`, `EzConsoleSkinSize`, `EzConsoleSkinBackground`, `EzConsoleSkinText`, `EzConsoleSkinBar`, and `EzConsoleSkinMisc` objects are helper objects that will create the theme for you. These constructors are explained in the [Constructors](./Constructors) reference section.

---

## Change console styles (Not Recommended but possible)

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

## Change key bindings

In the create event of the `__EzConsole__` object you can change the key bindings of the console by changing the values of the variables:

| Variable              | Description                                                                                      | Default    |
| :-------------------- | :----------------------------------------------------------------------------------------------- | :--------- |
| console_key_nav_up    | The key that will move the cursor up in the command history or the typeahead list of commands.   | `vk_up`    |
| console_key_nav_down  | The key that will move the cursor down in the command history or the typeahead list of commands. | `vk_down`  |
| console_key_nav_left  | The key that will move the cursor left in the command.                                           | `vk_left`  |
| console_key_nav_right | The key that will move the cursor right in the command.                                          | `vk_right` |

The default key binding to autocomplete suggestions or typeahead commands is `vk_tab` and cannot be changed easily because it could break a lot of things. Sorry :(

---
