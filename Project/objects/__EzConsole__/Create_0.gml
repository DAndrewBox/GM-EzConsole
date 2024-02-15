/// @description Setup
if (ezConsole_debug_only && debug_mode) {
	instance_destroy(id, false);
	exit;
}

visible = ezConsole_prop_start_open;

try {
	console_width	= console_skin_get_width(ezConsole_skin_current[$ "width"]);
	console_height	= console_skin_get_height(ezConsole_skin_current[$ "height"]);
	
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

console_anchor	= ezConsole_skin_current[$ "anchor"];
console_position_set_by_anchor(console_anchor);

console_bg_color			= __ezConsole_dep_hex_to_dec(ezConsole_skin_current[$ "bg_color"]);
console_bg_alpha			= ezConsole_skin_current[$ "bg_alpha"];

console_text_font			= asset_get_index(ezConsole_skin_current[$ "text_font"]);
console_text_font_xoff		= ezConsole_skin_current[$ "text_font_xoff"];
console_text_font_yoff		= ezConsole_skin_current[$ "text_font_yoff"];
console_text_alpha			= ezConsole_skin_current[$ "text_alpha"];
console_text_log			= ds_list_create();
console_text_actual			= "";
console_text_actual_color	= __ezConsole_dep_hex_to_dec(ezConsole_skin_current[$ "text_color_common"]);
console_text_blink_t		= 0;
console_text_blink_rate		= ezConsole_skin_current[$ "text_blink_rate"];
console_text_blink_char		= ezConsole_skin_current[$ "text_blink_char"];
console_text_start_char		= ezConsole_skin_current[$ "text_start_char"];

console_bar_height			= ezConsole_skin_current[$ "bar_height"];
console_bar_color			= __ezConsole_dep_hex_to_dec(ezConsole_skin_current[$ "bar_color"]);
console_bar_color_highlight	= __ezConsole_dep_hex_to_dec(ezConsole_skin_current[$ "bar_color_highlight"]);

console_log_xpad			= ezConsole_skin_current[$ "bar_xpad"];
console_log_ypad			= ezConsole_skin_current[$ "bar_ypad"];
console_log_total_h			= 0;

console_surf				= -1;
console_surf_yoffset		= 0;
console_surf_yoffset_to		= 0;

console_key_toggle			= ezConsole_key_toggle;
console_key_nav_up			= vk_up;
console_key_nav_down		= vk_down;
console_key_nav_left		= vk_left;
console_key_nav_right		= vk_right;

console_nav_hor				= 0;
console_nav_scroll			= 0;
console_nav_scroll_speed	= ezConsole_prop_nav_scroll_speed;

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
console_blur_amount				= ezConsole_skin_current[$ "blur_amount"];

console_screenfill_flag			= ezConsole_enable_screenfill;
console_screenfill_color		= __ezConsole_dep_hex_to_dec(ezConsole_skin_current[$ "screenfill_color"]);
console_screenfill_alpha		= ezConsole_skin_current[$ "screenfill_alpha"];

console_suggestions_flag		= ezConsole_enable_suggestions;
console_suggestion_text			= "";

console_typeahead_flag			= ezConsole_enable_typeahead;
console_typeahead_show			= false;
console_typeahead_elements		= [];
console_typeahead_selected		= -1;
console_typeahead_elements_max	= ezConsole_prop_typeahead_elements;
console_typeahead_selected_yoff	= 0;
console_typeahead_text_color		= __ezConsole_dep_hex_to_dec(ezConsole_skin_current[$ "typeahead_text_color"]);
console_typeahead_text_highlight	= __ezConsole_dep_hex_to_dec(ezConsole_skin_current[$ "typeahead_text_color_highlight"]);


depth = ezConsole_prop_depth;
display_set_gui_maximize();
surface_depth_disable(true);

/* Initial message */
var _init_message = console_get_message(EZ_CONSOLE_MSG.INTIALIZATION, "");
console_write_log(_init_message, EZ_CONSOLE_MSG_TYPE.WARNING);