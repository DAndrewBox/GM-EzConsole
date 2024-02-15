call_later(2, time_source_units_frames, function () {
	#region // Add your custom skins here
	new EzConsoleSkin(
		new EzConsoleSkinOwnership("default-dark-example", "DAndrëwBox", "1.3"),
		new EzConsoleSkinSize(1, .33, 0),
		new EzConsoleSkinBackground(#07071e, .66),
		new EzConsoleSkinText(fnt_ezConsole_Smooth, 0, 0, #eeeeee, #ff004d, #ffec27, #8396bc, 1.),
		new EzConsoleSkinBar(16, #0f0f3c, #ffa040, 4, 4),
		new EzConsoleSkinMisc("_", 1, ">", #07071e, .33, #eeeeee, #0f0f3c),
	);
	#endregion
});