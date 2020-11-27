VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDW_GetSyntaxString"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW的字符串生成功能
Rem 输入local_webdw,利用这个结构生成一个符合规范要求的字符串
Rem 这个类对外只提供一个公共方法getsyntaxstring，用一个字符串填充local_webdw
Rem 输入：local_webdw
Rem 输出：字符串,errString,iret
Rem iret代表执行的状态标志，0正常 -1失败
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @版权所有 刘峻松 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------
Option Explicit

Public errString As String          '执行产生的错误信息
Private local_webdw As WebDWSyntax      'local_webdw现在是一个局部变量了，而不是全局变量了

'功能描述：设置local_webdw的值
'输入：glocal_webdw
'输出：local_webdw
Public Function SetLocalWebDW()
    local_webdw = GG_webdw
End Function

'功能描述：读取local_webdw的值
'输入:local_webdw
'输出:glocal_webdw
Public Function GetLocalWebDW()
    GG_webdw = local_webdw
End Function


'功能描述：将local_webdw转换成一个指定格式的字符串
'以后要修改生成的字符串，只需要修改local_webdw的数据就可以了
Public Function GetSyntaxString(ByRef iret As Long) As String
    Dim strFileHeader As String
    Dim stemp As String
    Dim strDW As String
    
    strFileHeader = "$PBExportHeader$test.srd" & Chr(13) & Chr(10) _
                    & "$PBExportComments$Create by WebDW Generater 1.0 " & Chr(13) & Chr(10) _
                    & "release 7;" & Chr(13) & Chr(10)
                        
    strDW = strFileHeader
    iret = 0
    
    'step1:datawindow属性
    stemp = getDW01_DataWindow(iret)
    
    If iret = -1 Then GetSyntaxString = "": Exit Function
    strDW = strDW & stemp
    
    'step2 Header属性
    stemp = getDW02_Header(iret)
    If iret = -1 Then GetSyntaxString = "": Exit Function
    strDW = strDW & stemp
        
    'step3 summary属性
    stemp = getDW03_Summary(iret)
    If iret = -1 Then GetSyntaxString = "": Exit Function
    strDW = strDW & stemp
    
    'ste4 footer属性
    stemp = getDW04_Footer(iret)
    If iret = -1 Then GetSyntaxString = "": Exit Function
    strDW = strDW & stemp
    
    'step5 detail属性
    stemp = getDW05_Detail(iret)
    If iret = -1 Then GetSyntaxString = "": Exit Function
    strDW = strDW & stemp
        
    'step6 table属性
    stemp = getDW06_Table(iret)
    If iret = -1 Then GetSyntaxString = "": Exit Function
    strDW = strDW & stemp
    
    'step7 text属性
    stemp = getDW07_Text(iret)
    If iret = -1 Then GetSyntaxString = "": Exit Function
    strDW = strDW & stemp

    'step8 column属性
    stemp = getDW08_Column(iret)
    If iret = -1 Then GetSyntaxString = "": Exit Function
    strDW = strDW & stemp

    'step9 line属性
    stemp = getDW09_Line(iret)
    If iret = -1 Then GetSyntaxString = "": Exit Function
    strDW = strDW & stemp

    GetSyntaxString = strDW
        
End Function

'得到DataWindow部分表示的字符串
Private Function getDW01_DataWindow(ByRef iret As Long) As String
    Dim sret As String
    iret = 0
    sret = "datawindow(" _
            & "units=" & local_webdw.datawindow.unit & " " _
            & "timer_interval=" & local_webdw.datawindow.timer_interval & " " _
            & "color=" & local_webdw.datawindow.color & " " _
            & "processing=" & local_webdw.datawindow.processiong & " " _
            & "HTMLDW=" & local_webdw.datawindow.HTMLDW & " " _
            & "print.documentname=" & """" & local_webdw.datawindow.print_documentname & """" & " " _
            & "print.orientation=" & local_webdw.datawindow.print_orientation & " " _
            & "print.margin.left=" & local_webdw.datawindow.print_margin_left & " " _
            & "print.margin.right=" & local_webdw.datawindow.print_margin_right & " " _
            & "print.margin.top=" & local_webdw.datawindow.print_margin_top & " " _
            & "print.margin.bottom=" & local_webdw.datawindow.print_margin_bottom & " " _
            & "print.paper.source=" & local_webdw.datawindow.print_paper_source & " " _
            & "print.print.paper.size=" & local_webdw.datawindow.print_paper_size & " " _
            & "print.prompt=" & local_webdw.datawindow.print_prompt & " " _
            & "print.buttons=" & local_webdw.datawindow.print_buttons & " " _
            & "print.preview.buttons=" & local_webdw.datawindow.print_preview_buttons & " " _
            & "grid.lines=" & " " _
            & " )" & Chr(13) & Chr(10)
    getDW01_DataWindow = sret
End Function

'得到Header部分的表示的字符串
Private Function getDW02_Header(ByRef iret As Long) As String
    Dim sret As String
        
    iret = 0
    sret = "header(" _
            & "height=" & local_webdw.header.height & " " _
            & "color=" & """" & local_webdw.header.color & """" & " ) " & Chr(13) & Chr(10)
     getDW02_Header = sret
End Function

'得到Summary部分的字符串表示
Private Function getDW03_Summary(ByRef iret As Long) As String
    Dim sret As String
        
    iret = 0
    sret = "summary(" _
            & "height=" & local_webdw.summary.height & " " _
            & "color=" & """" & local_webdw.summary.color & """" & " ) " & Chr(13) & Chr(10)
     getDW03_Summary = sret


End Function
'得到footer
Private Function getDW04_Footer(ByRef iret As Long) As String
    Dim sret As String
        
    iret = 0
    sret = "footer(" _
            & "height=" & local_webdw.footer.height & " " _
            & "color=" & """" & local_webdw.footer.color & """" & " ) " & Chr(13) & Chr(10)
     getDW04_Footer = sret

End Function
'得到detail
Private Function getDW05_Detail(ByRef iret As Long) As String
    Dim sret As String
    iret = 0
    sret = "detail(" _
            & "height=" & local_webdw.detail.height & " " _
            & "color=" & """" & local_webdw.detail.color & """" & " ) " & Chr(13) & Chr(10)
     getDW05_Detail = sret
End Function

'
'得到table表示,这个相对复杂一些了
'不过和把数据分解来看，还是相对简单一些了
Private Function getDW06_Table(ByRef iret As Long) As String
    Dim sret As String
    Dim id As Long
    
    Dim table_columns As String
    Dim table_retrieve As String
    Dim sep As String
    
    sep = ""

    'step1得到column部分的定义
    table_columns = ""
    For id = 1 To 100
        If local_webdw.table.Columns(id).Name = "" Then
            Exit For
        End If
        
        table_columns = table_columns & "column=(" _
                & "type=" & local_webdw.table.Columns(id).type & " " _
                & "update=" & local_webdw.table.Columns(id).update & " " _
                & "updatewhereclause=" & local_webdw.table.Columns(id).updatewhereclause & " " _
                & "name=" & local_webdw.table.Columns(id).Name & " " _
                & "dbname=" & """" & local_webdw.table.Columns(id).dbname & """" & " " _
                & "values=" & """" & local_webdw.table.Columns(id).values & """" & " " _
                & ")" & Chr(13) & Chr(10)
                        
    Next
    
    'step2 得到retrieve部分的定义
    table_retrieve = " retrieve=" & """" & "PBSELECT(" _
                    & " VERSION(" & local_webdw.table.retrieve.pbselect.version & " ) "
    
    'step2.1 table定义
    For id = 1 To 10
        If local_webdw.table.retrieve.pbselect.table(id) = "" Then
            Exit For
        End If
        
        table_retrieve = table_retrieve _
            & "TABLE(NAME=" & sep & local_webdw.table.retrieve.pbselect.table(id) & sep & " ) "
    Next
    
    'step2.2 column定义
    For id = 1 To 100
        If local_webdw.table.retrieve.pbselect.column(id) = "" Then
            Exit For
        End If
        
        table_retrieve = table_retrieve _
            & "COLUMN(NAME=" & sep & local_webdw.table.retrieve.pbselect.column(id) & sep & " ) "
        
    Next
    
    'step2.3 join定义
    For id = 1 To 10
        If local_webdw.table.retrieve.pbselect.join(id).join_left = "" Then
            Exit For
        End If
        
        table_retrieve = table_retrieve & "JOIN (" _
        & "LEFT=" & sep & local_webdw.table.retrieve.pbselect.join(id).join_left & sep & " " _
        & "OP=" & sep & local_webdw.table.retrieve.pbselect.join(id).join_op & sep & " " _
        & "RIGHT=" & sep & local_webdw.table.retrieve.pbselect.join(id).join_right & sep & " " _
        & " ) "
    Next
    
    'step2.4 where定义
    For id = 1 To 10
        If local_webdw.table.retrieve.pbselect.where(id).exp1 = "" Then
            Exit For
        End If
        
        table_retrieve = table_retrieve & "WHERE(" _
        & " EXP1 =" & local_webdw.table.retrieve.pbselect.where(id).exp1 & " " _
        & " OP =" & local_webdw.table.retrieve.pbselect.where(id).op & " " _
        & " EXP2 =" & local_webdw.table.retrieve.pbselect.where(id).exp2 & " " _
        & " LOGIC =" & local_webdw.table.retrieve.pbselect.where(id).logic & " " _
        & " ) "
    Next
    
    table_retrieve = table_retrieve & " ) " & """"
    
    'step3 .sret
    sret = "table(" & table_columns & table_retrieve _
        & "update=" & """" & local_webdw.table.update & """" & " " _
        & "updatewhere=" & local_webdw.table.updatewhere & " " _
        & "updatekeyinplace=" & local_webdw.table.updatekeyinplace & " " & " )"
        
    getDW06_Table = sret
End Function
'得到标签表示
Private Function getDW07_Text(ByRef iret As Long) As String
    Dim sret As String
    Dim id As Long
    
    iret = 0
    sret = ""
    
    For id = 1 To 100
        If local_webdw.text(id).Name = "" Then
            Exit For
        End If
        
        sret = sret & "text(" _
            & "band=" & local_webdw.text(id).band & " " _
            & "alignment=" & """" & local_webdw.text(id).alignment & """" & " " _
            & "text=" & """" & local_webdw.text(id).text & """" & " " _
            & "border=" & """" & local_webdw.text(id).border & """" & " " _
            & "color=" & """" & local_webdw.text(id).color & """" & " " _
            & "x=" & """" & local_webdw.text(id).X & """" & " " _
            & "y=" & """" & local_webdw.text(id).Y & """" & " " _
            & "height=" & """" & local_webdw.text(id).height & """" & " " _
            & "width=" & """" & local_webdw.text(id).width & """" & " " _
            & "name=" & """" & local_webdw.text(id).Name & """" & " " _
            & "font.face=" & """" & local_webdw.text(id).font.face & """" & " " _
            & "font.height=" & """" & local_webdw.text(id).font.height & """" & " " _
            & "font.weight=" & """" & local_webdw.text(id).font.weight & """" & " " _
            & "font.family=" & """" & local_webdw.text(id).font.family & """" & " " _
            & "font.pitch=" & """" & local_webdw.text(id).font.pitch & """" & " " _
            & "font.charset=" & """" & local_webdw.text(id).font.charset & """" & " " _
            & "background.mode=" & """" & local_webdw.text(id).background_mode & """" & " " _
            & "background.color=" & """" & local_webdw.text(id).background_color & """" & " " _
            & ")" & Chr(13) & Chr(10)
    Next
    
    getDW07_Text = sret
End Function

'得到列表示
Private Function getDW08_Column(ByRef iret As Long) As String
    Dim sret As String
    Dim id As Long
    
    iret = 0
    sret = ""
    
    For id = 1 To 100
        If local_webdw.column(id).Name = "" Then
            Exit For
        End If
        
       sret = sret & "column(" _
            & "band=" & local_webdw.column(id).band & " " _
            & "id=" & local_webdw.column(id).id & " " _
            & "alignment=" & """" & local_webdw.column(id).alignment & """" & " " _
            & "tabsequence=" & local_webdw.column(id).tabsequence & " " _
            & "border=" & """" & local_webdw.column(id).border & """" & " " _
            & "color=" & """" & local_webdw.column(id).color & """" & " " _
            & "x=" & """" & local_webdw.column(id).X & """" & " " _
            & "y=" & """" & local_webdw.column(id).Y & """" & " " _
            & "height=" & """" & local_webdw.column(id).height & """" & " " _
            & "width=" & """" & local_webdw.column(id).width & """" & " " _
            & "format=" & """" & local_webdw.column(id).format & """" & " " _
            & "name=" & local_webdw.column(id).Name & " " _
            & "tag=" & """" & local_webdw.column(id).tag & """" & " " _
            & "edit.limit=" & local_webdw.column(id).edit_limit & " " _
            & "edit.case=" & local_webdw.column(id).edit_case & " " _
            & "edit.focusrectangle=" & local_webdw.column(id).edit_focusrectangle & " " _
            & "edit.autoselect=" & local_webdw.column(id).edit_autoselect & " " _
            & "edit.autohscroll=" & local_webdw.column(id).edit_autohscroll & " " _
            & "font.face=" & """" & local_webdw.column(id).font.face & """" & " " _
            & "font.height=" & """" & local_webdw.column(id).font.height & """" & " " _
            & "font.weight=" & """" & local_webdw.column(id).font.weight & """" & " " _
            & "font.family=" & """" & local_webdw.column(id).font.family & """" & " " _
            & "font.pitch=" & """" & local_webdw.column(id).font.pitch & """" & " " _
            & "font.charset=" & """" & local_webdw.column(id).font.charset & """" & " "
            
        sret = sret & "background.mode=" & """" & local_webdw.column(id).background_mode & """" & " " _
            & "background.color=" & """" & local_webdw.column(id).background_color & """" & " " _
            & ")" & Chr(13) & Chr(10)
    Next
    
    getDW08_Column = sret

End Function

'得到线表示
Private Function getDW09_Line(ByRef iret As Long) As String
    Dim sret As String
    Dim id As Long
    
    iret = 0
    sret = ""
    
    For id = 1 To 100
        If local_webdw.lineinfo(id).Name = "" Then
            Exit For
        End If
        
        sret = sret & "line(" _
            & "band=" & local_webdw.lineinfo(id).band & " " _
            & "x1=" & """" & local_webdw.lineinfo(id).x1 & """" & " " _
            & "y1=" & """" & local_webdw.lineinfo(id).y1 & """" & " " _
            & "x2=" & """" & local_webdw.lineinfo(id).x2 & """" & " " _
            & "y2=" & """" & local_webdw.lineinfo(id).y2 & """" & " " _
            & "name=" & local_webdw.lineinfo(id).Name & " " _
            & "pen.style=" & """" & local_webdw.lineinfo(id).pen_style & """" & " " _
            & "pen.width=" & """" & local_webdw.lineinfo(id).pen_width & """" & " " _
            & "pen.color=" & """" & local_webdw.lineinfo(id).pen_color & """" & " " _
            & "background.mode=" & """" & local_webdw.lineinfo(id).background_mode & """" & " " _
            & "background.color=" & """" & local_webdw.lineinfo(id).background_color & """" & " " _
            & ")" & Chr(13) & Chr(10)
    Next
    
    getDW09_Line = sret
End Function

