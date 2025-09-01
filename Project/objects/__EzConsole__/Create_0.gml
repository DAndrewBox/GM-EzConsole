/// @description Setup
if (ezConsole_debug_only && debug_mode) {
	instance_destroy(id, false);
	exit;
}

x = 200;
y = 200;

visible = ezConsole_prop_start_open;

try {	
	/* [Bugfix EZC-2]
		Going fullscreen doesn't resize console nor blur surface.
	*/
	__original_window_w = window_get_width();
	__original_window_h = window_get_height();
} catch(e) {
	/* [Bugfix EZC-1]
		Console crash games when starting before main window is initialized.
	*/
	show_debug_message(e.longMessage);
	instance_destroy();
}

#region	Pre-setup props to clear some feather errors
console_x = 0;
console_y = 0;

console_width	= console_skin_get_width(ezConsole_skin_current[$ "width"]);
console_height	= console_skin_get_height(ezConsole_skin_current[$ "height"]);

console_anchor	= ezConsole_skin_current[$ "anchor"];
console_position_set_by_anchor(console_anchor);

console_bg_color			= c_black;
console_bg_alpha			= 1.0;

console_border_color		= c_white;
console_border_alpha		= 1.0;

console_text_font			= fnt_ezConsole_Pixel;
console_text_font_xoff		= 0;
console_text_font_yoff		= 0;
console_text_alpha			= 1.0
console_text_actual_color	= c_white;
console_text_blink_rate		= 1
console_text_blink_char		= "_";
console_text_start_char		= ">";

console_typeahead_text_color		= c_gray;
console_typeahead_text_highlight	= c_orange;

console_bar_height			= 8;
console_bar_color			= c_black;
console_bar_color_highlight	= c_dkgray;
console_bar_inset			= 0;

console_log_xpad			= 4;
console_log_ypad			= 2;

console_screenfill_alpha	= 0.0;
console_screenfill_color	= c_black;

console_blur_amount			= 0;
#endregion

event_user(1);

console_drag_mouse_active	= false;
console_drag_mouse_xoff		= 0;
console_drag_mouse_yoff		= 0;

console_window_title		= $"GameMaker's EzConsole (v{ezConsole_version})";
console_window_open			= true;

console_text_actual			= "";
console_text_blink_t		= 0;

console_text_log			= ds_list_create();
console_log_total_h			= 0;

console_surf				= -1;
console_surf_yoffset		= 0;
console_surf_yoffset_to		= 0;

console_nav_hor				= 0;
console_nav_scroll			= 0;

console_fps_t		= 0;
console_fps_show	= false;
console_fps_real	= string(round(fps_real));
console_fps			= string(round(fps));
console_fps_avg		= string(round(fps));
console_fps_hist	= [];

console_debug_overlay_show		= false;

console_callback_on_open		= ezConsole_callback_onOpen;
console_callback_on_close		= ezConsole_callback_onClose;
console_callback_on_log			= ezConsole_callback_onLog;
console_callback_on_destroy		= ezConsole_callback_onDestroy;
console_callback_on_game_end	= ezConsole_callback_onGameEnd;

console_blur_flag				= ezConsole_enable_blur;
console_blur_surf				= -1;

console_screenfill_flag			= ezConsole_enable_screenfill;
console_suggestions_flag		= ezConsole_enable_suggestions;
console_suggestion_text			= "";

console_typeahead_flag			= ezConsole_enable_typeahead;
console_typeahead_show			= false;
console_typeahead_elements		= [];
console_typeahead_selected		= -1;
console_typeahead_elements_max	= ezConsole_prop_typeahead_elements;
console_typeahead_selected_yoff	= 0;

console_instance_highlight_index = 0;

depth = ezConsole_prop_depth;
display_set_gui_maximize();
surface_depth_disable(true);

/* Initial message */
var _init_message = console_get_message(EZ_CONSOLE_MSG.INTIALIZATION, "");
console_write_log(_init_message, EZ_CONSOLE_MSG_TYPE.WARNING);