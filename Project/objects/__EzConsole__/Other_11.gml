/// @description Load skin props
console_width	= console_skin_get_width(ezConsole_skin_current[$ "width"]);
console_height	= console_skin_get_height(ezConsole_skin_current[$ "height"]);

console_anchor	= ezConsole_skin_current[$ "anchor"];
console_position_set_by_anchor(console_anchor);

console_bg_color			= __ezConsole_dep_hex_to_dec(ezConsole_skin_current[$ "bg_color"]);
console_bg_alpha			= ezConsole_skin_current[$ "bg_alpha"];

console_border_color		= __ezConsole_dep_hex_to_dec(ezConsole_skin_current[$ "border_color"]);
console_border_alpha		= ezConsole_skin_current[$ "border_alpha"];

console_text_font			= asset_get_index(ezConsole_skin_current[$ "text_font"]);
console_text_font_xoff		= ezConsole_skin_current[$ "text_font_xoff"];
console_text_font_yoff		= ezConsole_skin_current[$ "text_font_yoff"];
console_text_alpha			= ezConsole_skin_current[$ "text_alpha"];
console_text_actual_color	= __ezConsole_dep_hex_to_dec(ezConsole_skin_current[$ "text_color_common"]);
console_text_blink_rate		= ezConsole_skin_current[$ "text_blink_rate"];
console_text_blink_char		= ezConsole_skin_current[$ "text_blink_char"];
console_text_start_char		= ezConsole_skin_current[$ "text_start_char"];

console_typeahead_text_color		= __ezConsole_dep_hex_to_dec(ezConsole_skin_current[$ "typeahead_text_color"]);
console_typeahead_text_highlight	= __ezConsole_dep_hex_to_dec(ezConsole_skin_current[$ "typeahead_text_color_highlight"]);

console_bar_height			= ezConsole_skin_current[$ "bar_height"];
console_bar_color			= __ezConsole_dep_hex_to_dec(ezConsole_skin_current[$ "bar_color"]);
console_bar_color_highlight	= __ezConsole_dep_hex_to_dec(ezConsole_skin_current[$ "bar_color_highlight"]);
console_bar_inset			= ezConsole_skin_current[$ "bar_inset"];

console_log_xpad			= ezConsole_skin_current[$ "bar_xpad"];
console_log_ypad			= ezConsole_skin_current[$ "bar_ypad"];

console_screenfill_alpha		= ezConsole_skin_current[$ "screenfill_alpha"];
console_screenfill_color		= __ezConsole_dep_hex_to_dec(ezConsole_skin_current[$ "screenfill_color"]);

console_blur_amount				= ezConsole_skin_current[$ "blur_amount"];
