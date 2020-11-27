package com.webdw
{
	
import flash.geom.Rectangle;

import mx.containers.Panel;
import mx.controls.Label;

/**
 * 自定义的JPanel类,用来简化代码的迁移功能
 * 
 * @author liujunsong
 * 
 */
public class MyJLabel extends Label {
//	public void ReadMe() {
//		System.out
//				.println("My Create JSlider,It has the same interface like VB");
//		System.out.println(Golbal.JWebDWInfo);
//	}

	public function MyJLabel(s1:String , name:String, targetControls:Array,
			parent:Panel) {
		super();
		super.text=s1;
		targetControls.push(this);
		parent.addChild(this);
	}


	public function setBounds4( x1:int,  y1:int,  width1:int, height1:int):void {
		//super.setBounds(x, y, width, height);
		super.x = x1;
		super.y = y1;
		super.width = width1;
		super.height = height1;
	}
}
}