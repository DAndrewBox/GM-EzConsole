/// @func	ezConsole_log(message)
/// @param	{str}	message
/// @desc	Logs a user typed message on the console.
function ezConsole_log(_msg) {
	console_write_log(_msg, EZ_CONSOLE_MSG_TYPE.COMMON);
}

/// @func	ezConsole_warn(message)
/// @param	{str}	message
/// @desc	Logs a warning message on the console.
function ezConsole_warn(_msg) {
	console_write_log(_msg, EZ_CONSOLE_MSG_TYPE.WARNING);
	show_debug_message($"(EzConsole) WARNING! - {_msg}");
}

/// @func	ezConsole_error(message)
/// @param	{str}	message
/// @desc	Logs a error message on the console.
function ezConsole_error(_msg) {
	console_write_log(_msg, EZ_CONSOLE_MSG_TYPE.ERROR);
	show_debug_message($"(EzConsole) ERROR! - {_msg}");
}

/// @func	ezConsole_info(message)
/// @param	{str}	message
/// @desc	Logs a info message on the console.
function ezConsole_info(_msg) {
	console_write_log(_msg, EZ_CONSOLE_MSG_TYPE.INFO);
	show_debug_message($"(EzConsole) INFO - {_msg}");
}

/// @func	ezConsole_is_open()
/// @desc	Checks if the console is currently open.
function ezConsole_is_open() {
	return ezConsole && ezConsole.visible && ezConsole.console_window_open;
}

/// @func	ezConsole_is_visible()
/// @desc	Checks if the console is currently visible.
function ezConsole_is_visible() {
	return ezConsole && ezConsole.visible;
}

/// @func 	ezConsole_set_visible()
/// @desc	Sets the console to be visible based on user interaction.
function ezConsole_set_visible() {
	if (!ezConsole) return;
	if (keyboard_check_pressed(ezConsole.console_key_toggle)) {
		// Reset console text bar when visible again
		keyboard_lastkey = noone;
		keyboard_string = "";
		ezConsole.console_text_actual = "";
		visible = true;
		if (ezConsole.console_callback_on_open) ezConsole.console_callback_on_open();
	}
}

/// @func 	ezConsole_set_invisible()
/// @desc	Sets the console to be invisible based on user interaction.
function ezConsole_set_invisible() {
	if (!ezConsole) return;
	ezConsole.visible = false;
	if (ezConsole.console_callback_on_close) ezConsole.console_callback_on_close();
}