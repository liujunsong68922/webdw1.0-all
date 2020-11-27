VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDW_SyntaxFromSQL"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW�����ݴ����Զ�������
Rem ���������Ŀ���Ǹ���һ��Select��䣬�Զ����local_webdw����ֵ
Rem ������û�кͺ�̨���ݿ�Ľ���������Ҫ�������������ṩ����
Rem �������ɵ����ݴ��ڵ����Ͳ�ͬ����Ϊ�����ͬ�ķ�����ʵ��
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @��Ȩ���� ������ 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------
Option Explicit

'���ñ�������
Public errString As String      '������Ϣ�洢�ַ���������ַ���

'colDefString�ַ��������ݴ��ⲿֱ�Ӵ���
Public colDefString As String   '�����д洢�ַ�������ʽΪ����һ�����б��������У��еĶ�����Ϣ

Dim columnlist As String    'select�������б�
Dim tablelist As String     'select����table�б�
Dim joinlist As String      'select�����������
Dim wherelist As String     'select����where�����־�

Const color_white = 16777215

Private local_webdw As WebDWSyntax 'local_webdw������һ���ֲ������ˣ�������ȫ�ֱ�����

'��������������local_webdw��ֵ
'���룺glocal_webdw
'�����local_webdw
Public Function SetLocalWebDW()
    local_webdw = GG_webdw
End Function

'������������ȡlocal_webdw��ֵ
'����:local_webdw
'���:glocal_webdw
Public Function GetLocalWebDW()
    GG_webdw = local_webdw
End Function


'���ݸ�����SQL��䣬�Լ���Ӧ�����ݴ�������
'���õ�local_webdw��ȥ
'�Ӷ���ת�����õ�һ����Ӧ�����ݴ��ڶ��������
'iret����ֵ��0 ���� -1 ʧ��
'������Ϣ�����errstring��
'���������һ��Select����С�ͽ�����
Public Function SyntaxFromSQL(strsql As String, stype As String, ByRef iret As Long) As String
    Dim strDW As String
    'step1 �ж�stype�Ƿ�Ϸ����Ƿ���֧�ֵ�DW����
    If stype <> "freedom" And stype <> "grid" Then
        iret = -1
        SyntaxFromSQL = ""
        errString = "��֧�ֵ�DW����:" & stype
        Exit Function
    End If
    
    
    'step2�ȵ���ͨ�ù���
    generateDW_0Common strsql, stype, iret
    
    If iret = -1 Then
        SyntaxFromSQL = ""
        Exit Function
    End If
    
    '�ٸ���stype�����ö�Ӧ�ĵ����⹦��
    If stype = "freedom" Then
        generateDW_1Freedom strsql, stype, iret
    End If
    
    If stype = "grid" Then
        generateDW_2Grid strsql, stype, iret
    End If
    
End Function

'���ݸ�����SQL��䣬�Լ���Ӧ�����ݴ�������
'���õ�local_webdw��ȥ
'�Ӷ���ת�����õ�һ����Ӧ�����ݴ��ڶ��������
'iret����ֵ��0 ���� -1 ʧ��
'������Ϣ�����errstring��
'���������һ��Select����С�ͽ�����
Private Function generateDW_0Common(strsql As String, stype As String, ByRef iret As Long) As String
    local_webdw = GG_empty_webdw    '��ʼ��
    initDW (stype)      '���ó�ʼֵ��������ĺ�������
            
    generateDW_0Common = ""
    '�Ƚ�Where����зֳ��Ĳ��֣��������е��ĸ��Ӿ�
    Dim selectpos As Long
    Dim frompos As Long
    Dim wherepos As Long
    Dim orderpos As Long
    
    Dim temparray() As String
    Dim tempv As Variant
    Dim temps As String
    Dim id As Long
    
    '��ʱ�Ȳ�����groupby,having�ؼ��֣��Ժ�����
    selectpos = InStr(1, strsql, "select ", vbTextCompare)
    
    '���select�ؼ���
    If selectpos < 0 Then
        iret = -1
        errString = "SQL������Ҳ���select�ؼ���"
        Exit Function
    End If
    
    frompos = InStr(selectpos + 6, strsql, " from ", vbTextCompare)
    '���from�ؼ���
    If frompos < 0 Then
        iret = -1
        errString = "SQL������Ҳ���from�ؼ���"
        Exit Function
    End If
    
    columnlist = Mid(strsql, selectpos + 7, frompos - (selectpos + 7) + 1) '�õ������е��б�
    
    '���where�ؼ���
    wherepos = InStr(frompos, strsql, " where ", vbTextCompare)
    If wherepos > 0 Then
        tablelist = Mid(strsql, frompos + 6, wherepos - (frompos + 6) + 1)
    Else
        tablelist = Mid(strsql, frompos + 6, Len(strsql) - (frompos + 6) + 1)
    End If
    
    '�������õõ���columnlist��tablelist�����local_webdw������
    'join�Ӿ䣬where�Ӿ䣬order�Ӿ��֧���Ժ������ӣ������һ���������ܡ�
    '���õõ���table���ƣ�������Ӧ��Table����
    temparray = Split(tablelist, ",")
    id = 0
    For Each tempv In temparray
        temps = tempv                           'ת�����ַ���������һ�����ݱ�����
        temps = Trim(temps)
        
        id = id + 1
        local_webdw.table.retrieve.pbselect.table(id) = temps
    Next
    
    
    Dim col_datatype As String
    Dim col_length As Long
    Dim stablename As String
    Dim scolname As String
    Dim ipos As Long
    
    temparray = Split(columnlist, ",", -1, vbTextCompare)        '��columnlist�зֳ�����
    id = 0
    For Each tempv In temparray
        temps = tempv                           'ת�����ַ���,����һ��������
        temps = Trim(temps)
        id = id + 1
        '�������column�����ƣ��Զ�����text,column,table�����column
            
        'step1 ��ʼ��table.column
        local_webdw.table.Columns(id).dbname = temps
        ipos = InStr(1, temps, ".")
        If ipos < 0 Then
            stablename = local_webdw.table.retrieve.pbselect.table(1)
            scolname = temps
        Else
            stablename = Left(temps, ipos - 1)
            scolname = Right(temps, Len(temps) - ipos)
        End If
        
        '�����õ����ݱ���Ӧ�е��ֶ����ͺ��ֶγ���
        If getDataType(stablename, scolname, col_datatype, col_length) = -1 Then
            generateDW_0Common = ""
            iret = -1
            errString = "��ȡ�����е���������ʱ��������!"
            Exit Function
        End If
        
        local_webdw.table.Columns(id).Name = Replace(temps, ".", "_") '���Ƶ�.����»���
        local_webdw.table.Columns(id).type = col_datatype & "(" & col_length & ")"
        local_webdw.table.Columns(id).update = "yes"
        local_webdw.table.Columns(id).updatewhereclause = "yes"
        
        'TODO:��һ����Ҫ���ݴ��ֶ��Ƿ�Ϊ�������Լ��Ƿ��б��������ж�key������
        local_webdw.table.Columns(id).key = "no"
        
        'step2 ��ʼ��table.retrieve.column ��ֵ
        local_webdw.table.retrieve.pbselect.column(id) = "~" & """" & temps & "~" & """"
        
        'stemp3 ��ʼ��text��ֵ
        local_webdw.text(id).Name = Replace(temps, ".", "_") & "_t"
        local_webdw.text(id).alignment = 2
        local_webdw.text(id).text = Replace(temps, ".", "_")    'δ������Ӧ�������ݿ��еõ�
        local_webdw.text(id).border = 0
        local_webdw.text(id).color = 0
        local_webdw.text(id).font.face = "MS Sans Serif"
        local_webdw.text(id).font.height = "-8"
        local_webdw.text(id).font.weight = 700
        local_webdw.text(id).font.family = 2
        local_webdw.text(id).font.pitch = 2
        local_webdw.text(id).font.charset = 0
        
        local_webdw.text(id).background_mode = 1
        local_webdw.text(id).background_color = color_white
        
        
        'step4 ��ʼ��column������
        local_webdw.column(id).width = col_length               '��ʱ���е����ݿⶨ����ȴ���width��������
        local_webdw.column(id).Name = Replace(temps, ".", "_")
        local_webdw.column(id).id = id
        local_webdw.column(id).alignment = "0"
        local_webdw.column(id).tabsequence = id * 10
        local_webdw.column(id).border = 1
        local_webdw.column(id).color = 0
        local_webdw.column(id).format = "[general]"
        local_webdw.column(id).tag = Replace(temps, ".", "_")
        local_webdw.column(id).edit_limit = 0
        local_webdw.column(id).edit_case = "any"
        local_webdw.column(id).edit_focusrectangle = "no"
        local_webdw.column(id).edit_autoselect = "no"
        local_webdw.column(id).edit_autohscroll = "no"
        local_webdw.column(id).font.face = "MS Sans Serif"
        local_webdw.column(id).font.height = "-8"
        local_webdw.column(id).font.weight = 400
        local_webdw.column(id).font.family = 2
        local_webdw.column(id).font.pitch = 2
        local_webdw.column(id).font.charset = 0
        local_webdw.column(id).background_mode = 1
        local_webdw.column(id).background_color = color_white
        local_webdw.column(id).band = "detail"
    Next
    
End Function

'���ݸ�����SQL��䣬�Լ���Ӧ�����ݴ�������
'����һ��Freedom����DW����
Private Function generateDW_1Freedom(strsql As String, stype As String, ByRef iret As Long) As String
    Dim temparray() As String
    Dim id As Long
    Dim tempv As Variant
    Dim temps As String
    Dim col_length As Long
    
    temparray = Split(columnlist, ",", -1, vbTextCompare)        '��columnlist�зֳ�����
    id = 0
    For Each tempv In temparray
        temps = tempv                           'ת�����ַ���,����һ��������
        temps = Trim(temps)
        id = id + 1
        
        '����text������
        local_webdw.text(id).X = 10
        If id = 1 Then
            local_webdw.text(id).Y = 10
        Else
            local_webdw.text(id).Y = local_webdw.column(id - 1).Y _
                         + local_webdw.column(id - 1).height + 50
        End If
                                    
        local_webdw.text(id).width = 500
        local_webdw.text(id).height = 50
        local_webdw.text(id).band = "detail"
        local_webdw.detail.height = local_webdw.text(id).Y + local_webdw.text(id).height + 200
            
        '����column������
        local_webdw.column(id).X = 600
        If id = 1 Then
            local_webdw.column(id).Y = 10
        Else
            local_webdw.column(id).Y = local_webdw.column(id - 1).Y _
                        + local_webdw.column(id - 1).height + 50
        End If
            
        '��width����ȡ��col_length����
        col_length = local_webdw.column(id).width
        If col_length <= 30 Then
            If col_length < 10 Then
                local_webdw.column(id).width = 200
                local_webdw.column(id).height = 50
            Else
                local_webdw.column(id).width = 25 * col_length
                local_webdw.column(id).height = 50
            End If
        Else
            local_webdw.column(id).width = 800
            local_webdw.column(id).height = 200
        End If
            
        '����freedom���͵�DW������detail��height
        If local_webdw.detail.height < local_webdw.column(id).Y + local_webdw.column(id).height + 100 Then
             local_webdw.detail.height = local_webdw.column(id).Y + local_webdw.column(id).height + 100
        End If
            
    Next
    
End Function

Private Function generateDW_2Grid(strsql As String, stype As String, ByRef iret As Long) As String
    Dim temparray() As String
    Dim tempv As Variant
    Dim temps As String
    Dim id As Long
    Dim ipos As Long
    Dim stablename As String
    Dim scolname As String
    Dim col_length As Long
    Dim sum_width As Long
    
    sum_width = 0
    temparray = Split(columnlist, ",", -1, vbTextCompare)        '��columnlist�зֳ�����
    id = 0
    For Each tempv In temparray
        temps = tempv                           'ת�����ַ���,����һ��������
        temps = Trim(temps)
        id = id + 1
        '�������column�����ƣ��Զ�����text,column,table�����column
            
        'step1 ��ʼ��table.column
        local_webdw.table.Columns(id).dbname = temps
        ipos = InStr(1, temps, ".")
        If ipos < 0 Then
            stablename = local_webdw.table.retrieve.pbselect.table(1)
            scolname = temps
        Else
            stablename = Left(temps, ipos - 1)
            scolname = Right(temps, Len(temps) - ipos)
        End If
        
        '����text������
        local_webdw.text(id).Y = 10
        local_webdw.text(id).X = 10 + sum_width
        local_webdw.text(id).height = 200
        local_webdw.text(id).band = "header"
        local_webdw.header.height = 200
        local_webdw.detail.height = 100
        
        
        '����column������
        local_webdw.column(id).border = 0
        local_webdw.column(id).Y = 10
        local_webdw.column(id).X = 10 + sum_width
        col_length = local_webdw.column(id).width
        local_webdw.column(id).width = 500
        
        If col_length <= 20 Then
            If col_length < 10 Then
                local_webdw.column(id).width = 200
                local_webdw.text(id).width = 200
                local_webdw.column(id).height = 50
            Else
                local_webdw.column(id).width = col_length * 25
                local_webdw.text(id).width = col_length * 25
                local_webdw.column(id).height = 50
            End If
        Else
            local_webdw.column(id).width = 500
            local_webdw.text(id).width = 500
            local_webdw.column(id).height = 200
            local_webdw.detail.height = 220
        End If
        
        sum_width = sum_width + 10 + local_webdw.column(id).width
    Next


End Function

'������������ʼ��local_webdw����Ϊ���и������ݸ����ʼֵ
'�������������SQL�������һ��Datawindows���е���
'��һ����ֱ�Ӳ���local_webdw����
Private Function initDW(dwtype As String) As Long

    '��ʼ��datawindow������
    local_webdw.datawindow.unit = 0
    local_webdw.datawindow.timer_interval = 0
    local_webdw.datawindow.color = 16777215
    local_webdw.datawindow.processiong = 1
    local_webdw.datawindow.HTMLDW = "no"
    local_webdw.datawindow.print_documentname = ""
    local_webdw.datawindow.print_orientation = 0
    local_webdw.datawindow.print_margin_left = 110
    local_webdw.datawindow.print_margin_right = 110
    local_webdw.datawindow.print_margin_top = 96
    local_webdw.datawindow.print_margin_bottom = 96
    local_webdw.datawindow.print_paper_source = 0
    local_webdw.datawindow.print_paper_size = 0
    local_webdw.datawindow.print_prompt = "no"
    local_webdw.datawindow.print_buttons = "no"
    local_webdw.datawindow.print_preview_buttons = "no"
    
    '��ʼ��header������
    '����Ǳ����ͣ���ͷ��������û��ͷ��
    If dwtype = "grid" Then
        local_webdw.header.height = 96
    Else
        local_webdw.header.height = 0
    End If
    local_webdw.header.color = color_white
    
    '��ʼ��summary������
    local_webdw.summary.height = 96
    local_webdw.summary.color = color_white
    
    '��ʼ��footer������
    local_webdw.footer.height = 96
    local_webdw.footer.color = color_white
    
    '��ʼ��detail������
    local_webdw.detail.height = 96
    local_webdw.detail.color = color_white
    
    '��ʼ��table������
    local_webdw.table.updatewhere = 1
    local_webdw.table.updatekeyinplace = "no"
    
    
End Function

'�õ�����ĳһ�еľ�����������
'�е����������ַ�����colDefString�еõ�����������
'����:����������
'������������ͣ��г���
'���أ���־λ��0 �ɹ� -1 ʧ��
Private Function getDataType(stable As String, scol As String, _
                            ByRef sDataType As String, ByRef collen As Long) As Long
    Dim line() As String
    Dim sdata() As String
    
    Dim aline As Variant
    Dim sline As String
    Dim id As Long
    
    Dim tab_colIndex As Long    'TNAME�е����
    Dim col_colIndex As Long    'CNAME�е����
    Dim type_index As Long
    Dim len_index As Long
    
    '�ж��Ƿ��ǿ��ַ���
    If colDefString = "" Then
        getDataType = -1
        errString = "��δ����colDefString��ֵ"
        Exit Function
    End If
        
    '����Tname�� �� Cname�е����
    tab_colIndex = getColIndex("TNAME")
    col_colIndex = getColIndex("CNAME")
    type_index = getColIndex("COLTYPE")
    len_index = getColIndex("WIDTH")
    
    If tab_colIndex = -1 Or col_colIndex = -1 _
        Or type_index = -1 Or len_index = -1 Then
        getDataType = -1
        errString = "�޷����TNAME�к�CNAME�е��±�"
        Exit Function
    End If
    
    '�����зֳɶ���
    line = Split(colDefString, "" & Chr(13) & Chr(10))
    
    For Each aline In line
        sline = aline
        sdata = Split(sline, "" & Chr(9))
        
        If sdata(tab_colIndex) = stable And sdata(col_colIndex) = scol Then
            sDataType = sdata(type_index)
            collen = sdata(len_index)
            getDataType = 0
            Exit Function
        End If
    Next
    
    getDataType = -1
    Exit Function
End Function

'��colDefString�м������������е�һ��
'����һ�������������õ���Ӧ���±��(��0��ʼ)
'����ֵ:>=0 �����±��
'����-1�����Ҳ���,��������
Private Function getColIndex(colname As String) As Long
    Dim line() As String
    Dim colnames() As String
    Dim id As Long
    
    On Error GoTo errorHandle
    '�����зֳɶ���
    line = Split(colDefString, "" & Chr(13) & Chr(10))
    colnames = Split(line(0), "" & Chr(9))
    For id = 0 To UBound(colnames)
        If UCase(colnames(id)) = UCase(colname) Then
            getColIndex = id
            Exit Function
        End If
    Next
errorHandle:
    getColIndex = -1
End Function

