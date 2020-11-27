package com.webdw
{
	
import flash.events.Event;
import flash.events.MouseEvent;

import mx.containers.Panel;
import mx.controls.Alert;
import mx.controls.VScrollBar;
import mx.events.ScrollEvent;
import mx.events.StateChangeEvent;
/**
 * 自定义的JPanel类,用来简化代码的迁移功能
 * 
 * @author liujunsong
 * 
 */
public class MyJVScrollBar extends VScrollBar {
	private var parentDW: CWebDWUI_ParentDW = null;
	private function redraw(event:Event):void{
		//Alert.show("HScrollBar.Redraw");
		if (parentDW !=null){
			parentDW.DrawDW();
		}
	}	
	public function MyJVScrollBar(name:String, targetControls:Array,
			parent:Panel,pdw:CWebDWUI_ParentDW) {
		try{
			super();
			parentDW = pdw;
			targetControls.push(this);
			parent.addChild(this);
			//this.addEventListener(ScrollEvent.SCROLL,redraw);
			//this.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE,redraw);
			this.addEventListener(MouseEvent.CLICK,redraw);
			
		}catch(e:Error){
			Alert.show(e.message);
			throw e;
		}
	}
}
}