#region // GET
/// @function console_get_commands()
function console_get_commands() {
	var _commands = [];
	for (var i = 1; i < array_length(global.__debug_console_commands); i++) {
		array_push(_commands, global.__debug_console_commands[i])
	}
	
	return _commands;
}

/// @function console_get_message(message_type, command, params_count, min_params, max_params)
/// @param	{real}		message_type
/// @param	{string}	command
/// @param	{real}		params_count
/// @param	{real}		min_params
/// @param	{real}		max_params
function console_get_message(_type, _command, _params_count=0, _min_params=0, _max_params=1) {
	switch (_type) {
		case EZ_CONSOLE_MSG.NOT_ENOUGH_PARAMS:
			return ("\"" + _command + "\" must to recieve at least " +
					string(_min_params) + " argument(s).\n(" + string(_params_count) + " were given)");
		
		case EZ_CONSOLE_MSG.TOO_MUCH_PARAMS:
			return ("\"" + _command + "\" must to recieve " +
					string(_max_params) + " argument(s).\n(" + string(_params_count) + " were given)");
			
		case EZ_CONSOLE_MSG.NOT_A_COMMAND:
			return ("\"" + _command + "\" is not a command.");
			
		case EZ_CONSOLE_MSG.INVALID_PARAM:
			return ("Command \"" + _command + "\" has no param \"");
			
		case EZ_CONSOLE_MSG.HELP_MENU:
			return ("Type \"help <command>\" to get more information about the command.");
			
		case EZ_CONSOLE_MSG.COMMAND_DOESNT_EXISTS:
			return ("Command \"" + _command + "\" does not exists.");
			
		case EZ_CONSOLE_MSG.INTIALIZATION:
			return ("=== GM Ez Console v1.1 ===\nType \"help\" to start.");
	}
}

/// @function console_get_type_color(type)
/// @param	{real}	type
/// @desc	Get message colour
function console_get_type_color(_type) {
	switch (_type) {
		default:
		case EZ_CONSOLE_MSG_TYPE.COMMON:	return #EEEEEE;
		case EZ_CONSOLE_MSG_TYPE.ERROR:		return #ff004d;
		case EZ_CONSOLE_MSG_TYPE.WARNING:	return #ffec27;
		case EZ_CONSOLE_MSG_TYPE.INFO:		return #8396Bc;
	}
}

/// @function console_get_timestamp(time)
/// @param	{real}	time
function console_get_timestamp(_t) {
	var _hh, _mm, _ss;
	_hh = string_replace(string_format(date_get_hour(_t), 2, 0), " ", "0");
	_mm = string_replace(string_format(date_get_minute(_t), 2, 0), " ", "0");
	_ss = string_replace(string_format(date_get_second(_t), 2, 0), " ", "0");
	
	return "<" + _hh + ":" + _mm + ":" + _ss + "> ";
}

/// @function console_get_suggestion(message)
/// @param	{string}	message
function console_get_suggestion(_msg) {
	var _msg_trimmed	= string_split(_msg, " ");
	var _is_command		= array_length(_msg_trimmed) < 2;
	var _suggestion		= "";
	var _commands		= console_get_commands();
	var _commands_len	= array_length(_commands);
	
	if (_is_command) {
		var _command  = "";
		var _msg_len  = string_length(_msg_trimmed[0]);
		for (var i = 0; i < _commands_len; i++) {
			_command = _commands[i].name;
			if (_msg_trimmed[0] == string_copy(_command, 1, _msg_len)) {
				var _command_len = string_length(_command);
				_suggestion = string_copy(_command, _msg_len + 1, _command_len - _msg_len);
			}
		}
	} else {
		var _prev_word_is_command = false;
		var _command = _commands[0];
		for (var i = 0; i < _commands_len; i++) {
			if (_msg_trimmed[0] == _commands[i].name) {
				_command = _commands[i];
				_prev_word_is_command = true;
				break;
			}
		}
		
		if (_prev_word_is_command) {
			show_debug_message(_msg_trimmed);
			var _msg_trimmed_len = array_length(_msg_trimmed) - 1;
			var _command_args_len = array_length(_command.args) - 1;
			
			for (var i = _msg_trimmed_len - 1; i <= _command_args_len; i++) {
				if (_msg_trimmed_len >= i + 1 && string_length(_msg_trimmed[i + 1]) >= 1) continue;
				_suggestion += (i == _msg_trimmed_len - 1 ? "" : " ") + _command.args[i];
			}
		}
	}
	
	return _suggestion;
}
#endregion

#region // ADD
/// @function	console_add_command(command)
/// @param	{any}	command
function console_add_command(_cmd) {
	array_push(global.__debug_console_commands, _cmd);
}

/// @function	console_add_commands_from_file(filepath)
/// @param	{str}	filepath
function console_add_commands_from_file(_path) {
	var _file = file_text_open_read(_path);
	var _json = file_to_json(_file);
	
	for (var i = 0; i < array_length(_json); i++) {
		var _cmd = _json[i];
		_cmd.callback = asset_get_index(_cmd.callback);
		console_add_command(_cmd);
	}
	
	file_text_close(_file);
}
#endregion

#region // Write on console log logic
/// @function ConsoleLog(message, [type])
/// @param	{string}	message
/// @param	{real}		[type]
function ConsoleLog(_msg, _type = EZ_CONSOLE_MSG_TYPE.COMMON) constructor {
	message		= _msg;
	type		= _type;
	color		= console_get_type_color(type);
	time		= date_current_datetime();
	timestamp	= console_get_timestamp(time);
}

/// @function console_write_log(message, [type])
/// @param	{string}	message
/// @param	{real}		[type]
function console_write_log(_msg, _type = EZ_CONSOLE_MSG_TYPE.COMMON) {
	with (__debug_console__) {
		if (console_callback_on_log) console_callback_on_log();
		var _new_msg = new ConsoleLog(_msg, _type);
		ds_list_add(console_text_log, _new_msg);
	
		keyboard_string = "";
		console_text_actual = "";
		console_nav = ds_list_size(console_text_log);
		event_user(0);
	}
}
#endregion

/// @function console_set_visible()
function console_set_visible() {
	if (keyboard_check_pressed(console_key_toggle)) {
		// Reset console text bar when visible again
		keyboard_lastkey = noone;
		keyboard_string = "";
		console_text_actual = "";
		visible = true;
		if (console_callback_on_open) console_callback_on_open();
	}
}

/// @function console_set_invisible()
function console_set_invisible() {
	visible = false;
	if (console_callback_on_close) console_callback_on_close();
}

/// @function console_check_command(message)
/// @param	{string}	message
function console_check_command(_msg) {
	var _msg_array	= string_split(_msg, " ");
	var _command	= _msg_array[0];
	var _params		= [];
	array_copy(_params, 0, _msg_array, 1, array_length(_msg_array) - 1);
	
	console_write_log(console_text_actual);
	
	var _commands = console_get_commands();
	for (var i = 0; i < array_length(_commands); i++) {
		if (_commands[i].name == _command || (_commands[i].short == _command && _commands[i].short != "-")) {
			_commands[i].callback(_params);
			return -1;
		}
	}
	
	var _not_found_text = console_get_message(EZ_CONSOLE_MSG.NOT_A_COMMAND, _command);
	console_write_log(_not_found_text, EZ_CONSOLE_MSG_TYPE.INFO);
}
	
/// @function console_save_log_to_file()
function console_save_log_to_file() {
	var _logs = console_text_log;
	var _msg, _time, _file;	
	_file = file_text_open_write("ezConsole_logs_{0}.txt");
	
	for (var i = 0; i < ds_list_size(_logs); i++) {
		_time = _logs[| i].timestamp;
		_msg = _logs[| i].message;
		file_text_write_string(_file, _time + " " + _msg + "\n");
	}
	
	file_text_close(_file);
}