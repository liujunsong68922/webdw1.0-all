package com.webdw
{
// 'summary属性定义
public class WebDW_Summary {
	public var height:int = 0;

	public var color:int = 0;

	public function Clone(): WebDW_Summary {

		var newOne:WebDW_Summary = new WebDW_Summary();

		newOne.height = height;

		newOne.color = color;

		return newOne;
	}
}
}