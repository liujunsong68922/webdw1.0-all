class MyUIComponent {
	// 构造函数,带一个字符串的参数，代表文本值
	constructor(_svalue) {
		// ----------所有界面元素的公用属性定义--------------//
		// 最基本的元素属性定义：classname,id,name,text,tag
		// 每个可实例化的类都有自己的类名称，在常量类中定义
		this.classname = "";
		// id代表最终生成DOM元素的id值，可以通过document.getElementById()来获取DOM对象
		this.Id = "";
		// name代表最终生成DOM元素的name值
		this.Name = "";
		// text代表最终生成DOM元素的text属性（或者是其他关联属性），从数据库中获取的原始值
		this.Text = "";
		// tag代表标签属性，来自数据窗口定义
		this.Tag = "";

		// 最基本的元素位置定义：left,top,width,height,都用像素（px）来表示
		this.Left = 0;
		this.Top = 0;
		this.Width = 0;
		this.Height = 0;	
		
		// 设置Text的初始值
		if(_svalue != null){
			this.Text = _svalue;
		}
	}

	//setName的方法
	setName(sname){
		this.Name = sname;
	}	
	
	// setBounds的方法
	setBounds(xvalue, topvalue, width2, height2) {
		this.Left = xvalue;
		this.Top = topvalue;
		this.Width = width2;
		this.Height = height2;
	}
	// 设置Bounds为一个长方形
	setBounds2(rect) {
		this.setBounds(rect.x, rect.y, rect.width, rect.height);

	}
	
	setText(_text){
		this.Text = _text;
	}
}