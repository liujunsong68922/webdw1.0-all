package com.webdw
{
// '数据列对下拉数据窗口的支持，这是Column的一个属性
// '20090125日大年三十日添加
public class WebDW_Column_DDDW {
	public var Name :String =""; // '数据窗口的名字，未来用这个字符串来检索此数据窗口

	public var DisplayColumn :String =""; // '显示列的名字，这一列在子数据窗口中

	public var DataColumn :String =""; // '数据列的名字，用这一列来设置原数据窗口

	public var PercentWidth:int = 0; // '百分比表示的显示宽度

	public var Lines :int = 0;

	public var limit :int = 0;

	public var allowedit :String ="";

	public var useasborder :String ="";

	public var case1 :String ="";

	public var vscrollbar :String =""; // '是否显示竖滚动条

	public function Clone():WebDW_Column_DDDW {

		var newOne:WebDW_Column_DDDW = new WebDW_Column_DDDW();

		newOne.Name = Name; // '数据窗口的名字，未来用这个字符串来检索此数据窗口

		newOne.DisplayColumn = DisplayColumn; // '显示列的名字，这一列在子数据窗口中

		newOne.DataColumn = DataColumn; // '数据列的名字，用这一列来设置原数据窗口

		newOne.PercentWidth = PercentWidth; // '百分比表示的显示宽度

		newOne.Lines = Lines;

		newOne.limit = limit;

		newOne.allowedit = allowedit;

		newOne.useasborder = useasborder;

		newOne.case1 = case1;

		newOne.vscrollbar = vscrollbar; // '是否显示竖滚动条

		return newOne;
	}
}
}