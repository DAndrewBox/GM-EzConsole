call_later(2, time_source_units_frames, function () {
	#region // Add your custom skins here
	new EzConsoleSkin(
		new EzConsoleSkinOwnership("default-dark-pixel", "DAndrëwBox"),
		new EzConsoleSkinSize(1, .33, EZ_CONSOLE_ANCHOR.BOTTOM_LEFT),
		new EzConsoleSkinBackground(#07071e, #07071e, .66, .33, .20),
		new EzConsoleSkinText(fnt_ezConsole_Smooth, 0, 0, #eeeeee, #ff004d, #ffec27, #8396bc, 1.),
		new EzConsoleSkinBar(16, #0f0f3c, #ffa040, 4, 4),
		new EzConsoleSkinMisc("_", 1, ">", #07071e, .33, #eeeeee, #0f0f3c),
	);
	
	new EzConsoleSkin(
		new EzConsoleSkinOwnership("default-ImGui", "DAndrëwBox"),
		new EzConsoleSkinSize(.50, .33, EZ_CONSOLE_ANCHOR.NONE),
		new EzConsoleSkinBackground(#111111, #4f4f4f, .85, 1., .10),
		new EzConsoleSkinText(fnt_ezConsole_Smooth, 0, 0, #FFFFFF, #ff0000, #ffff00, #838383, 1.),
		new EzConsoleSkinBar(16, #1e304a, #397ccd, 4, 4, 2),
		new EzConsoleSkinMisc("_", 1, ">", #000000, .0, #FFFFFF, #FFFFFF),
	);
	#endregion
});