VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDW"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW���ַ�����������
Rem ����һ���ַ���,������ַ���������һ��WebDW�ṹ
Rem �Ժ�Ϳ���ֱ�ӷ���WebDW�ṹ,��������ȥ�����ַ������н���
Rem �����ַ����Ľ���ֻ��Ҫ����һ�ξͿ�����
Rem ��������ֻ�ṩһ����������convertDW����һ���ַ������g_webdw
Rem �����g_webdw,errString
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @��Ȩ���� ������ 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------
Option Explicit

Public dwString As String       '��������洢Ҫ�������ַ���,δ���������Ƚ�,ֻ��
Public errString As String      '����ʧ���Ժ�Ĵ�����Ϣ�洢������
'�����һ����Ҫ�Ķ��⹫���Ľ�������
'����һ���ַ���,����������һ��webdw�ṹ������
'���洢��g_webdw��
'�ַ����洢��dwString�б���
'����0�����ɹ�
'�������ʧ��,����-1�����д���(һ�㲻��)
'���洢�ַ���,Ҳ���洢webdw
'������Ϣ�洢��errString��
Public Function ConvertDW(inString As String) As Long
    Dim webdw1 As WebDWStructure
    Dim iflag As Long
   'step1 ��ʼ��g_webdw
   
    g_webdw = webdw1
    dwString = inString
    errString = ""
    
   'step2 ����datawindow����,�������,�˳�����
    If readWebDW01_Datawindow() = -1 Then
        ConvertDW = -1: Exit Function
    End If
    
    'step3 ����header����
    If readWebDW02_Header() = -1 Then
        ConvertDW = -1: Exit Function
    End If
    
    'step4 ����summary����
    If readWebDW03_Summary() = -1 Then
        ConvertDW = -1: Exit Function
    End If
    'step5 ����footer����
    If readWebDW04_Footer() = -1 Then
        ConvertDW = -1: Exit Function
    End If
    
    'step6 ����detail����
    If readWebDW05_Detail() = -1 Then
        ConvertDW = -1: Exit Function
    End If
    
    'step7 ����table����
    If readWebDW06_Table() = -1 Then
        ConvertDW = -1: Exit Function
    End If
    
    'step8 ����text����
    If readWebDW07_Text() = -1 Then
        ConvertDW = -1: Exit Function
    End If
    
    'step9 ����column����
    If readWebDW08_Column() = -1 Then
        ConvertDW = -1: Exit Function
    End If
    
    'step10 ����line����
    If readWebDW09_Line() = -1 Then
        ConvertDW = -1: Exit Function
    End If
    'return
    ConvertDW = 0
End Function

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


'��Ԫ�ر�ʾ���ַ������棬�����Ű���������
'ȡ��ָ�������Ե�ʵ������ֵ
'����Ҳ������򷵻�һ�����ַ���
'retFlag��һ����־�ַ���������0�����ҵ��ˣ�����-1����û�����ָ�����ƵĲ���
'eleString ֻ��
'paraName ֻ������Сд���У�
'begPos   ��ʼ���ҵ�
'defValue �Ҳ���ʱ���Ĭ��ֵ
'retFlag  �������0�����ɹ�����-1����ʧ��
Private Function getElementProp(eleString As String, paraName As String, begPos As Long, defValue As String, ByRef retFlag As Long) As String
    Dim iBeg As Long
    Dim iEnd As Long
    Dim ipos As Long
    Dim i As Long
    Dim iflag As Long
    Dim s As String
    Dim svalue As String
    
'    retFlag = -1
'    ipos = InStr(begPos, eleString, paraName & "=")     '�ҵ��������ƵĿ�ʼ��
'    If ipos <= 0 Then                                   '�Ҳ������˳�
'        getElementProp = defValue                       '����Ĭ��ֵ
'        Exit Function
'    End If
'
'    iBeg = ipos + Len(paraName & "=")                   'iBeg����ֵ�Ŀ�ʼ��
'    iflag = 0
'    For i = iBeg To Len(eleString)
'        s = Mid(eleString, i, 1)
'
'        If s = """" Then                                '�����ǰ�ַ��������ţ���ô���ñ�־
'            If iflag = 0 Then
'                iflag = 1
'            Else
'                iflag = 0
'            End If
'            GoTo continueNext
'        End If
'
'        If s = " " Then                                 '���s�ǿո���Ҫ����iFlag���ж�
'            If iflag = 0 Then                           '��������ַ����ڣ���ô���˳�
'                svalue = Mid(eleString, iBeg, i - iBeg)
'                removeQuote svalue                      'ȥ����ͷ�ͽ�β������
'                getElementProp = svalue
'                retFlag = 0                             '��־�ɹ�����
'                Exit Function                           '�˳��˹���
'            End If
'        End If
'
'continueNext:
'    Next i
'
'    getElementProp = defValue                           '����Ĭ��ֵ

    'Ĭ��ʹ�ÿո���Ϊ������Ƿ���
    svalue = getElementProp2(eleString, paraName, begPos, defValue, retFlag, " ")
    getElementProp = svalue
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

Private Function getElementProp2(eleString As String, paraName As String, begPos As Long, _
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
        getElementProp2 = defValue                       '����Ĭ��ֵ
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
                getElementProp2 = svalue
                retFlag = 0                             '��־�ɹ�����
                Exit Function                           '�˳��˹���
            End If
        End If
            
continueNext:
    Next i
    
    getElementProp2 = defValue                           '����Ĭ��ֵ
End Function



'����datawindow���ֵ�����
'����0�����ɹ�
'����-1����ʧ��
Private Function readWebDW01_Datawindow() As Long
    Dim sDataWindow As String
    Dim ipos As Long
    Dim iflag As Long
    
    '�õ�datawindow�ı�ʾ
    sDataWindow = getElementDesc(dwString, "datawindow", 1, ipos)
    
    '���������datawindow����,��Ϊ��������,ִֹͣ��
    If ipos < 0 Then
        errString = "ERROR:readWebDW01_Datawindow:���ݸ�ʽ���Ϸ�:�Ҳ���datawindow����(����)"
        readWebDW01_Datawindow = -1
        Exit Function
    End If
    
    '�������datawindow����,��ô��������������
    '��ʹû��,Ҳֱ������ȥ,��������,ֱ������һ��Ĭ��ֵ
    g_webdw.datawindow.unit = getElementProp(sDataWindow, "unit", 1, "0", iflag)
    g_webdw.datawindow.timer_interval = getElementProp(sDataWindow, "time_interval", 1, "0", iflag)
    g_webdw.datawindow.color = getElementProp(sDataWindow, "color", 1, "0", iflag)
    g_webdw.datawindow.processiong = getElementProp(sDataWindow, "processiong", 1, "", iflag)
    g_webdw.datawindow.HTMLDW = getElementProp(sDataWindow, "HTMLDW", 1, "no", iflag)
    g_webdw.datawindow.print_documentname = getElementProp(sDataWindow, "print.documentname", 1, "", iflag)
    g_webdw.datawindow.print_orientation = getElementProp(sDataWindow, "print.orientation", 1, "0", iflag)
    g_webdw.datawindow.print_margin_left = getElementProp(sDataWindow, "print.margin.left", 1, "110", iflag)
    g_webdw.datawindow.print_margin_right = getElementProp(sDataWindow, "print.margin.right", 1, "110", iflag)
    g_webdw.datawindow.print_margin_top = getElementProp(sDataWindow, "print.margin.top", 1, "96", iflag)
    g_webdw.datawindow.print_margin_bottom = getElementProp(sDataWindow, "print.margin.bottom", 1, "96", iflag)
    g_webdw.datawindow.print_paper_source = getElementProp(sDataWindow, "print.paper.source", 1, "0", iflag)
    g_webdw.datawindow.print_paper_size = getElementProp(sDataWindow, "print.paper.size", 1, "0", iflag)
    g_webdw.datawindow.print_prompt = getElementProp(sDataWindow, "print.prompt", 1, "no", iflag)
    g_webdw.datawindow.print_buttons = getElementProp(sDataWindow, "print.buttons", 1, "no", iflag)
    g_webdw.datawindow.print_preview_buttons = getElementProp(sDataWindow, "print.preview.buttons", 1, "no", iflag)
    
    readWebDW01_Datawindow = 0
End Function

'����header���ֵ�����
'����0�����ɹ�
'����-1����ʧ��
Private Function readWebDW02_Header() As Long
    Dim sHeader As String
    Dim ipos As Long
    Dim iflag As Long
    
    '�õ�datawindow�ı�ʾ
    sHeader = getElementDesc(dwString, "header", 1, ipos)
    
    '����Ҳ���header���壬���˳�
    If ipos < 0 Then
        readWebDW02_Header = 0
        Exit Function
    End If
    
    g_webdw.header.height = getElementProp(sHeader, "height", 1, "0", iflag)
    g_webdw.header.color = getElementProp(sHeader, "color", 1, "0", iflag)
    readWebDW02_Header = 0
    
End Function

'����summary���ֵ�����
'����0�����ɹ�
'����-1����ʧ��
Private Function readWebDW03_Summary() As Long
    Dim sSummary As String
    Dim ipos As Long
    Dim iflag As Long
    
    '�õ�summary�ı�ʾ
    sSummary = getElementDesc(dwString, "summary", 1, ipos)
    
    '����Ҳ���summary���壬���˳�
    If ipos < 0 Then
        errString = "ERROR:readWebDW03_Summary:���ݸ�ʽ���Ϸ�:�Ҳ���summary����(����)"
        readWebDW03_Summary = -1
        Exit Function
    End If
    
    g_webdw.summary.height = getElementProp(sSummary, "height", 1, "0", iflag)
    g_webdw.summary.color = getElementProp(sSummary, "color", 1, "0", iflag)
    readWebDW03_Summary = 0
End Function


'����footer���ֵ�����
'����0�����ɹ�
'����-1����ʧ��
Private Function readWebDW04_Footer() As Long
    Dim sFooter As String
    Dim ipos As Long
    Dim iflag As Long
    
    '�õ�footer�ı�ʾ
    sFooter = getElementDesc(dwString, "footer", 1, ipos)
    
    '����Ҳ���footer���壬���˳�
    If ipos < 0 Then
        errString = "ERROR:readWebDW04_Footer:���ݸ�ʽ���Ϸ�:�Ҳ���footer����(����)"
        readWebDW04_Footer = -1
        Exit Function
    End If
    
    g_webdw.footer.height = getElementProp(sFooter, "height", 1, "0", iflag)
    g_webdw.footer.color = getElementProp(sFooter, "color", 1, "0", iflag)
    readWebDW04_Footer = 0
End Function

'����detail���ֵ�����
'����0�����ɹ�
'����-1����ʧ��
Private Function readWebDW05_Detail() As Long
    Dim sDetail As String
    Dim ipos As Long
    Dim iflag As Long
    
    '�õ�footer�ı�ʾ
    sDetail = getElementDesc(dwString, "detail", 1, ipos)
    
    '����Ҳ���footer���壬���˳�
    If ipos < 0 Then
        errString = "ERROR:readWebDW05_Detail:���ݸ�ʽ���Ϸ�:�Ҳ���detail����(����)"
        readWebDW05_Detail = -1
        Exit Function
    End If
    
    g_webdw.detail.height = getElementProp(sDetail, "height", 1, "0", iflag)
    g_webdw.detail.color = getElementProp(sDetail, "color", 1, "0", iflag)
    readWebDW05_Detail = 0
End Function

'����detail���ֵ�����
'����0�����ɹ�
'����-1����ʧ��
Private Function readWebDW06_Table() As Long
    Dim stable As String
    Dim ipos As Long
    Dim iflag As Long
    Dim columnArray As Collection
    Dim obj As Variant
    Dim stemp As String
    Dim id As Long
    
    '�õ�footer�ı�ʾ
    stable = getElementDesc(dwString, "table", 1, ipos)
    
    '����Ҳ���footer���壬���˳�
    If ipos < 0 Then
        errString = "ERROR:readWebDW06_Table:���ݸ�ʽ���Ϸ�:�Ҳ���table����(����)"
        readWebDW06_Table = -1
        Exit Function
    End If
    
    
    '�ȶ�ȡcolumn����
    Set columnArray = getAllElement(stable, "column=")
    id = 0
    For Each obj In columnArray
        stemp = obj
        
        id = id + 1
        If id > 100 Then
            errString = "ERROR:readWebDW06_Table:SELECT���г���100��!"
            readWebDW06_Table = -1
            Exit Function
        End If
           
        g_webdw.table.Columns(id).type = getElementProp(stemp, "type", 1, "", iflag)
        g_webdw.table.Columns(id).update = getElementProp(stemp, "update", 1, "yes", iflag)
        g_webdw.table.Columns(id).updatewhereclause = _
                        getElementProp(stemp, "updatewhereclause", 1, "yes", iflag)
        g_webdw.table.Columns(id).key = getElementProp(stemp, "key", 1, "", iflag)
        g_webdw.table.Columns(id).name = getElementProp(stemp, "name", 1, "", iflag)
        g_webdw.table.Columns(id).dbname = getElementProp(stemp, "dbname", 1, "", iflag)
        g_webdw.table.Columns(id).values = getElementProp(stemp, "values", 1, "", iflag)
        
    Next
    
    '��ȡretrieve����ֵ
    'g_webdw.table.retrieve = getElementProp(stable, "retrieve", 1, "", iflag)
    
    'update,updatewhere,updatekeyinplace
    g_webdw.table.update = getElementProp(stable, "update", 1, "", iflag)
    g_webdw.table.updatewhere = getElementProp(stable, "updatewhere", 1, "", iflag)
    g_webdw.table.updatekeyinplace = getElementProp(stable, "updatekeyinplace", 1, "", iflag)
    
    '��retrieve�ַ��������Զ�ȡ����Ӧ�ı�����ȥ
    'retrieve���ڲ���һ������������һ���ṹ���ˡ�
    Dim strPBSelect As String
    Dim Columns(100) As String          '����Ҫ��ȡ��column�����ƣ����column�����ݿ������
    Dim tables(10) As String            '����Ҫ��ȡ��table���ƣ����10��
    Dim temparray As Variant
    Dim tempobj As Variant
    Dim iret As Long
    
    Dim select_tablelist As String      'tabel �Ӿ�
    Dim select_columnlist As String     'column �Ӿ�
    Dim select_join As String           'join �����Ӿ�
    Dim select_where As String          'where�Ӿ�
    
    
    Dim stablename As String
    Dim table_id As Long
    Dim scolumnname As String
    Dim column_id As Long
    
    Dim join_id As Long
    Dim join_left As String
    Dim join_op As String
    Dim join_right As String
    
    Dim where_id As Long
    Dim exp1 As String
    Dim where_op As String
    Dim exp2 As String
    Dim logic As String
    
    strPBSelect = getElementProp(stable, "retrieve", 1, "", iflag)  '�ȶ�ȡretrieve���Գ���
    
    '��ȡtable����
    Set temparray = getAllElement(strPBSelect, "TABLE")     '�õ�TABLEԪ�صĶ���
    table_id = 0
    For Each tempobj In temparray
        stemp = tempobj
        stablename = getElementProp2(stemp, "NAME", 1, "", iret, " ")
        
        If iret = -1 Then GoTo continue1
        
        table_id = table_id + 1
        g_webdw.table.retrieve.pbselect.table(table_id) = stablename     '�洢tableName��ֵ
continue1:
    Next
    
    '��ȡcolumn����
    Set temparray = getAllElement(strPBSelect, "COLUMN")    '�õ�columnԪ�ض���
    column_id = 0
    For Each tempobj In temparray
        stemp = tempobj
        scolumnname = getElementProp2(stemp, "NAME", 1, "", iret, ")")
        
        If iret = -1 Then GoTo continue2
                
        column_id = column_id + 1
        g_webdw.table.retrieve.pbselect.column(column_id) = scolumnname     '�洢column��NAME
continue2:
    Next
    
    '��ȡjoin����
    Set temparray = getAllElement(strPBSelect, "JOIN ")  '�õ�JOINԪ�ض��壬������һ���ո�
    join_id = 0
    For Each tempobj In temparray
        stemp = tempobj
        join_left = getElementProp2(stemp, "LEFT", 1, "", iret, " ")
        If iret = -1 Then GoTo continue3
        
        join_op = getElementProp2(stemp, "OP", 1, "", iret, " ")
        If iret = -1 Then GoTo continue3
        
        join_right = getElementProp2(stemp, "RIGHT", 1, "", iret, " ")
        If iret = -1 Then GoTo continue3
        
        join_id = join_id + 1
        g_webdw.table.retrieve.pbselect.join(join_id).join_left = join_left
        g_webdw.table.retrieve.pbselect.join(join_id).join_op = join_op
        g_webdw.table.retrieve.pbselect.join(join_id).join_right = join_right
continue3:
    Next
    
    '��ȡwhere����
    Set temparray = getAllElement(strPBSelect, "WHERE") '�õ�WhereԪ�ض���
    where_id = 0
    For Each tempobj In temparray
        stemp = tempobj
        exp1 = getElementProp2(stemp, "EXP1", 1, "", iret, " ")
        If iret = -1 Then GoTo continue4
        
        where_op = getElementProp2(stemp, "OP", 1, "", iret, " ")
        If iret = -1 Then GoTo continue4
        
        exp2 = getElementProp2(stemp, "EXP2", 1, "", iret, " ")
        If iret = -1 Then GoTo continue4
        
        logic = getElementProp2(stemp, "LOGIC", 1, "", iret, " ")
        
        where_id = where_id + 1
        g_webdw.table.retrieve.pbselect.where(where_id).exp1 = exp1
        g_webdw.table.retrieve.pbselect.where(where_id).op = where_op
        g_webdw.table.retrieve.pbselect.where(where_id).exp2 = exp2
        g_webdw.table.retrieve.pbselect.where(where_id).logic = logic
        
       
continue4:
    Next

    
    readWebDW06_Table = 0
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


'�������е�text������
'����0�����ɹ�
'����-1����ʧ��

Private Function readWebDW07_Text() As Long
    Dim textArray As Collection
    Dim obj As Variant
    Dim stemp As String
    Dim id As Long
    Dim iret As Long
    
    Set textArray = getAllElement(dwString, "text")
    id = 0
    'ѭ������
    For Each obj In textArray
        stemp = obj
        If Len(stemp) < 10 Then GoTo continueNext
            
        id = id + 1
        
        If id > 100 Then
            readWebDW07_Text = -1
            errString = "ERROR:readWebDW07_Text:���ɶ�ȡ100����ǩ!"
            Exit Function
        End If
        
        g_webdw.text(id).band = getElementProp(stemp, "band", 1, "detail", iret)
        g_webdw.text(id).alignment = getElementProp(stemp, "alignment", 1, "1", iret)
        g_webdw.text(id).text = getElementProp(stemp, "text", 1, "", iret)
        g_webdw.text(id).border = getElementProp(stemp, "border", 1, "", iret)
        g_webdw.text(id).color = getElementProp(stemp, "color", 1, "0", iret)
        g_webdw.text(id).x = getElementProp(stemp, "x", 1, "0", iret)
        g_webdw.text(id).y = getElementProp(stemp, "y", 1, "0", iret)
        g_webdw.text(id).height = getElementProp(stemp, "height", 1, "0", iret)
        g_webdw.text(id).width = getElementProp(stemp, "width", 1, "0", iret)
        g_webdw.text(id).name = getElementProp(stemp, "name", 1, "", iret)
        
        '��������������
        g_webdw.text(id).font.face = getElementProp(stemp, "font.face", 1, "", iret)
        g_webdw.text(id).font.height = getElementProp(stemp, "font.height", 1, "", iret)
        g_webdw.text(id).font.weight = getElementProp(stemp, "font.weight", 1, "", iret)
        g_webdw.text(id).font.family = getElementProp(stemp, "font.family", 1, "", iret)
        g_webdw.text(id).font.pitch = getElementProp(stemp, "font.pitch", 1, "", iret)
        g_webdw.text(id).font.charset = getElementProp(stemp, "font.charset", 1, "", iret)
        g_webdw.text(id).font.italic = getElementProp(stemp, "font.italic", 1, "0", iret)
        g_webdw.text(id).font.underline = getElementProp(stemp, "font.underline", 1, "0", iret)
        g_webdw.text(id).font.strikethrough = getElementProp(stemp, "font.strikethrough", 1, "0", iret)
        
        '��������ɫ����
        g_webdw.text(id).background_mode = getElementProp(stemp, "background.mode", 1, "", iret)
        g_webdw.text(id).background_color = getElementProp(stemp, "background.color", 1, "", iret)
continueNext:
    Next

End Function

'�������е�column������
'����0�����ɹ�
'����-1����ʧ��
Private Function readWebDW08_Column() As Long
    Dim columnArray As Collection
    Dim obj As Variant
    Dim scolumn As String
    Dim id As Long
    Dim iret As Long
    
    Set columnArray = getAllElement(dwString, "column")
    id = 0
    'ѭ������
    For Each obj In columnArray
        scolumn = obj
        id = id + 1
        
        If id > 100 Then
            readWebDW08_Column = -1
            errString = "ERROR:readWebDW08_Column:���ɶ�ȡ100����!"
            Exit Function
        End If
        
        g_webdw.column(id).band = getElementProp(scolumn, "band", 1, "1", iret)
        g_webdw.column(id).id = getElementProp(scolumn, "id", 1, "0", iret)
        g_webdw.column(id).alignment = getElementProp(scolumn, "alignment", 1, "1", iret)
        g_webdw.column(id).tabsequence = getElementProp(scolumn, "tabsequence", 1, "", iret)
        g_webdw.column(id).border = getElementProp(scolumn, "border", 1, "1", iret)
        g_webdw.column(id).color = getElementProp(scolumn, "color", 1, "0", iret)
        
        g_webdw.column(id).x = getElementProp(scolumn, "x", 1, "0", iret)
        g_webdw.column(id).y = getElementProp(scolumn, "y", 1, "0", iret)
        g_webdw.column(id).height = getElementProp(scolumn, "height", 1, "0", iret)
        g_webdw.column(id).width = getElementProp(scolumn, "width", 1, "0", iret)
        g_webdw.column(id).format = getElementProp(scolumn, "format", 1, "", iret)
        g_webdw.column(id).name = getElementProp(scolumn, "name", 1, "", iret)
        g_webdw.column(id).tag = getElementProp(scolumn, "tag", 1, "", iret)
        
        '�����Ǳ༭���֧��
        g_webdw.column(id).edit_limit = getElementProp(scolumn, "edit.limit", 1, "0", iret)
        g_webdw.column(id).edit_case = getElementProp(scolumn, "edit.case", 1, "any", iret)
        g_webdw.column(id).edit_focusrectangle = getElementProp(scolumn, "edit.focusrectangle", 1, "no", iret)
        g_webdw.column(id).edit_autoselect = getElementProp(scolumn, "edit.autoselect", 1, "no", iret)
        g_webdw.column(id).edit_autohscroll = getElementProp(scolumn, "edit.autohscroll", 1, "yes", iret)
        
        '����������֧��
        g_webdw.column(id).font.face = getElementProp(scolumn, "font.face", 1, "", iret)
        g_webdw.column(id).font.height = getElementProp(scolumn, "font.height", 1, "", iret)
        g_webdw.column(id).font.weight = getElementProp(scolumn, "font.weight", 1, "", iret)
        g_webdw.column(id).font.family = getElementProp(scolumn, "font.family", 1, "", iret)
        g_webdw.column(id).font.pitch = getElementProp(scolumn, "font.pitch", 1, "", iret)
        g_webdw.column(id).font.charset = getElementProp(scolumn, "font.charset", 1, "", iret)
        g_webdw.column(id).font.italic = getElementProp(scolumn, "font.italic", 1, "0", iret)
        g_webdw.column(id).font.underline = getElementProp(scolumn, "font.underline", 1, "0", iret)
        g_webdw.column(id).font.strikethrough = getElementProp(scolumn, "font.strikethrough", 1, "0", iret)
        
        
        '������background֧��
        g_webdw.column(id).background_mode = getElementProp(scolumn, "background.mode", 1, "", iret)
        g_webdw.column(id).background_color = getElementProp(scolumn, "background.color", 1, "", iret)
       
    Next
    readWebDW08_Column = 0
End Function

'��ȡ��������������
Private Function readWebDW09_Line() As Long
    Dim lineArray As Collection
    Dim obj As Variant
    Dim sline As String
    Dim id As Long
    Dim iret As Long

    Set lineArray = getAllElement(dwString, "line")
    id = 0
    'ѭ������
    For Each obj In lineArray
        sline = obj
        id = id + 1
        
        If id > 100 Then
            readWebDW09_Line = -1
            errString = "ERROR:readWebDW09_Line:���ɶ�ȡ100������!"
            Exit Function
        End If
        
        g_webdw.lineinfo(id).band = getElementProp(sline, "band", 1, "detail", iret)
        g_webdw.lineinfo(id).x1 = getElementProp(sline, "x1", 1, "0", iret)
        g_webdw.lineinfo(id).y1 = getElementProp(sline, "y1", 1, "0", iret)
        g_webdw.lineinfo(id).x2 = getElementProp(sline, "x2", 1, "0", iret)
        g_webdw.lineinfo(id).y2 = getElementProp(sline, "y2", 1, "0", iret)
        g_webdw.lineinfo(id).name = getElementProp(sline, "name", 1, "", iret)
        g_webdw.lineinfo(id).pen_style = getElementProp(sline, "pen.style", 1, "", iret)
        g_webdw.lineinfo(id).pen_width = getElementProp(sline, "pen.width", 1, "", iret)
        g_webdw.lineinfo(id).pen_color = getElementProp(sline, "pen.color", 1, "", iret)
        g_webdw.lineinfo(id).background_mode = getElementProp(sline, "background.mode", 1, "", iret)
        g_webdw.lineinfo(id).background_color = getElementProp(sline, "background.color", 1, "", iret)
    Next
        
End Function

