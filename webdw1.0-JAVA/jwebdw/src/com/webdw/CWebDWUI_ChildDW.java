package com.webdw;

import com.webdw.ui.*;
import java.util.*;
import javax.swing.*;

//import java.awt.font.*;
//import java.awt.Font;
import java.awt.Color;

public class CWebDWUI_ChildDW extends Golbal {
	public void ReadMe() {
		System.out.println("�����ݴ�����");
		System.out.println(JWebDWInfo);
	}

	public CWebDW webdw = null; // '����webdw��Ӧ���ļ���ȡ��(�����һ��ָ��)

	public String errString = "";// '���صĴ�����Ϣ�ַ���

	public CWebDWData webdwData = null;// '����webdw�����ݶ�����

	// '------------����Ķ����ǽ����ϵĶ�̬Ԫ�ض�Ӧ���¼�����������
	// Private WithEvents myTextBox As TextBox 'myTextBox��һ��������ı������������ı����¼���Ӧ
	// '------------���涯̬Ԫ�ض������

	//public String parentControlName = "";// '�����ݴ��ڵĿؼ�����

	//public String dataColumnName = "";// '����������

	public void parentControlName(String sname){
		parentClassDW.parentControlName=sname;
	}
	public void dataColumnName(String sname){
		parentClassDW.dataColumnName =sname;
	}
	//private CWebDWUI parentDW = null;// '���ø����ݴ��ڵľ��

	private CWebDWUI_ParentDW parentClassDW = null;// '���ø�������ݴ�����ľ�������಻�ٴ洢�������ظ�����

	public CWebDWUI_ChildDW() {
		parentClassDW = new CWebDWUI_ParentDW();
		webdw = parentClassDW.webdw;
		webdwData = parentClassDW.webdwData;
	}

	// '��������������g_webdw��ֵ
	// '���룺gg_webdw
	// '�����g_webdw
	public void SetWebDW() {
		parentClassDW.SetLocalWebDW();
	}

	// '������������ȡg_webdw��ֵ
	// '����:g_webdw
	// '���:gg_webdw
	public void GetWebDW() {
		parentClassDW.GetLocalWebDW();
	}

	// '���ı���ķ���
	// 'targetControls Ŀ��ؼ�����
	// 'pictTarget Ҫ���Ƶ�ͼƬ��
	// 'lineNum �кţ���1��ʼ���ı���ֻ��detail������ƣ���������������
	// 'leftpos ��ƫ��������������ƫ��leftpos<0
//	private int DrawColumn(List targetControls, JPanel targetPict,
//			double convertRate, int lineNum, int leftPos) {
//		return parentClassDW.DrawColumn(lineNum, leftPos);
//	}

	// '���ı���ķ���
	// 'targetControls Ŀ��ؼ�����
	// 'pictTarget Ҫ���Ƶ�ͼƬ��
	// 'lineNum �кţ���1��ʼ���ı���ֻ��detail������ƣ���������������
	// 'leftpos ��ƫ��������������ƫ��leftpos<0
//	private int DrawColumn(List targetControls, JPanel targetPict,
//			double convertRate, int lineNum) {
//		return parentClassDW.DrawColumn(lineNum, 0);
//	}

	// '����DW�ķ���,begId����ʼ���Ƶ�һ��.begId>0
	// 'targetControls: Ŀ��ؼ��ļ��� ����
	// 'targetPict: Ҫ���Ƶ�Ŀ��ͼƬ�� ����
	public int DrawDW() {
		return parentClassDW.DrawDW();
	}

//	private int drawImageOnly() {
//		return parentClassDW.DrawDW_ImageOnly();
//	}

	// '����ǩ�ķ���
	// 'targetControls Ŀ�괰������û��ؼ��Ŀؼ�����
	// 'pictTarget Ŀ��ͼƬ��
	// 'lineNum �к�0������Ʊ�ͷ���������������к�
	// 'leftpos ����Ԫ�ص���ƫ���� leftpos <=0
	// 'ͼ��������Դ: g_webdw
//	private int DrawLabel(List targetControls, JPanel targetPict,
//			double convertRate, int lineNum, int leftPos) {
//		return parentClassDW.DrawLabel(lineNum, leftPos);
//	}

	// '����ǩ�ķ���
	// 'targetControls Ŀ�괰������û��ؼ��Ŀؼ�����
	// 'pictTarget Ŀ��ͼƬ��
	// 'lineNum �к�0������Ʊ�ͷ���������������к�
	// 'leftpos ����Ԫ�ص���ƫ���� leftpos <=0
	// 'ͼ��������Դ: g_webdw
//	private int DrawLabel(List targetControls, JPanel targetPict,
//			double convertRate, int lineNum) {
//		return parentClassDW.DrawLabel(lineNum, 0);
//	}

	// '�ڽ����ϻ��ߵķ���
	// 'ͨ���������֧���ڽ����Ͻ��л���
	// 'leftpos ��ƫ���� leftpos<=0
//	public int DrawLine(List targetControls, JPanel targetPict,
//			double convertRate, int lineNum, int leftPos) {
//		return parentClassDW.DrawLine(lineNum, leftPos);
//	}

	// '�ڽ����ϻ��ߵķ���
	// 'ͨ���������֧���ڽ����Ͻ��л���
	// 'leftpos ��ƫ���� leftpos<=0
//	public int DrawLine(List targetControls, JPanel targetPict,
//			double convertRate, int lineNum) {
//		return parentClassDW.DrawLine(lineNum, 0);
//	}

	// '�����������õ���ǰ��
	// 'Ҫ�õ���ǰ�У���Ҫ���뵱ǰ���ڶ����ID��
//	public int DW_GetRow() {
//		return parentClassDW.DW_GetRow();
//	}

	// '�õ����Ҫ�ύ����̨�ĸ������ݿ�������
	// '��������֮����chr(13)chr(10)���ָ�
	// 'Ŀǰ��֧�ֵ���ĸ��²�������Ҫ��SQL����
	public String DW_GetSQLPreview(MyInt iret) {

		return parentClassDW.DW_GetSQLPreview(iret);
	}

	// '�����ݴ����в���һ����¼������������¼�ĵ�ǰ�кţ������������-1
	// 'rowid����Ҫ������кţ����Ϊ0������������
	public int DW_InsertRow(int rowid) {
		return parentClassDW.DW_InsertRow(rowid);
	}

	// '���ݴ��ڵļ������ܣ��ȼ۹���dw.Retrieve()
	// 'ǰ���������Ѿ�������datawindow����
	// 'args�Ǽ������õĲ�������������֮����TAB���ָ�
	// '20090116�Բ��������޸ģ�targetControls��targetPict������Ҫ�ⲿ����
	public int DW_Retrieve(String args) {
		return parentClassDW.DW_Retrieve(args);
	}

	// '���ݴ��ڵļ������ܣ��ȼ۹���dw.Retrieve()
	// 'ǰ���������Ѿ�������datawindow����
	// 'args�Ǽ������õĲ�������������֮����TAB���ָ�
	// '20090116�Բ��������޸ģ�targetControls��targetPict������Ҫ�ⲿ����
	public int DW_Retrieve() {
		return parentClassDW.DW_Retrieve();
	}

	// '�õ���ǰDataWindow�ڵļ�¼����
	// '����-1����ʧ��
	// '�����������ֵ>=0
	public int DW_RowCount() {

		return parentClassDW.DW_RowCount();
	}

	// '����dataobject����dataobject������һ���ַ���������
	// '����һ����ʵ�ֵķ�������������в��ٴ���vscroll,hscroll��Щ����
	// '����ͨ�������������з���
	public int DW_SetDataObject(List targetControlsArg, MyJPanel targetPictArg,
			MyJPanel parentPict,
			String sUIDesc, boolean childFlag,boolean createflag) {

		return parentClassDW.DW_SetDataObject(targetControlsArg, targetPictArg,
				parentPict,sUIDesc, childFlag,createflag);
	}

	// '����dataobject����dataobject������һ���ַ���������
	// '����һ����ʵ�ֵķ�������������в��ٴ���vscroll,hscroll��Щ����
	// '����ͨ�������������з���
	public int DW_SetDataObjectByName(List targetControlsArg,
			MyJPanel targetPictArg, MyJPanel parentPict,String sdwName,
			boolean childFlag,boolean createflag) {
		int iret = 0;
		iret = parentClassDW.DW_SetDataObjectByName(targetControlsArg,
				targetPictArg,parentPict, sdwName,childFlag,createflag);
		errString = parentClassDW.errString;
		return iret;
	}

	// '���õ�ǰ��
	public int DW_SetRow(int rowid) {
		return parentClassDW.DW_SetRow(rowid);
	}

	// 'ִ��Dw��Update����,��������
	// '����0������óɹ�
	// '����-1������÷�������
	// '��targetControls,targetPict���Ӳ�����ȥ��
	public int DW_Update() {

		return parentClassDW.DW_Update();
	}

	public String GetItemString(int rowid, int colid) {
		return webdwData.GetItemString(rowid, colid);
	}

	// '�õ�����Ĵ���
	private int getParentErr(int iret) {
		if (iret == -1) {
			errString = parentClassDW.errString;
		}
		return 0;
	}

	// '���ݸ����ĵ�ǰ�ؼ������֣��жϵ�ǰ�����е����
	// '����-1����ʧ�ܣ�>=0�������
	public int GetRowIdColumnId(String currentControlName, MyInt rowid,
			MyInt colid) {
		return parentClassDW.GetRowIdColumnId(currentControlName, rowid, colid);
	}

	// '���ø��������ݣ�����ʼ�����ݴ洢
	// 'targetControls �ؼ��ļ���
	// 'pictTarget Ҫ��ͼ�Ŀؼ�
	// 'indata �������õ�����
	// 'datastate ��ѡ��,���ݵ�״̬,Ĭ��Ϊ"normal"
	public int SetData(String indata, String datastate) {
		return parentClassDW.SetData(indata, datastate);
	}

	// '���ø��������ݣ�����ʼ�����ݴ洢
	// 'targetControls �ؼ��ļ���
	// 'pictTarget Ҫ��ͼ�Ŀؼ�
	// 'indata �������õ�����
	// 'datastate ��ѡ��,���ݵ�״̬,Ĭ��Ϊ"normal"
	public int SetData(String indata) {
		return parentClassDW.SetData(indata);
	}

	// '���ݸ�����columnname�����㷵�ص��б��(1 based)
	// 'Public Function GetColumnIdByColumnName(colname As String) As Long
	// ' GetColumnIdByColumnName =
	// parentClassDW.GetColumnIdByColumnName(colname)
	// 'End Function
	//
	// '��������,ֻ������PrimaryBuffer������
	public String SetItemString(int rowid, int colid, String sdata) {
		return webdwData.SetItemString(rowid, colid, sdata);
	}

	// '���ø����ݴ��ڵľ��
	public int SetParentDW(CWebDWUI pui) {
		return parentClassDW.SetParentDW(pui);
	}
	
	public int CloseDW(){
		return parentClassDW.CloseDW();
	}
}
