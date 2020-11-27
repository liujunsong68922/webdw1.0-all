class MyUIContainer extends MyUIComponent {
	// 构造函数，带有一个代表Name属性的构造参数
	constructor(s1) {
		super(s1);
		//所有下级节点的列表存储对象
		this.childElements = new Array();
	}

	//增加下级节点
	add(child) {
		this.childElements.push(child);
	}
	
	//删除下级节点
	remove(child) {
		if (child == null) {
			return;
		}
		var index = this.childElements.indexOf(child);
		if(index >=0 ){
			this.childElements.splice(index,1); //删除此元素
		}
	}
}