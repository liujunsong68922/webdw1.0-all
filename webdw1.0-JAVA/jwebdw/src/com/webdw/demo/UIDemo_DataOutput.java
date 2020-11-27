package com.webdw.demo;

import com.webdw.*;
import com.webdw.ui.*;
import java.awt.*;
import java.awt.event.*;

import javax.swing.JFrame;
import java.util.*;
import java.io.*;

public class UIDemo_DataOutput extends Golbal {
	public void ReadMe() {
		System.out.println("JWebDW�Ĳ����û����������ʾ��.");
		System.out.println(JWebDWInfo);
	}

	static String defaultRate = "0.25";

	static JFrame jframe = new JFrame(
			"JWebDW ���������ʾ: ����� http://webdw.vicp.net");

	static ArrayList targetControls = new ArrayList();

	static CWebDWUI ui = new CWebDWUI();

	public static void setupFrame() {
		jframe.setBounds(200, 100, 800, 500);
		jframe.setVisible(true);
		jframe.getContentPane().setLayout(null);
		jframe.getContentPane().setBackground(new Color(204, 204, 204));
		jframe.setSize(new Dimension(760, 460));
		setupUI();
	}

	public static void setupUI() {
		// ��һ�����
		MyJPanel jPanel_Top = new MyJPanel("", targetControls, jframe
				.getContentPane()); // �Ϸ��Ŀ���,�洢����ʾ��������
		jPanel_Top.setBounds(new Rectangle(3, 2, 740, 50));
		// jPanel_Top.setBackground(new Color(255,255,255));

		MyJPanel jPanel_Body = new MyJPanel("", targetControls, jframe
				.getContentPane());// �м�Ŀ���,�洢��Ҫ��ͼ�Ķ�����
		jPanel_Body.setBounds(new Rectangle(3, 53, 740, 380));

		// �ڶ������
		MyJPanel jPanel_ConvertRate = new MyJPanel("", targetControls,
				jPanel_Top);//
		jPanel_ConvertRate.setBounds(new Rectangle(3, 3, 150, 40));

		MyJPanel jPanel_Command = new MyJPanel("", targetControls, jPanel_Top);
		jPanel_Command.setBounds(new Rectangle(160, 3, 575, 40));

		MyJPanel Picture1 = new MyJPanel("Picture1", targetControls,
				jPanel_Body);
		Picture1.setBounds(10, 10, 725, 320);

		MyJPanel Picture2 = new MyJPanel("Picture2", targetControls, Picture1);
		Picture2.setBounds(10, 10, 690, 280);

		MyJLabel ErrorInfo = new MyJLabel("http://webdw.vicp.net", "ErrorInfo",
				targetControls, jPanel_Body);
		ErrorInfo.setBounds(10, 340, 660, 20);

		// ���������
		// ImageIcon icon1 = new ImageIcon();
		// ��һ����,ת����������
		MyJLabel label_convertrate = new MyJLabel("ת������:", "", targetControls,
				jPanel_ConvertRate);
		label_convertrate.setBounds(new Rectangle(10, 10, 60, 20));

		MyJTextField textConvertRate = new MyJTextField(defaultRate,
				"TextConvertRate", targetControls, jPanel_ConvertRate);
		textConvertRate.setBounds(new Rectangle(70, 10, 50, 20));
		textConvertRate.addKeyListener(new KeyListener() {
			public void keyTyped(KeyEvent e) {
				System.out.println(e);
			}

			public void keyPressed(KeyEvent e) {
				System.out.println(e);
			}

			public void keyReleased(KeyEvent e) {
				System.out.println(e);
			}
		});

		MyJComboBox Combo1 = new MyJComboBox("dwlist", targetControls,
				jPanel_Command);
		Combo1.setBounds(10, 10, 150, 20);
		Combo1.addItem("d_products_grid");
		Combo1.addItem("d_products_tabular");
		Combo1.addItem("d_product_freedom");
		Combo1.addItem("d_employee_list");
		Combo1.addItem("d_employee_list2");
		Combo1.addItem("d_employee_001");
		Combo1.addItem("d_dddw_dept");
		Combo1.addItem("d_stock_list");
		Combo1.addItem("d_stock_rec_list");
		Combo1.addItem("dddw_stock_list");

		// ���������
		// �ڶ�����:��ť
		MyJButton cmdSetDataObject = new MyJButton("�������ݴ��ڶ���",
				"cmdSetDataObject", targetControls, jPanel_Command);
		cmdSetDataObject.setBounds(new Rectangle(170, 10, 130, 20));

		MyJButton cmdRetrieve = new MyJButton("����", "cmdRetrieve",
				targetControls, jPanel_Command);
		cmdRetrieve.setBounds(new Rectangle(300, 10, 60, 20));

		MyJButton cmdSaveText = new MyJButton("��Ϊtxt", "cmdSaveText", targetControls,
				jPanel_Command);
		cmdSaveText.setBounds(new Rectangle(360, 10, 100, 20));

//		MyJButton cmdDelete = new MyJButton("ɾ��", "cmdDelete", targetControls,
//				jPanel_Command);
//		cmdDelete.setBounds(new Rectangle(420, 10, 60, 20));
//
//		MyJButton cmdUpdate = new MyJButton("����", "cmdUpdate", targetControls,
//				jPanel_Command);
//		cmdUpdate.setBounds(new Rectangle(480, 10, 60, 20));

		cmdSetDataObject.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int iret = 0;
				MyJLabel infolabel = (MyJLabel) GF_GetObjectByName(
						targetControls, "ErrorInfo");
				MyJPanel targetPict = (MyJPanel) GF_GetObjectByName(
						targetControls, "Picture2");
				MyJPanel picture1 = (MyJPanel) GF_GetObjectByName(
						targetControls, "Picture1");
				MyJComboBox dwlist = (MyJComboBox) GF_GetObjectByName(
						targetControls, "dwlist");
				dwlist.Refresh();
				String dwname = dwlist.Text;
				iret = ui.DW_SetDataObjectByName(targetControls, targetPict,
						picture1, dwname, true, true);
				if (iret == -1) {
					System.out.println("SetDataObjectError:" + ui.errString);
					infolabel.Text("SetDataObjectError:" + ui.errString);
					MessageBox("�������ݴ��ڶ���ʧ��", ui.errString);
				} else {
					System.out.println("SetDataObject Ok.");
					infolabel.Text("SetDataObject Ok.");
					// MessageBox("�������ݴ��ڶ���ɹ�");
				}
			}
		});

		cmdRetrieve.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int iret = 0;
				iret = ui.DW_Retrieve("");
				MyJLabel infolabel = (MyJLabel) GF_GetObjectByName(
						targetControls, "ErrorInfo");
				if (iret == -1) {
					System.out.println("Retrieve Error:" + ui.errString);
					infolabel.Text("Retrieve Error:" + ui.errString);
					MessageBox(ui.errString);
				} else {
					System.out.println("Retrieve Ok.");
					infolabel.Text("Retrieve Ok.");
				}
			}
		});

		cmdSaveText.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try{
				File f1 = new File("C://webdwtextoutput.txt");
				FileOutputStream s1 = new FileOutputStream(f1);
				String sdata = ui.GetOutputData();
				byte buffer[] = sdata.getBytes();
				s1.write(buffer);
				s1.close();
				
				MsgBox("C://webdwtextoutput.txt",0,"�����ļ��ɹ�" );
				// ui.DrawDW();
				}catch(Exception e1){
					e1.printStackTrace();
				}
			}
		});


		MyJPanel childpict = new MyJPanel("PictureChild", targetControls,
				Picture2);
		childpict.setBounds(0, 0, 200, 200);
		childpict.setVisible(false);

		jframe.setVisible(true);
	}

}
