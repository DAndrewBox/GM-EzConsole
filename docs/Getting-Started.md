# 🚀 Getting Started

## 📖 Table of Contents

- [🔧 Versioning & Compatibility](#🔧-versioning--compatibility)
- [🌱 Installation](#🌱-installation)
- [🆕 Setting up on a new project](#🆕-setting-up-on-a-new-project)
- [🧰 Setting up on an existing project](#🧰-setting-up-on-an-existing-project)
- [⚙️ Features customization](#️-features-customization)

---

### 🔧 Versioning and Compatibility

Any of the releases of this extension are compatible with GameMaker Studio from versions 2.3 to 2022.11 (Including 2022.x LTS). But the table below shows the compatibility of each release.

✅: Fully compatible. (\*: Recommended for this version.)

⚠️: Compatible but could have some compatibility issues with the new features of the version.

❌: Not compatible.

| GameMaker Version | GM-EzConsole v1.0.0 | GM-EzConsole v1.1.0 | GM-EzConsole v1.2.x | GM-EzConsole v1.3.x |
| ----------------: | :-----------------: | :-----------------: | :-----------------: | :-----------------: |
|      Studio 1.4.x |          ❌          |          ❌          |          ❌          |          ❌          |
|    Studio 2 - 2.2 |          ❌          |          ❌          |          ❌          |          ❌          |
|      Studio 2.3.x |         ✅\*         |          ❌          |          ❌          |          ❌          |
|   2022.1 - 2022.9 |         ✅\*         |          ❌          |          ❌          |          ❌          |
|        2022.x LTS |         ✅\*         |          ⚠️          |          ❌          |          ❌          |
|           2022.11 |          ⚠️          |          ✅          |         ✅\*         |          ⚠️          |
|            2023.1 |          ⚠️          |          ✅          |         ✅\*         |          ⚠️          |
|           2024.2+ |          ⚠️          |          ✅          |          ✅          |         ✅\*         |

---

## 🌱 Installation

1. Download the latest release from the [releases page](https://github.com/DAndrewBox/GM-EzConsole/releases). **(Be sure you are downloading the correct version for your GameMaker version. Check the compatible versions in the [home page](https://github.com/DAndrewBox/GM-EzConsole/wiki).)**

2. (A) Import the contents into your project just draggin the `GM-EzConsole-[version].yymps` file into it.

3. (B) You can also import it into your project using the top toolbar on Tools > Import Local Package > Select the `GM-EzConsole-[version].yymps` file.

4. A window should appear asking you to select the resources you want to import.

5. Select the `GML-EzConsole` folder, press `Add All`, and then click `Import`.

<p style="text-align: center;">
  <img src="https://i.imgur.com/MvnB1mG.png" width="75%"/>
</p>

6. You can now use the extension in your project!

---

## 🆕 Setting up on a new project

To setup the extension on a new project, you shouldn't need to do anything special.

Just import the extension and you should be good to go. :)

---

## 🧰 Setting up on an existing project

> [!IMPORTANT]
> If you already installed this extension before and have custom commands callbacks or functions on the `ezConsole_custom_commands` script, **you should not import the `ezConsole_custom_commands` on step 1**.

If you want to set up the extension on an existing project, you can do so by following these steps:

1. Import the extension into your project. (See [Installation](#installation))
2. Make sure you have the `GM-EzConsole` folder in your project.
3. Make sure you have the `__EzConsole__` object in your `EzConsole\Objects` folder.
4. Make sure you have the `GM-EzConsole` folder, and the following files: `default_commands.json`, `default-dark.skin` and `default-light.skin` files
   in your `Included Files` folder (or try to find it on your `datafiles` project folder).
5. If you have the `ezConsole_autocreate` flag deactivated (see [Features customization](#features-customization)), then place the `__EzConsole__` object in the first room of your project.
6. Run your project and press `F1` _(by default)_ to open the console.
7. If you can see the console window, you're good to go.

---

## ⚙️ Features customization

You can customize some of the features of the console on the `ezConsole_configurations` script.

The following table shows the available configurations and their default values:

| Configuration                         | Description                                                                                 | Default value               |
| :------------------------------------ | ------------------------------------------------------------------------------------------- | --------------------------- |
| `ezConsole_files`                     | An array with the filenames of the files with custom commands to import.                    | `["default_commands.json"]` |
| `ezConsole_skin_selected`             | The skin to use for the console.                                                            | `"default-dark.skin"`       |
| `ezConsole_debug_only`                | If `true`, the console will only be available on debug mode.                                | `false`                     |
| `ezConsole_callback_onOpen`           | The function to call when the console is opened.                                            | `noone`                     |
| `ezConsole_callback_onClose`          | The function to call when the console is closed.                                            | `noone`                     |
| `ezConsole_callback_onLog`            | The function to call when a log is added to the console.                                    | `noone`                     |
| `ezConsole_callback_onDestroy`        | The function to call when the console is destroyed.                                         | `noone`                     |
| `ezConsole_callback_onGameEnd`        | The function to call when the game ends.                                                    | `console_save_log_to_file`  |
| `ezConsole_enable_blur`               | If `true`, the game will be blurred behind the console when is opened. (Will use more GPU)  | `true`                      |
| `ezConsole_enable_suggestions`        | If `true`, the console will show suggestions in the console bar for the commands.           | `true`                      |
| `ezConsole_enable_typeahead`          | If `true`, the console will show type-ahead suggestions for the commands.                   | `true`                      |
| `ezConsole_enable_screenfill`         | If `true`, the console will fill the entire screen with a color when the console is opened. | `true`                      |
| `ezConsole_enable_typeahead_icons`    | If `true`, the console will show icons for the type-ahead suggestions.                      | `true`                      |
| `ezConsole_enable_typeahead_inst_ref` | If `true`, the console will show instance reference index for the type-ahead suggestions.   | `true`                      |
| `ezConsole_prop_depth`                | The depth of the console.                                                                   | `-10000`                    |
| `ezConsole_prop_start_open`           | If `true`, the console will start opened.                                                   | `true`                      |
| `ezConsole_prop_typeahead_elements`   | The max number of elements to show on the type-ahead suggestions.                           | `20`                        |
| `ezConsole_prop_nav_scroll_speed`     | The speed of the scroll when navigating through the console.                                | `1`                         |
| `ezConsole_prop_blur_quality`         | The quality of the blur effect. (1: Worse quality less GPU, 4: Best quality more GPU)       | `3`                         |
| `ezConsole_prop_blur_multiplier`      | The multiplier of the blur effect.                                                          | `2.5`                       |
| `ezConsole_autocreate`                | If `true`, the console will be created automatically when the game starts.                  | `true`                      |
| `ezConsole_key_toggle`                | The key to toggle the console.                                                              | `vk_f1`                     |
| `ezConsole_key_nav_up`                | The key to navigate up in the console.                                                      | `vk_up`                     |
| `ezConsole_key_nav_down`              | The key to navigate down in the console.                                                    | `vk_down`                   |
| `ezConsole_key_nav_left`              | The key to move the console cursor left.                                                    | `vk_left`                   |
| `ezConsole_key_nav_right`             | The key to move the console cursor right.                                                   | `vk_right`                  |
| `ezConsole_key_auto_complete`         | The key to auto-complete the command in the console.                                        | `vk_tab`                    |
| `ezConsole_key_send_line`             | The key to submit the command in the console.                                               | `vk_enter`                  |

---
