package com.webdw;
//Rem -------------------------------------------------
//Rem WebDW�����ݴ����Զ�������
//Rem ���������Ŀ���Ǹ���һ��Select��䣬�Զ����local_webdw����ֵ
//Rem ������û�кͺ�̨���ݿ�Ľ���������Ҫ�������������ṩ����
//Rem �������ɵ����ݴ��ڵ����Ͳ�ͬ����Ϊ�����ͬ�ķ�����ʵ��
//Rem @CopyRight Mr.Liu Junsong 2008-2009
//Rem @��Ȩ���� ������ 2008-2009
//Rem E_mail : liujunsong@yahoo.com.cn
//Rem -------------------------------------------------
public class CWebDW_SyntaxFromSQL extends Golbal {
	public void ReadMe(){
		System.out.println("WebDW�����ݴ����Զ�������");
		System.out.println(JWebDWInfo);
	}
	//'���ñ�������
	public String errString="";// As String      '������Ϣ�洢�ַ���������ַ���

	//'colDefString�ַ��������ݴ��ⲿֱ�Ӵ���
	public String colDefString="";// As String   '�����д洢�ַ�������ʽΪ����һ�����б������У��еĶ�����Ϣ

	private String columnlist=""; //As String    'select�������б�
	private String  tablelist=""; // As String     'select����table�б�
	private String  joinlist=""; // As String      'select�����������
	private String  wherelist=""; // As String     'select����where�����־�

	private int color_white = 16777215;

	private WebDWSyntax local_webdw =null;// 'local_webdw������һ���ֲ������ˣ�������ȫ�ֱ�����

//	'��������������local_webdw��ֵ
//	'���룺glocal_webdw
//	'�����local_webdw
	public void SetLocalWebDW(){
	    local_webdw = Golbal.GG_webdw.Clone();
	}

//	'������������ȡlocal_webdw��ֵ
//	'����:local_webdw
//	'���:glocal_webdw
	public void GetLocalWebDW(){
	   Golbal.GG_webdw = local_webdw.Clone();
	}

//	'���ݸ�����SQL��䣬�Լ���Ӧ�����ݴ�������
//	'���õ�local_webdw��ȥ
//	'�Ӷ���ת�����õ�һ����Ӧ�����ݴ��ڶ��������
//	'iret����ֵ��0 ���� -1 ʧ��
//	'������Ϣ�����errstring��
//	'���������һ��Select����С�ͽ�����
	public String SyntaxFromSQL(String strsql ,String stype ,MyInt iret){
		iret.intvalue = -1;
		errString ="SyntaxFromSQL������δ��ֲ���!";
		return "";
	}



}
