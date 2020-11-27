VERSION 5.00
Begin VB.Form FormDSQuickSelect3 
   Caption         =   "Quick Select"
   ClientHeight    =   3840
   ClientLeft      =   4005
   ClientTop       =   3180
   ClientWidth     =   7605
   LinkTopic       =   "Form1"
   ScaleHeight     =   3840
   ScaleWidth      =   7605
   Begin VB.CommandButton CommandCancel 
      Caption         =   "取消"
      Height          =   375
      Left            =   5040
      TabIndex        =   8
      Top             =   3240
      Width           =   1575
   End
   Begin VB.CommandButton CommandSelectAll 
      Caption         =   "全选"
      Height          =   375
      Left            =   1080
      TabIndex        =   7
      Top             =   3240
      Width           =   1575
   End
   Begin VB.CommandButton CommandNext 
      Caption         =   "下一步"
      Height          =   375
      Left            =   3120
      TabIndex        =   6
      Top             =   3240
      Width           =   1455
   End
   Begin VB.ListBox List2 
      Height          =   1620
      Left            =   4080
      MultiSelect     =   1  'Simple
      TabIndex        =   5
      Top             =   1320
      Width           =   3015
   End
   Begin VB.ListBox List1 
      Height          =   1620
      Left            =   120
      TabIndex        =   4
      Top             =   1320
      Width           =   3015
   End
   Begin VB.Label Label4 
      Caption         =   "列列表："
      Height          =   255
      Left            =   4080
      TabIndex        =   3
      Top             =   960
      Width           =   3015
   End
   Begin VB.Label Label3 
      Caption         =   "3.选择排序和选择条件"
      Height          =   255
      Left            =   240
      TabIndex        =   2
      Top             =   960
      Width           =   3015
   End
   Begin VB.Label Label2 
      Caption         =   "2.选择一列或者多列"
      Height          =   255
      Left            =   240
      TabIndex        =   1
      Top             =   600
      Width           =   3015
   End
   Begin VB.Label Label1 
      Caption         =   "1.单击数据表名来选择和取消选定"
      Height          =   255
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   3015
   End
End
Attribute VB_Name = "FormDSQuickSelect3"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Option Base 0

Dim ui As CWebDWUI                      'ui是一个总的接口，所有的功能都通过ui来进行调用
Public sDWtype As String                '绘制用的DW类型
Private langsupport As New CMultiLang   '多语言支持功能

'取消按钮
Private Sub CommandCancel_Click()
    Unload FormDSQuickSelect3
End Sub

Private Sub CommandNext_Click()
    '功能描述：根据选择，生成SQL命令，并根据SQL命令来生成DWSyntax，构建DW
    
    Dim sColDefString As String '表示选择列数据类型的字符串，从后台返回
    
    Dim strsql As String        '选择的SQL语句
    Dim strDWSyntax As String   '生成的DW语法字符串
    Dim strcollist As String    '选择的列名称列表，用字符串表示，逗号分割
    Dim stablename As String    '数据表名称
    Dim i As Long               '返回值，及循环变量
    
    stablename = List1.List(List1.ListIndex)    '数据表名称
    
    strcollist = ""                             '选择列列表
    For i = 0 To List2.ListCount - 1
        If List2.Selected(i) Then
            If strcollist = "" Then
                strcollist = stablename & "." & List2.List(i)
            Else
                strcollist = strcollist & " , " _
                        & stablename & "." & List2.List(i)
            End If
        End If
    Next i
    
    strsql = "select " & strcollist _
            & " from " & stablename             '生成SQL语句
    MsgBox strsql, , "SQL"                      '显示SQL
    
    ui.sqlca.opertype = 1
    ui.sqlca.command = "Select TNAME,COLNO,CNAME,COLTYPE,WIDTH from col" _
                    & " where TNAME='" & stablename & "'"
    ui.sqlca.beginPos = 0
    ui.sqlca.readNum = 100
    
    sColDefString = ui.sqlca.ExecuteSelect(i)   '执行SQL命令，得到列类型表示
    If i = -1 Then                              '发生错误，提示错误，终止
        MsgBox ui.sqlca.ErrString, , "Error"
        Exit Sub
    End If
    
    If Right(sColDefString, 2) = "OK" Then      '去掉最后一行的OK
        sColDefString = Left(sColDefString, Len(sColDefString) - 2)
    End If
    
    ui.SetColumnDefString sColDefString  '设置列的数据类型字符串
    strDWSyntax = ui.DW_SyntaxFromSQL(strsql, sDWtype, i) '生成g_webdw,返回值是无用的
    
    If i = -1 Then                              '生成错误，提示错误，终止
        MsgBox ui.ErrString, , "Error"
        Exit Sub
    End If
    
    strDWSyntax = ui.DW_GetSyntax(i) '根据g_webdw生成对应的DWSyntax字符串
    
    'MsgBox strDWSyntax
    
    FormDWDefineShow4.showText = strDWSyntax
    
    FormDSQuickSelect3.Hide
    FormDWDefineShow4.Show
   
End Sub

Private Sub CommandSelectAll_Click()
    '全选所有的列表列
    '把所有列都标记为选择上
    Dim i As Long
    For i = 0 To List2.ListCount - 1
        List2.Selected(i) = True
    Next
End Sub

Private Sub Form_Load()
    '将此窗口居中显示
    Dim screenx As Single
    Dim screeny As Single
    screenx = Screen.width
    screeny = Screen.height
    
    Me.top = (screeny - Me.height) / 2
    Me.Left = (screenx - Me.width) / 2
    
    
    'Dim table(1000) As String
    'Dim tableNum As Integer
    'Dim i As Integer
    Dim sret As String
    Dim iret As Long
    Dim table() As String
    Dim tablev As Variant
    Dim stable As String
    Dim tabletype() As String
    Dim i As Integer
    
    Set ui = New CWebDWUI
    
    ui.sqlca.opertype = 3       '3代表得到数据表列表
    ui.sqlca.beginPos = 0
    ui.sqlca.readNum = 1000
    
    sret = ui.sqlca.ExecuteSelect(iret)
    
    If iret = -1 Then
        MsgBox sret, , "Error"
        Exit Sub
    End If
    
    '利用检索到的数据表名称填充List1
    If Right(sret, 2) = "OK" Then
        sret = Left(sret, Len(sret) - 2)
    End If
    table = Split(sret, "" & Chr(13) & Chr(10))
    i = 0
    For Each tablev In table
        
        '跳过第一行,第一行返回的是标题，无效
        If i = 0 Then
            GoTo continueNext
        End If
        
        stable = tablev
        tabletype = Split(stable, "" & Chr(9))
        
        If UBound(tabletype) = 1 Then
            List1.AddItem tabletype(0)
        End If
continueNext:
        i = i + 1
    Next
    
    ChangeTitleLang '修改界面的标题语言
    
End Sub

Private Sub List1_Click()
    Dim stablename As String
    Dim cols(1000) As String
    Dim colNum As Integer
    Dim i As Integer
    Dim iret As Long
    Dim sret As String
    Dim column() As String
    Dim columnv As Variant
    Dim sColumn As String
    
    
    If List1.ListIndex < 0 Then
        Exit Sub
    End If
    
    '得到数据表名称
    stablename = List1.List(List1.ListIndex)
    
    
    '检索表定义的列列表
    ui.sqlca.opertype = 4       '4代表检索列定义
    ui.sqlca.beginPos = 0
    ui.sqlca.readNum = 1000
    ui.sqlca.command = stablename
    
    sret = ui.sqlca.ExecuteSelect(iret)
    
    If iret = -1 Then
        MsgBox sret, , "Error"
        Exit Sub
    End If
    
    '刷新List2
    List2.Clear

    '利用检索到的数据表名称填充List1
    If Right(sret, 2) = "OK" Then
        sret = Left(sret, Len(sret) - 2)
    End If
    
    column = Split(sret, "" & Chr(13) & Chr(10))
    i = 0
    For Each columnv In column
        '跳过第一行，代表标题
        If i = 0 Then
            GoTo continueNext
        End If
        
        sColumn = columnv
        If sColumn > "" Then
            List2.AddItem sColumn
        End If
        
continueNext:
        i = i + 1
    Next

End Sub

'改变界面上的各个标题显示
Private Function ChangeTitleLang() As Long
    Dim strinfo As String
    
    '窗口标题
    strinfo = langsupport.SumAllLang("step3:Quick Select", _
                                    "step3:Quick Select")
    Me.Caption = langsupport.GetCurrent(strinfo)
    
    '全选按钮
    strinfo = langsupport.SumAllLang("全选", "Select All")
    CommandSelectAll.Caption = langsupport.GetCurrent(strinfo)
    
    '下一步按钮
    strinfo = langsupport.SumAllLang("下一步", "Next")
    CommandNext.Caption = langsupport.GetCurrent(strinfo)
    
    '取消按钮
    strinfo = langsupport.SumAllLang("取消", "Cacel")
    CommandCancel.Caption = langsupport.GetCurrent(strinfo)
    
    'label1
    strinfo = langsupport.SumAllLang("1.单击数据表名来选择和取消选定", _
                        "1.Click table name to select and deselect")
    Label1.Caption = langsupport.GetCurrent(strinfo)
    
    'label2
    strinfo = langsupport.SumAllLang("2.选择一列或者多列", _
                        "2.Select one column or multi columns")
    Label2.Caption = langsupport.GetCurrent(strinfo)
    
    'label3
    strinfo = langsupport.SumAllLang("3.选择排序和选择条件", _
                        "3. Choice sort and filter condition.")
    Label3.Caption = langsupport.GetCurrent(strinfo)
    
    '列列表
    strinfo = langsupport.SumAllLang("列列表", "List of Columns")
    Label4.Caption = langsupport.GetCurrent(strinfo)
    
    
End Function


