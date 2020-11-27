package com.webdw
{
// 'WebDW用到的内部Font定义，
// '这个Font属性对text和column有效
// '20081225日增加

public class WebDW_Font {
	public var face :String= "";

	public var height :int =0;

	public var weight :int =0;

	public var family :int =0;

	public var pitch :int =0;

	public var charset :int =0;

	public var italic :int =0;

	public var underline :int =0;

	public var strikethrough :int =0;

	public  function Clone():WebDW_Font {

		var newOne:WebDW_Font = new WebDW_Font();

		newOne.face = face;

		newOne.height = height;

		newOne.weight = weight;

		newOne.family = family;

		newOne.pitch = pitch;

		newOne.charset = charset;

		newOne.italic = italic;

		newOne.underline = underline;

		newOne.strikethrough = strikethrough;

		return newOne;
	}
}

}