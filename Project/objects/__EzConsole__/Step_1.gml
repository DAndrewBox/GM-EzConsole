/// @description Window/Mouse drag events
if (console_anchor != EZ_CONSOLE_ANCHOR.NONE) exit;

var _mouse_gui_x	= display_mouse_get_x() - window_get_x();
var _mouse_gui_y	= display_mouse_get_y() - window_get_y();
var _mouse_press	= mouse_check_button_pressed(mb_left);
var _mouse_hold		= mouse_check_button(mb_left);
var _mouse_in_area	= point_in_rectangle(_mouse_gui_x, _mouse_gui_y, console_x, console_y - console_bar_height, console_x + console_width, console_y);

if (!console_drag_mouse_active && _mouse_press && _mouse_in_area) {
	console_drag_mouse_active = true;
	console_drag_mouse_xoff = _mouse_gui_x - console_x;
	console_drag_mouse_yoff = _mouse_gui_y - console_y;
	
	var _mouse_in_window_toggle = point_in_rectangle(_mouse_gui_x, _mouse_gui_y, console_x + console_log_xpad, console_y - console_bar_height, console_x + console_log_xpad + 13, console_y);
	if (_mouse_in_window_toggle) {
		console_drag_mouse_active = false;
		console_drag_mouse_xoff = 0;
		console_drag_mouse_yoff = 0;
		console_window_open = !console_window_open;
	}
	
	var _mouse_in_window_close = point_in_rectangle(_mouse_gui_x, _mouse_gui_y, console_x + console_width - console_log_xpad - 13, console_y - console_bar_height, console_x + console_width, console_y);
	if (_mouse_in_window_close) {
		console_drag_mouse_active = false;
		console_drag_mouse_xoff = 0;
		console_drag_mouse_yoff = 0;
		console_set_invisible();
	}
}

if (console_drag_mouse_active) {
	console_x = _mouse_gui_x - console_drag_mouse_xoff;
	console_y = _mouse_gui_y - console_drag_mouse_yoff;
	
	if (!_mouse_hold) {
		console_drag_mouse_active = false;
		console_drag_mouse_xoff = 0;
		console_drag_mouse_yoff = 0;
	}
}

var _debug_view_open = is_debug_overlay_open();
console_x = clamp(console_x, 0, display_get_gui_width() - console_width);
console_y = clamp(console_y, console_bar_height + 19 * _debug_view_open, display_get_gui_height() - console_height * console_window_open);