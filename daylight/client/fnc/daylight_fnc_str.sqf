/*
	Description:	String functions
	Author:			qbt
*/

/*
	Description:	String length
	Args:			str string
	Return:			int strlen
*/
daylight_fnc_strLen = {
	count(toArray _this)
};

/*
	Description:	Resize string
	Args:			arr [str string, int newLen]
	Return:			str stringResized
*/
daylight_fnc_strResize = {
	private ["_arrStrInput"];

	_arrStrInput = toArray (_this select 0);
	_arrStrInput resize (_this select 1);

	(toString _arrStrInput)
};