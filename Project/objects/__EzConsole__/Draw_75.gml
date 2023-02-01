/// @description Draw above everything on GUI
if !(visible) exit;
var _bar_y = console_y + console_height - console_bar_height;

draw_set_alpha(1);

// Draw screenfill
if (console_screenfill_flag) {
	draw_set_alpha(console_screenfill_alpha);
	draw_set_colour(console_screenfill_color);
	draw_rectangle(0, 0, window_get_width(), window_get_height(), false);
}

// Draw blurred background
if (console_blur_flag && surface_exists(application_surface)) {
	draw_set_alpha(1);
	if (!surface_exists(console_blur_surf)) {
		console_blur_surf = surface_create(console_width, console_height);
	}
	surface_set_target(console_blur_surf);
	draw_clear_alpha(console_bg_color, .0);
	draw_surface_part_ext(
		application_surface,
		console_x,
		console_y,
		console_width,
		console_height - 1,
		0,
		0,
		window_get_fullscreen() ? display_get_width() / __original_window_w : 1,
		window_get_fullscreen() ? display_get_height() / __original_window_h : 1,
		-1,
		1
	);
	surface_reset_target();
	
	__ezConsole_dep_draw_surface_blur(console_blur_surf, console_blur_amount, console_x, console_y);
}

// Draw console layout
draw_set_alpha(console_bg_alpha);
draw_set_colour(console_bg_color);
draw_rectangle(console_x, console_y, console_x + console_width, _bar_y, false);

draw_set_colour(console_bar_color);
draw_rectangle(console_x, _bar_y, console_x + console_width, _bar_y + console_bar_height, false);

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
if (console_suggestions_flag && console_suggestion_text != "") {
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
	draw_set_alpha(console_bg_alpha);
	draw_set_color(console_bg_color);
	draw_rectangle(_sidebar_x - 1,
				   _sidebar_y,
				   _sidebar_x + 1,
				   _sidebar_y + _sidebar_max_h,
				   false);
	draw_set_color(console_text_actual_color);
	draw_rectangle(_sidebar_x - 2,
				   _sidebar_y + console_surf_yoffset/console_log_total_h * _sidebar_max_h - 1,
				   _sidebar_x + 2,
				   _sidebar_y + console_surf_yoffset/console_log_total_h * _sidebar_max_h + 1,
				   false);
}

// Draw typeahed
if (console_typeahead_flag && console_typeahead_show) {	
	var _bar_on_bottom = _bar_y > window_get_height() / 2;
	for (var i = 0; i < array_length(console_typeahead_elements); i++) {
		draw_set_alpha(.90);
		draw_set_color(console_typeahead_selected == i ? console_bar_color_highlight : console_bar_color);
		if (_bar_on_bottom) {
			draw_rectangle(
				console_x,
				_bar_y - console_bar_height * i,
				console_x + console_width / 7,
				_bar_y - console_bar_height - console_bar_height * i,
				false
			);
		} else {
			draw_rectangle(
				console_x,
				_bar_y + console_bar_height + console_bar_height * i,
				console_x + console_width / 7,
				_bar_y + console_bar_height * 2 + console_bar_height * i,
				false
			);
		}
		
		draw_set_alpha(console_text_alpha);
		draw_set_color(console_text_actual_color);
		if (_bar_on_bottom) {
			draw_text(
				_console_text_x,
				_bar_y - console_bar_height * i - string_height(console_typeahead_elements[i]) / 2 + 1 + console_text_font_yoff,
				console_typeahead_elements[i]
			);
		} else {
			draw_text(
				_console_text_x,
				_bar_y + console_bar_height * 2 + console_bar_height * i - string_height(console_typeahead_elements[i]) / 2 + 1 + console_text_font_yoff,
				console_typeahead_elements[i]
			);
		}
	}
}

// Draw fps
draw_set_alpha(1);
if (console_fps_show) {
	draw_set_halign(fa_right);
	draw_set_valign(fa_top);
	draw_set_colour(console_text_actual_color);
	
	var _x = window_get_width() - 2;
	var _y = 2;
	
	draw_text(_x, _y, "FPS: "		+ console_fps + "\n" +
					  "FPS REAL: "	+ console_fps_real + "\n" +
					  "FPS AVG: "	+ console_fps_avg);
}