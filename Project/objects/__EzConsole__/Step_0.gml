/// @description Systems
// Discard event if not visible
if (!visible) {
	ezConsole_set_visible();
	exit;
}

// Don't do anything if window close
if (!console_window_open) exit;

var _nav_up		= keyboard_check_pressed(ezConsole_key_nav_up);
var _nav_down	= keyboard_check_pressed(ezConsole_key_nav_down);
var _nav_left	= keyboard_check_pressed(ezConsole_key_nav_left);
var _nav_right	= keyboard_check_pressed(ezConsole_key_nav_right);

var _nav_hold_up = keyboard_check(ezConsole_key_nav_up);
var _nav_hold_down = keyboard_check(ezConsole_key_nav_down);

var _nav_hold_up = keyboard_check(console_key_nav_up);
var _nav_hold_down = keyboard_check(console_key_nav_down);

var _backspace_is_pressed	= false;
var _delete_is_pressed		= false;

var _inst_ref_split_delim	= "(ref";

// Blink thing after text in bar
console_text_blink_t = ( console_text_blink_t > game_get_speed(gamespeed_fps) * console_text_blink_rate ? 0 : ++console_text_blink_t );
console_surf_yoffset = lerp(console_surf_yoffset, console_surf_yoffset_to, .16);

// Do actions
if (keyboard_check_pressed(vk_anykey)) {
	switch (keyboard_lastkey) {
		case ezConsole_key_send_line:
			#region // Send command
			if (console_text_actual != "") {
				console_check_command(console_text_actual);
				if (console_log_total_h > 0) {
					console_surf_yoffset_to = console_log_total_h;
					event_user(0);
				}
			}
			console_nav_hor = 0;
			
			console_suggestion_text = "";
			
			console_typeahead_show			= false;
			console_typeahead_selected		= -1;
			console_typeahead_selected_yoff	= 0;
			console_typeahead_elements		= [];
			#endregion
			break;
		
		case ezConsole_key_auto_complete:
			// Autocomplete commands
			var _use_suggestion	= (ezConsole_enable_suggestions && console_suggestion_text != "");
			var _use_typeahead	= (ezConsole_enable_typeahead && console_typeahead_selected > -1);
			
			if (_use_suggestion || _use_typeahead) {
				var _is_command = array_length(string_split(keyboard_string, " ")) == 1;
				keyboard_string = (
					_use_suggestion
					? (_is_command ? string_lower(keyboard_string) : keyboard_string) + console_suggestion_text					// Autocompletes using suggestion
					: console_typeahead_elements[console_typeahead_selected]	// Autocomplete using typeahead
				);
				
				var _last_arg = array_last(string_split(keyboard_string, " "));
				if (_use_suggestion && !_is_command && ezConsole_enable_typeahead_inst_ref && string_char_at(_last_arg, 1) == ":") {
					var _kb_last_space = string_last_pos(" ", keyboard_string);
					var _kb_str_without_last_arg = string_copy(keyboard_string, 1, _kb_last_space - 1);
					var _splitted_str = string_split(console_typeahead_elements[console_typeahead_selected], _inst_ref_split_delim);
					var _inst_name = string_trim(_splitted_str[0]);
					var _ref_number = string_digits(_splitted_str[1]);

					keyboard_string = $"{_kb_str_without_last_arg} {_inst_name}:{_ref_number}";
				}
					
				console_typeahead_selected = -1;
				console_suggestion_text = "";
				keyboard_lastchar = "";
			}
			break;
			
		case ezConsole_key_toggle: // toggle console on/off
			ezConsole_set_invisible();
			break;
			
		case vk_backspace:
		case vk_delete:
			_backspace_is_pressed = keyboard_check_pressed(vk_backspace);
			_delete_is_pressed = keyboard_check_pressed(vk_delete);

			if (console_nav_hor != 0) {
				keyboard_string = console_text_actual;
			}
			
			keyboard_lastchar = "";
			break;
			
		
		case ezConsole_key_nav_up:
		case ezConsole_key_nav_down:
		case ezConsole_key_nav_left:
		case ezConsole_key_nav_right:
		case vk_shift:
		case vk_lshift:
		case vk_rshift:
		case vk_control:
			// Do nothing
			break;
			
		default:
			var _key_is_valid = string_pos(keyboard_lastchar, ezConsole_valid_charset) > 0;
		
			if (console_nav_hor != 0 && _key_is_valid) {
				keyboard_string = console_text_actual;
				keyboard_string =
					string_insert(
						keyboard_lastchar,
						console_text_actual,
						string_length(console_text_actual) + console_nav_hor + 1
					);
			}
			
			if (console_nav_hor == 0 && !_key_is_valid && !keyboard_check_pressed(vk_escape)) {
				keyboard_string = string_copy(keyboard_string, 1, string_length(keyboard_string) - 1);
			}
			
			keyboard_lastchar = "";
			break;
	}
}

// Update text in bar
if (keyboard_check(vk_anykey)) {
	var _control_is_pressed = keyboard_check(vk_control);
	
	if (_control_is_pressed) {
		// Paste a text
		if (clipboard_has_text() && keyboard_check_pressed(ord("V"))) {
			keyboard_string += clipboard_get_text();
			if (string_pos("\n", keyboard_string)) {
				keyboard_string = string_split(keyboard_string, "\n")[0];
				keyboard_string = string_replace_all(keyboard_string, "\t", " ");
			}
		}
		
		// Copy a command
		if (keyboard_check_pressed(ord("C")) && string_length(console_text_actual) > 0) {
			clipboard_set_text(console_text_actual);
			console_write_log($"Line \"{console_text_actual}\" copied to clipboard!", EZ_CONSOLE_MSG_TYPE.INFO);
		}
		
		// Erase a whole word
		if (_backspace_is_pressed) {
			var _end_next = false;
			var _kb_str_len = string_length(keyboard_string);
			for (var i = _kb_str_len; i > 0; i--) {
				// Remove chars while check for space
				if (_end_next) break;
				
				var _char = string_char_at(keyboard_string, i);
				keyboard_string = string_delete(keyboard_string, i, 1);

				if (_char == " " || _char == "." || _char == ":") {
					_end_next = true;
				}
			}
		}
	}
	
	draw_set_font(console_text_font);
	if (string_width(console_text_start_char + keyboard_string) < (console_width - console_log_xpad - console_text_font_xoff)) {
		console_text_actual = string_copy(keyboard_string, 1, string_length(keyboard_string));
		
		var _console_text_actual_split = string_split(console_text_actual, " "); 
		var _console_text_actual_split_len = array_length(_console_text_actual_split);
		
		console_typeahead_selected = min(array_length(console_typeahead_elements) - 1, console_typeahead_selected);
		
		if (_console_text_actual_split_len > 0 && array_length(console_typeahead_elements) > 0 && console_typeahead_selected > -1) {
			var _console_text_last_arg_len = string_length(_console_text_actual_split[_console_text_actual_split_len - 1]);
			console_suggestion_text = string_copy(
				console_typeahead_elements[console_typeahead_selected],
				_console_text_last_arg_len + 1,
				string_length(console_typeahead_elements[console_typeahead_selected]) - _console_text_last_arg_len
			);
			
			if (ezConsole_enable_typeahead_inst_ref && string_pos(_inst_ref_split_delim, console_suggestion_text)) {
				var _splitted_str = string_split(console_suggestion_text, _inst_ref_split_delim);
				var _ref_number = string_digits(_splitted_str[1]);
				var _trimmed_arg = string_trim(_splitted_str[0]);
				var _last_kb_str_arg = array_last(string_split(keyboard_string, " "));
				_last_kb_str_arg = string_copy(_last_kb_str_arg, 2, string_length(_last_kb_str_arg) - 2);
							
				_trimmed_arg += ( string_pos(":", _last_kb_str_arg) ? "" : ":" );
				console_suggestion_text = $"{_trimmed_arg}{_ref_number}";
			}
		}
	}
	
	if (!_control_is_pressed && console_nav_hor != 0 && (_backspace_is_pressed || _delete_is_pressed)) {
		console_text_actual =
			string_delete(
				console_text_actual,
				string_length(console_text_actual) + console_nav_hor + _delete_is_pressed,
				1
			);
		console_nav_hor += _delete_is_pressed;
	}
	
	keyboard_string = console_text_actual;
	
	if (_nav_left || _nav_right) {
		console_nav_hor += _nav_right - _nav_left;
		console_nav_hor = clamp(console_nav_hor, -string_length(console_text_actual), 0);
	}
	
	if (ezConsole_enable_suggestions) {
		if (console_typeahead_selected < 0) {
			console_suggestion_text = (
				string_length(console_text_actual) > 0
				? console_get_suggestion(console_text_actual)
				: ""
			);
		}
	}
	
	if (ezConsole_enable_typeahead) {
		console_typeahead_elements =  (
			string_length(console_text_actual) > 0
			? console_get_typeahead(console_text_actual)
			: []
		);
		console_typeahead_elements = array_filter(
			console_typeahead_elements,
			console_typeahead_filter
		);
		var _typeahead_len = array_length(console_typeahead_elements);
		console_typeahead_show = (
			_typeahead_len >= 1 && ezConsole_enable_suggestions ||
			_typeahead_len > 0 && !ezConsole_enable_suggestions
		);
		console_typeahead_selected = console_typeahead_show ? console_typeahead_selected : -1;
		console_typeahead_selected_yoff =
			_typeahead_len <= console_typeahead_selected_yoff
			? 0
			: console_typeahead_selected_yoff;
			
		if (keyboard_check(vk_escape)) {
			console_typeahead_show = false;
			console_typeahead_selected_yoff = 0;
			console_typeahead_selected = -1;
		}
		
		if (console_typeahead_selected > _typeahead_len) {
			console_typeahead_selected = _typeahead_len - 1;
		}
	}
}

// Scroll logs
var _mouse_x = display_mouse_get_x() - window_get_x();
var _mouse_y = display_mouse_get_y() - window_get_y();

if (_mouse_x >= console_x && _mouse_x <= console_x + console_width) && (_mouse_y >= console_y && _mouse_y <= console_y + console_height) {
	var _mouse_wheel_up = mouse_wheel_up();
	var _mouse_wheel_down = mouse_wheel_down();
	
	if (_mouse_wheel_up || _mouse_wheel_down || console_surf_yoffset != console_surf_yoffset_to) {
		console_surf_yoffset_to = ( ( console_surf_yoffset_to/console_log_total_h < 1 && _mouse_wheel_down) || (console_surf_yoffset_to > 0 && _mouse_wheel_up)
								? console_surf_yoffset_to + (ezConsole_prop_nav_scroll_speed * 24 * (_mouse_wheel_down - _mouse_wheel_up))
								: console_surf_yoffset_to );
		
		console_surf_yoffset_to = ( console_surf_yoffset_to/console_log_total_h > 1 ? console_log_total_h : console_surf_yoffset_to );
		console_surf_yoffset_to = ( console_surf_yoffset_to/console_log_total_h < 0 ? 0 : console_surf_yoffset_to );
		event_user(0);
	}
}

// Navigation with keys
var _log_len = ds_list_size(console_text_log);
if (_log_len > 0) {
	if (_nav_hold_up || _nav_hold_down) {
		console_typeahead_nav_t++;
	} else {
		console_typeahead_nav_t = 0;
	}
	
	if (_nav_up || _nav_down || console_typeahead_nav_t > game_get_speed(gamespeed_fps) * .66) {
		if (ezConsole_enable_typeahead && console_typeahead_show) {
			var _typeahead_len = array_length(console_typeahead_elements);
			var _bar_y = console_y + console_height - console_bar_height;
			var _console_on_bottom = _bar_y > window_get_height() / 2;
			
			if (_nav_hold_up) {
				keyboard_key_press(ezConsole_key_nav_up);
				_nav_up = true;
			} else if (_nav_hold_down) {
				keyboard_key_press(ezConsole_key_nav_down);
				_nav_down = true;
			}
			
			console_typeahead_nav_t *= .80;
			
			if (console_typeahead_selected == -1 && ((_console_on_bottom && _nav_down) || (!_console_on_bottom && _nav_up))) {
				console_typeahead_selected = _typeahead_len - 1;
			} else {
				console_typeahead_selected =
					clamp(
						console_typeahead_selected + (_console_on_bottom ? -_nav_down + _nav_up : _nav_down - _nav_up ),
						-1,
						_typeahead_len 
					);
			}
			#region // Console typeadeah navigation 
			if (_console_on_bottom) {
				if (_nav_down && console_typeahead_selected <= -1) {
					console_typeahead_selected_yoff = _typeahead_len - console_typeahead_elements_max;
					console_typeahead_selected = (_typeahead_len - 1);
				} else if (_nav_up && console_typeahead_selected == _typeahead_len) {
					console_typeahead_selected_yoff = 0;
					console_typeahead_selected = 0;
				} else if (console_typeahead_selected >= console_typeahead_elements_max) {
					console_typeahead_selected_yoff += _nav_up - _nav_down;
					if (console_typeahead_selected_yoff >= 0) {
						console_typeahead_selected = clamp(console_typeahead_selected, -1, _typeahead_len - 1);
					} else {
						console_typeahead_selected_yoff = _typeahead_len - console_typeahead_elements_max;
					}
				} else if (_nav_down && console_typeahead_selected < console_typeahead_elements_max) {
					console_typeahead_selected_yoff--;
					console_typeahead_selected = clamp(console_typeahead_selected, -1, _typeahead_len - 1);
				}
			} else {
				if (_nav_up && console_typeahead_selected <= -1) {
					console_typeahead_selected_yoff = _typeahead_len - console_typeahead_elements_max;
					console_typeahead_selected = (_typeahead_len - 1);
				} else if (_nav_down && console_typeahead_selected == _typeahead_len) {
					console_typeahead_selected_yoff = 0;
					console_typeahead_selected = 0;
				} else if (console_typeahead_selected >= console_typeahead_elements_max) {
					console_typeahead_selected_yoff += _nav_down - _nav_up;
					if (console_typeahead_selected_yoff >= 0) {
						console_typeahead_selected = clamp(console_typeahead_selected, -1, _typeahead_len - 1);
					} else {
						console_typeahead_selected_yoff = _typeahead_len - console_typeahead_elements_max;
					}
				} else if (_nav_up && console_typeahead_selected < console_typeahead_elements_max) {
					console_typeahead_selected_yoff--;
					console_typeahead_selected = clamp(console_typeahead_selected, -1, _typeahead_len - 1);
				}
			}

			console_typeahead_selected_yoff = clamp(console_typeahead_selected_yoff, 0, max(0, _typeahead_len - console_typeahead_elements_max));
			#endregion
			
			if (console_typeahead_selected > -1) {
				if (ezConsole_enable_suggestions) {
					var _console_text_len = string_length(console_text_actual);
					var _console_text_actual_split = string_split(console_text_actual, " "); 
					var _console_text_actual_split_len = array_length(_console_text_actual_split);
					
					if (_console_text_actual_split_len == 0) {
						console_suggestion_text = string_copy(
							console_typeahead_elements[console_typeahead_selected],
							_console_text_len + 1,
							string_length(console_typeahead_elements[console_typeahead_selected]) - _console_text_len
						);
					} else {
						var _console_text_last_arg_len = string_length(_console_text_actual_split[_console_text_actual_split_len - 1]);
						console_suggestion_text = string_copy(
							console_typeahead_elements[console_typeahead_selected],
							_console_text_last_arg_len + 1,
							string_length(console_typeahead_elements[console_typeahead_selected]) - _console_text_last_arg_len
						);
						
						if (ezConsole_enable_typeahead_inst_ref && string_pos(_inst_ref_split_delim, console_suggestion_text)) {
							var _splitted_str = string_split(console_suggestion_text, _inst_ref_split_delim);
							var _ref_number = string_digits(_splitted_str[1]);
							var _trimmed_arg = string_trim(_splitted_str[0]);
							var _last_kb_str_arg = array_last(string_split(keyboard_string, " "));
							_last_kb_str_arg = string_copy(_last_kb_str_arg, 2, string_length(_last_kb_str_arg) - 2);
							
							_trimmed_arg += ( string_pos(":", _last_kb_str_arg) ? "" : ":" );
							console_suggestion_text = $"{_trimmed_arg}{_ref_number}";
						}
					}
				}
			}
		} else {
			var _iterations = 0;
			do {
				console_nav_scroll = clamp(console_nav_scroll + (_nav_down - _nav_up), 0, _log_len - 1);
				if (console_text_log[| console_nav_scroll].type == EZ_CONSOLE_MSG_TYPE.COMMON) {
					console_text_actual = console_text_log[| console_nav_scroll].message;
					keyboard_string = console_text_actual;
				} else {
					_iterations++;
				}
			} until (console_nav_scroll < 0 || console_nav_scroll > _log_len - 1 || console_text_log[| console_nav_scroll].type == EZ_CONSOLE_MSG_TYPE.COMMON || _iterations > 128);
		}
	}
}

// Update fps every half second
if (console_fps_show) {
	console_fps_t++
	if (console_fps_t > game_get_speed(gamespeed_fps) * .5) {
		var _fps_hist_len = array_length(console_fps_hist);
		if (_fps_hist_len >= 20) {
			array_delete(console_fps_hist, 0, 1);
		}
		array_push(console_fps_hist, fps);
		
		console_fps_real	= string(round(fps_real));
		console_fps			= string(round(fps));
		
		var _avg_fps = 0;
		for (var i = 0; i < _fps_hist_len; i++) {
			_avg_fps += console_fps_hist[i];
		}
		
		console_fps_avg	= string(round(_avg_fps / _fps_hist_len));
		console_fps_t = 0;
	}
}