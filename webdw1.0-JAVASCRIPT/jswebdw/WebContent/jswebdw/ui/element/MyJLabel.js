class MyJLabel extends MyUIElement {
	// constructor
	constructor(s1, name, targetControls, parent) {
		super(s1);
		super.classname = MyUIComponentConst.UITYPE_LABEL;
		super.setName(name);
		this._ReadMe = ("MyJLabel define");
		targetControls.push(this);
		//if(parent!=null && parent.instanceof(MyUIContainer)){
		//	parent.add(this);
		//}
	}
}
