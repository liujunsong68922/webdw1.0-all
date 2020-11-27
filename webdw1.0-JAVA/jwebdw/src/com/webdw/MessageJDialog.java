package com.webdw;

import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JTextField;

class MessageJDialog extends JDialog {
	public void ReadMe() {
		System.out
				.println("My Create JDialog,It has the same interface like VB MessageBox");
		System.out.println(Golbal.JWebDWInfo);
	}
	
	public MessageJDialog(String stitle,String sinfo,JFrame jframe){
		super(jframe,stitle,true);
		this.setBounds(300, 200, 400, 300);
		this.getContentPane().setLayout(null);

		JTextField text = new JTextField();
		text.setText(sinfo);
		text.setAutoscrolls(true);
		//JLabel text = new JLabel(sinfo);
		text.setBounds(20, 100, 350, 100);
		text.setVisible(true);
		text.setEditable(false);
		this.getContentPane().add(text);
		
		this.addWindowListener(new WindowAdapter() { 
            public void windowClosing(WindowEvent evt) { 
            	setVisible(false);
            	setModal(false);
            } 
        }); 
		this.setVisible(true);
	}
}
