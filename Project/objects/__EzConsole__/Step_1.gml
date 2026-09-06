/// @description Window/Mouse drag events
if (!visible) {
	console_resize_active = false;
	console_release_cursor();
	exit;
}

display_set_gui_maximize();

var _mouse_gui_x	= display_mouse_get_x() - window_get_x();
var _mouse_gui_y	= display_mouse_get_y() - window_get_y();
var _mouse_press	= mouse_check_button_pressed(mb_left);
var _mouse_hold		= mouse_check_button(mb_left);

#region // Focus
/*	Clicking anywhere on the console focuses it, clicking outside drops the focus.
	Only a focused console reacts to the keyboard. */
if (_mouse_press) {
	var _focus_pad	= (ezConsole_enable_resize ? ezConsole_prop_resize_grip_outer : 0);
	var _focus_y1	= console_y - (console_anchor == EZ_CONSOLE_ANCHOR.NONE ? console_bar_height : 0);
	var _focus_y2	= (console_window_open ? console_y + console_height + _focus_pad : console_y);
	var _was_focused = console_focused;
	
	console_focused = point_in_rectangle(
		_mouse_gui_x, _mouse_gui_y,
		console_x, _focus_y1,
		console_x + console_width + _focus_pad, _focus_y2
	);
	
	if (console_focused != _was_focused) {
		if (console_focused) {
			keyboard_string		= console_text_actual;
			keyboard_lastchar	= "";
			keyboard_lastkey	= vk_nokey;
		} else {
			console_typeahead_show		= false;
			console_typeahead_selected	= -1;
			console_suggestion_text		= "";
		}
	}
}
#endregion

#region // Resize by the bottom-right corner
console_resize_hover = false;

if (ezConsole_enable_resize && console_window_open) {
	var _corner_x	= console_x + console_width;
	var _corner_y	= console_y + console_height;
	var _grip		= ezConsole_prop_resize_grip;
	var _grip_outer	= ezConsole_prop_resize_grip_outer;
	
	var _mouse_in_grip = point_in_rectangle(
		_mouse_gui_x, _mouse_gui_y,
		_corner_x - _grip, _corner_y - _grip,
		_corner_x + _grip_outer, _corner_y + _grip_outer
	);
	
	if (!console_resize_active && !console_drag_mouse_active && _mouse_press && _mouse_in_grip) {
		console_resize_active	= true;
		console_resize_xoff		= _corner_x - _mouse_gui_x;
		console_resize_yoff		= _corner_y - _mouse_gui_y;
		console_resize_from_w	= console_width;
		console_resize_from_h	= console_height;
	}
	
	console_resize_hover = (_mouse_in_grip || console_resize_active);
	
	if (console_resize_active) {
		// Theme size is the floor, whatever is left of the GUI is the ceiling.
		var _max_w = display_get_gui_width() - console_x;
		var _max_h = display_get_gui_height() - console_y;
		
		var _new_w = round(clamp(_mouse_gui_x + console_resize_xoff - console_x, console_width_min, max(console_width_min, _max_w)));
		var _new_h = round(clamp(_mouse_gui_y + console_resize_yoff - console_y, console_height_min, max(console_height_min, _max_h)));
		
		if (_new_w != console_width || _new_h != console_height) {
			console_width	= _new_w;
			console_height	= _new_h;
			console_surfaces_rebuild();
			
			if (console_anchor != EZ_CONSOLE_ANCHOR.NONE) {
				console_position_set_by_anchor(console_anchor);
			}
		}
		
		if (!_mouse_hold) {
			console_resize_active = false;
			
			if (console_width != console_resize_from_w || console_height != console_resize_from_h) {
				ezConsole_info($"Console resized to {console_width}x{console_height}.", false, false);
			}
		}
	}
}

// Only touch the cursor while the console actually owns it.
if (console_resize_hover) {
	window_set_cursor(cr_size_nwse);
	console_cursor_owned = true;
} else {
	console_release_cursor();
}
#endregion

if (console_anchor != EZ_CONSOLE_ANCHOR.NONE) exit;

var _mouse_in_area	= point_in_rectangle(_mouse_gui_x, _mouse_gui_y, console_x, console_y - console_bar_height, console_x + console_width, console_y);

if (!console_drag_mouse_active && !console_resize_active && _mouse_press && _mouse_in_area) {
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
		ezConsole_set_invisible();
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