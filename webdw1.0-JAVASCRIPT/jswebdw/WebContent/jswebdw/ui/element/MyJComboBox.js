class MyJComboBox extends MyUIElement {
	constructor(name, targetControls, parent) {
		super(name);
		super.classname = MyUIComponentConst.UITYPE_COMBOBOX; 
		super.setName(name);
		this.Refresh();
		
		this._ReadMe="MyJComboBox";
		//values代表所有可选项的组合，传递到前端形成下拉框的列表数据
		this.values="";
		//selectedIndex代表实际取值对应于列表中的序号，后端计算得到，传递到前台做显示
		this.selectedIndex=0;			
		
		targetControls.push(this);
		//parent.add(this);
	}	
	
	getSelectedIndex() {
		return this.selectedIndex;
	}

	setSelectedIndex(selectedIndex) {
		this.selectedIndex = selectedIndex;
	}

	Refresh() {
		try{
//		Text = getSelectedItem().toString();
		}catch( e){
			this.Text="";
		}
	}

	getValues() {
		return this.values;
	}

	setValues( values) {
		this.values = values;
	}

}