/// @description Draw above everything on GUI
if !(visible) exit;
display_set_gui_maximize();

var _gui_w = display_get_width();
var _gui_h = display_get_height();
var _bar_y = console_y + console_height - console_bar_height;

draw_set_alpha(1);

// Draw drop-shadow if window mode
if (console_anchor == EZ_CONSOLE_ANCHOR.NONE) {
	var _offset = console_bar_height / 2;
	var _height = (console_height * console_window_open) + console_bar_height + (2 * _offset);
	
	draw_sprite_stretched_ext(
		s_ezConsole_shadow, 0,
		console_x - _offset,
		console_y - console_bar_height - _offset,
		console_width + (2 * _offset),
		_height,
		c_white,
		.80
	);
}

// Draw screenfill
if (ezConsole_enable_screenfill && console_window_open) {
	draw_set_alpha(console_screenfill_alpha);
	draw_set_colour(console_screenfill_color);
	draw_rectangle(0, 0, _gui_w, _gui_h, false);
}

// Draw blurred background
if (console_window_open && ezConsole_enable_blur && surface_exists(application_surface)) {
	draw_set_alpha(1);
	if (!surface_exists(console_blur_surf)) {
		console_blur_surf = surface_create(console_width, console_height);
	}
	surface_set_target(console_blur_surf);
	draw_clear_alpha(console_bg_color, .0);
	draw_surface_part_ext(
		application_surface,
		0,
		0,
		console_width,
		console_height - 1,
		-console_x,
		-console_y,
		(_gui_w / __original_window_w) - 1,
		(_gui_h / __original_window_h) - 1,
		-1,
		1
	);
	surface_reset_target();
	
	__ezConsole_dep_draw_surface_blur(console_blur_surf, console_blur_amount, console_x, console_y);
}

// Draw console layout
draw_set_alpha(console_bg_alpha);
draw_set_colour(console_bg_color);
if (console_window_open) {
	var _bar_inset = console_bar_inset;
	draw_rectangle(console_x, console_y, console_x + console_width, _bar_y + ((_bar_inset > 0) * console_bar_height), false);
	
	draw_set_colour(console_bar_color);
	draw_rectangle(console_x + _bar_inset, _bar_y + _bar_inset, console_x + console_width - _bar_inset, _bar_y + console_bar_height - _bar_inset, false);
}

if (console_border_alpha > .0) {
	var _no_anchor = console_anchor == EZ_CONSOLE_ANCHOR.NONE;
	draw_set_alpha(console_border_alpha);
	draw_set_colour(console_window_open ? console_border_color : console_bar_color_highlight);
	
	if (console_window_open) {
		draw_rectangle(console_x, console_y - (_no_anchor * console_bar_height), console_x + console_width, _bar_y + console_bar_height, true);
		draw_line(console_x + console_log_xpad, _bar_y - 1, console_x + console_width - console_log_xpad, _bar_y - 1);
	} else {
		draw_rectangle(console_x, console_y - (_no_anchor * console_bar_height), console_x + console_width, console_y, true);
	}
}

#region // Windowed title if no anchor
if (console_anchor == EZ_CONSOLE_ANCHOR.NONE) {
	draw_set_alpha(console_window_open ? 1. : .66);
	draw_set_colour(console_window_open ? console_bar_color : console_bg_color);
	draw_rectangle(console_x, console_y - console_bar_height, console_x + console_width, console_y, false);

	draw_set_alpha(1);
	draw_set_font(console_text_font);
	draw_set_colour(console_typeahead_text_highlight);
	draw_set_halign(fa_left);
	draw_set_valign(fa_center);
	draw_text(console_x + console_log_xpad * 5, (console_y - console_bar_height / 2) + 2, console_window_title);

	draw_sprite(s_ezConsole_icon_window_status, console_window_open, console_x + console_log_xpad, console_y - console_bar_height / 2);
	draw_sprite(s_ezConsole_icon_toggle, 0, console_x + console_width - console_log_xpad, console_y - console_bar_height / 2)
}
#endregion

if (console_window_open) {
	// Draw console bar text
	draw_set_font(console_text_font);
	draw_set_alpha(console_text_alpha);
	draw_set_colour(console_text_actual_color);
	draw_set_halign(fa_left);
	draw_set_valign(fa_center);

	var _console_msg = console_text_actual
	var _console_blink_char =
		( console_text_blink_t < room_speed * .66
		&& string_width(console_text_start_char + keyboard_string) < (console_width - console_log_xpad * 2)
		? console_text_blink_char
		: "" );
	var _console_text_x = console_x + console_log_xpad + console_text_font_xoff;
	var _console_text_y = _bar_y + console_bar_height/2 + 1 + console_text_font_yoff;

	draw_text(_console_text_x, _console_text_y, console_text_start_char + _console_msg);

	if (_console_blink_char != "") {
		var _console_blink_char_xoff =
			string_width(console_text_start_char + _console_msg) + (console_nav_hor * string_width("M"));
		draw_text(_console_text_x + _console_blink_char_xoff, _console_text_y, _console_blink_char);
	}

	// Draw console bar text suggestion
	if (ezConsole_enable_suggestions && console_suggestion_text != "") {
		var _console_text_w = string_width(console_text_start_char + console_text_actual);
		draw_set_alpha(console_text_alpha * .50);
		draw_text(	_console_text_x + _console_text_w,
					_console_text_y,
					console_suggestion_text);
				
		draw_set_alpha(1);
	}

	// Draw text in console
	if !(surface_exists(console_surf)) {
		event_user(0);
	}

	draw_surface(console_surf, console_x + console_log_xpad, console_y + console_log_ypad);

	// Draw scrollbar
	if (console_log_total_h > 0) {
		var _sidebar_x = console_x + console_width - console_log_xpad - 1;
		var _sidebar_y = console_y + console_log_ypad;
		var _sidebar_max_h = ((console_height - console_bar_height - (2 * console_log_ypad)));
		var _sidebar_cursor_h = max(1, (_sidebar_max_h / 3) * (_sidebar_max_h / console_log_total_h));
		draw_set_alpha(console_bg_alpha);
		draw_set_color(console_bg_color);
		draw_rectangle(_sidebar_x - 1,
					   _sidebar_y,
					   _sidebar_x + 1,
					   _sidebar_y + _sidebar_max_h,
					   false);
		draw_set_color(console_text_actual_color);
		draw_rectangle(_sidebar_x - 2,
					   _sidebar_y + max(0, (console_surf_yoffset/console_log_total_h * (_sidebar_max_h - _sidebar_cursor_h))),
					   _sidebar_x + 2,
					   _sidebar_y + min(_sidebar_max_h, (console_surf_yoffset/console_log_total_h * (_sidebar_max_h - _sidebar_cursor_h)) + _sidebar_cursor_h),
					   false);
	}

	// Draw typeahed
	var _typeahead_max_len = array_length(console_typeahead_elements);
	if (ezConsole_enable_typeahead && console_typeahead_show && _typeahead_max_len > 0) {
		var _typeahead_xoff = string_width(" " + string_copy(console_text_actual, 1, string_last_pos(" ", console_text_actual)));
	
		var _bar_on_bottom = _bar_y > window_get_height() / 2;
		var _typeahead_len = min(_typeahead_max_len, console_typeahead_elements_max) + console_typeahead_selected_yoff;
		var _typeahead_w = 0;
	
		for (var i = 0; i < _typeahead_max_len; i++) {
			_typeahead_w = max(_typeahead_w, string_width(console_typeahead_elements[i]) + console_log_xpad * 2);
		}
		
		// Draw typeahead element
		for (var i = console_typeahead_selected_yoff; i < _typeahead_len; i++) {
			var _element = string_trim(console_typeahead_elements[i]);
			var _asset_index = asset_get_index(_element);
			var _typeahead_icon_size = (console_bar_height - 4); // 2px border
			var _typeahead_icon_xoff = ezConsole_enable_typeahead_icons * console_get_typeahead_asset_valid(_asset_index) * (_typeahead_icon_size + 4);

			var _text_height = string_height(_element);

			draw_set_alpha(.90);
			draw_set_color(console_typeahead_selected == i ? console_bar_color_highlight : console_bar_color);
			if (_bar_on_bottom) {
				draw_rectangle(
					console_x + _typeahead_xoff + .5,
					_bar_y - console_bar_height * (i - console_typeahead_selected_yoff),
					console_x + _typeahead_w + _typeahead_xoff + _typeahead_icon_xoff,
					_bar_y - console_bar_height - console_bar_height * (i - console_typeahead_selected_yoff),
					false
				);
			} else {
				draw_rectangle(
					console_x + _typeahead_xoff,
					_bar_y + console_bar_height + console_bar_height * (i - console_typeahead_selected_yoff),
					console_x + _typeahead_w + _typeahead_xoff + _typeahead_icon_xoff,
					_bar_y + console_bar_height * 2 + console_bar_height * (i - console_typeahead_selected_yoff),
					false
				);
			}
		
			draw_set_alpha(console_text_alpha);
			draw_set_color(console_typeahead_selected == i ? console_typeahead_text_highlight : console_typeahead_text_color);
			if (_bar_on_bottom) {
				draw_text(
					_console_text_x + _typeahead_xoff + _typeahead_icon_xoff,
					_bar_y - console_bar_height * (i - console_typeahead_selected_yoff) - _text_height / 2 + 1 - console_text_font_yoff,
					_element
				);
			
				if (ezConsole_enable_typeahead_icons) {
					var _asset_type = asset_get_type(_asset_index);
					var _icon = console_get_typeahead_icon(_asset_index, _asset_type);
					if (_icon > -1) {
						draw_sprite_stretched(_icon, 0, _console_text_x + _typeahead_xoff, _bar_y + 5.5 - console_bar_height * 2 - console_bar_height * (i - console_typeahead_selected_yoff) + _text_height / 2 - console_text_font_yoff + (_typeahead_icon_size / 2), _typeahead_icon_size, _typeahead_icon_size);
					}
				}
			} else {
				draw_text(
					_console_text_x + _typeahead_xoff + _typeahead_icon_xoff,
					_bar_y + console_bar_height * 2 + console_bar_height * (i - console_typeahead_selected_yoff) - _text_height / 2 + 1 + console_text_font_yoff,
					_element
				);
			
				if (ezConsole_enable_typeahead_icons) {
					var _asset_type = asset_get_type(_asset_index);
					var _icon = console_get_typeahead_icon(_asset_index, _asset_type);
					if (_icon > -1) {
						draw_sprite_stretched(_icon, 0, _console_text_x + _typeahead_xoff, _bar_y - .5 + console_bar_height * 2 + console_bar_height * (i - console_typeahead_selected_yoff) - _text_height / 2 + console_text_font_yoff - (_typeahead_icon_size / 2), _typeahead_icon_size, _typeahead_icon_size);
					}
				}
			}
		}
		
		// Draw typeahead scrollbar
		if (_typeahead_max_len > console_typeahead_elements_max) {
			var _sidebar_x = console_x + _typeahead_w + 1 + _typeahead_xoff + abs(_typeahead_icon_xoff);
			var _sidebar_y = _bar_y + console_bar_height;
			var _sidebar_elements_len = min(_typeahead_max_len, console_typeahead_elements_max);
			var _sidebar_max_h = (_sidebar_elements_len / _typeahead_max_len) * (console_bar_height * _typeahead_max_len);
			var _sidebar_cursor_h = max(1, (_sidebar_max_h / console_bar_height));
		
			if (_bar_on_bottom) {
				_sidebar_y = _bar_y - (_sidebar_elements_len * console_bar_height);
			}
		
			draw_set_alpha(console_bg_alpha);
			draw_set_color(console_bg_color);
			draw_rectangle(_sidebar_x - 1,
							_sidebar_y,
							_sidebar_x + 1,
							_sidebar_y + _sidebar_max_h,
							false);
			draw_set_color(console_text_actual_color);
			var _sidebar_bottom_h = (_sidebar_max_h - _sidebar_cursor_h) * (max(0, console_typeahead_selected)/(_typeahead_max_len - 1));
			if (_bar_on_bottom) {
				draw_rectangle(
					_sidebar_x - 1,
					_bar_y - _sidebar_bottom_h,
					_sidebar_x + 1,
					_bar_y - _sidebar_bottom_h - _sidebar_cursor_h,
					false
				);
			} else {
				draw_rectangle(
					_sidebar_x - 1,
					_sidebar_y + _sidebar_bottom_h,
					_sidebar_x + 1,
					_sidebar_y + _sidebar_bottom_h + _sidebar_cursor_h,
					false
				);
			}
		}
	}
}

// Draw fps
draw_set_alpha(1);
if (console_fps_show) {
	draw_set_halign(fa_right);
	draw_set_valign(fa_top);
	draw_set_colour(console_text_actual_color);
	
	var _x = _gui_w - 2;
	var _y = 2;
	
	draw_text(_x, _y,
		"FPS: "		+ console_fps + "\n" +
		"FPS REAL: "+ console_fps_real + "\n" +
		"FPS AVG: "	+ console_fps_avg
	);
}
