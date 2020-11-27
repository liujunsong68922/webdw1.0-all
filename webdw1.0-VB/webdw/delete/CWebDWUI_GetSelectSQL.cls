VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDW_GetRetrieveSQL"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW�ĵ����ݷ��ʹ�����
Rem ���룺local_webdw
Rem local_webdw����CWebDW�������ɵ�
Rem �����Ժ󣬶���local_webdw���������ݶ�ȡ����ȫ��������CWebDWReader��ʵ��
Rem ����������ȷ����Ĺ��ܻ��֣�����������
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @��Ȩ���� ������ 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit
Option Base 1

Private local_webdw As WebDWSyntax       '���ڽ�local_webdw�����һ���ֲ�����������ȫ�ֱ�����

'��������������local_webdw��ֵ
'���룺glocal_webdw
'�����local_webdw
Public Function SetLocalWebDW()
    local_webdw = GG_webdw
End Function

'������������ȡlocal_webdw��ֵ
'����:local_webdw
'���:glocal_webdw
'��һ����Ӧ�������õģ���Ϊ���������local_webdw������������������
Private Function getLocalWebDW()
    GG_webdw = local_webdw
End Function


'��������ַ������м��
'�����"��ͷ����"����,��ô��ɾ����ǰ�����������
Private Function removeQuote(ByRef strIn As String)
    Dim ilen As Long
    ilen = Len(strIn)
    
    If strIn = "" Then Exit Function
    If Left(strIn, 1) = """" And Right(strIn, 1) = """" Then
        strIn = Mid(strIn, 2, ilen - 2)
    End If
End Function


'�õ�label������
Private Function getLableNum() As Long
    Dim id As Long
    For id = 1 To 100
        If local_webdw.text(id).Name = "" Then
            getLableNum = id - 1
            Exit Function
        End If
    Next
    getLableNum = id - 1
End Function
'�õ�Ԫ�ص�����
'��inString�ַ����У�����Ԫ�ص����ƣ��õ����Ԫ�ص����������ַ���
'���ҵ��㷨�ǣ�
'��ԭʼ�ַ����п�ʼ���ң��ҵ�eleName�����ĺ���Ӧ�ø���һ��(����־���Ԫ�صĿ�ʼ
'Ԫ���п���Ƕ�׶����ڲ�Ԫ�أ������Ҫ���ҵ���()���м���
'���ص��ַ��������ٰ���()
'���ҵ��㷨������webdw�ľ����ʾ��Ŀǰ���ú�PB7һ�µı�ʾ����
'���ճ�����ƣ�webdwӦ�ÿ���֧��PB7������DW��������ʾ����
'����˵��webdw��PB7�Ǽ��ݵġ�
'inString �ܵ��ַ���
'eleName Ԫ������
'beginPos ��ʼ����λ��
'findPos �������,��ʾ�ҵ���λ��,û�ҵ�����-1

Private Function getElementDesc(inString As String, eleName As String, beginPos As Long, ByRef findPos As Long) As String
    Dim iBeg As Long
    Dim leftPos As Long
    Dim iflag As Long
    
    Dim i As Long
    Dim s As String
    
    findPos = -1                                         '��ʼ��findPos��ֵ��������ı䣬���صľ���-1
    
    iBeg = InStr(beginPos, inString, eleName)
    If iBeg <= 0 Then
        getElementDesc = "": Exit Function              '���ؿ��ַ�������û���ҵ����Ԫ��
    End If
    
    leftPos = InStr(iBeg, inString, "(")                '�õ��������ŵ�λ��
    If leftPos <= 0 Then
        getElementDesc = "": Exit Function              '���ؿ��ַ�������û���ҵ����Ԫ��
    End If
    
    iflag = 0                                           'ÿ�ҵ�һ��(��iflag++,�ҵ�һ��) iflag --
    For i = leftPos + 1 To Len(inString)
        s = Mid(inString, i, 1)                         'ȡ��ǰ�ַ���
        
        If (s = "(" Or s = ")") _
            And Mid(inString, i - 1, 1) = "~" Then      '�����()����Ҫ�ж��ϸ��ַ��Ƿ���~,����ǲ�����
            GoTo continueNext
        End If
        
        
        If s = "(" Then
            iflag = iflag + 1
            GoTo continueNext                           '��������ѭ��
        End If
        
        If s = ")" Then                                 '��ǰֵΪ)ʱ��Ҫ�ж�iflag��ֵ
            If iflag = 0 Then                           'iflag=0�����Խ���ѭ��
                getElementDesc = Mid(inString, leftPos, i - leftPos + 1)
                findPos = leftPos                       '�ҵ���λ����leftPos
                Exit Function
            Else
                iflag = iflag - 1                       '����iflag��ȥ1
            End If
        End If
continueNext:
    Next i
    
    getElementDesc = ""
End Function

'��Ԫ�ر�ʾ���ַ������棬�����Ű���������
'ȡ��ָ�������Ե�ʵ������ֵ
'����Ҳ������򷵻�һ�����ַ���
'retFlag��һ����־�ַ���������0�����ҵ��ˣ�����-1����û�����ָ�����ƵĲ���
'eleString ֻ��
'paraName ֻ������Сд���У�
'begPos   ��ʼ���ҵ�
'defValue �Ҳ���ʱ���Ĭ��ֵ
'retFlag  �������0�����ɹ�����-1����ʧ��
'sep      �����ķָ���ţ������˷��Ŵ�������

Private Function getElementProp(eleString As String, paraName As String, begPos As Long, _
                        defValue As String, ByRef retFlag As Long, sep As String) As String
    Dim iBeg As Long
    Dim iEnd As Long
    Dim ipos As Long
    Dim i As Long
    Dim iflag As Long
    Dim s As String
    Dim svalue As String
    
    retFlag = -1
    ipos = InStr(begPos, eleString, paraName & "=")     '�ҵ��������ƵĿ�ʼ��
    If ipos <= 0 Then                                   '�Ҳ������˳�
        getElementProp = defValue                       '����Ĭ��ֵ
        Exit Function
    End If
    
    iBeg = ipos + Len(paraName & "=")                   'iBeg����ֵ�Ŀ�ʼ��
    iflag = 0
    For i = iBeg To Len(eleString)
        s = Mid(eleString, i, 1)
        
        If s = """" Then                                '�����ǰ�ַ��������ţ���ô���ñ�־
            If iflag = 0 Then
                iflag = 1
            Else
                iflag = 0
            End If
            GoTo continueNext
        End If
        
        If s = sep Then                                 '���s�ǽ������ţ���Ҫ����iFlag���ж�
            If iflag = 0 Then                           '��������ַ����ڣ���ô���˳�
                svalue = Mid(eleString, iBeg, i - iBeg)
                removeQuote svalue                      'ȥ����ͷ�ͽ�β������
                getElementProp = svalue
                retFlag = 0                             '��־�ɹ�����
                Exit Function                           '�˳��˹���
            End If
        End If
            
continueNext:
    Next i
    
    getElementProp = defValue                           '����Ĭ��ֵ
End Function

'������������������ַ����зֳɰ������ʵ��Ԫ�ص�array����
'ֻ��ȡ���е�ָ�����Ͷ���
Private Function getAllElement(inString As String, eletype As String) As Collection
    Dim myarray As New Collection
    Dim stext As String
    Dim ipos As Long
    
    '�ֽ�dwString�������е�Ԫ��ȡ������������myarray��ȥ
    
    stext = getElementDesc(inString, eletype & "(", 1, ipos)
    While ipos > 0
        myarray.Add stext                              '�����ڼ���sText
        stext = getElementDesc(inString, eletype & "(", ipos + 1, ipos)
    Wend

    Set getAllElement = myarray
End Function



'������������DW�����У��ֽ�õ����ݿ�����õ�Select���
'Ϊ��һ��ִ��SQL�������»���
'���SQL�����ܻ���в���
Public Function GetRetrieveSQL() As String
    
    Dim id As Long
    Dim select_tablelist As String      'tabel �Ӿ�
    Dim select_columnlist As String     'column �Ӿ�
    Dim select_join As String           'join �����Ӿ�
    Dim select_where As String          'where�Ӿ�
    Dim select_orderby As String        'order by�Ӿ�
    
    select_tablelist = ""
    For id = 1 To 10
        If local_webdw.table.retrieve.pbselect.table(id) = "" Then
            Exit For
        End If
        
        If select_tablelist = "" Then
            select_tablelist = local_webdw.table.retrieve.pbselect.table(id)
        Else
            select_tablelist = select_tablelist & "," _
                & local_webdw.table.retrieve.pbselect.table(id)  'ƴװTable�Ӿ�
        End If
        
    Next
    
    select_columnlist = ""
    For id = 1 To 100
        If local_webdw.table.retrieve.pbselect.column(id) = "" Then
            Exit For
        End If
        
        If select_columnlist = "" Then
            select_columnlist = local_webdw.table.retrieve.pbselect.column(id)
        Else
            select_columnlist = select_columnlist & "," _
                & local_webdw.table.retrieve.pbselect.column(id)
        End If
    Next
    
   
    select_join = ""
    For id = 1 To 10
        If local_webdw.table.retrieve.pbselect.join(id).join_left = "" Then
            Exit For
        End If
        
        If select_join = "" Then
            select_join = "(" & local_webdw.table.retrieve.pbselect.join(id).join_left _
            & " " & local_webdw.table.retrieve.pbselect.join(id).join_op _
            & " " & local_webdw.table.retrieve.pbselect.join(id).join_right & ")"
        Else
            select_join = select_join & " AND " & _
                    "(" & local_webdw.table.retrieve.pbselect.join(id).join_left _
                    & " " & local_webdw.table.retrieve.pbselect.join(id).join_op _
                    & " " & local_webdw.table.retrieve.pbselect.join(id).join_right & ")"
        End If
    Next
    
   
    select_where = select_join
    For id = 1 To 10
        If local_webdw.table.retrieve.pbselect.where(id).exp1 = "" Then
            Exit For
        End If
        
        If select_where = "" Then
            select_where = "(" & local_webdw.table.retrieve.pbselect.where(id).exp1 _
                            & " " & local_webdw.table.retrieve.pbselect.where(id).op _
                            & " " & local_webdw.table.retrieve.pbselect.where(id).exp2 & ") " _
                            & local_webdw.table.retrieve.pbselect.where(id).logic
        Else
            select_where = select_where & " And " & _
                        "(" & local_webdw.table.retrieve.pbselect.where(id).exp1 _
                        & " " & local_webdw.table.retrieve.pbselect.where(id).op _
                        & " " & local_webdw.table.retrieve.pbselect.where(id).exp2 & ") " _
                        & local_webdw.table.retrieve.pbselect.where(id).logic
        End If
    Next
    If select_where > "" Then
        select_where = " Where " & select_where
    End If
    
    '���Ӷ�order by �Ӿ��֧�֣�20090204
    select_orderby = ""
    For id = 1 To 10
        If local_webdw.table.retrieve.pbselect.order(id).Name = "" Then
            Exit For
        End If
        
        If select_orderby = "" Then
            If UCase(local_webdw.table.retrieve.pbselect.order(id).Asc) = "YES" Then
                select_orderby = local_webdw.table.retrieve.pbselect.order(id).Name & " ASC "
            Else
                select_orderby = local_webdw.table.retrieve.pbselect.order(id).Name & " DESC "
            End If
        Else
            If UCase(local_webdw.table.retrieve.pbselect.order(id).Asc) = "YES" Then
                select_orderby = select_orderby & " , " _
                            & local_webdw.table.retrieve.pbselect.order(id).Name & " ASC "
            Else
                select_orderby = select_orderby & " , " _
                            & local_webdw.table.retrieve.pbselect.order(id).Name & " DESC "
            End If
        End If
    Next
    
    If select_orderby > "" Then
        select_orderby = " Order By " & select_orderby
    End If
    
    GetRetrieveSQL = "Select " & select_columnlist & " from " & select_tablelist _
                    & select_where & select_orderby
                    
    GetRetrieveSQL = Replace(GetRetrieveSQL, "~""", "")
End Function