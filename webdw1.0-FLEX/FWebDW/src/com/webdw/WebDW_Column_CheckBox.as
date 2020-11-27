package com.webdw
{
// '数据列对选择框的支持定义，这是Column的一个属性
public class WebDW_Column_CheckBox {
	public var  text:String = ""; // '显示在界面上的字符串

	public var  on:String = ""; // '选中时的数据值

	public var  off:String = ""; // '未选中时的数据值

	public var  scale1:String = ""; // '含义不明,scale是vb保留字，改名

	public var  threed:String = ""; // '3D显示风格

	public function Clone():WebDW_Column_CheckBox {

		 var  newOne:WebDW_Column_CheckBox = new WebDW_Column_CheckBox();

		newOne.text = text; // '显示在界面上的字符串

		newOne.on = on; // '选中时的数据值

		newOne.off = off; // '未选中时的数据值

		newOne.scale1 = scale1; // '含义不明,scale是vb保留字，改名

		newOne.threed = threed; // '3D显示风格
		return newOne;
	}
}
}