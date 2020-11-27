package com.webdw
{
// 'header属性定义
public class WebDW_Header {
	public var height:int = 0;

	public var color:int  = 0;

	public function Clone(): WebDW_Header{
		var newOne:WebDW_Header = new WebDW_Header();

		newOne.height = height;

		newOne.color = color;

		return newOne;
	}
}

}