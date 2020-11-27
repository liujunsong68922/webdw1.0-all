package com.webdw.demo;

import com.webdw.*;
import com.webdw.ui.*;
import java.awt.*;
import java.awt.event.*;

import javax.swing.JFrame;
import java.util.*;

public class UIDemo_DataAccess extends Golbal {
	public void ReadMe() {
		System.out.println("JWebDW的测试用户界面程序，演示用.");
		System.out.println(JWebDWInfo);
	}

	static String defaultRate = "0.25";

	static JFrame jframe = new JFrame(
			"JWebDW Example: 请访问 http://webdw.vicp.net");

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
		// 第一层对象
		MyJPanel jPanel_Top = new MyJPanel("", targetControls, jframe
				.getContentPane()); // 上方的框体,存储了显示条件定义
		jPanel_Top.setBounds(new Rectangle(3, 2, 740, 50));
		// jPanel_Top.setBackground(new Color(255,255,255));

		MyJPanel jPanel_Body = new MyJPanel("", targetControls, jframe
				.getContentPane());// 中间的框体,存储了要绘图的对象本身
		jPanel_Body.setBounds(new Rectangle(3, 53, 740, 380));

		// 第二层对象
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

		// 第三层对象
		// ImageIcon icon1 = new ImageIcon();
		// 第一部分,转换比例设置
		MyJLabel label_convertrate = new MyJLabel("转换比例:", "", targetControls,
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

		// 第三层对象
		// 第二部分:按钮
		MyJButton cmdSetDataObject = new MyJButton("设置数据窗口对象",
				"cmdSetDataObject", targetControls, jPanel_Command);
		cmdSetDataObject.setBounds(new Rectangle(170, 10, 130, 20));

		MyJButton cmdRetrieve = new MyJButton("检索", "cmdRetrieve",
				targetControls, jPanel_Command);
		cmdRetrieve.setBounds(new Rectangle(300, 10, 60, 20));

		MyJButton cmdInsert = new MyJButton("插入", "cmdInsert", targetControls,
				jPanel_Command);
		cmdInsert.setBounds(new Rectangle(360, 10, 60, 20));

		MyJButton cmdDelete = new MyJButton("删除", "cmdDelete", targetControls,
				jPanel_Command);
		cmdDelete.setBounds(new Rectangle(420, 10, 60, 20));

		MyJButton cmdUpdate = new MyJButton("保存", "cmdUpdate", targetControls,
				jPanel_Command);
		cmdUpdate.setBounds(new Rectangle(480, 10, 60, 20));

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
					MessageBox("设置数据窗口对象失败", ui.errString);
				} else {
					System.out.println("SetDataObject Ok.");
					infolabel.Text("SetDataObject Ok.");
					// MessageBox("设置数据窗口对象成功");
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

		cmdInsert.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int iret = 0;
				iret = ui.DW_InsertRow(0);
				MyJLabel infolabel = (MyJLabel) GF_GetObjectByName(
						targetControls, "ErrorInfo");
				if (iret == -1) {
					System.out.println("Retrieve Error:" + ui.errString);
					infolabel.Text("Insert Error:" + ui.errString);
					MessageBox(ui.errString);
				} else {
					System.out.println("Retrieve Ok.");
					infolabel.Text("Insert Ok.");
				}
				// ui.DrawDW();
			}
		});

		cmdDelete.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				// '删除当前行的调用功能测试
				String strinfo = "";
				int irow = 0;// As Long '当前行定义
				irow = ui.DW_GetRow();// '得到当前行，当前行为0代表没有当前行
				MyJLabel infolabel = (MyJLabel) GF_GetObjectByName(
						targetControls, "ErrorInfo");

				if (irow == -1) {// Then '错误判断和显示
					// strinfo = langsupport.SumAllLang("得到当前行错误", "GetRow
					// Error");
					// MsgBox ui.errString, vbExclamation,
					// langsupport.GetCurrent(strinfo)
					strinfo = "Delete Error" + ui.errString;
					infolabel.Text(strinfo);
					MessageBox(ui.errString);
					// Exit Sub
					return;
				}

				int iret = 0;// As Long
				if (irow > 0) {// Then
					iret = ui.DW_DeleteRow(irow);
					if (iret == -1) {// Then
						// strinfo = langsupport.SumAllLang("删除错误", "DeleteRow
						// Error")
						strinfo = "Delete Error" + ui.errString;
						infolabel.Text(strinfo);
						// MsgBox ui.errString, vbExclamation,
						// langsupport.GetCurrent(strinfo)
					}
				}

			}
		});

		cmdUpdate.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				MyJLabel infolabel = (MyJLabel) GF_GetObjectByName(
						targetControls, "ErrorInfo");
				MyInt int1 = new MyInt(0);
				String sUpdate = ui.DW_GetSQLPreview(int1);

				if (int1.intvalue == -1) {
					infolabel.Text(ui.errString);
					MessageBox(ui.errString);
					return;
				} else {
					infolabel.Text(sUpdate);
					MessageBox(sUpdate);
				}

				ui.DW_SetAutoCommit(1);// '设置为自动更新模式
				int iret = ui.DW_Update();// '调用更新方法

				if (iret == -1) {// Then
					// strinfo = langsupport.SumAllLang("保存错误", "Update
					// Error:");
					// MsgBox ui.errString, vbExclamation,
					// langsupport.GetCurrent(strinfo)

					infolabel.Text("Update Error:" + ui.errString);
				} else {
					// strinfo = langsupport.SumAllLang("保存成功", "Update ok");
					// MsgBox "OK", , langsupport.GetCurrent(strinfo)
					infolabel.Text("Update OK");
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
