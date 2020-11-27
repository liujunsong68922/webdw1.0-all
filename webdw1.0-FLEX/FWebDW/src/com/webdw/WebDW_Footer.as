package com.webdw
{
// 'footer属性定义
public class WebDW_Footer {
	public var height:int = 0;

	public var color:int = 0;

	public function  Clone():WebDW_Footer {
		var newOne :WebDW_Footer= new WebDW_Footer();

		newOne.height = height;

		newOne.color = color;

		return newOne;
	}
}
}