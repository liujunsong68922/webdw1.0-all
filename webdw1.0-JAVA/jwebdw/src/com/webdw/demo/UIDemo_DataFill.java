package com.webdw.demo;

import com.webdw.*;
import com.webdw.ui.*;
import java.awt.*;
import java.awt.event.*;
import java.io.InputStream;
import java.io.*;
import javax.swing.JFrame;
import java.util.*;

public class UIDemo_DataFill extends Golbal {
	public void ReadMe() {
		System.out.println("JWebDW的测试用户界面程序，演示用.");
		System.out.println(JWebDWInfo);
	}

	static String defaultRate = "0.25";

	static JFrame jframe = new JFrame(
			"JWebDW数据填充功能演示: 请访问 http://webdw.vicp.net");

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
		jPanel_Top.setBounds(new Rectangle(3, 2, 740, 100));
		// jPanel_Top.setBackground(new Color(255,255,255));

		MyJPanel jPanel_Body = new MyJPanel("", targetControls, jframe
				.getContentPane());// 中间的框体,存储了要绘图的对象本身
		jPanel_Body.setBounds(new Rectangle(3, 103, 740, 380));

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

		MyJTextArea txtSource = new MyJTextArea("","txtSource",targetControls,jPanel_Top);
		txtSource.setBounds(10, 55, 350, 40);
		
		MyJTextArea txtData = new MyJTextArea("","txtData",targetControls,jPanel_Top);
		txtData.setBounds(365, 55, 350, 40);
		
		//从文件中读取数据，填充到文本框中去
		UIDemo_DataFill_Const cons = new UIDemo_DataFill_Const();
		
		txtSource.Text(cons.dwdefine);
		txtData.Text(cons.fillData);
		
		// 第三层对象
		// ImageIcon icon1 = new ImageIcon();
		// 第一部分,转换比例设置
		MyJLabel label_convertrate = new MyJLabel("转换比例:", "", targetControls,
				jPanel_ConvertRate);
		label_convertrate.setBounds(new Rectangle(10, 10, 60, 20));

		MyJTextField textConvertRate = new MyJTextField(defaultRate,
				"TextConvertRate", targetControls, jPanel_ConvertRate);
		textConvertRate.setBounds(new Rectangle(70, 10, 50, 20));

		// 第三层对象
		// 第二部分:按钮
		MyJButton cmdSetDataObject = new MyJButton("设置数据窗口对象",
				"cmdSetDataObject", targetControls, jPanel_Command);
		cmdSetDataObject.setBounds(new Rectangle(100, 10, 130, 20));

		MyJButton cmdRetrieve = new MyJButton("检索", "cmdRetrieve",
				targetControls, jPanel_Command);
		cmdRetrieve.setBounds(new Rectangle(250, 10, 60, 20));

		MyJButton cmdFill = new MyJButton("数据填充", "cmdInsert", targetControls,
				jPanel_Command);
		cmdFill.setBounds(new Rectangle(330, 10, 100, 20));

		MyJButton cmdUpdate = new MyJButton("保存", "cmdUpdate", targetControls,
				jPanel_Command);
		cmdUpdate.setBounds(new Rectangle(450, 10, 60, 20));

		cmdSetDataObject.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int iret = 0;
				MyJLabel infolabel = (MyJLabel) GF_GetObjectByName(
						targetControls, "ErrorInfo");
				MyJPanel targetPict = (MyJPanel) GF_GetObjectByName(
						targetControls, "Picture2");
				MyJPanel picture1 = (MyJPanel) GF_GetObjectByName(
						targetControls, "Picture1");
				MyJTextArea dwdefine = (MyJTextArea) GF_GetObjectByName(
						targetControls, "txtSource");
				dwdefine.Refresh();
				System.out.println("DWDefine:"+dwdefine.Text);
				String dwname = dwdefine.Text;
				iret = ui.DW_SetDataObject(targetControls, targetPict,
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

		cmdFill.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int iret = 0;
				MyJLabel infolabel = (MyJLabel) GF_GetObjectByName(
						targetControls, "ErrorInfo");
				MyJPanel targetPict = (MyJPanel) GF_GetObjectByName(
						targetControls, "Picture2");
				MyJPanel picture1 = (MyJPanel) GF_GetObjectByName(
						targetControls, "Picture1");
				MyJTextArea dwdefine = (MyJTextArea) GF_GetObjectByName(
						targetControls, "txtSource");
				dwdefine.Refresh();
				String dwname = dwdefine.Text;
				iret = ui.DW_SetDataObject(targetControls, targetPict,
						picture1, dwname, true, true);
				if (iret == -1) {
					System.out.println("SetDataObjectError:" + ui.errString);
					infolabel.Text("SetDataObjectError:" + ui.errString);
					MessageBox("设置数据窗口对象失败", ui.errString);
					return;
				} else {
					System.out.println("SetDataObject Ok.");
					infolabel.Text("SetDataObject Ok.");
					// MessageBox("设置数据窗口对象成功");
				}
				
				MyJTextArea dwdata = (MyJTextArea) GF_GetObjectByName(
						targetControls, "txtData");
				dwdata.Refresh();
				iret = ui.SetData(dwdata.Text, "new");
				if (iret == -1){
					infolabel.Text("SetData Error:" + ui.errString);
					MessageBox("填充数据失败:", ui.errString);					
				}else{
					MessageBox("已经填充行数",""+ui.DW_RowCount());
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
class UIDemo_DataFill_Const{
	String dwdefine="";
	String fillData="";
	String configfile="com/webdw/demo/d_products.srd";
	String configfile2="com/webdw/demo/d_products.txt";
	
	private String readFile(String surl){
		 try{
				ClassLoader loader = this.getClass().getClassLoader();
	  			InputStream stream = loader.getResourceAsStream(surl);
				String record = "";	
	  			byte buffer[]=new byte[10000];
	  			int iread = stream.read(buffer);
	  			System.out.println("read:"+iread);
	  			record = new String(buffer,0,iread);
	  			System.out.println("record:"+record);
	  			
	  			stream.close();
	  			return record;
	  			
			 }catch(Exception e){
				 e.printStackTrace();
				 return "";
			 }
		
	}
	public UIDemo_DataFill_Const(){
		dwdefine = readFile(configfile);
		fillData = readFile(configfile2);

	}
	
	
}