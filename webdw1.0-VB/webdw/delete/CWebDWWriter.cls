VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDWWriter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW���ַ������ɹ���
Rem ����g_webdw,��������ṹ����һ�����Ϲ淶Ҫ����ַ���
Rem ��������ֻ�ṩһ����������GetDWString����һ���ַ������g_webdw
Rem ���룺g_webdw
Rem ������ַ���,errString,iret
Rem iret����ִ�е�״̬��־��0���� -1ʧ��
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @��Ȩ���� ������ 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------
Option Explicit

Public errString As String 'ִ�в����Ĵ�����Ϣ

'������������g_webdwת����һ��ָ����ʽ���ַ���
'�Ժ�Ҫ�޸����ɵ��ַ�����ֻ��Ҫ�޸�g_webdw�����ݾͿ�����
Public Function GetDWString(ByRef iret As Long) As String
    Dim strFileHeader As String
    Dim stemp As String
    Dim strDW As String
    
    strFileHeader = "$PBExportHeader$test.srd" & Chr(13) & Chr(10) _
                    & "$PBExportComments$Create by WebDW Generater 1.0 " & Chr(13) & Chr(10) _
                    & "release 7;" & Chr(13) & Chr(10)
                        
    strDW = strFileHeader
    iret = 0
    
    'step1:datawindow����
    stemp = getDW01_DataWindow(iret)
    
    If iret = -1 Then GetDWString = "": Exit Function
    strDW = strDW & stemp
    
    'step2 Header����
    stemp = getDW02_Header(iret)
    If iret = -1 Then GetDWString = "": Exit Function
    strDW = strDW & stemp
        
    'step3 summary����
    stemp = getDW03_Summary(iret)
    If iret = -1 Then GetDWString = "": Exit Function
    strDW = strDW & stemp
    
    'ste4 footer����
    stemp = getDW04_Footer(iret)
    If iret = -1 Then GetDWString = "": Exit Function
    strDW = strDW & stemp
    
    'step5 detail����
    stemp = getDW05_Detail(iret)
    If iret = -1 Then GetDWString = "": Exit Function
    strDW = strDW & stemp
        
    'step6 table����
    stemp = getDW06_Table(iret)
    If iret = -1 Then GetDWString = "": Exit Function
    strDW = strDW & stemp
    
    'step7 text����
    stemp = getDW07_Text(iret)
    If iret = -1 Then GetDWString = "": Exit Function
    strDW = strDW & stemp

    'step8 column����
    stemp = getDW08_Column(iret)
    If iret = -1 Then GetDWString = "": Exit Function
    strDW = strDW & stemp

    'step9 line����
    stemp = getDW09_Line(iret)
    If iret = -1 Then GetDWString = "": Exit Function
    strDW = strDW & stemp

    GetDWString = strDW
        
End Function

'�õ�DataWindow���ֱ�ʾ���ַ���
Private Function getDW01_DataWindow(ByRef iret As Long) As String
    Dim sret As String
    iret = 0
    sret = "datawindow(" _
            & "units=" & g_webdw.datawindow.unit & " " _
            & "timer_interval=" & g_webdw.datawindow.timer_interval & " " _
            & "color=" & g_webdw.datawindow.color & " " _
            & "processing=" & g_webdw.datawindow.processiong & " " _
            & "HTMLDW=" & g_webdw.datawindow.HTMLDW & " " _
            & "print.documentname=" & """" & g_webdw.datawindow.print_documentname & """" & " " _
            & "print.orientation=" & g_webdw.datawindow.print_orientation & " " _
            & "print.margin.left=" & g_webdw.datawindow.print_margin_left & " " _
            & "print.margin.right=" & g_webdw.datawindow.print_margin_right & " " _
            & "print.margin.top=" & g_webdw.datawindow.print_margin_top & " " _
            & "print.margin.bottom=" & g_webdw.datawindow.print_margin_bottom & " " _
            & "print.paper.source=" & g_webdw.datawindow.print_paper_source & " " _
            & "print.print.paper.size=" & g_webdw.datawindow.print_paper_size & " " _
            & "print.prompt=" & g_webdw.datawindow.print_prompt & " " _
            & "print.buttons=" & g_webdw.datawindow.print_buttons & " " _
            & "print.preview.buttons=" & g_webdw.datawindow.print_preview_buttons & " " _
            & "grid.lines=" & " " _
            & " )" & Chr(13) & Chr(10)
    getDW01_DataWindow = sret
End Function

'�õ�Header���ֵı�ʾ���ַ���
Private Function getDW02_Header(ByRef iret As Long) As String
    Dim sret As String
        
    iret = 0
    sret = "header(" _
            & "height=" & g_webdw.header.height & " " _
            & "color=" & """" & g_webdw.header.color & """" & " ) " & Chr(13) & Chr(10)
     getDW02_Header = sret
End Function

'�õ�Summary���ֵ��ַ�����ʾ
Private Function getDW03_Summary(ByRef iret As Long) As String
    Dim sret As String
        
    iret = 0
    sret = "summary(" _
            & "height=" & g_webdw.summary.height & " " _
            & "color=" & """" & g_webdw.summary.color & """" & " ) " & Chr(13) & Chr(10)
     getDW03_Summary = sret


End Function
'�õ�footer
Private Function getDW04_Footer(ByRef iret As Long) As String
    Dim sret As String
        
    iret = 0
    sret = "footer(" _
            & "height=" & g_webdw.footer.height & " " _
            & "color=" & """" & g_webdw.footer.color & """" & " ) " & Chr(13) & Chr(10)
     getDW04_Footer = sret

End Function
'�õ�detail
Private Function getDW05_Detail(ByRef iret As Long) As String
    Dim sret As String
    iret = 0
    sret = "detail(" _
            & "height=" & g_webdw.detail.height & " " _
            & "color=" & """" & g_webdw.detail.color & """" & " ) " & Chr(13) & Chr(10)
     getDW05_Detail = sret
End Function

'
'�õ�table��ʾ,�����Ը���һЩ��
'�����Ͱ����ݷֽ�������������Լ�һЩ��
Private Function getDW06_Table(ByRef iret As Long) As String
    Dim sret As String
    Dim id As Long
    
    Dim table_columns As String
    Dim table_retrieve As String
    Dim sep As String
    
    sep = ""

    'step1�õ�column���ֵĶ���
    table_columns = ""
    For id = 1 To 100
        If g_webdw.table.Columns(id).name = "" Then
            Exit For
        End If
        
        table_columns = table_columns & "column=(" _
                & "type=" & g_webdw.table.Columns(id).type & " " _
                & "update=" & g_webdw.table.Columns(id).update & " " _
                & "updatewhereclause=" & g_webdw.table.Columns(id).updatewhereclause & " " _
                & "name=" & g_webdw.table.Columns(id).name & " " _
                & "dbname=" & """" & g_webdw.table.Columns(id).dbname & """" & " " _
                & "values=" & """" & g_webdw.table.Columns(id).values & """" & " " _
                & ")" & Chr(13) & Chr(10)
                        
    Next
    
    'step2 �õ�retrieve���ֵĶ���
    table_retrieve = " retrieve=" & """" & "PBSELECT(" _
                    & " VERSION(" & g_webdw.table.retrieve.pbselect.version & " ) "
    
    'step2.1 table����
    For id = 1 To 10
        If g_webdw.table.retrieve.pbselect.table(id) = "" Then
            Exit For
        End If
        
        table_retrieve = table_retrieve _
            & "TABLE(NAME=" & sep & g_webdw.table.retrieve.pbselect.table(id) & sep & " ) "
    Next
    
    'step2.2 column����
    For id = 1 To 100
        If g_webdw.table.retrieve.pbselect.column(id) = "" Then
            Exit For
        End If
        
        table_retrieve = table_retrieve _
            & "COLUMN(NAME=" & sep & g_webdw.table.retrieve.pbselect.column(id) & sep & " ) "
        
    Next
    
    'step2.3 join����
    For id = 1 To 10
        If g_webdw.table.retrieve.pbselect.join(id).join_left = "" Then
            Exit For
        End If
        
        table_retrieve = table_retrieve & "JOIN (" _
        & "LEFT=" & sep & g_webdw.table.retrieve.pbselect.join(id).join_left & sep & " " _
        & "OP=" & sep & g_webdw.table.retrieve.pbselect.join(id).join_op & sep & " " _
        & "RIGHT=" & sep & g_webdw.table.retrieve.pbselect.join(id).join_right & sep & " " _
        & " ) "
    Next
    
    'step2.4 where����
    For id = 1 To 10
        If g_webdw.table.retrieve.pbselect.where(id).exp1 = "" Then
            Exit For
        End If
        
        table_retrieve = table_retrieve & "WHERE(" _
        & " EXP1 =" & g_webdw.table.retrieve.pbselect.where(id).exp1 & " " _
        & " OP =" & g_webdw.table.retrieve.pbselect.where(id).op & " " _
        & " EXP2 =" & g_webdw.table.retrieve.pbselect.where(id).exp2 & " " _
        & " LOGIC =" & g_webdw.table.retrieve.pbselect.where(id).logic & " " _
        & " ) "
    Next
    
    table_retrieve = table_retrieve & " ) " & """"
    
    'step3 .sret
    sret = "table(" & table_columns & table_retrieve _
        & "update=" & """" & g_webdw.table.update & """" & " " _
        & "updatewhere=" & g_webdw.table.updatewhere & " " _
        & "updatekeyinplace=" & g_webdw.table.updatekeyinplace & " " & " )"
        
    getDW06_Table = sret
End Function
'�õ���ǩ��ʾ
Private Function getDW07_Text(ByRef iret As Long) As String
    Dim sret As String
    Dim id As Long
    
    iret = 0
    sret = ""
    
    For id = 1 To 100
        If g_webdw.text(id).name = "" Then
            Exit For
        End If
        
        sret = sret & "text(" _
            & "band=" & g_webdw.text(id).band & " " _
            & "alignment=" & """" & g_webdw.text(id).alignment & """" & " " _
            & "text=" & """" & g_webdw.text(id).text & """" & " " _
            & "border=" & """" & g_webdw.text(id).border & """" & " " _
            & "color=" & """" & g_webdw.text(id).color & """" & " " _
            & "x=" & """" & g_webdw.text(id).x & """" & " " _
            & "y=" & """" & g_webdw.text(id).y & """" & " " _
            & "height=" & """" & g_webdw.text(id).height & """" & " " _
            & "width=" & """" & g_webdw.text(id).width & """" & " " _
            & "name=" & """" & g_webdw.text(id).name & """" & " " _
            & "font.face=" & """" & g_webdw.text(id).font.face & """" & " " _
            & "font.height=" & """" & g_webdw.text(id).font.height & """" & " " _
            & "font.weight=" & """" & g_webdw.text(id).font.weight & """" & " " _
            & "font.family=" & """" & g_webdw.text(id).font.family & """" & " " _
            & "font.pitch=" & """" & g_webdw.text(id).font.pitch & """" & " " _
            & "font.charset=" & """" & g_webdw.text(id).font.charset & """" & " " _
            & "background.mode=" & """" & g_webdw.text(id).background_mode & """" & " " _
            & "background.color=" & """" & g_webdw.text(id).background_color & """" & " " _
            & ")" & Chr(13) & Chr(10)
    Next
    
    getDW07_Text = sret
End Function

'�õ��б�ʾ
Private Function getDW08_Column(ByRef iret As Long) As String
    Dim sret As String
    Dim id As Long
    
    iret = 0
    sret = ""
    
    For id = 1 To 100
        If g_webdw.column(id).name = "" Then
            Exit For
        End If
        
       sret = sret & "column(" _
            & "band=" & g_webdw.column(id).band & " " _
            & "id=" & g_webdw.column(id).id & " " _
            & "alignment=" & """" & g_webdw.column(id).alignment & """" & " " _
            & "tabsequence=" & g_webdw.column(id).tabsequence & " " _
            & "border=" & """" & g_webdw.column(id).border & """" & " " _
            & "color=" & """" & g_webdw.column(id).color & """" & " " _
            & "x=" & """" & g_webdw.column(id).x & """" & " " _
            & "y=" & """" & g_webdw.column(id).y & """" & " " _
            & "height=" & """" & g_webdw.column(id).height & """" & " " _
            & "width=" & """" & g_webdw.column(id).width & """" & " " _
            & "format=" & """" & g_webdw.column(id).format & """" & " " _
            & "name=" & g_webdw.column(id).name & " " _
            & "tag=" & """" & g_webdw.column(id).tag & """" & " " _
            & "edit.limit=" & g_webdw.column(id).edit_limit & " " _
            & "edit.case=" & g_webdw.column(id).edit_case & " " _
            & "edit.focusrectangle=" & g_webdw.column(id).edit_focusrectangle & " " _
            & "edit.autoselect=" & g_webdw.column(id).edit_autoselect & " " _
            & "edit.autohscroll=" & g_webdw.column(id).edit_autohscroll & " " _
            & "font.face=" & """" & g_webdw.column(id).font.face & """" & " " _
            & "font.height=" & """" & g_webdw.column(id).font.height & """" & " " _
            & "font.weight=" & """" & g_webdw.column(id).font.weight & """" & " " _
            & "font.family=" & """" & g_webdw.column(id).font.family & """" & " " _
            & "font.pitch=" & """" & g_webdw.column(id).font.pitch & """" & " " _
            & "font.charset=" & """" & g_webdw.column(id).font.charset & """" & " "
            
        sret = sret & "background.mode=" & """" & g_webdw.column(id).background_mode & """" & " " _
            & "background.color=" & """" & g_webdw.column(id).background_color & """" & " " _
            & ")" & Chr(13) & Chr(10)
    Next
    
    getDW08_Column = sret

End Function

'�õ��߱�ʾ
Private Function getDW09_Line(ByRef iret As Long) As String
    Dim sret As String
    Dim id As Long
    
    iret = 0
    sret = ""
    
    For id = 1 To 100
        If g_webdw.lineinfo(id).name = "" Then
            Exit For
        End If
        
        sret = sret & "line(" _
            & "band=" & g_webdw.lineinfo(id).band & " " _
            & "x1=" & """" & g_webdw.lineinfo(id).x1 & """" & " " _
            & "y1=" & """" & g_webdw.lineinfo(id).y1 & """" & " " _
            & "x2=" & """" & g_webdw.lineinfo(id).x2 & """" & " " _
            & "y2=" & """" & g_webdw.lineinfo(id).y2 & """" & " " _
            & "name=" & g_webdw.lineinfo(id).name & " " _
            & "pen.style=" & """" & g_webdw.lineinfo(id).pen_style & """" & " " _
            & "pen.width=" & """" & g_webdw.lineinfo(id).pen_width & """" & " " _
            & "pen.color=" & """" & g_webdw.lineinfo(id).pen_color & """" & " " _
            & "background.mode=" & """" & g_webdw.lineinfo(id).background_mode & """" & " " _
            & "background.color=" & """" & g_webdw.lineinfo(id).background_color & """" & " " _
            & ")" & Chr(13) & Chr(10)
    Next
    
    getDW09_Line = sret
End Function
