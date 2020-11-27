package com.webdw
{
	
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import mx.containers.Panel;
import mx.controls.TextInput;
import mx.controls.Alert;

/**
 * 自定义的JPanel类,用来简化代码的迁移功能
 * 
 * @author liujunsong
 * 
 */
public class MyJTextField extends TextInput {
	private var parentDW: CWebDWUI_ParentDW = null;	
	public var tag:String ="";
		private function updateTextData(event:Event):void {
			//Alert.show("enter updateTextData");
			//System.out.println("enter.");
			//Refresh();
			// '为避免重复进行无效功能调用，如果tag="reenter"，就啥也不干
			if (tag==("reenter")) {
				tag = "";
				return;
			}
			var rowid:MyInt = new MyInt(0);
			var colid:MyInt = new MyInt(0);
			var iret:int = parentDW.GetRowIdColumnId(name, rowid, colid);// '得到当前行，当前列
			if (iret == 0) {
				iret = parentDW.DW_SetItem(rowid.intvalue, colid.intvalue, text);// '设置数据
				// If iret = -1 Then
				// 'myTextBox.tag = "reenter" '设置重入标志
				// 'myTextBox.text = DW_GetItemString(rowid, colid)
				// 'myTextBox.tag = ""
				// End If
			}
		}

		private function setCurrentRow(event: Event):void {
			var rowid:MyInt = new MyInt(0);
			var colid:MyInt = new MyInt(0);
			var iret:int = parentDW.GetRowIdColumnId(name, rowid, colid);// '得到当前行，当前列
			if (iret == 0) {
				iret = parentDW.DW_SetRow(rowid.intvalue);
				// If iret = -1 Then
				// 'myTextBox.tag = "reenter" '设置重入标志
				// 'myTextBox.text = DW_GetItemString(rowid, colid)
				// 'myTextBox.tag = ""
				// End If
			}

		} 
	
	public function MyJTextField(s1:String , name1:String, targetControls:Array,
			parent:Panel,pdw: CWebDWUI_ParentDW) {
		super();
		this.text=s1;
		this.name=name1;
		parentDW = pdw;
		targetControls.push(this);
		parent.addChild(this);
		this.addEventListener(MouseEvent.MOUSE_DOWN,setCurrentRow);
		this.addEventListener(KeyboardEvent.KEY_UP,updateTextData);
	}

	public function setBounds4( x1:int,  y1:int,  width1:int, height1:int):void {
		//super.setBounds(x, y, width, height);
		super.x = x1;
		super.y = y1;
		super.width = width1;
		super.height = height1;
	}

	public function setBounds(rect:Rectangle) :void{
		//super.setBounds(rect);
		super.x = rect.x;
		super.y = rect.y;
		super.width = rect.width;
		super.height = rect.height;
	}
	
	
}
}