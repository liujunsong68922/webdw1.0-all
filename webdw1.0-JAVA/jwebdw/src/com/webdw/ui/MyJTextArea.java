package com.webdw.ui ;

import com.webdw.*;

import java.util.ArrayList;

import javax.swing.BorderFactory;
import javax.swing.JTextArea;
import java.awt.Container;

/**
 * 自定义的JPanel类,用来简化代码的迁移功能
 * 
 * @author liujunsong
 * 
 */
public class MyJTextArea extends JTextArea {
	public void ReadMe() {
		System.out
				.println("My Create JSlider,It has the same interface like VB");
		System.out.println(Golbal.JWebDWInfo);
	}

	/**
	 * 带有一个ArrayList的构造函数,在创建此对象以后,把自己放入到这个ArrayList里面
	 * 
	 * @param targetControls
	 */
	public MyJTextArea(String stext,String name,ArrayList targetControls,Container parent) {
		super.setText(stext);
		super.setName(name);
		super.setLayout(null);
		super.setBorder(BorderFactory.createEtchedBorder());
		Refresh();
		targetControls.add(this);
		parent.add(this);
	}

	public int Left;

	public int Top;

	public int Width;

	public int Height;

	public String Name;

	public String Text;
	
	public String Tag = "";

	public boolean Locked = false;
	
	public void Refresh() {
		Left = super.getX();
		Top = super.getY();
		Width = super.getWidth();
		Height = super.getHeight();
		Name = super.getName();
		Text = super.getText();
		Locked = ! super.isEditable();
	}

	public void Left(int xvalue) {
		super.setBounds(xvalue, Top, Width, Height);
		Refresh();
	}

	public void Top(int yvalue) {
		super.setBounds(Left, yvalue, Width, Height);
		Refresh();
	}

	public void Width(int wvalue) {
		super.setBounds(Left, Top, wvalue, Height);
		Refresh();
	}

	public void Height(int hvalue) {
		super.setBounds(Left, Top, Width, hvalue);
		Refresh();
	}

	public void Name(String sname) {
		super.setName(sname);
		Refresh();
	}
	
	public void Text(String stext){
		super.setText(stext);
		Refresh();
	}

	public void setBounds(int x, int y, int width, int height) {
		super.setBounds(x, y, width, height);
		Refresh();
	}

	public void setBounds(java.awt.Rectangle rect) {
		super.setBounds(rect);
		Refresh();
	}
	
	public void Locked(boolean b){
		super.setEditable(! b);
		Refresh();
	}
}
