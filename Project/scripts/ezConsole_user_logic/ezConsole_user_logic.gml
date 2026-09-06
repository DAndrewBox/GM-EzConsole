/// @func	ezConsole_log(message)
/// @param	{str}	message
/// @desc	Logs a user typed message on the console.
function ezConsole_log(_msg) {
	console_write_log(_msg, EZ_CONSOLE_MSG_TYPE.COMMON);
}

/// @func	ezConsole_warn(message, no_output, clear_input)
/// @param	{str}	message
/// @param	{bool}	no_output
/// @param	{bool}	clear_input
/// @desc	Logs a warning message on the console.
function ezConsole_warn(_msg, _no_output = false, _clear_input = true) {
	console_write_log(_msg, EZ_CONSOLE_MSG_TYPE.WARNING, _clear_input);
	if (!_no_output) {
		show_debug_message($"(EzConsole) WARNING! - {_msg}");
	}
}

/// @func	ezConsole_error(message, no_output, clear_input)
/// @param	{str}	message
/// @param	{bool}	no_output
/// @param	{bool}	clear_input
/// @desc	Logs a error message on the console.
function ezConsole_error(_msg, _no_output = false, _clear_input = true) {
	console_write_log(_msg, EZ_CONSOLE_MSG_TYPE.ERROR, _clear_input);
    
	if (!_no_output) {
		show_debug_message($"(EzConsole) ERROR! - {_msg}");
	}
}

/// @func	ezConsole_info(message, no_output, clear_input)
/// @param	{str}	message
/// @param	{bool}	no_output
/// @param	{bool}	clear_input
/// @desc	Logs a info message on the console.
function ezConsole_info(_msg, _no_output = false, _clear_input = true) {
	console_write_log(_msg, EZ_CONSOLE_MSG_TYPE.INFO, _clear_input);
	if (!_no_output) {
		show_debug_message($"(EzConsole) INFO - {_msg}");
	}
}

/// @func	ezConsole_is_open()
/// @desc	Checks if the console is currently open.
function ezConsole_is_open() {
    var _console = ezConsole;
    if (!_console) return;
        
	return _console && _console.visible && _console.console_window_open;
}

/// @func	ezConsole_is_visible()
/// @desc	Checks if the console is currently visible.
function ezConsole_is_visible() {
    var _console = ezConsole;
    if (!_console) return;
        
	return _console && _console.visible;
}

/// @func 	ezConsole_set_visible()
/// @desc	Sets the console to be visible based on user interaction.
function ezConsole_set_visible() {
    var _console = ezConsole;
    if (!_console) return;
        
	if (keyboard_check_pressed(_console.console_key_toggle)) {
		// Reset console text bar when visible again
		keyboard_lastkey = noone;
		keyboard_string = "";
		_console.console_text_actual = "";
		_console.console_focused = true;
		visible = true;
		
		if (script_exists(ezConsole_callback_onOpen)) {
			script_execute(ezConsole_callback_onOpen);
		}
	}
}

/// @func 	ezConsole_set_invisible()
/// @desc	Sets the console to be invisible based on user interaction.
function ezConsole_set_invisible() {
    var _console = ezConsole;
    if (!_console) return;
    
	_console.visible = false;
	_console.console_focused = false;
	_console.console_resize_active = false;
	console_release_cursor();
    
	if (script_exists(ezConsole_callback_onClose)) {
		script_execute(ezConsole_callback_onClose);
	}
}