package com.webdw;

//Rem CWebDW��һ��û�о���ʵ�ֹ��̵���ת��
//Rem �������Ŀ�������ζ���CWebDWUI_FromString��CWebDWUI_ToString�ķ���
//Rem ���еķ������CWebDW�����оͿ���
//Rem CWebDW��Ӧ�����ݽṹ��WebDWSyntax
//Rem CWebDW����������Դ��GG_WebDW

public class CWebDW extends Golbal {
	public void ReadMe(){
		System.out.println("CWebDW��һ��û�о���ʵ�ֹ��̵���ת��");
		System.out.println(JWebDWInfo);
	}
	public String dwString = "";// As String '��������洢Ҫ�������ַ���,δ���������Ƚ�,ֻ��

	public String errString = "";// As String '����ʧ���Ժ�Ĵ�����Ϣ�洢������

	// '----------���ض������װ��ʼ---------
	private CWebDW_Create reader = new CWebDW_Create();// '����һ����ȡ������

	private CWebDW_GetSyntaxString writer = new CWebDW_GetSyntaxString();// '����һ������ַ�����

	private CWebDW_GetRetrieveSQL sqlGener = new CWebDW_GetRetrieveSQL();// '����һ���õ����ݴ������Select����

	private CWebDW_SyntaxFromSQL synGener = new CWebDW_SyntaxFromSQL();// '����һ����select����﷨����

	// '----------���ض������װ����---------

	private WebDWSyntax local_webdw = new WebDWSyntax();// 'local_webdw������һ���ֲ������ˣ�������ȫ�ֱ�����

	// '��������������g_webdw��ֵ
	// '���룺gg_webdw
	// '�����local_webdw
	public void SetLocalWebDW() {
		local_webdw = Golbal.GG_webdw.Clone();
	}

	// '������������ȡlocal_webdw��ֵ
	// '����:local_webdw
	// '���:gg_webdw
	public void GetLocalWebDW() {
		Golbal.GG_webdw = local_webdw.Clone();
	}

	// '�����һ����Ҫ�Ķ��⹫���Ľ�������
	// '����һ���ַ���,����������һ��webdw�ṹ������
	// '���洢��g_webdw��
	// '�ַ����洢��dwString�б���
	// '����0����ɹ�
	// '�������ʧ��,����-1�����д���(һ�㲻��)
	// '���洢�ַ���,Ҳ���洢webdw
	// '������Ϣ�洢��errString��
	public int Create(String inString) {
		int iret = 0;// As Long
		iret = reader.Create(inString);

		dwString = inString;

		// '���±��ص�local_webdw����,��reader�ж�ȡ
		reader.GetLocalWebDW();
		SetLocalWebDW();

		if (iret == -1) {
			errString = reader.errString;
		}
		return iret;
	}

	// '�ڶ���g_webdw�Ժ󣬵õ���ʾ���������Ƶ��ַ�����ʾ
	// '����֮����chr(9)�ָ˳����column�����˳��
	// '�������������ʼ��webdwdata�����ݼ���
	// '����ǰ����local_webdw�Ѿ���������
	public String GetColumnDefineString() {
		String strcol = "";// As String
		int colid = 0;// As Long
		strcol = "";
		for (colid = 1; colid <= 100; colid++) {// 'g_webdw���������100���У��˴����ɶ�ȡcolumn�������ȡtable.column
			if (local_webdw.table.Columns[colid].Name.equals("")) {
				break;
			}

			if (strcol.equals("")) {
				strcol = strcol + local_webdw.table.Columns[colid].Name;
			} else {
				strcol = strcol + Chr(9)
						+ local_webdw.table.Columns[colid].Name;
			}
		}

		return strcol; // '�����ַ���
	}

	// '������������local_webdwת����һ��ָ����ʽ���ַ���
	// '�Ժ�Ҫ�޸����ɵ��ַ�����ֻ��Ҫ�޸�g_webdw�����ݾͿ�����
	// '��һ������Ӧ��PB��describe("dw_1.syntax")
	public String GetSyntaxString(MyInt iret) {
		GetLocalWebDW();
		writer.SetLocalWebDW();
		String s1 = "";
		s1 = writer.GetSyntaxString(iret);
		if (iret.intvalue == -1) {
			errString = writer.errString;
		}
		return s1;
	}

	// '������������DW�����У��ֽ�õ����ݿ�����õ�Select���
	// 'Ϊ��һ��ִ��SQL�������»���
	// '���SQL�����ܻ���в���
	public String GetRetrieveSQL() {
		GetLocalWebDW();
		sqlGener.SetLocalWebDW();
		return sqlGener.GetRetrieveSQL();
	}

	// '���ݸ�����SQL��䣬�Լ���Ӧ�����ݴ�������
	// '���õ�g_webdw��ȥ
	// '�Ӷ���ת�����õ�һ����Ӧ�����ݴ��ڶ��������
	// 'iret����ֵ��0 ���� -1 ʧ��
	// '������Ϣ�����errstring��
	// '���������һ��Select����С�ͽ�����
	public String SyntaxFromSQL(String strsql, String stype, MyInt iret) {

		String s1 = "";
		s1 = synGener.SyntaxFromSQL(strsql, stype, iret);
		if (iret.intvalue == -1) {
			errString = synGener.errString;
		}
		synGener.GetLocalWebDW();
		SetLocalWebDW();
		return s1;
	}

//	'����ColumnDefineString
	public int SetColumnDefineString(String colDefString ){
	    synGener.colDefString = colDefString;
	    return 0;
	}
	
//	'���ݸ�����columnname�����㷵�ص��б��(1 based)
//	'����local_webdw������õ�
	public int GetColumnIdByColumnName(String colname){
	    int colid =0;
	    for(colid = 1;colid<=100;colid++){
	        if( UCase(colname).equals(UCase(local_webdw.table.Columns[colid].Name))){
	            return colid;
	        }
	    }
	    return -1;
	}

//	'�õ����������ȣ��������������ú����������λ�õ���Ϣ
	public long getMaxWidth() {
	    int i = 0;//As Long
	    long imax = 0;// As Long
	    imax = 0;
	    //'ѭ����ȡlabel�������
	    for( i = 1 ;i<= 100;i++){
	        if( local_webdw.text[i].Name.equals("")){
	            break;
	        }
	        
	        if( local_webdw.text[i].x + local_webdw.text[i].width > imax){
	            imax = local_webdw.text[i].x + local_webdw.text[i].width;
	        }
	    }
	    
	    //'ѭ����ȡtext�������
	    for( i = 1 ;i<= 100;i++){
	        if(local_webdw.column[i].Name.equals("")){
	            break;
	        }
	        
	        if( local_webdw.column[i].x + local_webdw.column[i].width > imax){
	            imax = local_webdw.column[i].x + local_webdw.column[i].width;
	        }
	    }
	    
	    //'ѭ����ȡline�����������
	    for( i = 1 ;i<= 100;i++){
	        if( local_webdw.lineinfo[i].Name.equals("")){
	            break;
	        }
	        
	        if( local_webdw.lineinfo[i].x1 > imax){
	        	imax = local_webdw.lineinfo[i].x1;
	        }
	        if( local_webdw.lineinfo[i].x2 > imax){
	        	imax = local_webdw.lineinfo[i].x2;
	        }
	    }
	    
	    return imax;
	}




}
