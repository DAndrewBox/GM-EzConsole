/// @description Setup surface
var _surf_h = console_height - console_bar_height - (2 * console_log_ypad);
console_surf = surface_create(console_width - (2 * console_log_xpad), _surf_h);

surface_set_target(console_surf);
draw_clear_alpha(console_bg_color, 0);
gpu_set_blendenable(false);

var _timestamp_width = 80;
var _msg_width = console_width - _timestamp_width - (2 * console_log_xpad);
var _next_msg_yoff = 0;

draw_set_alpha(console_text_alpha);
draw_set_font(console_text_font);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

console_log_total_h = 0;
for (var i = 0; i < ds_list_size(console_text_log); i++) {
	var _next_msg_y = _next_msg_yoff + console_log_ypad - console_surf_yoffset;
	
	draw_set_color(console_text_log[| i].color);
	
	if (console_text_log[| i].type == EZ_CONSOLE_MSG_TYPE.COMMON) {
		// Draws a user input
		draw_text(console_log_xpad, _next_msg_y, console_text_log[| i].timestamp);
		draw_text_ext(console_log_xpad + _timestamp_width, _next_msg_y, console_text_log[| i].message, -1, _msg_width);
		_next_msg_yoff += string_height_ext(console_text_log[| i].message, -1, _msg_width) + 3;
	} else {
		// Draws a system response
		draw_text_ext(console_log_xpad, _next_msg_y, console_text_log[| i].message, -1, _msg_width + _timestamp_width);
		_next_msg_yoff += string_height_ext(console_text_log[| i].message, -1, _msg_width + _timestamp_width) + 3;
	}
}

console_log_total_h = _next_msg_yoff - _surf_h;

gpu_set_blendenable(true);
surface_reset_target();