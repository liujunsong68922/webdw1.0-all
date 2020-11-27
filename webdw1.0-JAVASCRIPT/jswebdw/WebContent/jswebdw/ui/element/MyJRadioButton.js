class MyJRadioButton extends MyUIElement {
	constructor(s1, name, targetControls, parent) {
		super(s1);
		super.classname = MyUIComponentConst.UITYPE_RADIOBUTTON;
		super.setName(name);
		
		this._ReadMe="My JRadioButton";
		this.Value = false;
		this.Enabled = false;
		this.selected = false;
		
		//RadioButton 应该隶属于一个parent来进行处理，不能直接加入到目标targetControls
		//RadioButton 是一个二级的UI元素对象
		//targetControls.add(this);
		parent.add(this);
	}

	isSelected() {
		return selected;
	}

	setSelected(selected) {
		this.selected = selected;
	}

}