package com.webdw.demo;

import com.webdw.*;
import com.webdw.ui.*;

import java.awt.*;
import java.awt.event.*;

import javax.swing.JFrame;
import javax.swing.JApplet;
import java.util.*;

public class UIDemo extends JApplet {
	public void ReadMe() {
		System.out.println("JWebDW 1.0 Demo App.");
		System.out.println(Golbal.JWebDWInfo);
	}

	static JFrame jframe = new JFrame("JWebDW 1.0 Demo Applicationʾ");

	static ArrayList targetControls = new ArrayList();

	public static void setupFrame() {
		jframe.setVisible(true);
		jframe.getContentPane().setLayout(null);
		// jframe.getContentPane().setBackground(new Color(204, 204, 204));
		jframe.setBounds(400, 200, 400, 300);

		WindowListener listener = new WindowAdapter() {
			public void windowClosing(WindowEvent e) {
				System.exit(0);
			}
		};
		jframe.addWindowListener(listener);
	}

	public static void main(String[] args) {
		init1();
	}

	public void init() {
		init1();
	}

	public static void init1() {
		Golbal.InitGlobalVariable();
		setupFrame();
		// ��һ�����
		MyJPanel jPanel_Top = new MyJPanel("", targetControls, jframe
				.getContentPane()); // �Ϸ��Ŀ���,�洢����ʾ��������
		jPanel_Top.setBounds(new Rectangle(3, 2, 350, 200));

		// ���������
		// �ڶ�����:��ť
		MyJButton cmdD0 = new MyJButton("Basic DataAccess", "cmdSetDataObject",
				targetControls, jPanel_Top);
		cmdD0.setBounds(new Rectangle(10, 10, 200, 20));

		MyJButton cmdD1 = new MyJButton("Data Fill", "cmdRetrieve",
				targetControls, jPanel_Top);
		cmdD1.setBounds(new Rectangle(10, 40, 200, 20));

		MyJButton cmdD2 = new MyJButton("Data Output", "cmdInsert",
				targetControls, jPanel_Top);
		cmdD2.setBounds(new Rectangle(10, 70, 200, 20));

		MyJButton cmdD3 = new MyJButton("Data Sort", "cmdDelete",
				targetControls, jPanel_Top);
		cmdD3.setBounds(new Rectangle(10, 100, 200, 20));

		MyJLabel label1 = new MyJLabel("Server: "+"http://localhost", "",
				targetControls, jPanel_Top);
		label1.setBounds(new Rectangle(10, 160, 200, 20));

		jframe.setVisible(true);

		cmdD0.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				UIDemo_DataAccess.setupFrame();
			}
		});
		cmdD1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				UIDemo_DataFill.setupFrame();
			}
		});
		cmdD2.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				UIDemo_DataOutput.setupFrame();
			}
		});
		cmdD3.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				UIDemo_DataSort.setupFrame();
			}
		});

	}
}
