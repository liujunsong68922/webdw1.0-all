package com.webdw;

import com.webdw.ui.*;
import java.util.*;
import javax.swing.*;

//Rem -------------------------------------------------
//Rem WebDW�û������������VB������
//Rem ��Ҫ���ܣ���һ���ַ�������ת������Ӧ��ͼ�ν���
//Rem ͼ�ν�����ַ������������������߼�������ȫ�ȼ۵�
//Rem ��������������������ͼ�ν�����,��HTML���Է����һ��ͼ�λ�����
//Rem ���а����ı�,ͼ�εȶ���Ԫ��(һ��ʼ����ֻ���ı�)
//Rem ͨ��һ���ļ����ѽ�������ݿ���Թ�������
//Rem ��һ�汾�Ľ������������ʽ�ϸ���PB7�����ݴ����ַ�����ʽ����ȡ
//Rem ������DW_��ͷ�ķ������ṩ��PB Datawindow�ؼ����ƵĹ��ܺ͵��ýӿ�
//Rem @CopyRight Mr.Liu Junsong 2008-2009
//Rem @��Ȩ���� ������ 2008-2009
//Rem E_mail : liujunsong@yahoo.com.cn
//Rem -------------------------------------------------

public class CWebDWUI extends Golbal {
	public void ReadMe() {
		System.out.println("WebDW�û�����������ӿ�");
		System.out.println(JWebDWInfo);
	}

	public String errString = "";// As String '���صĴ�����Ϣ�ַ���

	public CWebDWTransaction sqlca = null;// '����֧�֣�SQL����֧�ֶ���

	// '�����˽�б����Ķ���
	CWebDWUI_ParentDW parentClassDW = null;// '����һ������

	private MyInt iret = new MyInt(0);// 'ͨ�õķ���ֵ����

	private int iret2 = 0;

	/**
	 * ���캯��
	 * 
	 */
	public CWebDWUI() {
		parentClassDW = new CWebDWUI_ParentDW();// '���ø��ര�ڣ����󲿷ֹ����ɸ������

		parentClassDW.childDW = new CWebDWUI_ChildDW();// '�ڸ������ݴ����ϣ�����һ�������ݴ���
		parentClassDW.childDW.SetParentDW(this);// '���߸���������ݴ��ڣ�˭�����ְ�

		sqlca = parentClassDW.sqlca;

	}

	// '��������������g_webdw��ֵ
	// '���룺gg_webdw
	// '�����g_webdw
	public void SetWebDW() {
		parentClassDW.SetLocalWebDW();
	}

	// '�õ�����Ĵ���
	private void getParentErr(int iret) {
		if (iret == -1) {
			errString = parentClassDW.errString;
		}
	}

	// '������������ȡg_webdw��ֵ
	// '����:g_webdw
	// '���:gg_webdw
	public void GetWebDW() {
		parentClassDW.GetLocalWebDW();
	}

	// 'update()����commit()�ɹ��Ժ���õķ��������½������ݣ�����retrieve
	public int After_Update() {
		return parentClassDW.AfterUpdate();
	}

	// '���������ݴ��ڵ�ˢ�·���
	public int DrawChildDW() {
		int i = parentClassDW.DrawChildDW();
		getParentErr(i);
		return i;
	}

	// '����DW�ķ���,begId����ʼ���Ƶ�һ��.begId>0
	// 'targetControls: Ŀ��ؼ��ļ��� ����
	// 'targetPict: Ҫ���Ƶ�Ŀ��ͼƬ�� ����
	public int DrawDW() {
		iret2 = parentClassDW.DrawDW();
		getParentErr(iret2);
		return iret2;
	}

	// '�������
	public String DW_AddCommand(MyInt iret) {
		String sret = parentClassDW.DW_AddCommand(iret);
		errString = parentClassDW.errString;
		return sret;
	}

	public String DW_BeginTransaction(MyInt iret) {
		String sret = parentClassDW.DW_BeginTransaction(iret);
		errString = parentClassDW.errString;
		return sret;
	}

	// '�ύ����
	public String DW_Commit(MyInt iret) {
		String sret = parentClassDW.DW_Commit(iret);
		errString = parentClassDW.errString;
		return sret;
	}

	// '���ݸ���dw�﷨����ת���������ܷ���Թ���
	// '�˷��������﷨��Σ���Ӱ��������ʾ
	// '���ת��ʧ�ܣ�����-1
	public int DW_Create(String dwSyntax) {

		iret2 = parentClassDW.DW_Create(dwSyntax);
		if (iret2 == -1) {
			errString = parentClassDW.errString;
		}

		return iret2;
	}

	// '����������ɾ����ǰ��
	// '����0 �ɹ�
	// '����-1 ��������
	public int DW_DeleteRow(int rowid) {
		iret2 = parentClassDW.DW_DeleteRow(rowid);
		getParentErr(iret2);
		return iret2;
	}

	public int DW_GetAutoCommit() {
		return parentClassDW.DW_GetAutoCommit();
	}

	// '�������ݴ����еĵ�ǰ����
	// 'rowid �к�
	// 'colid �к�
	// '����ֵ����ǰֵ
	public String DW_GetItemString(int rowid, int colid) {
		return parentClassDW.DW_GetItemString(rowid, colid);
	}

	// '�����������õ���ǰ��
	// 'Ҫ�õ���ǰ�У���Ҫ���뵱ǰ���ڶ����ID��
	public int DW_GetRow() {
		iret2 = parentClassDW.DW_GetRow();
		getParentErr(iret2);
		return iret2;
	}

	// '�õ����Ҫ�ύ����̨�ĸ������ݿ�������
	// '��������֮����chr(13)chr(10)���ָ�
	// 'Ŀǰ��֧�ֵ���ĸ��²�������Ҫ��SQL����
	public String DW_GetSQLPreview(MyInt iret1) {
		String strsql = parentClassDW.DW_GetSQLPreview(iret1);
		getParentErr(iret1.intvalue);
		return strsql;
	}

	// '�õ������õ�select��䣬�����ݿ����
	public String DW_GetSQLSelect() {
		return parentClassDW.DW_GetSQLSelect();
	}

	// '�õ����ݴ��ڵ��﷨��ʾ
	// '����iret 0 ����ɹ� -1 ����ʧ��
	public String DW_GetSyntax(MyInt iret) {
		return parentClassDW.DW_GetSyntax(iret);
	}

	// '�����ݴ����в���һ����¼������������¼�ĵ�ǰ�кţ������������-1
	// 'rowid����Ҫ������кţ����Ϊ0������������
	public int DW_InsertRow(int rowid) {
		iret2 = parentClassDW.DW_InsertRow(rowid);
		getParentErr(iret2);
		return iret2;
	}

	public int DW_Retrieve() {
		iret2 = parentClassDW.DW_Retrieve();
		getParentErr(iret2);
		return iret2;
	}

	// '���ݴ��ڵļ������ܣ��ȼ۹���dw.Retrieve()
	// 'ǰ���������Ѿ�������datawindow����
	// 'args�Ǽ������õĲ�������������֮����TAB���ָ�
	// '20090116�Բ��������޸ģ�targetControls��targetPict������Ҫ�ⲿ����
	public int DW_Retrieve(String args) {
		iret2 = parentClassDW.DW_Retrieve(args);
		getParentErr(iret2);
		return iret2;
	}

	// '�ع�����'iret�Ƿ��ز���0 ���� -1 ʧ��
	public String DW_Rollback(MyInt iret) {
		String sret = parentClassDW.DW_Rollback(iret);
		errString = parentClassDW.errString;
		return sret;
	}

	// '�õ���ǰDataWindow�ڵļ�¼����
	// '����-1����ʧ��
	// '�����������ֵ>=0
	public int DW_RowCount() {
		iret2 = parentClassDW.DW_RowCount();
		getParentErr(iret2);
		return iret2;
	}

	public int DW_SetAutoCommit(int flag) {
		return parentClassDW.DW_SetAutoCommit(flag);
	}

	// '����dataobject����dataobject������һ���ַ���������
	// '����һ����ʵ�ֵķ�������������в��ٴ���vscroll,hscroll��Щ����
	// '����ͨ�������������з���
	public int DW_SetDataObject(List targetControlsArg, MyJPanel targetPictArg,
			MyJPanel parentPict, String sUIDesc, boolean childflag,
			boolean createflag) {
		iret2 = parentClassDW.DW_SetDataObject(targetControlsArg,
				targetPictArg, parentPict, sUIDesc, childflag, createflag);
		getParentErr(iret2);
		return iret2;
	}

	// '����dataobject����dataobject������һ���ַ���������
	// '����һ����ʵ�ֵķ�������������в��ٴ���vscroll,hscroll��Щ����
	// '����ͨ�������������з���
	public int DW_SetDataObjectByName(List targetControlsArg,
			MyJPanel targetPictArg, MyJPanel parentPict, String sdwName,
			boolean childflag, boolean createflag) {
		iret2 = parentClassDW.DW_SetDataObjectByName(targetControlsArg,
				targetPictArg, parentPict, sdwName, childflag, createflag);
		getParentErr(iret2);
		return iret2;
	}

	// '���������ߵ���ɫ0-15��Ч
	public int DW_SetGridLineColor(int color) {
		iret2 = parentClassDW.DW_SetGridLineColor(color);
		errString = parentClassDW.errString;
		return iret2;
	}

	// '��������,ֻ������PrimaryBuffer������
	public int DW_SetItem(int rowid, int colid, String sdata) {
		iret2 = parentClassDW.DW_SetItem(rowid, colid, sdata);
		getParentErr(iret2);
		return iret2;
	}

	// '���õ�ǰ��
	public int DW_SetRow(int rowid) {
		iret2 = parentClassDW.DW_SetRow(rowid);
		getParentErr(iret2);
		return iret2;
	}

	// '���ü����õ�Select���
	public int DW_SetSQLSelect(String strsql) {
		return parentClassDW.DW_SetSQLSelect(strsql);
	}

	// '���ݸ�����SQL��䣬�Լ���Ӧ�����ݴ�������
	// '���õ�g_webdw��ȥ
	// '�Ӷ���ת�����õ�һ����Ӧ�����ݴ��ڶ��������
	// 'iret����ֵ��0 ���� -1 ʧ��
	// '������Ϣ�����errstring��
	// '���������һ��Select����С�ͽ�����
	public String DW_SyntaxFromSQL(String strsql, String stype, MyInt iret) {
		String sret = parentClassDW.DW_SyntaxFromSQL(strsql, stype, iret);
		if (iret.intvalue == -1) {
			errString = parentClassDW.errString;
		}
		return sret;
	}

	// 'ִ��Dw��Update����,��������
	// '����0������óɹ�
	// '����-1������÷�������
	// '��targetControls,targetPict���Ӳ�����ȥ��
	public int DW_Update() {
		iret2 = parentClassDW.DW_Update();
		getParentErr(iret2);
		return iret2;
	}

	// '20090217���ṩ��Eval����
	// '���ĳ����ʵ������������������ʵ��ִ�еģ���ôֱ��ת�����������ִ��
	// 'ʵ�ʵ�ת��������parentclassdw��������
	// '�˴�������ֱ�ӵ���һ�¾Ϳ�����
	public String Eval(String command, MyInt iret) {
		String sret = parentClassDW.Eval(command, iret);
		if (iret.intvalue == -1) {
			errString = parentClassDW.errString;
		}
		return sret;
	}

	// '�����������õ���ǰ�������������������
	// '������Դ:local_webdw
	// '������������������ߵ�Xֵ����������ö��ŷָ����
	// '������Grid����Tabular�������ݴ��ڣ��������ķ���""
	public String GetGridLineInfo() {
		return parentClassDW.GetGridLineInfo();
	}

	// '���ݸ����ĵ�ǰ�ؼ������֣��жϵ�ǰ�����е����
	// '����-1����ʧ�ܣ�>=0�������
	public int GetRowIdColumnId(String currentControlName, MyInt rowid,
			MyInt colid) {
		iret2 = parentClassDW
				.GetRowIdColumnId(currentControlName, rowid, colid);
		getParentErr(iret2);
		return iret2;
	}

	// '�����ж����ַ���
	public int SetColumnDefString(String sColDefString) {
		return parentClassDW.SetColumnDefString(sColDefString);
	}

	// '���ø��������ݣ�����ʼ�����ݴ洢
	// 'targetControls �ؼ��ļ���
	// 'pictTarget Ҫ��ͼ�Ŀؼ�
	// 'indata �������õ�����
	// 'datastate ��ѡ��,���ݵ�״̬,Ĭ��Ϊ"normal"
	public int SetData(String indata) {
		iret2 = parentClassDW.SetData(indata);
		getParentErr(iret2);
		return iret2;
	}

	// '���ø��������ݣ�����ʼ�����ݴ洢
	// 'targetControls �ؼ��ļ���
	// 'pictTarget Ҫ��ͼ�Ŀؼ�
	// 'indata �������õ�����
	// 'datastate ��ѡ��,���ݵ�״̬,Ĭ��Ϊ"normal"
	public int SetData(String indata, String datastate) {
		iret2 = parentClassDW.SetData(indata, datastate);
		getParentErr(iret2);
		return iret2;
	}

	// '���������޸������ʾ���ֶ��п��
	// 'newX �µ��ֶ�Xֵ
	// 'oldX �ɵ��ֶ�Xֵ
	// '�޸�local_webdw����ֵ
	public int SetGridWidth(int newx, int oldx) {
		// TODO:�ں�̨�������������ȵĹ���
		// return parentClassDW.SetGridWidth(newx, oldx);
		return 0;
	}

	public String GetOutputData(){
		String s1= parentClassDW.webdwData.GetColumnString();
		s1=s1+"\r\n"+parentClassDW.webdwData.GetAllData();
		return s1;
	}
}
