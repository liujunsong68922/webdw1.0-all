class MyJTextField extends MyUIElement {
	/**
	 * 带有一个ArrayList的构造函数,在创建此对象以后,把自己放入到这个ArrayList里面
	 * 
	 * @param targetControls
	 */
	constructor(stext, name, targetControls, parent) {
		super(stext);
		super.classname = MyUIComponentConst.UITYPE_TEXTFIELD;
		super.setText(stext);
		super.setName(name);
		

		this.ReadMe = "MyJTextField";
		this.Locked = false;
		
		targetControls.push(this);
		//parent.add(this);
	}
}

