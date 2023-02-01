#region // Base commands
/// @function console_command_message(args)
/// @param	{array}	args
/// @desc	Hide debug overlay
function console_command_message(_args) {
	var _command	= "message";
	var _params_len = array_length(_args);
	var _min_params = 1;
	var _max_params = 99;
	
	if (console_check_params_count(_command, _params_len, _min_params, _max_params)) {
		var _msg = "";
		for (var i = 0; i < _params_len; i++) {
			_msg += _args[i] + (i == _params_len - 1 ? "" : " ");
		}
		
		show_message(_msg);
	}
}

/// @function console_command_game(args)
/// @param	{array}	args
/// @desc	Execute game actions
function console_command_game(_args) {
	var _command	= "game";
	var _params_len = array_length(_args);
	var _min_params = 1;
	var _max_params = 99;
	
	if (console_check_params_count(_command, _params_len, _min_params, _max_params)) {
		switch (_args[0]) {
			case "restart":
			case "reset":
				game_restart();
				break;
				
			case "end":
				game_end();
				break;
				
			default:
				var _invalid_param = console_get_message(EZ_CONSOLE_MSG.INVALID_PARAM, _command, _params_len, 1, 1) + _args[0] + "\".";
				console_write_log(_invalid_param, EZ_CONSOLE_MSG_TYPE.ERROR);
				break;
		}	
	}
}

/// @function console_command_fullscreen(args)
/// @param	{array}	args
/// @desc	Hide debug overlay
function console_command_fullscreen(_args) {
	var _command	= "fullscreen";
	var _params_len = array_length(_args);
	var _min_params = 1;
	var _max_params = 1;
	
	if (console_check_params_count(_command, _params_len, _min_params, _max_params)) {
		switch (string_lower(_args[0])) {
			case "0":
			case "false":
				window_set_fullscreen(false);
				console_write_log("Fullscreen toggled OFF.", EZ_CONSOLE_MSG_TYPE.WARNING);
				with (__EzConsole__) {
					console_width	= ezConsole_skin[$ "width"] * __original_window_w;
					console_height	= ezConsole_skin[$ "height"] * __original_window_h;
				}
				break;
				
			case "1":
			case "true":
				window_set_fullscreen(true);
				console_write_log("Fullscreen toggled ON.", EZ_CONSOLE_MSG_TYPE.WARNING);
				with (__EzConsole__) {
					console_width	= ezConsole_skin[$ "width"] * display_get_width();
					console_height	= ezConsole_skin[$ "height"] * display_get_height();
				}
				break;
				
			default:
				var _invalid_param = console_get_message(EZ_CONSOLE_MSG.INVALID_PARAM, _command, _params_len, 1, 1) + _args[0] + "\".";
				console_write_log(_invalid_param, EZ_CONSOLE_MSG_TYPE.ERROR);
				break;
		}	
	}
}

/// @function console_command_help(args)
/// @param	{array}	args
/// @desc	Show help about commands
function console_command_help(_args) {
	var _command	= "help";
	var _params_len = array_length(_args);
	
	if (_params_len > 1) {
		// Too much params
		var _too_much_text = console_get_message(EZ_CONSOLE_MSG.TOO_MANY_PARAMS, _command, _params_len, 0, 1);
		console_write_log(_too_much_text, EZ_CONSOLE_MSG_TYPE.INFO);
		return -1;
	}
	
	var _console_comands = ezConsole_commands;
	
	if (_params_len == 0) {
		// Show help text
		var _help_text = console_get_message(EZ_CONSOLE_MSG.HELP_MENU, _command);
		console_write_log(_help_text, EZ_CONSOLE_MSG_TYPE.INFO);
		
	
		// General help
		for (var i = 0; i < array_length(_console_comands); i++) {
			var _com_name = _console_comands[i].name;
			var _com_shrt = _console_comands[i].short;
			var _com_desc = _console_comands[i].desc;
			
			console_write_log(__ezConsole_dep_string_pad(_com_name, 12) + __ezConsole_dep_string_pad(_com_shrt, 8) + _com_desc, EZ_CONSOLE_MSG_TYPE.INFO);
		}
	} else if (_params_len == 1) {
		// First Checks if command exists
		var _command_exists = false;
		
		for (var i = 0; i < array_length(_console_comands); i++) {
			_command_exists = ( _console_comands[i].name == _args[0] || _console_comands[i].short == _args[0]
								? true
								: _command_exists );
		}
		
		if !(_command_exists) {
			var _command_doesnt_exists_text = console_get_message(EZ_CONSOLE_MSG.COMMAND_DOESNT_EXISTS, _args[0]);
			console_write_log(_command_doesnt_exists_text, EZ_CONSOLE_MSG_TYPE.ERROR);
			return -1;
		}
		
		
		// Command help
		var _com_name, _com_shrt, _com_desc, _com_args;
		
		for (var i = 0; i < array_length(_console_comands); i++) {
			_com_name = _console_comands[i].name;
			_com_shrt = _console_comands[i].short;
			
			if (_com_name != _args[0] && _com_shrt != _args[0]) { continue; }
			
			_com_name = _com_name;
			_com_desc = _console_comands[i].desc;
			_com_args = _console_comands[i].args;			
			
			// Function
			var _com_args_str = "";
			for (var j = 0; j < array_length(_com_args); j++) {
				_com_args_str += _com_args[j] + "  ";
			}
			
			console_write_log(__ezConsole_dep_string_pad(_com_name, 12) + _com_args_str, EZ_CONSOLE_MSG_TYPE.WARNING);
			if (_com_shrt != "-") {
				console_write_log(__ezConsole_dep_string_pad(_com_shrt, 12) + _com_args_str, EZ_CONSOLE_MSG_TYPE.WARNING);
			}
			
			// Description
			console_write_log(_com_desc + "\n\n", EZ_CONSOLE_MSG_TYPE.INFO);
			
			// Arguments description
			if (array_length(_com_args) > 0) {
				var _com_args_val = _console_comands[i].args_desc;
				console_write_log(_console_comands[0].args[0] + "   " + _console_comands[0].args_desc[0], EZ_CONSOLE_MSG_TYPE.INFO);
			
				for (var j = 0; j < array_length(_com_args); j++) {
					console_write_log(__ezConsole_dep_string_pad(_com_args[j], 12) + _com_args_val[j], EZ_CONSOLE_MSG_TYPE.INFO);
				}
			}
			
			return -1;
		}		
	}
}

/// @function console_command_create(args)
/// @param	{array}	args
/// @desc	Create an instance
function console_command_create(_args) {
	var _command	= "create";
	var _params_len = array_length(_args);
	var _min_params = 1;
	var _max_params = 4;
	
	if (console_check_params_count(_command, _params_len, _min_params, _max_params)) {
		var _asset = asset_get_index(_args[0]);
		
		try {
			var _x = ( _params_len > 1 ? real(_args[1]) : mouse_x );
			var _y = ( _params_len > 2 ? real(_args[2]) : mouse_y );
			var _depth = ( _params_len > 3 ? real(_args[3]) : -100 );
		} catch (e) {
			console_write_log(e.message, EZ_CONSOLE_MSG_TYPE.ERROR);
			return -1;
		}
		
		if (_asset == -1) {
			console_write_log("There's no object named \"" + _args[0] + "\"!", EZ_CONSOLE_MSG_TYPE.ERROR);
		} else {
			var _inst = instance_create_depth(_x, _y, _depth, _asset);
			console_write_log("Instance created with id " + string(_inst.id) + ".", EZ_CONSOLE_MSG_TYPE.INFO);
		}
	}
}

/// @function console_command_instances(args)
/// @param	{array}	args
/// @desc	Get all instances
function console_command_instances(_args) {
	var _command	= "instances";
	var _params_len = array_length(_args);
	
	if (_params_len > 1) {
		// Too much params
		var _too_much_text = console_get_message(EZ_CONSOLE_MSG.TOO_MANY_PARAMS, _command, _params_len, 1, 1);
		console_write_log(_too_much_text, EZ_CONSOLE_MSG_TYPE.INFO);
	} else if (_params_len == 1) {
		// Get all instances of 1 specific object
		var _asset = asset_get_index(_args[0]);
		
		if (_asset == -1) {
			console_write_log("There's no object named \"" + _args[0] + "\"!", EZ_CONSOLE_MSG_TYPE.ERROR);
		} else {
			console_write_log(__ezConsole_dep_string_pad("NAME", 32) +
							  __ezConsole_dep_string_pad("ID", 16) +
							  __ezConsole_dep_string_pad("POSITION", 16) +
							  __ezConsole_dep_string_pad("DEPTH", 8),
							  EZ_CONSOLE_MSG_TYPE.INFO);
			
			var _inst, _name, _id, _pos, _depth;
			for (var i = 0; i < instance_number(_asset); i++) {
				_inst = instance_find(_asset, i);
				_name = __ezConsole_dep_string_pad(_args[0], 32);
				_id	  = __ezConsole_dep_string_pad(string(_inst.id), 16);
				_pos  = __ezConsole_dep_string_pad("(" + string(_inst.x) + ", " + string(_inst.y) + ")", 16);
				_depth= __ezConsole_dep_string_pad(string(_inst.depth), 8);
				
				console_write_log(_name + _id + _pos + _depth, EZ_CONSOLE_MSG_TYPE.INFO);
			}
		}
	} else if (_params_len == 0) {
		// Get all active instances
		console_write_log(	__ezConsole_dep_string_pad("NAME", 32) +
							__ezConsole_dep_string_pad("ID", 16) +
							__ezConsole_dep_string_pad("POSITION", 16) +
							__ezConsole_dep_string_pad("DEPTH", 8),
							EZ_CONSOLE_MSG_TYPE.INFO);
							  
		with (all) {
			var _name, _id, _pos, _depth;
			_name = __ezConsole_dep_string_pad(object_get_name(object_index), 32);
			_id	  = __ezConsole_dep_string_pad(string_delete(string(id), 1, 4), 16);
			_pos  = __ezConsole_dep_string_pad("(" + string(x) + ", " + string(y) + ")", 16);
			_depth= __ezConsole_dep_string_pad(string(depth), 8);
			
			console_write_log(_name + _id + _pos + _depth, EZ_CONSOLE_MSG_TYPE.INFO);
		}
	}
}

/// @function console_command_instance_set(args)
/// @param	{array}	args
/// @desc	Set a variable in an instance
function console_command_instance_set(_args) {
	var _command	= "set";
	var _params_len = array_length(_args);
	var _min_params = 3;
	var _max_params = 3;
	
	if (console_check_params_count(_command, _params_len, _min_params, _max_params)) {
		var _instance_id	= _args[0];
		var _variable_name	= _args[1];
		var _variable_value	= _args[2];
		
		var _inst_to_check = (
			string_digits(_instance_id) == _instance_id
			? _instance_id
			: asset_get_index(_instance_id)
		);

		if (!instance_exists(_inst_to_check) || _inst_to_check == -1) {
			console_write_log("Instance " + _instance_id + " doesn't exists", EZ_CONSOLE_MSG_TYPE.ERROR);
			return;
		}
		
		if !(variable_instance_exists(_inst_to_check, _variable_name)) {
			console_write_log("Variable " + _variable_name + " doesn't exists on instance " + _instance_id, EZ_CONSOLE_MSG_TYPE.ERROR);
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
		console_write_log(string("Variable {0} set as {1} on instance {2}.", _variable_name, _variable_value, _instance_id), EZ_CONSOLE_MSG_TYPE.INFO);
	}
}

/// @function console_command_instance_get(args)
/// @param	{array}	args
/// @desc	Gets a variable in an instance
function console_command_instance_get(_args) {
	var _command	= "get";
	var _params_len = array_length(_args);
	var _min_params = 1;
	var _max_params = 2;
	
	if (console_check_params_count(_command, _params_len, _min_params, _max_params)) {
		var _instance_id	= _args[0];
		var _variable_name	= array_length(_args) > 1 ? _args[1] : "";
		
		var _inst_to_check = (
			string_digits(_instance_id) == _instance_id
			? _instance_id
			: asset_get_index(_instance_id)
		);

		if (!instance_exists(_inst_to_check) || _inst_to_check == -1) {
			console_write_log("Instance " + _instance_id + " doesn't exists", EZ_CONSOLE_MSG_TYPE.ERROR);
			return;
		}
		
		if (_variable_name != "") {
			if !(variable_instance_exists(_inst_to_check, _variable_name)) {
				console_write_log("Variable " + _variable_name + " doesn't exists on instance " + _instance_id, EZ_CONSOLE_MSG_TYPE.ERROR);
				return;
			}
			
			console_write_log(
				__ezConsole_dep_string_pad("VARIABLE NAME", 32) +
				"VALUE",
				EZ_CONSOLE_MSG_TYPE.INFO
			);
			
			var _variable_value = variable_instance_get(_inst_to_check, _variable_name);
			console_write_log(
				__ezConsole_dep_string_pad(_variable_name, 32) +
				__ezConsole_dep_value_to_string(_variable_value),
				EZ_CONSOLE_MSG_TYPE.INFO
			);
			return;
		}
		
		var _variable_names = variable_instance_get_names(_inst_to_check);
		array_sort(_variable_names, true);
		console_write_log(
			__ezConsole_dep_string_pad("VARIABLE NAME", 32) +
			"VALUE",
			EZ_CONSOLE_MSG_TYPE.INFO
		);
		
		for (var i = 0; i < array_length(_variable_names); i++) {
			var _variable_value = variable_instance_get(_inst_to_check, _variable_names[i]);
			console_write_log(
				__ezConsole_dep_string_pad(_variable_names[i], 32) +
				__ezConsole_dep_value_to_string(_variable_value),
				EZ_CONSOLE_MSG_TYPE.INFO
			);
		}
	}
}

/// @function console_command_instance_delete(args)
/// @param	{array}	args
/// @desc	Delete an instance
function console_command_instance_delete(_args) {
	var _command	= "delete";
	var _params_len = array_length(_args);
	var _min_params = 1;
	var _max_params = 2;
	
	if (console_check_params_count(_command, _params_len, _min_params, _max_params)) {
		var _instance_id	= _args[0];
		var _exec_ev		= ( _params_len > 1 ? _args[1] : "1" );
		
		var _inst_to_check = (
			string_digits(_instance_id) == _instance_id
			? _instance_id
			: asset_get_index(_instance_id)
		);

		if (!instance_exists(_inst_to_check) || _inst_to_check == -1) {
			console_write_log("Instance " + _instance_id + " doesn't exists", EZ_CONSOLE_MSG_TYPE.ERROR);
			return;
		}
		
		instance_destroy(_inst_to_check, _exec_ev == "1" || _exec_ev == "true");
		console_write_log(string("Instance \"{0}\" destroyed.", _instance_id), EZ_CONSOLE_MSG_TYPE.INFO);
	}
}

/// @function console_command_clear(args)
/// @param	{array}	args
/// @desc	Clears console log
function console_command_clear(_args) {
	var _command	= "clear";
	var _params_len = array_length(_args);
	var _min_params = 0;
	var _max_params = 0;
	
	if (console_check_params_count(_command, _params_len, _min_params, _max_params)) {
		with (__EzConsole__) {
			ds_list_clear(console_text_log);
			console_log_total_h = 0;
			console_nav_scroll = 0;
			console_surf_yoffset = 0;
		}
		
		var _init_message = console_get_message(EZ_CONSOLE_MSG.INTIALIZATION, "");
		console_write_log(_init_message, EZ_CONSOLE_MSG_TYPE.WARNING);
	}
}

/// @function console_command_fps(args)
/// @param	{array}	args
/// @desc	Toggle or set and set FPS on screen
function console_command_fps(_args) {
	var _command	= "fps";
	var _params_len = array_length(_args);
	var _min_params = 0;
	var _max_params = 1;
	
	if (console_check_params_count(_command, _params_len, _min_params, _max_params)) {
		if (_params_len == 0) {
			__EzConsole__.console_fps_show = !__EzConsole__.console_fps_show;
			console_write_log(string("FPS are now {0}!", ( __EzConsole__.console_fps_show ? "visible" : "invisible" )), EZ_CONSOLE_MSG_TYPE.WARNING);
		} else {
			switch (_args[1]) {					
				case "0":
				case "false":
					__EzConsole__.console_fps_show = false;
					console_write_log("FPS are now invisible!", EZ_CONSOLE_MSG_TYPE.WARNING);
					break;
					
				case "1":
				case "true":
					__EzConsole__.console_fps_show = true;
					console_write_log("FPS are now visible!", EZ_CONSOLE_MSG_TYPE.WARNING);
					break;
					
				default:
					var _invalid_param = console_get_message(EZ_CONSOLE_MSG.INVALID_PARAM, _command, _params_len, 1, 1) + _args[1] + "\".";
					console_write_log(_invalid_param, EZ_CONSOLE_MSG_TYPE.ERROR);
			}
		}
	}
}

/// @function console_command_debug_overlay(args)
/// @param	{array}	args
/// @desc	Toggle or set and set debug overlay on screen
function console_command_debug_overlay(_args) {
	var _command	= "overlay";
	var _params_len = array_length(_args);
	var _min_params = 0;
	var _max_params = 1;
	
	if (console_check_params_count(_command, _params_len, _min_params, _max_params)) {
		if (_params_len == 0) {
			__EzConsole__.console_debug_overlay_show = !__EzConsole__.console_debug_overlay_show;
			show_debug_overlay(__EzConsole__.console_debug_overlay_show);
			console_write_log(string("Debug overlay is now {0}!", ( __EzConsole__.console_debug_overlay_show ? "visible" : "invisible" )), EZ_CONSOLE_MSG_TYPE.WARNING);
		} else {
			switch (_args[1]) {
				case "0":
				case "false":
					__EzConsole__.console_debug_overlay_show = false;
					console_write_log("Debug overlay is now invisible!", EZ_CONSOLE_MSG_TYPE.WARNING);
					break;
					
				case "1":
				case "true":
					__EzConsole__.console_debug_overlay_show = true;
					console_write_log("Debug overlay is now visible!", EZ_CONSOLE_MSG_TYPE.WARNING);
					break;
					
				default:
					var _invalid_param = console_get_message(EZ_CONSOLE_MSG.INVALID_PARAM, _command, _params_len, 1, 1) + _args[1] + "\".";
					console_write_log(_invalid_param, EZ_CONSOLE_MSG_TYPE.ERROR);
			}
		}
	}
}

#endregion