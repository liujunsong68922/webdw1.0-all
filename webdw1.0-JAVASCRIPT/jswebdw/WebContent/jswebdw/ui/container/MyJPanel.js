class MyJPanel extends MyUIContainer {
	// constructor
	constructor(name, targetControls, parent) {
		super(name);
		super.classname = MyUIComponentConst.UITYPE_PANEL;
		if(targetControls != null){
			targetControls.add(this);
		}
		
		if(parent != null){
			parent.add(this);
		}
	}
}