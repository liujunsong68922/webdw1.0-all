package com.webdw
{
// 'text的支持属性定义
// '从配置文件中读入到这个结构中
// '再用这个结构来绘图显示
// '属性名称与属性文件中定义的相同，不与控件本身一致
// '属性名全用小写
public class WebDW_Text {
	public var band :String = "";

	public var alignment :int = 0;

	public var text :String = "";

	public var border :int = 0;

	public var color :int = 0;

	public var x :int = 0;

	public var y :int = 0;

	public var height :int = 0;

	public var width :int = 0;

	public var Name :String = "";

	public var font:WebDW_Font = new WebDW_Font(); // '新定义的font属性

	public var background_mode :int = 0;

	public var background_color :int = 0;

	public function Clone():WebDW_Text  {

		var newOne:WebDW_Text = new WebDW_Text();

		newOne.band = band;

		newOne.alignment = alignment;

		newOne.text = text;

		newOne.border = border;

		newOne.color = color;

		newOne.x = x;

		newOne.y = y;

		newOne.height = height;

		newOne.width = width;

		newOne.Name = Name;

		newOne.font = font.Clone(); // '新定义的font属性

		newOne.background_mode = background_mode;

		newOne.background_color = background_color;

		return newOne;
	}
}

}