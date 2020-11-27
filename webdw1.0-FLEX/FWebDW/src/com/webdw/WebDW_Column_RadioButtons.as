package com.webdw
{
	import mx.controls.Button;

public class WebDW_Column_RadioButtons {
	public var Columns:int = 0; //

	public function Clone():WebDW_Column_RadioButtons {

		var newOne:WebDW_Column_RadioButtons = new WebDW_Column_RadioButtons();

		newOne.Columns = Columns;

		return newOne;
	}
}
}