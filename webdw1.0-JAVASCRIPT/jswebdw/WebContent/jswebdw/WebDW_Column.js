/**
 * This is the new ES6 type's WebDWSyntax using Class keyword ,instant of
 * function keyword. Author: Mr.Liu Junsong E_main:liujunsong@aliyun.com
 */

class WebDW_Column extends WebDWSyntax_Cloneable {
	constructor(){
		// call super's constructor
		super();
		
		this.band = "";
	
		this.id = 0;
	
		this.alignment = 0;
	
		this.tabsequence = 0;
	
		this.border = 0;
	
		this.color = 0;
	
		this.x = 0;
	
		this.y = 0;
	
		this.height = 0;
	
		this.width = 0;
	
		this.format = "";
	
		this.Name = "";
	
		this.tag = "";
	
		this.edit_limit = 0;
	
		this.edit_case = "";
	
		this.edit_focusrectangle = "";
	
		this.edit_autoselect = "";
	
		this.edit_autohscroll = "";
	
		this.font = new WebDW_Font(); // '重新定义Font结构并使用这个结构来使用
	
		this.background_mode = 0;
	
		this.background_color = 0;
	
		this. radiobuttons = new WebDW_Column_RadioButtons(); // '单选按钮的支持定义20090124
	
		this. checkbox = new WebDW_Column_CheckBox(); // '选择按钮的支持定义20090124
	
		this. combobox = new WebDW_Column_ComboBox(); // '下拉列表框的支持定义20090124
	
		this. dddw = new WebDW_Column_DDDW(); // '下拉数据窗口的支持定义20090125

}
	Clone() {

		var newOne = new WebDW_Column();
		var fields = new Array("band","id","alignment","tabsequence","border",
				"color","x","y","height","width",
				"format","Name","tag",
				"edit_limit","edit_case","edit_focusrectangle","edit_autoselect","edit_autohscroll",
				"background_mode","background_color");
		
		// call super function to clone field value.
		super.F_Clone(this,newOne,fields);

		// the following is object,not only value.
		// call the object's deep clone function.
		newOne.font = this.font.Clone(); // '重新定义Font结构并使用这个结构来使用

		newOne.radiobuttons = this.radiobuttons.Clone(); // '单选按钮的支持定义20090124

		newOne.checkbox = this.checkbox.Clone(); // '选择按钮的支持定义20090124

		newOne.combobox = this.combobox.Clone(); // '下拉列表框的支持定义20090124

		newOne.dddw = this.dddw.Clone(); // '下拉数据窗口的支持定义20090125

		return newOne;
	}
}

