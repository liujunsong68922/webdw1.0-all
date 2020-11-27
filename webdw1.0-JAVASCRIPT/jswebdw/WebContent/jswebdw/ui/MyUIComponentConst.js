class MyUIComponentConstDefine {
	// constructor
	constructor(){
		// 画板定义
		this.UITYPE_PANEL = "JPanel";
		// 复选框
		this.UITYPE_CHECKBOX = "JCheckBox";
		// 下拉框
		this.UITYPE_COMBOBOX = "JComboBox";
		// 标签文本
		this.UITYPE_LABEL = "JLabel";
		// 单选按钮
		this.UITYPE_RADIOBUTTON = "JRadioButton";
		// 文本框
		this.UITYPE_TEXTFIELD = "JTextField";
		}
}

// 定义一个全局变量,其他地方进行直接引用调用
var MyUIComponentConst = new MyUIComponentConstDefine();
