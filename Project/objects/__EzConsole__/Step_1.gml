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

#region // Scrollbar dragging
console_scroll_hover = false;

var _scrollbar = console_get_scrollbar();

if (!is_undefined(_scrollbar) && !console_resize_active && !console_drag_mouse_active) {
	var _grab		= ezConsole_prop_scrollbar_grab;
	var _thumb_y	= console_get_scrollbar_thumb_y(_scrollbar, console_surf_yoffset_to);
	
	var _on_track = point_in_rectangle(
		_mouse_gui_x, _mouse_gui_y,
		_scrollbar.x - _grab, _scrollbar.track_y,
		_scrollbar.x + _grab, _scrollbar.track_y + _scrollbar.track_h
	);
	
	console_scroll_hover = (_on_track || console_scroll_drag_active);
	
	if (!console_scroll_drag_active && _mouse_press && _on_track) {
		var _on_thumb = point_in_rectangle(
			_mouse_gui_x, _mouse_gui_y,
			_scrollbar.x - _grab, _thumb_y,
			_scrollbar.x + _grab, _thumb_y + _scrollbar.thumb_h
		);
		
		/*	Grabbing the thumb keeps the log still under the cursor. Clicking the bare
			track jumps instead, centring the thumb on the click. */
		console_scroll_drag_active	= true;
		console_scroll_drag_yoff	= (_on_thumb ? _mouse_gui_y - _thumb_y : _scrollbar.thumb_h / 2);
	}
}

if (console_scroll_drag_active) {
	if (is_undefined(_scrollbar) || !_mouse_hold) {
		console_scroll_drag_active = false;
	} else {
		var _travelled	= (_mouse_gui_y - console_scroll_drag_yoff) - _scrollbar.track_y;
		var _offset_to	= clamp(_travelled / _scrollbar.travel, 0, 1) * console_log_total_h;
		
		if (_offset_to != console_surf_yoffset_to) {
			console_surf_yoffset_to	= _offset_to;
			// Track the cursor exactly rather than easing behind it while dragging.
			console_surf_yoffset	= _offset_to;
			event_user(0);
		}
	}
}
#endregion

#region // Click a log line to copy it
/*	The scrollbar sits inside the log viewport, so it gets first refusal on the click. */
if (ezConsole_enable_log_copy
&& _mouse_press
&& !console_scroll_hover
&& !console_scroll_drag_active
&& !console_resize_hover
&& !console_drag_mouse_active) {
	var _viewport = console_get_log_viewport();
	
	if (!is_undefined(_viewport)
	&& console_window_open
	&& point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _viewport.x1, _viewport.y1, _viewport.x2, _viewport.y2)) {
		var _layout		= console_get_log_layout();
		var _layout_len	= array_length(_layout);
		
		for (var i = 0; i < _layout_len; i++) {
			if (_mouse_gui_y < _layout[i].top || _mouse_gui_y > _layout[i].bottom) continue;
			
			clipboard_set_text(console_text_log[| i].message);
			
			/*	The highlight is the whole confirmation: writing a "copied!" line to the log
				would push the log around and bury the line that was just copied. */
			console_log_copied_index	= i;
			console_log_copied_t		= game_get_speed(gamespeed_fps) * ezConsole_prop_log_copy_flash;
			console_show_notice("Line copied!");
			break;
		}
	}
}

if (console_log_copied_t > 0) {
	console_log_copied_t--;
	
	if (console_log_copied_t <= 0) {
		console_log_copied_index = -1;
	}
}
#endregion

#region // Middle-click paste
/*	Same gesture as an X11 terminal: the middle button drops the clipboard at the text
	cursor, with no keyboard involved. */
if (ezConsole_enable_middle_paste && console_window_open && mouse_check_button_pressed(mb_middle)) {
	var _paste_y1 = console_y - (console_anchor == EZ_CONSOLE_ANCHOR.NONE ? console_bar_height : 0);
	
	var _mouse_on_console = point_in_rectangle(
		_mouse_gui_x, _mouse_gui_y,
		console_x, _paste_y1,
		console_x + console_width, console_y + console_height
	);
	
	if (_mouse_on_console) {
		console_focused = true;
		
		if (console_paste_from_clipboard()) {
			console_show_notice("Pasted!");
		}
	}
}
#endregion

if (console_notice_t > 0) {
	console_notice_t--;
	
	if (console_notice_t <= 0) {
		console_notice_text = "";
	}
}

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