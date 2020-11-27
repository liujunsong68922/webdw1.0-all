package com.webdw
{
	import mx.controls.Button;
	
// '
// 'column的支持属性定义，
// '从配置文件中读入到这个结构中
// '再用这个结构来绘图显示
// '属性名称与属性文件中定义的相同,不与控件本身一致
// '属性名全用小写
public class WebDW_Column {
     public var band:String = "";

     public var id :int = 0;

     public var alignment:int  = 0;

     public var tabsequence :int = 0;

     public var border:int  = 0;

     public var color:int  = 0;

     public var x :int = 0;

     public var y:int  = 0;

     public var height:int  = 0;

     public var width:int  = 0;

     public var format:String = "";

     public var Name:String = "";

     public var tag:String = "";

     public var edit_limit:int  = 0;

     public var edit_case:String = "";

     public var edit_focusrectangle :String= "";

     public var edit_autoselect :String= "";

     public var edit_autohscroll:String = "";

     public var font:WebDW_Font = new WebDW_Font(); // '重新定义Font结构并使用这个结构来使用

     public var background_mode:int  = 0;

     public var background_color:int  = 0;

     public var radiobuttons:WebDW_Column_RadioButtons = new WebDW_Column_RadioButtons(); // '单选按钮的支持定义20090124

     public var checkbox:WebDW_Column_CheckBox = new WebDW_Column_CheckBox(); // '选择按钮的支持定义20090124

     public var combobox :WebDW_Column_ComboBox= new WebDW_Column_ComboBox(); // '下拉列表框的支持定义20090124

     public var dddw:WebDW_Column_DDDW = new WebDW_Column_DDDW(); // '下拉数据窗口的支持定义20090125

	public function  Clone():WebDW_Column {

	     var newOne:WebDW_Column = new WebDW_Column();
		newOne.band = band;

		newOne.id = id;

		newOne.alignment = alignment;

		newOne.tabsequence = tabsequence;

		newOne.border = border;

		newOne.color = color;

		newOne.x = x;

		newOne.y = y;

		newOne.height = height;

		newOne.width = width;

		newOne.format = format;

		newOne.Name = Name;

		newOne.tag = tag;

		newOne.edit_limit = edit_limit;

		newOne.edit_case = edit_case;

		newOne.edit_focusrectangle = edit_focusrectangle;

		newOne.edit_autoselect = edit_autoselect;

		newOne.edit_autohscroll = edit_autohscroll;

		newOne.font = font.Clone(); // '重新定义Font结构并使用这个结构来使用

		newOne.background_mode = background_mode;

		newOne.background_color = background_color;

		newOne.radiobuttons = radiobuttons.Clone(); // '单选按钮的支持定义20090124

		newOne.checkbox = checkbox.Clone(); // '选择按钮的支持定义20090124

		newOne.combobox = combobox.Clone(); // '下拉列表框的支持定义20090124

		newOne.dddw = dddw.Clone(); // '下拉数据窗口的支持定义20090125

		return newOne;
	}
}
}