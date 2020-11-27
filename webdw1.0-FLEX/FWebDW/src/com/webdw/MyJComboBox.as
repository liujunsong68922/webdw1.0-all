package com.webdw
{
	
import flash.geom.Rectangle;
import mx.controls.ComboBox;

/**
 * 自定义的JPanel类,用来简化代码的迁移功能
 * 
 * @author liujunsong
 * 
 */
public class MyJComboBox extends ComboBox {
//	public void ReadMe() {
//		System.out
//				.println("My Create JSlider,It has the same interface like VB");
//		System.out.println(Golbal.JWebDWInfo);
//	}

	public function MyJComboBox(s1:String , name:String, targetControls:Array,
			parent) {
		super();
		//super(s1);
		super.text=s1;
		//super.setName(name);
		Name = name;
		//super.setLayout(null);
		//super.setName(name);
		// super.setBorder(BorderFactory.createEtchedBorder());
		Refresh();
		targetControls.add(this);
		parent.add(this);
	}

	public var Left:int;

	public var Top:int;

	public var Width:int;

	public var Height:int;

	public var Name:String;

	public var Text:String;

	public var Tag: String = "";

	public function Refresh():void {
		Left = super.x;
		Top = super.y;
		Width = super.width;
		Height = super.height;
		//Name = super.getName();
		Text = super.text;
	}

	public function _Left(xvalue:int):void {
		//super.setBounds(xvalue, Top, Width, Height);
		super.x = xvalue;
		Refresh();
	}

	public function _Top( yvalue:int):void {
		//super.setBounds(Left, yvalue, Width, Height);
		super.y=yvalue;
		Refresh();
	}

	public function _Width(wvalue:int):void {
		//super.setBounds(Left, Top, wvalue, Height);
		super.width = wvalue;
		Refresh();
	}

	public function _Height( hvalue:int):void {
		//super.setBounds(Left, Top, Width, hvalue);
		super.height = hvalue;
		Refresh();
	}

	public function _Name( sname:String):void {
		//super.setName(sname);
		Name = sname;
		Refresh();
	}

	public function _Text(stext:String ):void {
		//super.setText(stext);
		super.text = stext;
		Refresh();
	}

	public function setBounds4( x1:int,  y1:int,  width1:int, height1:int):void {
		//super.setBounds(x, y, width, height);
		super.x = x1;
		super.y = y1;
		super.width = width1;
		super.height = height1;
		Refresh();
	}

	public function setBounds(rect:Rectangle) :void{
		//super.setBounds(rect);
		super.x = rect.x;
		super.y = rect.y;
		super.width = rect.width;
		super.height = rect.height;
		Refresh();
	}
}
}