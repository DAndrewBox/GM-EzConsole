#region // Base commands
/// @func	console_command_base_message(args)
/// @param	{array}	args
/// @desc	Hide debug overlay
function console_command_base_message(_args) {		
	show_message_async(_args[0]);
}

/// @func	console_command_base_game(args)
/// @param	{array}	args
/// @desc	Execute game actions
function console_command_base_game(_args) {
	switch (_args[0]) {
		case "reset":
			game_restart();
			break;
				
		case "end":
			game_end();
			break;
				
		default:
			var _invalid_param = console_get_message(EZ_CONSOLE_MSG.INVALID_PARAM, "game", array_length(_args), 1, 1) + _args[0] + "\".";
			ezConsole_error(_invalid_param);
			break;
	}	
}

/// @func	console_command_base_fullscreen(args)
/// @param	{array}	args
/// @desc	Hide debug overlay
function console_command_base_fullscreen(_args) {
	var _params_len = array_length(_args);
	if (_params_len == 0) {
		var _is_fullscreen = window_get_fullscreen();
		window_set_fullscreen(!_is_fullscreen);
		ezConsole_warn($"Fullscreen toggled {_is_fullscreen ? "OFF" : "ON"}");
		return;
	}
	
	switch (string_lower(_args[0])) {
		case "0":
		case "false":
			window_set_fullscreen(false);
			ezConsole_warn("Fullscreen toggled OFF.");
			with (ezConsole) {
				console_width	= ezConsole_skin_current[$ "width"] * __original_window_w;
				console_height	= ezConsole_skin_current[$ "height"] * __original_window_h;
			}
			break;
				
		case "1":
		case "true":
			window_set_fullscreen(true);
			ezConsole_warn("Fullscreen toggled ON.");
			with (ezConsole) {
				console_width	= ezConsole_skin_current[$ "width"] * display_get_width();
				console_height	= ezConsole_skin_current[$ "height"] * display_get_height();
			}
			break;
				
		default:
			static _command = "fullscreen";
			var _invalid_param = console_get_message(EZ_CONSOLE_MSG.INVALID_PARAM, _command, _params_len, 1, 1) + _args[0] + "\".";
			ezConsole_error(_invalid_param);
			break;
	}
}

/// @func	console_command_base_help(args)
/// @param	{array}	args
/// @desc	Show help about commands
function console_command_base_help(_args) {
	static _command	= "help";
	var _params_len = array_length(_args);
	
	if (_params_len > 1) {
		// Too much params
		var _too_much_text = console_get_message(EZ_CONSOLE_MSG.TOO_MANY_PARAMS, _command, _params_len, 0, 1);
		ezConsole_info(_too_much_text);
		return -1;
	}
	
	var _console_comands = ezConsole_commands;
	array_sort(_console_comands, function (_elem_a, _elem_b) {
		return (_elem_a.name > _elem_b.name);
	})
	
	if (_params_len == 0) {
		// Show help text
		static _help_header = __ezConsole_dep_string_pad("COMMAND", 20) + __ezConsole_dep_string_pad("ALIAS", 12) + "DESCRIPTION";
		static _help_divider = string_repeat("-", 80);
		static _help_text = console_get_message(EZ_CONSOLE_MSG.HELP_MENU, "help");
		
		ezConsole_warn(_help_text);
		ezConsole_info(_help_header);
		ezConsole_info(_help_divider);
	
		// General help
		var _undefined_commands_detected = false;
		var _console_commands_len = array_length(_console_comands);
		for (var i = 0; i < _console_commands_len; i++) {
			var _com_name = _console_comands[i].name;
			var _com_shrt = _console_comands[i].alias;
			var _com_desc = _console_comands[i].desc;
			
			if (is_undefined(_com_name) || is_undefined(_com_shrt) || is_undefined(_com_desc)) {
				_undefined_commands_detected = true;
				continue;
			}
			
			ezConsole_info(
				__ezConsole_dep_string_pad(_com_name, 20) +
				__ezConsole_dep_string_pad(_com_shrt, 12) +
				_com_desc
			);
		}
		
		if (_undefined_commands_detected) {
			var _undefined_message = console_get_message(EZ_CONSOLE_MSG.UNDEFINED_COMMANDS_FOUND, _command);
			ezConsole_error(_undefined_message);
		}
	} else if (_params_len == 1) {
		// First Checks if command exists
		var _command_exists = false;
		var _commands_len = array_length(_console_comands);
		
		for (var i = 0; i < _commands_len; i++) {
			if (_command_exists) break;

			_command_exists = (
				_console_comands[i].name == _args[0] || _console_comands[i].alias == _args[0]
				? true
				: _command_exists
			);
		}
		
		if !(_command_exists) {
			var _command_doesnt_exists_text = console_get_message(EZ_CONSOLE_MSG.COMMAND_DOESNT_EXISTS, _args[0]);
			ezConsole_error(_command_doesnt_exists_text);
			return -1;
		}
		
		
		// Command help
		var _com_name, _com_shrt, _com_desc, _com_args;
		
		for (var i = 0; i < _commands_len; i++) {
			_com_name = _console_comands[i].name;
			_com_shrt = _console_comands[i].alias;
			
			if (_com_name != _args[0] && _com_shrt != _args[0]) continue;
			
			_com_name = _com_name;
			_com_desc = _console_comands[i].desc;
			_com_args = _console_comands[i].args;			
			
			// Function
			var _com_args_str = "";
			var _com_args_len = array_length(_com_args);
			for (var j = 0; j < _com_args_len; j++) {
				_com_args_str += _com_args[j] + "  ";
			}
			
			ezConsole_warn("> USAGE");
			ezConsole_info(_com_name + "  " + _com_args_str);
			
			if (_com_shrt != "") {
				ezConsole_info(_com_shrt + "  " + _com_args_str);
			}
			
			// Description
			ezConsole_warn("\n> DESCRIPTION");
			ezConsole_info(_com_desc);
			
			// Arguments description
			var _command_args_len = array_length(_com_args);
			if (_command_args_len > 0) {
				ezConsole_warn(__ezConsole_dep_string_pad("\n> ARGUMENTS", 22) + "   " + "DESCRIPTION");
				var _com_args_val = _console_comands[i].args_desc;
				ezConsole_info(__ezConsole_dep_string_pad(_console_comands[0].args[0], 24) + _console_comands[0].args_desc[0]);
			
				for (var j = 0; j < _command_args_len; j++) {
					ezConsole_info(__ezConsole_dep_string_pad(_com_args[j], 24) + _com_args_val[j]);
				}
			}
			
			break;
		}		
	}
}

/// @func	console_command_base_create(args)
/// @param	{array}	args
/// @desc	Creates an instance
function console_command_base_create(_args) {
	var _asset = asset_get_index(_args[0]);
	var _params_len = array_length(_args);
		
	try {
		var _x = ( _params_len > 1 ? real(_args[1]) : mouse_x );
		var _y = ( _params_len > 2 ? real(_args[2]) : mouse_y );
		var _depth = ( _params_len > 3 ? real(_args[3]) : -100 );
	} catch (e) {
		ezConsole_error(e.message);
		return -1;
	}
		
	if (_asset == -1) {
		ezConsole_error("There's no object named \"" + _args[0] + "\"!");
	} else {
		var _inst = instance_create_depth(_x, _y, _depth, _asset);
		ezConsole_info("Instance created with id " + string(_inst.id) + ".");
	}
}

/// @func	console_command_base_instances(args)
/// @param	{array}	args
/// @desc	Get all instances
function console_command_base_instances(_args) {
	var _command	= "instances";
	var _params_len = array_length(_args);
	
	if (_params_len > 1) {
		// Too much params
		var _too_much_text = console_get_message(EZ_CONSOLE_MSG.TOO_MANY_PARAMS, _command, _params_len, 1, 1);
		ezConsole_info(_too_much_text);
	} else if (_params_len == 1) {
		// Get all instances of 1 specific object
		var _asset = asset_get_index(_args[0]);
		
		if (_asset == -1) {
			ezConsole_error("There's no object named \"" + _args[0] + "\"!");
		} else {
			ezConsole_info(
				__ezConsole_dep_string_pad("NAME", 32) +
				__ezConsole_dep_string_pad("ID", 16) +
				__ezConsole_dep_string_pad("POSITION", 16) +
				__ezConsole_dep_string_pad("DEPTH", 8),
			);
			
			var _inst, _name, _id, _pos, _depth;
			var _len = instance_number(_asset);
			for (var i = 0; i < _len; i++) {
				_inst = instance_find(_asset, i);
				_name = __ezConsole_dep_string_pad(_args[0], 32);
				_id	  = __ezConsole_dep_string_pad(string_replace_all(string(_inst.id), "ref instance ", ""), 16);
				_pos  = __ezConsole_dep_string_pad("(" + string(_inst.x) + ", " + string(_inst.y) + ")", 16);
				_depth= __ezConsole_dep_string_pad(string(_inst.depth), 8);
				
				ezConsole_info(_name + _id + _pos + _depth);
			}
		}
	} else if (_params_len == 0) {
		// Get all active instances
		ezConsole_info(
			__ezConsole_dep_string_pad("NAME", 32) +
			__ezConsole_dep_string_pad("ID", 16) +
			__ezConsole_dep_string_pad("POSITION", 16) +
			__ezConsole_dep_string_pad("DEPTH", 8)
		);
							  
		with (all) {
			var _name, _id, _pos, _depth;
			_name = __ezConsole_dep_string_pad(object_get_name(object_index), 32);
			_id	  = __ezConsole_dep_string_pad(string_replace_all(string(id), "ref instance ", ""), 16);
			_pos  = __ezConsole_dep_string_pad("(" + string(x) + ", " + string(y) + ")", 16);
			_depth= __ezConsole_dep_string_pad(string(depth), 8);
			
			ezConsole_info(_name + _id + _pos + _depth);
		}
	}
}

/// @func	console_command_base_instance_set(args)
/// @param	{array}	args
/// @desc	Set a variable in an instance
function console_command_base_instance_set(_args) {
	var _instance_id	= _args[0];
	var _variable_name	= _args[1];
	var _variable_value	= _args[2];
		
	var _inst_to_check = (
		string_digits(_instance_id) == _instance_id
		? _instance_id
		: asset_get_index(_instance_id)
	);

	if (!instance_exists(_inst_to_check) || _inst_to_check == -1) {
		ezConsole_error("Instance " + _instance_id + " doesn't exists");
		return;
	}
		
	if !(variable_instance_exists(_inst_to_check, _variable_name)) {
		ezConsole_error("Variable " + _variable_name + " doesn't exists on instance " + _instance_id);
		return;
	}
		
	var _type_of = typeof(variable_instance_get(_inst_to_check, _variable_name));
	switch(_type_of) {
		case "number":
		case "real":
		case "int32":
		case "int64":
			_variable_value = real(_variable_value);
			break;
	}
		
	variable_instance_set(_inst_to_check, _variable_name, _variable_value);
	ezConsole_info(string("Variable {0} set as {1} on instance {2}.", _variable_name, _variable_value, _instance_id));
}

/// @func	console_command_base_instance_get(args)
/// @param	{array}	args
/// @desc	Gets a variable in an instance
function console_command_base_instance_get(_args) {
	var _instance_id	= _args[0];
	var _variable_name	= array_length(_args) > 1 ? _args[1] : "";
		
	var _inst_to_check = (
		string_digits(_instance_id) == _instance_id
		? _instance_id
		: asset_get_index(_instance_id)
	);

	if (!instance_exists(_inst_to_check) || _inst_to_check == -1) {
		ezConsole_error($"Instance {_instance_id} doesn't exists");
		return;
	}
		
	if (_variable_name != "") {
		if !(variable_instance_exists(_inst_to_check, _variable_name)) {
			ezConsole_error($"Variable {_variable_name} doesn't exists on instance {_instance_id}");
			return;
		}
			
		ezConsole_info(
			__ezConsole_dep_string_pad("VARIABLE NAME", 32) +
			"VALUE"
		);
			
		var _variable_value = variable_instance_get(_inst_to_check, _variable_name);
		ezConsole_info(
			__ezConsole_dep_string_pad(_variable_name, 32) +
			__ezConsole_dep_value_to_string(_variable_value)
		);
		return;
	}
		
	var _variable_names = variable_instance_get_names(_inst_to_check);
	array_sort(_variable_names, true);
	ezConsole_info(
		__ezConsole_dep_string_pad("VARIABLE NAME", 32) +
		"VALUE"
	);
	
	var _variable_names_len = array_length(_variable_names);
	for (var i = 0; i < _variable_names_len; i++) {
		var _variable_value = variable_instance_get(_inst_to_check, _variable_names[i]);
		ezConsole_info(
			__ezConsole_dep_string_pad(_variable_names[i], 32) +
			__ezConsole_dep_value_to_string(_variable_value)
		);
	}
}

/// @func	console_command_base_instance_delete(args)
/// @param	{array}	args
/// @desc	Delete an instance
function console_command_base_instance_delete(_args) {
	var _instance_id	= _args[0];
	var _exec_ev		= ( array_length(_args) > 1 ? _args[1] : "1" );
	
	_instance_id = array_last(string_split(_instance_id, ":"));
	
	if (_instance_id == "") {
		ezConsole_error("Instance id not valid doesn't exists");
	}
		
	var _inst_to_check = (
		string_digits(_instance_id) == _instance_id
		? _instance_id
		: asset_get_index(_instance_id)
	);

	if (_inst_to_check.object_index == __EzConsole__) {
		ezConsole_error("The ezConsole instance cannot be deleted!");
		return;
	}

	if (!instance_exists(_inst_to_check) || _inst_to_check == -1) {
		ezConsole_error("Instance " + _instance_id + " doesn't exists");
		return;
	}
		
	instance_destroy(_inst_to_check, _exec_ev == "1" || _exec_ev == "true");
	ezConsole_info($"Instance \"{_instance_id}\" destroyed.");
}

/// @func	console_command_base_clear(args)
/// @param	{array}	args
/// @desc	Clears console log
function console_command_base_clear(_args) {
	with (ezConsole) {
		ds_list_clear(console_text_log);
		console_log_total_h = 0;
		console_nav_scroll = 0;
		console_surf_yoffset = 0;
		console_surf_yoffset_to = 0;
	}
		
	var _init_message = console_get_message(EZ_CONSOLE_MSG.INTIALIZATION, "");
	console_write_log(_init_message, EZ_CONSOLE_MSG_TYPE.WARNING);
}

/// @func	console_command_base_fps(args)
/// @param	{array}	args
/// @desc	Toggle or set and set FPS on screen
function console_command_base_fps(_args) {
	var _args_len = array_length(_args);
	if (_args_len == 0) {
		ezConsole.console_fps_show = !ezConsole.console_fps_show;
		ezConsole_warn(
			$"FPS are now {( ezConsole.console_fps_show ? "visible" : "invisible" )}!"
		);
		return;
	}
	
	switch (_args[0]) {
		case "0":
		case "false":
			ezConsole.console_fps_show = false;
			ezConsole_warn("FPS are now invisible!");
			break;
					
		case "1":
		case "true":
			ezConsole.console_fps_show = true;
			ezConsole_warn("FPS are now visible!");
			break;
					
		default:
			var _invalid_param = console_get_message(EZ_CONSOLE_MSG.INVALID_PARAM, "fps", _args_len, 1, 1) + _args[1] + "\".";
			ezConsole_error(_invalid_param);
	}
}

/// @func	console_command_base_debug_overlay(args)
/// @param	{array}	args
/// @desc	Toggle or set and set debug overlay on screen
function console_command_base_debug_overlay(_args) {
	if (array_length(_args) == 0) {
		ezConsole.console_debug_overlay_show = !ezConsole.console_debug_overlay_show;
		show_debug_overlay(ezConsole.console_debug_overlay_show);
		ezConsole_warn(string("Debug overlay is now {0}!", ( ezConsole.console_debug_overlay_show ? "visible" : "invisible" )));
	} else {
		switch (_args[0]) {
			case "0":
			case "false":
				ezConsole.console_debug_overlay_show = false;
				ezConsole_warn("Debug overlay is now invisible!");
				break;
					
			case "1":
			case "true":
				ezConsole.console_debug_overlay_show = true;
				ezConsole_warn("Debug overlay is now visible!");
				break;
					
			default:
				var _invalid_param = console_get_message(EZ_CONSOLE_MSG.INVALID_PARAM, "debug_view", array_length(_args), 1, 1) + _args[0] + "\".";
				ezConsole_error(_invalid_param);
		}
	}
}

/// @func	console_command_base_goto(args)
/// @param	{array}	args
/// @desc	Toggle or set and set debug overlay on screen
function console_command_base_goto(_args) {
	room_goto(asset_get_index(_args[0]));
}

/// @func	console_command_base_skin(args)
/// @param	{array}	args
/// @desc	Toggle or set and set debug overlay on screen
function console_command_base_skin(_args) {
	var _args_len = array_length(_args);
	
	switch (_args[0]) {
		case "set":
			var _current_skin = struct_get(ezConsole_skin_list, ezConsole_skin_selected);
			
			if (_args_len < 3) {
				var _msg = console_get_message(EZ_CONSOLE_MSG.NOT_ENOUGH_PARAMS, "skin set", _args_len, 3, 3);
				console_write_log(_msg, EZ_CONSOLE_MSG_TYPE.ERROR);
				return;
			}
			
			if (!array_contains(console_get_skin_prop_names(), _args[1])) {
				console_write_log($"Prop \"{_args[1]}\" doesn't exists!", EZ_CONSOLE_MSG_TYPE.ERROR);
				return;
			}
			
			console_skin_set_prop(_args[1], _args[2]);
			console_write_log($"New value for prop \"{_args[1]}\": {_args[2]}", EZ_CONSOLE_MSG_TYPE.INFO);
			with (ezConsole) {
				event_user(1);
			}
			break;
					
		case "get":
			var _current_skin = struct_get(ezConsole_skin_list, ezConsole_skin_selected);
			
			if (_args_len == 1) {
				var _json_str = _current_skin.toJSON();
				clipboard_set_text(_json_str);
				console_write_log("Console skin JSON copied to clipboard!", EZ_CONSOLE_MSG_TYPE.INFO);
			} else if (_args_len == 2) {
				var _current_param = struct_get(_current_skin, _args[1]);
				if (!is_undefined(_current_param)) {
					var _param_is_color = string_pos("color", _args[1]);
					console_write_log($"{_args[1]}: {_param_is_color ? __ezConsole_dep_dec_to_hex(_current_param) : _current_param}", EZ_CONSOLE_MSG_TYPE.INFO);
					return;
				}
				console_write_log($"Prop \"{_args[1]}\" doesn't exists!", EZ_CONSOLE_MSG_TYPE.ERROR);
			} else {
				var _msg = console_get_message(EZ_CONSOLE_MSG.TOO_MANY_PARAMS, "skin get", _args_len, 1, 2);
				console_write_log(_msg, EZ_CONSOLE_MSG_TYPE.ERROR);
			}
			break;
					
		default:
			var _invalid_param = console_get_message(EZ_CONSOLE_MSG.INVALID_PARAM, "skin", _args_len, 1, 1) + _args[0] + "\".";
			console_write_log(_invalid_param, EZ_CONSOLE_MSG_TYPE.ERROR);
	}
}
#endregion