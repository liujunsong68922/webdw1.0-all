package com.webdw;

//Rem -------------------------------------------------
//Rem WebDW������������
//Rem Ŀ���ǶԿͻ��˵ķ����ṩһ���ں�̨������֧������
//Rem �����Ȳ���һ�����ݿ������
//Rem @CopyRight Mr.Liu Junsong 2008-2009
//Rem @��Ȩ���� ������ 2008-2009
//Rem E_mail : liujunsong@yahoo.com.cn
//Rem -------------------------------------------------
import java.io.*;
import java.net.*;

public class CWebDWTransaction extends Golbal {
	public void ReadMe(){
		System.out.println("����֧�֣���̨���������");
		System.out.println(JWebDWInfo);
	}
	// '���ʵ��ò���,��Ҫ�ⲿ������
	private String serverURL = ""; // '��̨���ʵ�URL,�����ṩ��������Ȩ�ޣ�ͨ��g_serverurl������

	public String userid = ""; // '��½���û���

	public String passwd = ""; // '�����ÿ���

	public String opertype = ""; // '���ʵĲ�������

	public String command = ""; // 'Ҫִ�еľ���ָ��

	public int beginPos = 0; // '��ѯ����Ŀ�ʼ������Ĭ��Ϊ0,��ζ����������

	public int readNum = 1000; // '��ѯ����ķ���������Ĭ��Ϊ1000

	public String transid = ""; // '��֧�����������£�transId��ʾ�����

	public String errString = ""; // '������Ϣ�洢�ַ���

	public String resultString = ""; // 'ִ�к�ķ����ַ���

	// '����������ִ��һ��SQL��䣬����һ����׼�Ľ���ַ���
	// 'Ҫִ�е�sql����Լ���ز�����������public����
	// 'ִ��֮ǰ�������ø����������ٵ��ô˷���
	// '�����Ƶ�Ŀ������Ϊһ������������������Ի󲻽�
	// 'iret ����״̬��0���� -1 ʧ��
//	public String ExecuteSelect(MyInt iret,int i) {
//
//		String sURL = "";
//
//		errString = "";
//		serverURL = Golbal.G_ServerURL;// '��ȡG_ServerURL
//
//		// '����Ҫִ�е�sql�����һ��rand������Ϊ�˽�����������
//		sURL = serverURL + "?opertype=" + opertype + "&command=" + command
//				+ "&beginpos=" + beginPos + "&readnum=" + readNum + "&userid="
//				+ userid + "&passwd=" + passwd + "&rand=" + Now();
//		try {
//			//MyInt iret = new MyInt(0);
//			String svalue = callServer(sURL,iret);
//
//			return svalue;
//		} catch (Exception e) {
//			e.printStackTrace();
//			iret.intvalue = -1;
//			errString = "���ݿ���ʷ����쳣" + e;
//			return "";
//		}
//
//	}

//	private String CallServer(String surl) throws Exception {
//		URL url = new URL(surl);
//		URLConnection conn = url.openConnection();
//
//		System.out.println("getting inputStream finished");
//
//		BufferedReader in = new BufferedReader(new InputStreamReader(conn
//				.getInputStream()));
//		String s = null;
//		String svalue = "";
//		int i = 0, j = 0;
//		while ((s = in.readLine()) != null) {
//			if (!s.equals("OK")) {
//				if (svalue.equals("")) {
//					svalue = s;
//				} else {
//					svalue = svalue + "\r\n" + s;
//				}
//			}
//		}
//		in.close();
//		// String svalue = (String) objectinputstream.readObject();
//
//		System.out.println(svalue);
//		return svalue;
//	}

	// '����������ִ��һ��SQL��䣬����һ����׼�Ľ���ַ���
	// '���������һ���ײ��ʵ�ʵ��ù��̣�
	// '�����������������������������е��õ�
	// '��׼����һ���ַ���
	// '����д��󣬴���洢��errString����
	private String callServer(String opertypearg, MyInt iret) {// As String
		String surl = "";// As String

		errString = "";
		opertype = opertypearg;// '����Ϊ��ѯ����

		// '����Ҫִ�е�sql�����һ��rand������Ϊ�˽�����������
		surl = Golbal.G_ServerURL + "?opertype=" + opertype + "&command="
				+ URLEncoder.encode(command) + "&beginpos=" + beginPos + "&readnum=" + readNum
				+ "&userid=" + userid + "&passwd=" + passwd + "&transid="
				+ transid + "&rand=" + Rnd(10);
		System.out.println(surl);
		try {
			URL url = new URL(surl);
			URLConnection conn = url.openConnection();
			//conn.setReadTimeout(30000);
			System.out.println("getting inputStream finished");
			//conn.connect();
			HttpURLConnection hconn = (HttpURLConnection)conn;
			hconn.setDoInput(true);
			//hconn.setReadTimeout(30000);
			InputStream ins = hconn.getInputStream();
			BufferedReader in = new BufferedReader(new InputStreamReader(ins));
			String s = null;
			String svalue = "";
			int i = 0, j = 0;
			while ((s = in.readLine()) != null) {
				if (!s.equals("OK")) {
					if (svalue.equals("")) {
						svalue = s;
					} else {
						svalue = svalue + "\r\n" + s;
					}
				}else{
					svalue = svalue + "\r\n" +s;
				}
			}
			in.close();

			if (svalue.indexOf("Exception") > 0) {
				iret.intvalue = -1;
				errString = svalue;
				svalue = "";
			} else {
				iret.intvalue = 0;
			}
			return svalue;
		} catch (Exception e) {
			e.printStackTrace();
			iret.intvalue = -1;
			errString = e.toString();
			//MessageBox(e.toString());
			return "";
		}
	}

	// '��Ҫ���£��¹��ܣ��ڿͻ�������һ����̨����(��������)
	// 'iret�Ƿ��ز���0 ���� -1 ʧ��
	public String AddCommand(MyInt iret) {// As String
		if (transid.equals("")) {// = "" Then
			iret.intvalue = -1;
			errString = "Please Start Transaction Frist";
			return "";
		}
		return callServer(Golbal.G_Transaction_Const.Trans_AddCommand, iret);
	}

	// '��Ҫ���£��¹��ܣ��ڿͻ�������һ����̨����(��������)
	// '�����ַ�������������
	// 'iret�Ƿ��ز���0 ���� -1 ʧ��
	public String BeginTransaction(MyInt iret) {
		if (transid.length() > 0) {// Then
			iret.intvalue = -1;
			errString = "Please call Commit or Rollback First";
			return "";
		}

		String sret = "";
		int pos1 = 0;
		sret = callServer(Golbal.G_Transaction_Const.Trans_BeginTrans, iret);
		if (iret.intvalue == -1) {
			return "";
		}
		// '��Ҫ��BeginTransaction�ķ��ؽ���н�������������
		// '����transId
		pos1 = InStr(sret, "" + Chr(13) + Chr(10) + "OK");
		if (pos1 > 0) {// Then
			transid = Left(sret, pos1 - 1);
			iret.intvalue = 0;
			return transid;
		} else {
			iret.intvalue = -1;
			return "";
		}
	}

	// '��Ҫ���£��¹��ܣ��ڿͻ����ύһ����̨����(��������)
	// 'iret�Ƿ��ز���0 ���� -1 ʧ��
	public String Commit(MyInt iret) {

		if (transid.equals("")) {
			iret.intvalue = -1;
			errString = "Please Call BeginTransaction Frist";
			return "";
		}

		String sret = callServer(Golbal.G_Transaction_Const.Trans_Commit, iret);
		transid = "";// '�����ǰ������
		return sret;
	}

	private boolean startWith(String str1, String str2) {
		if (UCase(Left(str1, Len(str2))).equals(UCase(str2))) {
			return true;
		} else {
			return false;
		}
	}

//	'��������ַ����У���������ߵ�һ�����ţ��õ�����Ψһ��һ������
//	'������������������������ȥ�����ߵ�����
//	'iret = 0 �����ɹ�
//	'iret = -1 ����ʧ��
	private String getOneInputArg(String cmd, MyInt iret ) {
	    int pos1 = 0;// As Long    '������
	    int pos2 =0;//As Long    '������
	    String stemp ="";// As String '��ʱ����
	    
	    pos1 = InStr(cmd, "(");
	    
	    //'pos2ָ���������һ��������
	    for( pos2 = Len(cmd);pos2 >= 1 ;pos2--){
	        if( Mid(cmd, pos2, 1).equals(")")){
	            break;
	        }
	    }
	    
	    if( pos1 <= 0 || pos2 <= 0 || pos1 > pos2){
	        iret.intvalue = -1;
	        errString = "�����������ʧ��:" + cmd;
	        return "";
	    }
	    
	    stemp = Mid(cmd, pos1 + 1, pos2 - (pos1 + 1));
	    stemp = Trim(stemp);
	    
	    //'ȥ��ǰ�������
	    if( Left(stemp, 1).equals( "\"") && Right(stemp, 1).equals( "\"") && Len(stemp) > 1){
	        stemp = Mid(stemp, 2, Len(stemp) - 2);
	    }
	    
	    iret.intvalue = 0;
	    return stemp;
	}	
	// 'Ϊ�˼������ݵ��������Լ����ٹ���Ķ���ӿ�
	// '���ڱ��س��������úͶ�ȡ������һ��ͳһ�Ľӿ���ʵ��
	// '�������command����
	// '�˷��������20090217��
	// '���÷�ʽΪeval("SetCommand(" + sql+")")�Ϳ�������command������
	public String Eval(String commandarg ,MyInt iret ){
	    if( commandarg.equals("")){
	         iret.intvalue = 0;
	        return "";
	    }
	    
// 'Ŀǰ֧�ֵĶ�ִ̬�з���ΪSetCommand,SetUserid,SetPasswd,SetBeginPos,SetReadNum,SetTransId
// '��ȡ�Ķ�ִ̬�з���ΪGetCommand,GetUserid,GetPasswd,GetBeginPos,GetReadNum,GetTransId
//	        
// '�ȴ������Get������֧�֣����е�Get��������Ҫ���⴫������Ľ�������
	    if( startWith(commandarg,"GetCommand")){
	        iret.intvalue = 0;
	        return command;
	    }
	    
	    if(startWith(commandarg,"GetUserid")){
	        iret.intvalue = 0;
	        return userid;
	    }
	    
	    if(startWith(commandarg,"GetPasswd")){
	        iret.intvalue = 0;
	        return passwd;
	    }
	    
	    if(startWith(commandarg,"GetBeginPos")){
	        iret.intvalue = 0;
	        return new Integer(beginPos).toString();
	    }
	    
	    if(startWith(commandarg,"GetReadNum")){
	        iret.intvalue = 0;
	        return new Integer(readNum).toString();
	    }
	    
	    if(startWith(commandarg,"GetTransId")){
	        iret.intvalue = 0;
	        return transid;
	    }

	    
//	    '���ṩ����Set��ʽ��֧�֣�Set��ʽ֧��ʱ��Ҫ�Ӵ��������н���������Ĳ�������
//	    '����Ĳ���������˫������������Set����ֻ����һ������,����������������
	    String arg1 ="";
	    
	    if(startWith(commandarg,"SetCommand(")){
	        arg1 = getOneInputArg(commandarg, iret);
	        if( iret.intvalue == -1){
	        	return "";
	        }else{
	            command = arg1;
	            return "OK";
	        }
	    }

	    if(startWith(commandarg,"SetUserid(")){
	        arg1 = getOneInputArg(commandarg, iret);
	        if( iret.intvalue == -1){
	        	return "";
	        }else{
	            userid = arg1;
	            return "OK";
	        }
	    }

	    if(startWith(commandarg,"SetPasswd(")){
	        arg1 = getOneInputArg(commandarg, iret);
	        if( iret.intvalue == -1){
	        	return "";
	        }else{
	            passwd = arg1;
	            return "OK";
	        }
	    }

	    if(startWith(commandarg,"SetBeginPos(")){
	        arg1 = getOneInputArg(commandarg, iret);
	        if( iret.intvalue == -1){
	        	return "";
	        }else{
	            beginPos = toInt(arg1);
	            return "OK";
	        }
	    }    
	    
	    if(startWith(commandarg,"SetReadNum(")){
	        arg1 = getOneInputArg(commandarg, iret);
	        if( iret.intvalue == -1){
	        	return "";
	        }else{
	            readNum = toInt(arg1);
	            return "OK";
	        }
	    }  	    
	
	    if(startWith(commandarg,"SetTransId(")){
	        arg1 = getOneInputArg(commandarg, iret);
	        if( iret.intvalue == -1){
	        	return "";
	        }else{
	            transid = arg1;
	            return "OK";
	        }
	    } 
	    
	    
//	    '���ڷ�GetSet��������ʱ��Ȼ���ñ�׼�ĺ������������е��á�
//	    '���ڲ���֧�ֵ��������ͣ�ֱ�ӷ���ʧ��ʧ����Ϣ
//	UnknownCommand:
	    iret.intvalue = -1;
	    errString = "Unknown Command: " + command;
	    return "";
	    
	}
	
//	'����������ִ��һ��SQL��䣬�õ���̨��ָ�����ݱ���������б�
//	'����֧�����Ҫ�ں�̨��ʵ�֣�ǰ̨����������淢��һ������
//	'iret   ����״̬��0���� -1 ʧ��
	public String ExecuteColumnList(MyInt iret ){
	    return callServer(Golbal.G_Transaction_Const.Trans_Oper_ColumnList, iret);
	}

//	'����������ִ��һ��SQL��䣬����һ����׼�Ľ���ַ���
//	'Ҫִ�е�sql����Լ���ز�����������public����
//	'ִ��֮ǰ�������ø����������ٵ��ô˷���
//	'�����Ƶ�Ŀ������Ϊһ������������������Ի󲻽�
//	'iret   ����״̬��0���� -1 ʧ��
	public String ExecuteSelect(MyInt iret ){

	    //'����һ��������жϣ�ȷ��SQL������Select��ͷ,������ǣ�ֱ���˳�
	    command = Trim(command);
	    
	    if(! Left(UCase(command), 6).equals("SELECT")) {
	        iret.intvalue = -1;
	        errString = "Error SQL Type:" + command;
	        return "";
	    }
	    
	    return callServer(Golbal.G_Transaction_Const.Trans_Oper_Query, iret);
	}

//	'����������ִ��һ��SQL��䣬�õ���̨�����ݱ���ͼ���б�
//	'����֧�����Ҫ�ں�̨��ʵ�֣�ǰ̨����������淢��һ������
//	'iret   ����״̬��0���� -1 ʧ��
	public String ExecuteTableList(MyInt iret ){
	    return callServer(Golbal.G_Transaction_Const.Trans_Oper_TableList, iret);
	}
	
//	'ִ��һ��Update�������Insert,����Delete����ķ���
//	'��һ������������ʽ�����汾�з�����
	private String executeUpdate(MyInt iret ){
	    return callServer(Golbal.G_Transaction_Const.Trans_Oper_Exec, iret);
	}

//	'�Ӻ�̨�������ϵõ�ָ���ļ�������ļ��������ݴ��ڵĶ���
//	'��һ���������������ݴ��ڵ������ݴ��ڶ���
//	'ֻ���������ܲ����޸ĵ�ʹ��PB�Զ����ɵ����ݴ��ڶ���
	public String GetDWDefine(String dwfileName, MyInt iret){
	    command = dwfileName;
	    return callServer(Golbal.G_Transaction_Const.Trans_GetDWDefine, iret);
	}

//	'��Ҫ���£��¹��ܣ��ڿͻ����ύһ����̨����(��������)
//	'iret�Ƿ��ز���0 ���� -1 ʧ��
	public String Rollback(MyInt iret){
	    
	    if( transid.equals("")){
	        iret.intvalue = -1;
	        errString = "Please Call BeginTransaction Frist";
	        return "";
	    }
	    
	    String sret = callServer(Golbal.G_Transaction_Const.Trans_Rollback, iret);
	    transid = ""    ;//        '�����ǰ������
	    return sret;

	}


}
