package com.webdw
{
// '线条的数据定义类型
public class WebDW_Line {
	public var band :String = "";

	public var x1 :int = 0;

	public var y1 :int = 0;

	public var x2 :int = 0;

	public var y2 :int = 0;

	public var Name :String = "";

	public var pen_style :String = "";

	public var pen_width :String = "";

	public var pen_color :String = "";

	public var background_mode :String = "";

	public var background_color :String = "";

	public function Clone():WebDW_Line {
		var newOne :WebDW_Line= new WebDW_Line();

		newOne.band = band;

		newOne.x1 = x1;

		newOne.y1 = y1;

		newOne.x2 = x2;

		newOne.y2 = y2;

		newOne.Name = Name;

		newOne.pen_style = pen_style;

		newOne.pen_width = pen_width;

		newOne.pen_color = pen_color;

		newOne.background_mode = background_mode;

		newOne.background_color = background_color;

		return newOne;
	}
}
}