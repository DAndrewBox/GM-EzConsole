/// @description Systems
// Discard event if not visible
if (!visible) {
	console_set_visible();
	exit;
}

// Blink thing after text in bar
console_text_blink_t = ( console_text_blink_t > room_speed ? 0 : ++console_text_blink_t );

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
			#endregion
			break;
			
		case vk_f1: // toggle console on/off
			console_set_invisible();
			break;
	}
}

// Update text in bar
if (keyboard_check(vk_anykey)) {
	if (keyboard_check(vk_control)) {
		// Paste a text
		if (clipboard_has_text() && keyboard_check_pressed(ord("V"))) {
			keyboard_string += clipboard_get_text();
		}
		
		// Erase a whole word
		if (keyboard_check_pressed(vk_backspace)) {
			var _end_next = false;
			for (var i = string_length(keyboard_string); i > 0; i--) {
				// Remove a space and end
				if (_end_next) {
					break;
				}
				
				// Remove chars while check for space
				var _char = string_char_at(keyboard_string, i);
				keyboard_string = string_delete(keyboard_string, i, 1);

				if (_char == " " || _char == ".") {
					_end_next = true;
				}
			}
		}
	}
	
	if (keyboard_check_pressed(vk_tab) && console_suggestion_text != "") {
		// Autocompletes suggestion
		keyboard_string += console_suggestion_text + " ";
	}
	
	console_text_actual = string_copy(keyboard_string, 1, console_bar_max_chars);
	keyboard_string = console_text_actual;
	
	if (console_suggestions_flag) {
		console_suggestion_text = ( string_length(console_text_actual) > 0
								  ? console_get_suggestion(console_text_actual)
								  : ""
								  );
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
								? console_surf_yoffset + (16 * (_mouse_wheel_down - _mouse_wheel_up))
								: console_surf_yoffset );
		
		console_surf_yoffset = ( console_surf_yoffset/console_log_total_h > 1 ? console_log_total_h : console_surf_yoffset );
		console_surf_yoffset = ( console_surf_yoffset/console_log_total_h < 0 ? 0 : console_surf_yoffset );
		event_user(0);
	}
}

// Navigation with keys
if (ds_list_size(console_text_log) > 0) {
	var _nav_up = keyboard_check_pressed(console_key_nav_up);
	var _nav_down = keyboard_check_pressed(console_key_nav_down);
	
	if (_nav_up || _nav_down) { 
		var _iterations = 0;
		do {
			console_nav = clamp(console_nav + _nav_down - _nav_up, 0, ds_list_size(console_text_log) - 1);
			if (console_text_log[| console_nav].type == EZ_CONSOLE_MSG_TYPE.COMMON) {
				console_text_actual = console_text_log[| console_nav].message;
				keyboard_string = console_text_actual;
			} else {
				_iterations++;
			}
		} until (console_text_log[| console_nav].type == EZ_CONSOLE_MSG_TYPE.COMMON || _iterations > 16);
	}
}

// Update fps every half second
if (console_fps_show) {
	console_fps_t++
	if (console_fps_t > room_speed * .5) {
		array_push(console_fps_hist, fps);
		
		console_fps_real = string_format(fps_real, 5, 0);
		console_fps	= string_format(fps, 5, 0);		
		
		var _avg_fps = 0;
		for (var i = 0; i < array_length(console_fps_hist); i++) {
			_avg_fps += console_fps_hist[i];
		}
		
		console_fps_avg	= string_format(_avg_fps / array_length(console_fps_hist), 5, 0);
		console_fps_t = 0;
	}
}