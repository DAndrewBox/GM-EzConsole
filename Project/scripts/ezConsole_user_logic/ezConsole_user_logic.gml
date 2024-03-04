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