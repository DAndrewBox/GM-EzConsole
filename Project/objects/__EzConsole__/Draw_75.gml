/// @description Draw above everything on GUI
if !(visible) exit;
display_set_gui_maximize();

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _bar_y = console_y + console_height - console_bar_height;

draw_set_alpha(1);

// Draw drop-shadow if window mode (only the focused console casts one)
if (console_anchor == EZ_CONSOLE_ANCHOR.NONE && console_focused) {
	var _offset = console_bar_height / 2;
	var _height = (console_height * console_window_open) + console_bar_height + (2 * _offset);
	
	draw_sprite_stretched_ext(
		s_ezConsole_shadow, 0,
		console_x - _offset,
		console_y - console_bar_height - _offset,
		console_width + (2 * _offset),
		_height,
		c_white,
		.50
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
	
	/* [Bugfix EZC-3]
		Blur surface kept its old size after the console was resized.
	*/
	if (surface_exists(console_blur_surf)
	&& (surface_get_width(console_blur_surf) != console_width
	||  surface_get_height(console_blur_surf) != console_height)) {
		surface_free(console_blur_surf);
	}
	
	if (!surface_exists(console_blur_surf)) {
		console_blur_surf = surface_create(console_width, console_height);
	}
	
	/* [Bugfix EZC-4]
		Blur always grabbed the top-left corner of the application surface
		instead of the region behind the console. The console rect lives in GUI
		space, so it has to be converted to application surface space first.
	*/
	var _app_xscale = surface_get_width(application_surface) / max(1, _gui_w);
	var _app_yscale = surface_get_height(application_surface) / max(1, _gui_h);
	
	surface_set_target(console_blur_surf);
	draw_clear_alpha(console_bg_color, .0);
	draw_surface_part_ext(
		application_surface,
		console_x * _app_xscale,
		console_y * _app_yscale,
		console_width * _app_xscale,
		console_height * _app_yscale,
		0,
		0,
		1 / _app_xscale,
		1 / _app_yscale,
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
	
    draw_set_alpha(console_focused ? console_bg_alpha : console_bg_alpha * .66)
    draw_set_colour(console_bar_color); 
    draw_rectangle(console_x + _bar_inset, _bar_y + _bar_inset, console_x + console_width - _bar_inset - (ezConsole_enable_resize ? ezConsole_prop_resize_grip + 2 : 0), _bar_y + console_bar_height - _bar_inset, false);
    
    draw_set_alpha(console_bg_alpha);
}

if (console_border_alpha > .0) {
	var _no_anchor = console_anchor == EZ_CONSOLE_ANCHOR.NONE;
	draw_set_alpha(console_border_alpha);
	draw_set_colour(console_focused ? console_bar_color_highlight : console_border_color);
	
	if (console_window_open) {
		draw_rectangle(console_x, console_y - (_no_anchor * console_bar_height), console_x + console_width, _bar_y + console_bar_height, true);
        
        draw_set_colour(console_border_color);
		draw_line(console_x + console_log_xpad, _bar_y - 1, console_x + console_width - console_log_xpad, _bar_y - 1);
	} else {
		draw_rectangle(console_x, console_y - (_no_anchor * console_bar_height), console_x + console_width, console_y, true);
	}
}

#region // Resize grip on the bottom-right corner
if (ezConsole_enable_resize && console_window_open) {
	var _corner_x	= console_x + console_width;
	var _corner_y	= console_y + console_height;
	var _grip_pad	= 3;
	var _grip_lines	= 3;
	var _grip_step	= 4;
	
	draw_set_alpha(1);
	draw_set_colour(console_resize_hover ? console_bar_color_highlight : console_border_color);
	
	for (var i = 1; i <= _grip_lines; i++) {
		var _len = i * _grip_step;
		draw_line(
			_corner_x - _grip_pad - _len, _corner_y - _grip_pad,
			_corner_x - _grip_pad, _corner_y - _grip_pad - _len
		);
	}
	
	draw_set_alpha(1);
}
#endregion

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
	var _title_x = console_x + console_log_xpad * 5;
	var _title_y = (console_y - console_bar_height / 2) + 2;
	
	draw_text(_title_x, _title_y, console_window_title);
	
	// Short-lived notice after a copy or a paste, so the log never has to record it.
	if (console_notice_t > 0 && console_notice_text != "") {
		draw_set_alpha(min(1, console_notice_t / max(1, game_get_speed(gamespeed_fps) * .5)));
		draw_set_colour(console_bar_color_highlight);
		draw_text(
			_title_x + string_width(console_window_title + "  "),
			_title_y,
			$"- {console_notice_text}"
		);
		draw_set_alpha(1);
	}

	#region // Title bar buttons
	var _header = console_get_header_buttons();
	if (!is_undefined(_header)) {
		var _radius = round(_header.size / 2) + 2;
		
		/*	The copy and close buttons get a highlight disc behind them while hovered. It is
			drawn first so the icon stays on top of it. */
		if (console_header_hover == "copy" || console_header_hover == "close") {
			var _hovered = (console_header_hover == "copy" ? _header.copy : _header.close);
			
			draw_set_alpha(.85);
			draw_set_colour(console_bar_color_highlight);
			draw_circle((_hovered.x1 + _hovered.x2) / 2 - 1, _header.cy, _radius, false);
		}
		
		draw_sprite_ext(
			s_ezConsole_icon_window_status, console_window_open,
			_header.status.x1, _header.cy,
			1, 1, 0, c_white,
			console_header_hover == "status" ? 1. : ezConsole_prop_header_icon_alpha
		);
		
		draw_sprite_ext(
			s_ezConsole_icon_copy, 0,
			_header.copy.x2, _header.cy,
			1, 1, 0, c_white,
			console_header_hover == "copy" ? 1. : ezConsole_prop_header_icon_alpha
		);
		
		draw_sprite_ext(
			s_ezConsole_icon_toggle, 0,
			_header.close.x2, _header.cy,
			1, 1, 0, c_white,
			console_header_hover == "close" ? 1. : ezConsole_prop_header_icon_alpha
		);
		
		draw_set_alpha(1);
	}
	#endregion
}
#endregion

if (console_window_open) {
	#region // Console bar text
	draw_set_font(console_text_font);

	var _console_text_x	= console_x + console_log_xpad + console_text_font_xoff;

	// The resize grip sits in the bottom-right corner, so the bar has to stop short of it.
	var _bar_pad_right	= console_log_xpad + (ezConsole_enable_resize ? ezConsole_prop_resize_grip + 2 : 0);
	var _bar_text_w		= max(1, console_width - console_log_xpad - console_text_font_xoff - _bar_pad_right);
	var _bar_text_h		= max(1, console_bar_height);

	if (surface_exists(console_bar_surf)
	&& (surface_get_width(console_bar_surf)  != _bar_text_w
	||  surface_get_height(console_bar_surf) != _bar_text_h)) {
		surface_free(console_bar_surf);
	}

	if (!surface_exists(console_bar_surf)) {
		console_bar_surf = surface_create(_bar_text_w, _bar_text_h);
	}

	var _console_msg		= console_text_start_char + console_text_actual;
	var _console_msg_w		= string_width(_console_msg);
	var _console_caret_at	= clamp(string_length(console_text_actual) + console_nav_hor, 0, string_length(console_text_actual));
	var _console_caret_x	= string_width(console_text_start_char + string_copy(console_text_actual, 1, _console_caret_at));
	var _console_suggest	= (ezConsole_enable_suggestions ? console_suggestion_text : "");
	var _console_total_w	= _console_msg_w + string_width(_console_suggest);

	// Follow the text cursor, but never scroll past the end of the line.
	console_bar_xscroll = min(console_bar_xscroll, _console_caret_x);
	console_bar_xscroll = max(console_bar_xscroll, _console_caret_x - _bar_text_w + 2);
	console_bar_xscroll = clamp(console_bar_xscroll, 0, max(0, _console_total_w - _bar_text_w + 2));

	var _console_blink_char =
		( console_focused && (console_text_blink_t < game_get_speed(gamespeed_fps) * .66 || keyboard_key)
		? console_text_blink_char
		: "" );

	var _surf_text_x = -console_bar_xscroll;
	var _surf_text_y = _bar_text_h/2 + 1 + console_text_font_yoff;

	surface_set_target(console_bar_surf);
	draw_clear_alpha(c_black, .0);

	/*	Premultiplied alpha: keeps the glyph edges clean on a transparent surface and
		lets the text cursor sit on top of a character instead of punching a hole in it. */
	gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);

	draw_set_alpha(console_focused ? console_text_alpha : console_text_alpha * .50);
	draw_set_colour(console_text_actual_color);
	draw_set_halign(fa_left);
	draw_set_valign(fa_center);

	draw_text(_surf_text_x, _surf_text_y, _console_msg);

	if (_console_suggest != "") {
		draw_set_alpha(console_text_alpha * .50);
		draw_text(_surf_text_x + _console_msg_w, _surf_text_y, _console_suggest);
		draw_set_alpha(console_text_alpha);
	}

	if (_console_blink_char != "") {
		draw_text(_surf_text_x + _console_caret_x, _surf_text_y, _console_blink_char);
	}

	gpu_set_blendmode(bm_normal);
	surface_reset_target();

	draw_set_alpha(1);
	gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	draw_surface(console_bar_surf, _console_text_x, _bar_y + (console_bar_height - _bar_text_h)/2);
	gpu_set_blendmode(bm_normal);
	#endregion

	// Draw text in console
	if !(surface_exists(console_surf)) {
		event_user(0);
	}

	/*	Flash the line that was just copied. Drawn before the log surface, which is cleared
		transparent, so it reads as a highlight behind the text instead of a wash over it. */
	if (console_log_copied_index > -1 && console_log_copied_t > 0) {
		var _copied_layout	= console_get_log_layout();
		var _copied_viewport = console_get_log_viewport();
		
		if (console_log_copied_index < array_length(_copied_layout) && !is_undefined(_copied_viewport)) {
			var _copied_line	= _copied_layout[console_log_copied_index];
			var _copied_top		= max(_copied_line.top, _copied_viewport.y1);
			var _copied_bottom	= min(_copied_line.bottom, _copied_viewport.y2);
			var _copied_fade	= console_log_copied_t / max(1, game_get_speed(gamespeed_fps) * ezConsole_prop_log_copy_flash);
			
			if (_copied_bottom > _copied_top) {
				draw_set_alpha(_copied_fade * .45);
				draw_set_colour(console_bar_color_highlight);
				draw_rectangle(_copied_viewport.x1, _copied_top, _copied_viewport.x2, _copied_bottom, false);
				draw_set_alpha(1);
			}
		}
	}
	
	draw_surface(console_surf, console_x + console_log_xpad, console_y + console_log_ypad);

	// Draw scrollbar
	var _scrollbar = console_get_scrollbar();
	if (!is_undefined(_scrollbar)) {
		var _thumb_y	= console_get_scrollbar_thumb_y(_scrollbar, console_surf_yoffset);
		var _grabbed	= (console_scroll_drag_active || console_scroll_hover);
		
		draw_set_alpha(console_bg_alpha);
		draw_set_color(console_bg_color);
		draw_roundrect_ext(
			_scrollbar.x - 1,
			round(_scrollbar.track_y),
			_scrollbar.x + 1,
			round(_scrollbar.track_y + _scrollbar.track_h),
			8, 8, false
		);
		
		draw_set_color(_grabbed ? console_bar_color_highlight : console_text_actual_color);
		draw_roundrect_ext(
			_scrollbar.x - 2,
			round(_thumb_y),
			_scrollbar.x + 2,
			round(_thumb_y + _scrollbar.thumb_h),
			8, 8, false
		);
	}

	// Draw typeahed
	var _typeahead_max_len = array_length(console_typeahead_elements);
	if (ezConsole_enable_typeahead && console_typeahead_show && _typeahead_max_len > 0) {
		var _typeahead_xoff = max(0, string_width(" " + string_copy(console_text_actual, 1, string_last_pos(" ", console_text_actual))) - console_bar_xscroll);
	
		var _bar_on_bottom = _bar_y > window_get_height() / 2;
		var _typeahead_len = min(_typeahead_max_len, console_typeahead_elements_max) + console_typeahead_selected_yoff;
		var _typeahead_w = 0;
	
		for (var i = 0; i < _typeahead_max_len; i++) {
			_typeahead_w = max(_typeahead_w, string_width(console_typeahead_elements[i]) + console_log_xpad * 2);
		}
		
		// Draw typeahead element
        var _typeahead_icon_xoff = 0;
		for (var i = console_typeahead_selected_yoff; i < _typeahead_len; i++) {
			var _element = string_trim(console_typeahead_elements[i]);
			var _asset_index = asset_get_index(_element);
			var _typeahead_icon_size = (console_bar_height - 4); // 2px border
			_typeahead_icon_xoff = ezConsole_enable_typeahead_icons * console_get_typeahead_asset_valid(_asset_index) * (_typeahead_icon_size + 4);

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
