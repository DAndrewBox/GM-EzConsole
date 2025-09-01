/// @desc Draw instance selected in typeahead (if active)
if (
	!console_typeahead_flag
	|| !ezConsole_enable_typeahead_inst_ref
	|| console_typeahead_selected == -1
	|| !console_window_open
) exit;

console_instance_highlight_index += .1;
console_instance_highlight_index = console_instance_highlight_index mod 2;
var _selected = console_typeahead_elements[console_typeahead_selected];
var _is_instance = string_pos("(ref ", _selected);
if (_is_instance) {
	var _inst_id = real(string_digits(string_replace(_selected, "(ref ", "")));
	var _inst = instance_find(_inst_id, 0);
		
	if (_inst) {
		var _gamespd = game_get_speed(gamespeed_fps) / 6;
		var _offset = 6 + (2 * dsin(current_time / _gamespd));
			
		draw_set_alpha(1);
		draw_set_color(c_white);
		draw_set_valign(fa_top);
		draw_set_halign(fa_center);
		draw_set_font(console_text_font);
			
		draw_sprite_stretched_ext(
			s_ezConsole_border_highlight,
			console_instance_highlight_index,
			_inst.bbox_left - _offset + 1,
			_inst.bbox_top - _offset + 1,
			_inst.bbox_right - _inst.bbox_left + _offset * 2,
			_inst.bbox_bottom - _inst.bbox_left + _offset * 2,
			console_bar_color_highlight,
			1.
		);
			
		draw_text(
			_inst.bbox_left + (_inst.bbox_right - _inst.bbox_left) / 2,
			_inst.bbox_bottom + 4 + _offset,
			$"ref:{string_split(string(_inst), " ")[2]}"
		);
	}
}