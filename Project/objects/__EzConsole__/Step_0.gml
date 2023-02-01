/// @description Systems
// Discard event if not visible
if (!visible) {
	console_set_visible();
	exit;
}

var _nav_up		= keyboard_check_pressed(console_key_nav_up);
var _nav_down	= keyboard_check_pressed(console_key_nav_down);
var _nav_left	= keyboard_check_pressed(console_key_nav_left);
var _nav_right	= keyboard_check_pressed(console_key_nav_right);

var _backspace_is_pressed	= false;
var _delete_is_pressed		= false;

// Blink thing after text in bar
console_text_blink_t = ( console_text_blink_t > room_speed * console_text_blink_rate ? 0 : ++console_text_blink_t );

// Do actions
if (keyboard_check_pressed(vk_anykey)) {
	switch (keyboard_lastkey) {
		case vk_enter:
			#region // Send command
			if (console_text_actual != "") {
				console_check_command(console_text_actual);
				if (console_log_total_h > 0) {
					console_surf_yoffset = console_log_total_h;
					event_user(0);
				}
			}
			console_nav_hor = 0;
			#endregion
			break;
		
		case vk_tab:
			// Autocomplete commands
			var _use_suggestion	= (console_suggestions_flag && console_suggestion_text != "");
			var _use_typeahead	= (console_typeahead_flag && console_typeahead_selected > -1);
			
			if (_use_suggestion || _use_typeahead) {
				keyboard_string = 
					( _use_suggestion
					? keyboard_string + console_suggestion_text					// Autocompletes using suggestion
					: console_typeahead_elements[console_typeahead_selected]	// Autocomplete using typeahead
					);
					
				console_typeahead_selected = -1;
				console_suggestion_text = "";
			}
			break;
			
		case vk_f1: // toggle console on/off
			console_set_invisible();
			break;
			
		case vk_backspace:
		case vk_delete:
			_backspace_is_pressed = keyboard_check_pressed(vk_backspace);
			_delete_is_pressed = keyboard_check_pressed(vk_delete);

			if (console_nav_hor != 0) {
				keyboard_string = console_text_actual;
			}
			break;
			
		
		case console_key_nav_up:
		case console_key_nav_down:
		case console_key_nav_left:
		case console_key_nav_right:
			// Do nothing
			break;
			
		default:
			if (console_nav_hor != 0 && string_pos(keyboard_lastchar, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_ ") > 0) {
				keyboard_string = console_text_actual;
				keyboard_string =
					string_insert(
						keyboard_lastchar,
						console_text_actual,
						string_length(console_text_actual) + console_nav_hor + 1
					);
				keyboard_lastchar = "";
			}
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
			var _first_enter = string_pos("\n", keyboard_string);
			if (_first_enter > 0) {
				keyboard_string = string_copy(keyboard_string, 1, _first_enter - 2);
				keyboard_string = string_replace_all(keyboard_string, "\t", "");
			}
		}
		
		// Copy a command
		if (keyboard_check_pressed(ord("C"))) {
			clipboard_set_text(keyboard_string);
		}
		
		// Erase a whole word
		if (_backspace_is_pressed) {
			var _end_next = false;
			for (var i = string_length(keyboard_string); i > 0; i--) {
				// Remove chars while check for space
				if (_end_next) break;
				
				var _char = string_char_at(keyboard_string, i);
				keyboard_string = string_delete(keyboard_string, i, 1);

				if (_char == " " || _char == ".") {
					_end_next = true;
				}
			}
		}
	}
	
	draw_set_font(console_text_font);
	if (string_width(console_text_start_char + keyboard_string) < (console_width - console_log_xpad - console_text_font_xoff)) {
		console_text_actual = string_copy(keyboard_string, 1, string_length(keyboard_string));
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
	
	if (console_suggestions_flag) {
		if (console_typeahead_selected < 0) {
			console_suggestion_text = ( string_length(console_text_actual) > 0
									  ? console_get_suggestion(console_text_actual)
									  : ""
									  );
		}
	}
	
	if (console_typeahead_flag) {
		console_typeahead_elements =  (	string_length(console_text_actual) > 0
									  ? console_get_typeahead(console_text_actual)
									  : []
									  );
		array_resize(console_typeahead_elements, console_typeahead_elements_max);
		console_typeahead_elements = array_filter(
			console_typeahead_elements,
			function (e) {
				return is_string(e);
			}
		);
		var _typeahead_len = array_length(console_typeahead_elements);
		console_typeahead_show = (
			_typeahead_len > 1 && console_suggestions_flag ||
			_typeahead_len > 0 && !console_suggestions_flag
		);
		console_typeahead_selected = console_typeahead_show ? console_typeahead_selected : -1;
	}
}

// Scroll logs
var _mouse_x = display_mouse_get_x() - window_get_x();
var _mouse_y = display_mouse_get_y() - window_get_y();

if (_mouse_x >= console_x && _mouse_x <= console_x + console_width) && (_mouse_y >= console_y && _mouse_y <= console_y + console_height) {
	var _mouse_wheel_up = mouse_wheel_up();
	var _mouse_wheel_down = mouse_wheel_down();
	
	if (_mouse_wheel_up || _mouse_wheel_down) {
		console_surf_yoffset = ( ( console_surf_yoffset/console_log_total_h < 1 && _mouse_wheel_down) || (console_surf_yoffset > 0 && _mouse_wheel_up)
								? console_surf_yoffset + (console_nav_scroll_speed * 24 * (_mouse_wheel_down - _mouse_wheel_up))
								: console_surf_yoffset );
		
		console_surf_yoffset = ( console_surf_yoffset/console_log_total_h > 1 ? console_log_total_h : console_surf_yoffset );
		console_surf_yoffset = ( console_surf_yoffset/console_log_total_h < 0 ? 0 : console_surf_yoffset );
		event_user(0);
	}
}

// Navigation with keys
var _log_len = ds_list_size(console_text_log);
if (_log_len > 0) {	
	if (_nav_up || _nav_down) {
		if (console_typeahead_flag && console_typeahead_show) {
			var _typeahead_len = array_length(console_typeahead_elements);
			var _bar_y = console_y + console_height - console_bar_height;
			var _console_on_bottom = _bar_y > window_get_height() / 2;
			
			if (console_typeahead_selected == -1 && ((_console_on_bottom && _nav_down) || (!_console_on_bottom && _nav_up))) {
				console_typeahead_selected = _typeahead_len - 1;
			} else {
				console_typeahead_selected =
					clamp(
						console_typeahead_selected + (_console_on_bottom ? -_nav_down + _nav_up : _nav_down - _nav_up ),
						-1,
						_typeahead_len - 1
					);
			}
				
			if (console_typeahead_selected > -1) {
				if (console_suggestions_flag) {
					var _console_text_len = string_length(console_text_actual);
					console_suggestion_text = string_copy(
						console_typeahead_elements[console_typeahead_selected],
						_console_text_len + 1,
						string_length(console_typeahead_elements[console_typeahead_selected]) - _console_text_len
					);
				}
			}
		} else {
			var _iterations = 0;
			do {
				console_nav_scroll = clamp(console_nav_scroll + _nav_down - _nav_up, 0, _log_len - 1);
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
	if (console_fps_t > room_speed * .5) {
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