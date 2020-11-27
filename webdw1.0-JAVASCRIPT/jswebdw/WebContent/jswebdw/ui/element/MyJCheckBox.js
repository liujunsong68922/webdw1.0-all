class MyJCheckBox extends MyUIElement {
	constructor(s1, name, targetControls, parent) {
		super(s1);
		this._ReadMe="MyJCheckBox";
		super.classname = MyUIComponentConst.UITYPE_CHECKBOX;
		super.setName(name);
		// targetControls.add(this);
		targetControls.push(this);
		//parent.add(this);
		
		this.Value = false;
	}


	setValue(value) {
		this.Value = value;
	}
}