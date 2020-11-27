/**
 * 由于Java对于字体的操作和VB不同 因此需要自定义一个Font类出来，使之可以变通接收Get Set类方法 减少代码迁移的工作量
 * 说明：jswebdw的前端样式由前端样式表负责控制，因此上这个类是无效的。
 * 这个类已经废弃掉了
 * @author liujunsong
 * 
 */
class Font{
	//construtor
	constructor(family,face,size){
		this.family = family;
		this.face = face;
		this.size = size;
		
	}
	
}

class MyFont{
	//constructor function
	constructor(){
		this.stf = new Font("Serif", Font.PLAIN, 24);
		this.Italic=false;
		this.Bold=false;
		this.Name="";
		this.Size=0;
		this.ReadMe="MyFont";
	}

	/*
	 * 设置Bold属性Set方法
	 */
	 Bold(isbold) {
		// 粗体属性与要设置的相同，直接退出
		if (stf.isBold() == isbold) {
			return;
		}

		// 先将字体设置为非粗体
		if (stf.isBold()) {
			stf = new Font(stf.getFamily(), stf.getStyle() - Font.BOLD, stf
					.getSize());
		}

		if (isbold) {
			stf = new Font(stf.getFamily(), stf.getStyle() + Font.BOLD, stf
					.getSize());
		}
		refresh();
	}
	/*
	 * 设置Italic属性Set方法
	 */
	Italic(isItalic) {
		// 粗体属性与要设置的相同，直接退出
		if (stf.isItalic() == isItalic) {
			return;
		}

		// 先将字体设置为非粗体
		if (stf.isItalic()) {
			stf = new Font(stf.getFamily(), stf.getStyle() - Font.ITALIC, stf
					.getSize());
		}

		if (isItalic) {
			stf = new Font(stf.getFamily(), stf.getStyle() + Font.ITALIC, stf
					.getSize());
		}
		refresh();
	}

	/*
	 * 设置字体名称，Java的字体和window不一致，以后再处理 这一功能需要仔细检查，否则字体不支持
	 */
	Name(facename) {
		// System.out.println("inface:"+facename);
		// System.out.println("decode face:"+Font.decode(facename).getFamily());
		// System.out.println("decode name:"+Font.decode(facename).getName());

		// stf = new Font(Font.decode(facename).getFamily(), stf.getStyle()
		// + Font.ITALIC, stf.getSize());

	}

	Size(size) {
		// System.out.println("size is: " + size);
		stf = new Font(stf.getFamily(), stf.getStyle(), size);
		refresh();
	}

	
	refresh(){
		Bold = stf.isBold();
		Italic = stf.isItalic();
		Name = stf.getFamily();
		Size = stf.getSize();
	}
}
