package com.webdw.ui;

import com.webdw.*;

import java.util.ArrayList;

import javax.swing.BorderFactory;
import javax.swing.JLabel;
import java.awt.Container;

/**
 * 自定义的JPanel类,用来简化代码的迁移功能
 * 
 * @author liujunsong
 * 
 */
public class MyJLabel extends JLabel {
	public void ReadMe() {
		System.out
				.println("My Create JSlider,It has the same interface like VB");
		System.out.println(Golbal.JWebDWInfo);
	}

	public MyJLabel(String s1, String name, ArrayList targetControls,
			Container parent) {
		super(s1);
		super.setName(name);
		super.setLayout(null);
		super.setName(name);
		// super.setBorder(BorderFactory.createEtchedBorder());
		Refresh();
		targetControls.add(this);
		if (parent instanceof MyJDialog) {
			MyJDialog d = (MyJDialog) parent;
			d.getContentPane().add(this);
		} else {
			parent.add(this);
		}
	}

	public int Left;

	public int Top;

	public int Width;

	public int Height;

	public String Name;

	public String Text;

	public String Tag = "";

	public void Refresh() {
		Left = super.getX();
		Top = super.getY();
		Width = super.getWidth();
		Height = super.getHeight();
		Name = super.getName();
		Text = super.getText();
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

	public void Text(String stext) {
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
}
