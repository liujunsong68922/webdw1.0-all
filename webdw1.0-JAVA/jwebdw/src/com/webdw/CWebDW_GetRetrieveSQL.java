package com.webdw;

import java.util.ArrayList;

//Rem -------------------------------------------------
//Rem WebDW�ĵ����ݷ��ʹ�����
//Rem ���룺g_webdw
//Rem g_webdw����CWebDW�������ɵ�
//Rem �����Ժ󣬶���g_webdw���������ݶ�ȡ����ȫ��������CWebDWReader��ʵ��
//Rem ����������ȷ����Ĺ��ܻ��֣�����������
//Rem @CopyRight Mr.Liu Junsong 2008-2009
//Rem @��Ȩ���� ������ 2008-2009
//Rem E_mail : liujunsong@yahoo.com.cn
//Rem -------------------------------------------------

public class CWebDW_GetRetrieveSQL extends Golbal {
	public void ReadMe(){
		System.out.println("WebDW�ĵ����ݷ��ʹ�����");
		System.out.println(JWebDWInfo);
	}
	private WebDWSyntax local_webdw = null;// 'local_webdw������һ���ֲ������ˣ�������ȫ�ֱ�����

	// '��������������g_webdw��ֵ
	// '���룺gg_webdw
	// '�����g_webdw
	public void SetLocalWebDW() {
		local_webdw = Golbal.GG_webdw.Clone();
	}

	// '������������ȡg_webdw��ֵ
	// '����:g_webdw
	// '���:gg_webdw
	public void GetLocalWebDW() {
		Golbal.GG_webdw = local_webdw.Clone();
	}

	// '��������ַ������м��
	// '�����"��ͷ����"����,��ô��ɾ����ǰ�����������
	private String removeQuote(String strIn) {
		int ilen;
		ilen = Len(strIn);

		if (strIn.equals("")) {
			return "";
		}
		if (Left(strIn, 1).equals("\"") && Right(strIn, 1).equals("\"")) {
			return Mid(strIn, 2, ilen - 2);
		}
		return strIn;
	}

	// '�õ�label������
	private int getLableNum() {
		int id = 0;
		for (id = 1; id <= 100; id++) {
			if (local_webdw.text[id].Name.equals("")) {
				return id - 1;
			}
		}
		return id - 1;
	}

	// '��inString�ַ����У�����Ԫ�ص����ƣ��õ����Ԫ�ص����������ַ���
	// '���ҵ��㷨�ǣ�
	// '��ԭʼ�ַ����п�ʼ���ң��ҵ�eleName�����ĺ���Ӧ�ø���һ��(����־���Ԫ�صĿ�ʼ
	// 'Ԫ���п���Ƕ�׶����ڲ�Ԫ�أ������Ҫ���ҵ���()���м���
	// '���ص��ַ��������ٰ���()
	// '���ҵ��㷨������webdw�ľ����ʾ��Ŀǰ���ú�PB7һ�µı�ʾ����
	// '���ճ�����ƣ�webdwӦ�ÿ���֧��PB7������DW��������ʾ����
	// '����˵��webdw��PB7�Ǽ��ݵġ�
	// 'inString �ܵ��ַ���
	// 'eleName Ԫ������
	// 'beginPos ��ʼ����λ��
	// 'findPos �������,��ʾ�ҵ���λ��,û�ҵ�����-1,Ҫ���ز���,������Integer����
	private String getElementDesc(String inString, String eleName,
			int beginPos, MyInt findPos) {
		int iBeg;
		int leftPos;
		int iflag;

		int i;
		String s;

		findPos.intvalue = -1; // '��ʼ��findPos��ֵ��������ı䣬���صľ���-1

		iBeg = InStr(beginPos, inString, eleName);
		if (iBeg <= 0) {
			return ""; // '���ؿ��ַ�������û���ҵ����Ԫ��
		}

		leftPos = InStr(iBeg, inString, "("); // '�õ��������ŵ�λ��
		if (leftPos <= 0) {
			return ""; // '���ؿ��ַ�������û���ҵ����Ԫ��
		}

		iflag = 0; // 'ÿ�ҵ�һ��(��iflag++,�ҵ�һ��) iflag --
		for (i = leftPos + 1; i <= VBFunction.Len(inString); i++) {
			s = Mid(inString, i, 1); // 'ȡ��ǰ�ַ���

			if (s.equals("(") || s.equals("")
					&& Mid(inString, i - 1, 1).equals("~")) { // '�����()����Ҫ�ж��ϸ��ַ��Ƿ���~,����ǲ�����
				continue;
			}

			if (s.equals("(")) {
				iflag = iflag + 1;
				continue; // '��������ѭ��
			}

			if (s.equals(")")) { // '��ǰֵΪ)ʱ��Ҫ�ж�iflag��ֵ
				if (iflag == 0) { // 'iflag=0�����Խ���ѭ��
					String s1 = Mid(inString, leftPos, i - leftPos + 1);
					findPos.intvalue = leftPos; // '�ҵ���λ����leftPos
					return s1;
				} else {
					iflag = iflag - 1; // '����iflag��ȥ1
				}
			}
		}

		return "";
	}

	// '��Ԫ�ر�ʾ���ַ������棬�����Ű���������
	// 'ȡ��ָ�������Ե�ʵ������ֵ
	// '����Ҳ������򷵻�һ�����ַ���
	// 'retFlag��һ����־�ַ���������0�����ҵ��ˣ�����-1����û�����ָ�����ƵĲ���
	// 'eleString ֻ��
	// 'paraName ֻ������Сд���У�
	// 'begPos ��ʼ���ҵ�
	// 'defValue �Ҳ���ʱ���Ĭ��ֵ
	// 'retFlag �������0����ɹ�����-1����ʧ��
	// 'sep �����ķָ���ţ������˷��Ŵ������

	private String getElementProp(String eleString, String paraName,
			int begPos, String defValue, MyInt retFlag, String sep) {
		int iBeg = 0;
		int iEnd = 0;
		int ipos = 0;
		int i = 0;
		int iflag = 0;
		String s = "";
		String svalue = "";

		retFlag.intvalue = -1;
		ipos = InStr(begPos, eleString, paraName + "=");// '�ҵ��������ƵĿ�ʼ��
		if (ipos <= 0) {// '�Ҳ������˳�
			return defValue;// '����Ĭ��ֵ
		}

		iBeg = ipos + Len(paraName + "=");// 'iBeg����ֵ�Ŀ�ʼ��
		iflag = 0;
		for (i = iBeg; i <= Len(eleString); i++) {
			s = Mid(eleString, i, 1);

			if (s.equals("\"")) {// '�����ǰ�ַ��������ţ���ô���ñ�־
				if (iflag == 0) {
					iflag = 1;
				} else {
					iflag = 0;
				}
				continue;
			}

			if (s.equals(sep)) {// '���s�ǽ������ţ���Ҫ����iFlag���ж�
				if (iflag == 0) {// '��������ַ����ڣ���ô���˳�
					svalue = Mid(eleString, iBeg, i - iBeg);
					svalue = removeQuote(svalue);// 'ȥ����ͷ�ͽ�β������
					retFlag.intvalue = 0;// '��־�ɹ�����
					return svalue;// '�˳��˹���
				}
			}

		}

		return defValue;// '����Ĭ��ֵ
	}

	// '������������������ַ����зֳɰ������ʵ��Ԫ�ص�array����
	// 'ֻ��ȡ���е�ָ�����Ͷ���
	private ArrayList getAllElement(String inString, String eletype) {
		ArrayList myarray = new ArrayList();
		String stext = "";
		MyInt ipos = new MyInt(0);

		// '�ֽ�dwString�������е�Ԫ��ȡ������������myarray��ȥ

		stext = getElementDesc(inString, eletype + "(", 1, ipos);
		while (ipos.intvalue > 0) {
			myarray.add(stext); // '�����ڼ���sText
			stext = getElementDesc(inString, eletype + "(", ipos.intvalue + 1,
					ipos);
		}

		return myarray;
	}

	// '������������DW�����У��ֽ�õ����ݿ�����õ�Select���
	// 'Ϊ��һ��ִ��SQL�������»���
	// '���SQL�����ܻ���в���
	public String GetRetrieveSQL() {

		int id = 0;
		String select_tablelist = "";// 'tabel �Ӿ�
		String select_columnlist = "";// 'column �Ӿ�
		String select_join = "";// 'join �����Ӿ�
		String select_where = "";// 'where�Ӿ�
		String select_orderby = "";// As String 'order by�Ӿ�

		select_tablelist = "";
		for (id = 1; id <= 10; id++) {
			if (local_webdw.table.retrieve.pbselect.table[id].equals("")) {
				break;
			}

			if (select_tablelist.equals("")) {
				select_tablelist = local_webdw.table.retrieve.pbselect.table[id];

			} else {
				select_tablelist = select_tablelist + ","
						+ local_webdw.table.retrieve.pbselect.table[id];// 'ƴװTable�Ӿ�
			}

		}

		select_columnlist = "";
		for (id = 1; id <= 100; id++) {
			if (local_webdw.table.retrieve.pbselect.column[id].equals("")) {
				break;
			}

			if (select_columnlist.equals("")) {
				select_columnlist = local_webdw.table.retrieve.pbselect.column[id];
			} else {
				select_columnlist = select_columnlist + ","
						+ local_webdw.table.retrieve.pbselect.column[id];
			}
		}

		select_join = "";
		for (id = 1; id <= 10; id++) {
			if (local_webdw.table.retrieve.pbselect.join[id].join_left
					.equals("")) {
				break;
			}

			if (select_join.equals("")) {
				select_join = "("
						+ local_webdw.table.retrieve.pbselect.join[id].join_left
						+ " "
						+ local_webdw.table.retrieve.pbselect.join[id].join_op
						+ " "
						+ local_webdw.table.retrieve.pbselect.join[id].join_right
						+ ")";
			} else {
				select_join = select_join
						+ " AND "
						+ "("
						+ local_webdw.table.retrieve.pbselect.join[id].join_left
						+ " "
						+ local_webdw.table.retrieve.pbselect.join[id].join_op
						+ " "
						+ local_webdw.table.retrieve.pbselect.join[id].join_right
						+ ")";
			}
		}

		select_where = select_join;
		for (id = 1; id <= 10; id++) {
			if (local_webdw.table.retrieve.pbselect.where[id].exp1.equals("")) {
				break;
			}

			if (select_where.equals("")) {
				select_where = "("
						+ local_webdw.table.retrieve.pbselect.where[id].exp1
						+ " "
						+ local_webdw.table.retrieve.pbselect.where[id].op
						+ " "
						+ local_webdw.table.retrieve.pbselect.where[id].exp2
						+ ") "
						+ local_webdw.table.retrieve.pbselect.where[id].logic;
			} else {
				select_where = select_where + " And " + "("
						+ local_webdw.table.retrieve.pbselect.where[id].exp1
						+ " "
						+ local_webdw.table.retrieve.pbselect.where[id].op
						+ " "
						+ local_webdw.table.retrieve.pbselect.where[id].exp2
						+ ") "
						+ local_webdw.table.retrieve.pbselect.where[id].logic;
			}
		}

		if (!select_where.equals("")) {
			select_where = " Where " + select_where;
		}
//	    '���Ӷ�order by �Ӿ��֧�֣�20090204
//	    select_orderby = ""
//	    For id = 1 To 10
//	        If local_webdw.table.retrieve.pbselect.order(id).Name = "" Then
//	            Exit For
//	        End If
//	        
//	        If select_orderby = "" Then
//	            If UCase(local_webdw.table.retrieve.pbselect.order(id).Asc) = "YES" Then
//	                select_orderby = local_webdw.table.retrieve.pbselect.order(id).Name & " ASC "
//	            Else
//	                select_orderby = local_webdw.table.retrieve.pbselect.order(id).Name & " DESC "
//	            End If
//	        Else
//	            If UCase(local_webdw.table.retrieve.pbselect.order(id).Asc) = "YES" Then
//	                select_orderby = select_orderby & " , " _
//	                            & local_webdw.table.retrieve.pbselect.order(id).Name & " ASC "
//	            Else
//	                select_orderby = select_orderby & " , " _
//	                            & local_webdw.table.retrieve.pbselect.order(id).Name & " DESC "
//	            End If
//	        End If
//	    Next

	    //'���Ӷ�order by �Ӿ��֧�֣�20090204
	    select_orderby = "";
	    for( id = 1;id<=10;id++){
	        if( local_webdw.table.retrieve.pbselect.order[id].Name.equals("")) {
	            break;
	        }
	        
	        if( select_orderby.equals("")){
	            if( UCase(local_webdw.table.retrieve.pbselect.order[id].Asc).equals("YES")) {
	                select_orderby = local_webdw.table.retrieve.pbselect.order[id].Name + " ASC ";
	            }else{
	                select_orderby = local_webdw.table.retrieve.pbselect.order[id].Name + " DESC ";
	            }
	        }else{
	            if( UCase(local_webdw.table.retrieve.pbselect.order[id].Asc).equals("YES")){
	                select_orderby = select_orderby + " , " 
	                            + local_webdw.table.retrieve.pbselect.order[id].Name + " ASC ";
	            }else{
	                select_orderby = select_orderby + " , " 
	                            + local_webdw.table.retrieve.pbselect.order[id].Name + " DESC ";
	            }
	        }
	    }
//	    If select_orderby > "" Then
//        select_orderby = " Order By " & select_orderby
//    End If

	    if( select_orderby.length()>0){
	    	select_orderby = " Order By " + select_orderby;
	    }
	    
		String SQL = "Select " + select_columnlist + " from "
				+ select_tablelist + select_where+ select_orderby;
		SQL = Replace(SQL, "~\"", "");
		return SQL;
	}

}
