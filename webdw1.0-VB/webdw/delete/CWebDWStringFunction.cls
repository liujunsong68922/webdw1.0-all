VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDWStringFunction"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW�û�������������õ��ĸ����ַ�����������
Rem ��Ҫ���ܣ������ַ��������л�ȡ���ݣ��Լ�ƴװ�ַ���
Rem ������Ѿ�������������Ǩ�Ƶ�CWebDW��ȥ�ˡ���������:2008-12-17
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @��Ȩ���� ������ 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------
'��������ַ������м��
'�����"��ͷ����"����,��ô��ɾ����ǰ�����������
'Private Function removeQuote(ByRef strIn As String)
'    Dim ilen As Long
'    ilen = Len(strIn)
'
'    If strIn = "" Then Exit Function
'    If Left(strIn, 1) = """" And Right(strIn, 1) = """" Then
'        strIn = Mid(strIn, 2, ilen - 2)
'    End If
'End Function


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
'Public Function getElementDesc(inString As String, eleName As String, beginPos As Long, ByRef findPos As Long) As String
'    Dim iBeg As Long
'    Dim leftPos As Long
'    Dim iflag As Long
'
'    Dim i As Long
'    Dim s As String
'
'    findPos = 0                                         '��ʼ��findPos��ֵ��������ı䣬���صľ���0
'
'    iBeg = InStr(beginPos, inString, eleName)
'    If iBeg <= 0 Then
'        getElementDesc = "": Exit Function              '���ؿ��ַ�������û���ҵ����Ԫ��
'    End If
'
'    leftPos = InStr(iBeg, inString, "(")                '�õ��������ŵ�λ��
'    If leftPos <= 0 Then
'        getElementDesc = "": Exit Function              '���ؿ��ַ�������û���ҵ����Ԫ��
'    End If
'
'    iflag = 0                                           'ÿ�ҵ�һ��(��iflag++,�ҵ�һ��) iflag --
'    For i = leftPos + 1 To Len(inString)
'        s = Mid(inString, i, 1)                         'ȡ��ǰ�ַ���
'
'        If (s = "(" Or s = ")") _
'            And Mid(inString, i - 1, 1) = "~" Then      '�����()����Ҫ�ж��ϸ��ַ��Ƿ���~,����ǲ�����
'            GoTo ContinueNext
'        End If
        
        
'        If s = "(" Then
'            iflag = iflag + 1
'            GoTo ContinueNext                           '��������ѭ��
'        End If
'
'        If s = ")" Then                                 '��ǰֵΪ)ʱ��Ҫ�ж�iflag��ֵ
'            If iflag = 0 Then                           'iflag=0�����Խ���ѭ��
'                getElementDesc = Mid(inString, leftPos, i - leftPos + 1)
'                findPos = leftPos                       '�ҵ���λ����leftPos
'                Exit Function
'            Else
'                iflag = iflag - 1                       '����iflag��ȥ1
'            End If
'        End If
'ContinueNext:
'    Next i
'
'    getElementDesc = ""
'End Function

'��Ԫ�ر�ʾ���ַ������棬�����Ű���������
'ȡ��ָ�������Ե�ʵ������ֵ
'����Ҳ������򷵻�һ�����ַ���
'retFlag��һ����־�ַ���������0�����ҵ��ˣ�����-1����û�����ָ�����ƵĲ���
'eleString ֻ��
'paraName ֻ������Сд���У�
'begPos   ��ʼ���ҵ�
'retFlag  �������0�����ɹ�����-1����ʧ��
'Public Function getElementProp(eleString As String, paraName As String, begPos As Long, ByRef retFlag As Long) As String
'    Dim iBeg As Long
'    Dim iEnd As Long
'    Dim ipos As Long
'    Dim i As Long
'    Dim iflag As Long
'   Dim s As String
'    Dim svalue As String
'
'    retFlag = -1
'    ipos = InStr(begPos, eleString, paraName & "=")     '�ҵ��������ƵĿ�ʼ��
'    If ipos <= 0 Then                                   '�Ҳ������˳�
'        getElementProp = ""
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
'            GoTo ContinueNext
'        End If
'
'        If s = " " Then                                 '���s�ǿո���Ҫ����iFlag���ж�
'            If iflag = 0 Then                           '��������ַ����ڣ���ô���˳�
'                svalue = Mid(eleString, iBeg, i - iBeg)
'                removeQuote svalue             'ȥ����ͷ�ͽ�β������
'                getElementProp = svalue
'                retFlag = 0                             '��־�ɹ�����
'                Exit Function                           '�˳��˹���
'            End If
'        End If
'
'ContinueNext:
'    Next i
'
'    getElementProp = ""
'End Function

'������������������ַ����зֳɰ������ʵ��Ԫ�ص�array����
'ֻ��ȡ���е�ָ�����Ͷ���
'Public Function getAllElement(dwString As String, eletype As String) As Collection
'    Dim myarray As New Collection
'    Dim stext As String
'    Dim ipos As Long
'
'    '�ֽ�dwString�������е�Ԫ��ȡ������������myarray��ȥ
'
'    stext = getElementDesc(dwString, eletype & "(", 1, ipos)
'    While ipos > 0
'        myarray.Add stext                              '�����ڼ���sText
'        stext = getElementDesc(dwString, eletype & "(", ipos + 1, ipos)
'    Wend
'
'    Set getAllElement = myarray
'End Function

'���ĳ��ָ��Ԫ�ص�ָ�����ԣ�����ж����ֻ���ص�һ��
'stextҪ���ҵ��ַ���
'eleName Ԫ������
'paraName ��������
'iflag ���ұ�־,0ʧ�� �����ҵ���λ��
'Public Function getElementParam2(stext As String, eleName As String, paraName As String, ByRef iflag As Long) As String
'    iflag = 0
'    getElementParam2 = ""
'
'    Dim sElement As String
'    Dim ipos As Long
'    Dim svalue As String
'
'    sElement = getElementDesc(stext, eleName, 1, ipos)
'    If ipos = 0 Then
'        Exit Function
'    End If
'
'    svalue = getElementProp(sElement, paraName, 1, iflag)
'    If iflag = -1 Then
'        getElementParam2 = ""
'    Else
'        removeQuote svalue                          'ȥ������
'        iflag = 1
'        getElementParam2 = svalue                   '�����ַ���
'    End If
'End Function

'��һ���ַ������棬������text�����Զ������
'���� sText����һ��ԭ�ļ��е�text����
'��� webDW_text�ṹ����ʾ��������ֵ
'��������ʱ�����g_webdw_text������
'Public Function getTextProp(stext As String) As Long
'    Dim iret As Long
'    g_webdw_text.band = getElementProp(stext, "band", 1, iret)
'    g_webdw_text.alignment = getElementProp(stext, "alignment", 1, iret)
'    g_webdw_text.text = getElementProp(stext, "text", 1, iret)
'    g_webdw_text.border = getElementProp(stext, "border", 1, iret)
'    g_webdw_text.color = getElementProp(stext, "color", 1, iret)
'    g_webdw_text.x = getElementProp(stext, "x", 1, iret)
'    g_webdw_text.y = getElementProp(stext, "y", 1, iret)
'    g_webdw_text.height = getElementProp(stext, "height", 1, iret)
'    g_webdw_text.width = getElementProp(stext, "width", 1, iret)
'    g_webdw_text.name = getElementProp(stext, "name", 1, iret)
'    g_webdw_text.font_face = getElementProp(stext, "font.face", 1, iret)
'    g_webdw_text.font_height = getElementProp(stext, "font.height", 1, iret)
'    g_webdw_text.font_weight = getElementProp(stext, "font.weight", 1, iret)
'    g_webdw_text.font_family = getElementProp(stext, "font.family", 1, iret)
'    g_webdw_text.font_pitch = getElementProp(stext, "font.pitch", 1, iret)
'    g_webdw_text.font_charset = getElementProp(stext, "font.charset", 1, iret)
'    g_webdw_text.background_mode = getElementProp(stext, "background.mode", 1, iret)
'    g_webdw_text.background_color = getElementProp(stext, "background.color", 1, iret)
'
'    getTextProp = 0
'End Function

'Public Function getColumnProp(scolumn As String) As Long
'    Dim iret As Long
'    Dim i As Long
'    Dim stemp As String
'    g_webdw_column.band = getElementProp(scolumn, "band", 1, iret)
'    g_webdw_column.alignment = getElementProp(scolumn, "alignment", 1, iret)
'    g_webdw_column.tabsequence = getElementProp(scolumn, "tabsequence", 1, iret)
'    g_webdw_column.border = getElementProp(scolumn, "border", 1, iret)
'    g_webdw_column.color = getElementProp(scolumn, "color", 1, iret)
'
'    g_webdw_column.x = getElementProp(scolumn, "x", 1, iret)
'    g_webdw_column.y = getElementProp(scolumn, "y", 1, iret)
'    g_webdw_column.height = getElementProp(scolumn, "height", 1, iret)
'    g_webdw_column.width = getElementProp(scolumn, "width", 1, iret)
'    g_webdw_column.format = getElementProp(scolumn, "format", 1, iret)
'    g_webdw_column.name = getElementProp(scolumn, "name", 1, iret)
'    g_webdw_column.tag = getElementProp(scolumn, "tag", 1, iret)
'
'    '�����Ǳ༭���֧��
'    stemp = getElementProp(scolumn, "edit.limit", 1, iret)
'    If iret = 0 Then
'        g_webdw_column.edit_limit = stemp
'    Else
'        g_webdw_column.edit_limit = 0
'    End If
'    g_webdw_column.edit_case = getElementProp(scolumn, "edit.case", 1, iret)
'    g_webdw_column.edit_focusrectangle = getElementProp(scolumn, "edit.focusrectangle", 1, iret)
'    g_webdw_column.edit_autoselect = getElementProp(scolumn, "edit.autoselect", 1, iret)
'    g_webdw_column.edit_autohscroll = getElementProp(scolumn, "edit.autohscroll", 1, iret)
'
    '����������֧��
'    g_webdw_column.font_face = getElementProp(scolumn, "font.face", 1, iret)
'    g_webdw_column.font_height = getElementProp(scolumn, "font.height", 1, iret)
'    g_webdw_column.font_weight = getElementProp(scolumn, "font.weight", 1, iret)
'    g_webdw_column.font_family = getElementProp(scolumn, "font.family", 1, iret)
'    g_webdw_column.font_pitch = getElementProp(scolumn, "font.pitch", 1, iret)
'    g_webdw_column.font_charset = getElementProp(scolumn, "font.charset", 1, iret)
    
'    '������background֧��
'    g_webdw_column.background_mode = getElementProp(scolumn, "background.mode", 1, iret)
'    g_webdw_column.background_color = getElementProp(scolumn, "background.color", 1, iret)
'
'    getColumnProp = 0
'End Function