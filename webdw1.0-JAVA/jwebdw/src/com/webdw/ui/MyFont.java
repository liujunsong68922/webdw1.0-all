package com.webdw.ui;

import java.awt.Font;


/**
 * 由于Java对于字体的操作和VB不同 因此需要自定义一个Font类出来，使之可以变通接收Get Set类方法 减少代码迁移的工作量
 * 
 * @author liujunsong
 * 
 */
public class MyFont extends com.webdw.Golbal {
	public Font stf = null;// new Font("Serif", Font.PLAIN, 24);// StdFont

	public MyFont() {
		//stf = new Font("宋体", Font.PLAIN, 24);
		stf = new Font("Serif", Font.PLAIN, 24);
	}
	



	public boolean Bold=false;
	/*
	 * 设置Bold属性Set方法
	 */
	public void Bold(boolean isbold) {
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
	public boolean  Italic=false;
	/*
	 * 设置Italic属性Set方法
	 */
	public void Italic(boolean isItalic) {
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
	public String Name="";
	public void Name(String facename) {
		// System.out.println("inface:"+facename);
		// System.out.println("decode face:"+Font.decode(facename).getFamily());
		// System.out.println("decode name:"+Font.decode(facename).getName());

		// stf = new Font(Font.decode(facename).getFamily(), stf.getStyle()
		// + Font.ITALIC, stf.getSize());

	}

	public int Size=0;
	public void Size(int size) {
		// System.out.println("size is: " + size);
		stf = new Font(stf.getFamily(), stf.getStyle(), size);
		refresh();
	}

	public void ReadMe() {
		System.out.println("MyFont");
		System.out.println(JWebDWInfo);
	}
	
	private void refresh(){
		Bold = stf.isBold();
		Italic = stf.isItalic();
		Name = stf.getFamily();
		Size = stf.getSize();
	}
}
