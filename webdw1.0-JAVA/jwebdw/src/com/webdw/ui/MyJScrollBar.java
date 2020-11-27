package com.webdw.ui ;

import com.webdw.*;

import java.awt.Container;
import java.util.ArrayList;

import javax.swing.BorderFactory;
import javax.swing.JScrollBar;

/**
 * 自定义的JScrollBar类,用来简化代码的迁移功能
 * 
 * @author liujunsong
 * 
 */
public class MyJScrollBar extends JScrollBar {
	public void ReadMe() {
		System.out
				.println("My Create JSlider,It has the same interface like VB");
		System.out.println(Golbal.JWebDWInfo);
	}

	public MyJScrollBar(String name,ArrayList targetControls,Container parent) {
		super.setName(name);
		super.setLayout(null);
		super.setBorder(BorderFactory.createEtchedBorder());
		super.setMinimum(0);
		super.setValue(0);
		super.setMaximum(0);
		super.setUnitIncrement(1);
		super.setBlockIncrement(2);
		Refresh();
		targetControls.add(this);
		parent.add(this);
	}
	public int Left;

	public int Top;

	public int Width;

	public int Height;

	public String Name;

	public String Tag = "";

	public int SmallChange=0;
	
	public int LargeChange=0;
	
	public int Min=0;
	
	public int Max=0;
	
	public int Value=0;
	
	
	public void Refresh() {
		Left = super.getX();
		Top = super.getY();
		Width = super.getWidth();
		Height = super.getHeight();
		Name = super.getName();
		SmallChange = super.getUnitIncrement();
		LargeChange = super.getBlockIncrement();
		Min = super.getMinimum();
		Max = super.getMaximum();
		Value = super.getValue();
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

	public void setBounds(int x, int y, int width, int height) {
		super.setBounds(x, y, width, height);
		Refresh();
	}

	public void setBounds(java.awt.Rectangle rect) {
		super.setBounds(rect);
		Refresh();
	}
	
	public void SmallChange(int i){
		super.setUnitIncrement(i);
		Refresh();
	}
	
	public void LargeChange(int i){
		super.setBlockIncrement(i);
		Refresh();
	}
	
	public void Min(int i){
		super.setMinimum(i);
		Refresh();
	}
	
	public void Max(int i){
		super.setMaximum(i);
		Refresh();
	}
	
	public void Value(int i){
		super.setValue(i);
		Refresh();
	}
}
