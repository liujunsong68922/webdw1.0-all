package com.webdw
{
// 'detail属性定义
public class WebDW_Detail {
	public var height :int = 0;

	public var color :int = 0;

	public function Clone():WebDW_Detail {
		var newOne :WebDW_Detail= new WebDW_Detail();

		newOne.height = height;

		newOne.color = color;

		return newOne;
	}
}
}