/// @description On Game End
if (is_callable(ezConsole_callback_onGameEnd)) {
	// Feather ignore once GM1041 - This is already validated to be a callable.
	ezConsole_callback_onGameEnd();
}