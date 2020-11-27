package com.webdw.ui ;

import com.webdw.*;
import java.awt.Container;
import javax.swing.JFrame;
import java.util.ArrayList;
import java.awt.event.*; 

import javax.swing.JDialog;
public class MyJDialog extends JDialog {
	public void ReadMe() {
		System.out
				.println("My Create JDialog,It has the same interface like VB MessageBox");
		System.out.println(Golbal.JWebDWInfo);
	}
	
	public MyJDialog(String stitle,String sinfo,JFrame jframe,ArrayList targetControls ){
		super(jframe,stitle,true);
		this.setBounds(300, 200, 400, 300);
		this.setLayout(null);

		
		MyJLabel text = new MyJLabel(sinfo,"",targetControls,this);
		text.setBounds(100, 30, 400, 200);
		text.setVisible(true);
		//this.add(text);
		
		this.addWindowListener(new WindowAdapter() { 
            public void windowClosing(WindowEvent evt) { 
            	setVisible(false);
            	setModal(false);
            } 
        }); 
		this.setVisible(true);
	}
}
