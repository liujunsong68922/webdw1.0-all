VERSION 5.00
Begin VB.Form FormWebDWUITest 
   Caption         =   "测试窗口"
   ClientHeight    =   9270
   ClientLeft      =   2130
   ClientTop       =   1515
   ClientWidth     =   9855
   LinkTopic       =   "Form1"
   ScaleHeight     =   9270
   ScaleWidth      =   9855
   Begin VB.CommandButton cmdSort 
      Caption         =   "排序"
      Height          =   375
      Left            =   6960
      TabIndex        =   26
      Top             =   960
      Width           =   1215
   End
   Begin VB.CommandButton cmdGetSort 
      Caption         =   "读排序条件"
      Height          =   375
      Left            =   5400
      TabIndex        =   25
      Top             =   960
      Width           =   1335
   End
   Begin VB.CommandButton cmdSetSort 
      Caption         =   "排序设置"
      Height          =   375
      Left            =   3840
      TabIndex        =   24
      Top             =   960
      Width           =   1215
   End
   Begin VB.Timer Timer1 
      Interval        =   100
      Left            =   2880
      Top             =   600
   End
   Begin VB.CommandButton cmdInsertRow 
      Caption         =   "插入"
      Height          =   375
      Left            =   5400
      TabIndex        =   19
      Top             =   480
      Width           =   1335
   End
   Begin VB.CommandButton cmdRowCount 
      Caption         =   "计数"
      Height          =   375
      Left            =   3840
      TabIndex        =   18
      Top             =   480
      Width           =   1215
   End
   Begin VB.CommandButton cmdUpdate 
      Caption         =   "保存"
      Height          =   375
      Left            =   8400
      TabIndex        =   17
      Top             =   0
      Width           =   1335
   End
   Begin VB.CommandButton cmdDelete 
      Caption         =   "删除"
      Height          =   375
      Left            =   6960
      TabIndex        =   16
      Top             =   0
      Width           =   1215
   End
   Begin VB.Frame Frame3 
      Caption         =   "显示比例"
      Height          =   615
      Left            =   120
      TabIndex        =   14
      Top             =   480
      Width           =   2655
      Begin VB.TextBox TextConvertRate 
         Height          =   405
         Left            =   1320
         TabIndex        =   15
         Text            =   "4.1"
         Top             =   120
         Width           =   1095
      End
   End
   Begin VB.CommandButton cmdSetDataObject 
      Caption         =   "设置数据窗口"
      Height          =   375
      Left            =   3840
      TabIndex        =   12
      Top             =   0
      Width           =   1215
   End
   Begin VB.CommandButton CommandR2 
      Caption         =   "检索数据"
      Height          =   375
      Left            =   5400
      TabIndex        =   11
      Top             =   0
      Width           =   1335
   End
   Begin VB.CommandButton CommandMax 
      Caption         =   "最大化"
      Height          =   375
      Left            =   8400
      TabIndex        =   10
      Top             =   480
      Width           =   1335
   End
   Begin VB.PictureBox Picture1 
      Height          =   5775
      Left            =   120
      ScaleHeight     =   5715
      ScaleWidth      =   9555
      TabIndex        =   3
      Top             =   3360
      Width           =   9615
      Begin VB.VScrollBar Picture2_VScroll_Page 
         Height          =   5295
         Left            =   9120
         Max             =   0
         TabIndex        =   13
         Top             =   0
         Width           =   255
      End
      Begin VB.HScrollBar Picture2_HScroll_Page 
         Height          =   375
         LargeChange     =   2
         Left            =   0
         Max             =   0
         TabIndex        =   9
         Top             =   5280
         Width           =   9255
      End
      Begin VB.VScrollBar Picture2_VScroll_Line 
         Height          =   5295
         LargeChange     =   10
         Left            =   9360
         Max             =   0
         TabIndex        =   5
         Top             =   -120
         Width           =   255
      End
      Begin VB.PictureBox Picture2 
         AutoRedraw      =   -1  'True
         Height          =   5175
         Left            =   0
         ScaleHeight     =   5115
         ScaleWidth      =   8955
         TabIndex        =   4
         Top             =   0
         Width           =   9015
         Begin VB.HScrollBar PictureChild_HScroll_Page 
            Height          =   255
            Left            =   3840
            TabIndex        =   22
            Top             =   4200
            Width           =   4215
         End
         Begin VB.VScrollBar PictureChild_VScroll_Line 
            Height          =   3015
            Left            =   8040
            TabIndex        =   21
            Top             =   1200
            Width           =   255
         End
         Begin VB.PictureBox PictureChild 
            Height          =   3015
            Left            =   3840
            ScaleHeight     =   2955
            ScaleWidth      =   4155
            TabIndex        =   20
            Top             =   1200
            Width           =   4215
            Begin VB.VScrollBar PictureChild_VScroll_Page 
               Height          =   2535
               Left            =   3840
               TabIndex        =   23
               Top             =   360
               Width           =   255
            End
            Begin VB.Image PictChild_ImageClose 
               Height          =   285
               Left            =   3840
               Picture         =   "FormWebDWUIInterpreterTest.frx":0000
               Stretch         =   -1  'True
               Top             =   0
               Width           =   285
            End
            Begin VB.Image PictureChild_ImagePoint 
               Height          =   225
               Left            =   0
               Picture         =   "FormWebDWUIInterpreterTest.frx":0582
               Top             =   0
               Width           =   9630
            End
         End
         Begin VB.Line LineAuto 
            BorderWidth     =   3
            X1              =   1800
            X2              =   1800
            Y1              =   960
            Y2              =   2400
         End
         Begin VB.Image Picture2_ImagePoint 
            Height          =   225
            Left            =   0
            Picture         =   "FormWebDWUIInterpreterTest.frx":2F80
            Top             =   0
            Width           =   9630
         End
      End
   End
   Begin VB.CommandButton CommandShow 
      Caption         =   "界面显示"
      Height          =   375
      Left            =   6960
      TabIndex        =   2
      Top             =   480
      Width           =   1215
   End
   Begin VB.Frame Frame1 
      Caption         =   "WebDW界面描述:"
      Height          =   1575
      Left            =   120
      TabIndex        =   0
      Top             =   1680
      Width           =   4455
      Begin VB.TextBox Text1 
         Height          =   1215
         Left            =   120
         MultiLine       =   -1  'True
         ScrollBars      =   3  'Both
         TabIndex        =   1
         Text            =   "FormWebDWUIInterpreterTest.frx":597E
         Top             =   240
         Width           =   4215
      End
   End
   Begin VB.Frame Frame2 
      Caption         =   "显示数据"
      Height          =   1575
      Left            =   4800
      TabIndex        =   7
      Top             =   1680
      Width           =   4935
      Begin VB.TextBox Text2 
         Height          =   1215
         Left            =   120
         MultiLine       =   -1  'True
         ScrollBars      =   3  'Both
         TabIndex        =   8
         Text            =   "FormWebDWUIInterpreterTest.frx":789D
         Top             =   240
         Width           =   4695
      End
   End
   Begin VB.Label LabelInfo 
      Caption         =   "LabelInfo"
      Height          =   375
      Left            =   120
      TabIndex        =   6
      Top             =   120
      Width           =   3495
   End
   Begin VB.Menu menuSelectDW 
      Caption         =   "选择测试数据窗口"
   End
End
Attribute VB_Name = "FormWebDWUITest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @版权所有 刘峻松 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit
Public ui As CWebDWUI                              'ui是一个总的接口，所有的功能都通过ui来进行调用
Public errString As String                      '错误信息
Dim currentControlName As String                '存储当前的控件名称
Dim langsupport As New CMultiLang               '多语言支持的功能


Private Sub cmdDelete_Click()
    '删除当前行的调用功能测试
    Dim strinfo As String
    Dim irow As Long        '当前行定义
    irow = ui.DW_GetRow    '得到当前行，当前行为0代表没有当前行
    
    If irow = -1 Then       '错误判断和显示
        strinfo = langsupport.SumAllLang("得到当前行错误", "GetRow Error")
        MsgBox ui.errString, vbExclamation, langsupport.GetCurrent(strinfo)
        Exit Sub
    End If
    
    Dim iret As Long
    If irow > 0 Then
        iret = ui.DW_DeleteRow(irow)
        If iret = -1 Then
            strinfo = langsupport.SumAllLang("删除错误", "DeleteRow Error")
            MsgBox ui.errString, vbExclamation, langsupport.GetCurrent(strinfo)
        End If
    End If
    
End Sub

Private Sub cmdGetSort_Click()
    MsgBox ui.DW_GetSort()
End Sub

Private Sub cmdInsertRow_Click()
'插入功能的测试
    Dim strinfo As String
    Dim iret As Long
    iret = ui.DW_InsertRow(0)
    
    If iret = -1 Then
        strinfo = langsupport.SumAllLang("插入行错误", "InsertRow Error:")
        MsgBox ui.errString, vbExclamation, langsupport.GetCurrent(strinfo)
    End If

End Sub

Private Sub cmdRowCount_Click()
    'RowCount()函数的测试代码
    Dim iret As Long
    Dim strinfo As String
    iret = ui.DW_RowCount
    
    If iret = -1 Then
        strinfo = langsupport.SumAllLang("计数错误", "RowCount Error")
        MsgBox ui.errString, vbExclamation, langsupport.GetCurrent(strinfo)
    Else
        strinfo = langsupport.SumAllLang("计数成功", "RowCount")
        MsgBox iret, , langsupport.GetCurrent(strinfo)
    End If
End Sub

Private Sub cmdSetDataObject_Click()
    Dim strinfo As String
    '设置数据窗口对象的测试功能
    Dim iret As Long
    iret = ui.DW_SetDataObject(FormWebDWUITest.Controls, Picture2, Text1.text)
    
    If iret = -1 Then   '返回-1代表发生错误
        strinfo = langsupport.SumAllLang("调用SetDataObject发生错误:", "Call SetDataObject Error:")
        MsgBox ui.errString, vbExclamation, langsupport.GetCurrent(strinfo)
    Else
        MsgBox "OK"
    End If

End Sub

Private Sub cmdSetSort_Click()
    ui.DW_SetSort ("#1 A")
End Sub

Private Sub cmdSort_Click()
    Dim iret As Long
    iret = ui.DW_Sort
    
    If iret = -1 Then
        MsgBox ui.errString, vbExclamation, "sort error"
        Exit Sub
    End If
    
    ui.DrawDW   '刷新界面
End Sub

Private Sub cmdUpdate_Click()
    'Update方法的测试按钮
    Dim strinfo As String
    Dim strUpdate As String
    Dim iret As Long
    strUpdate = ui.DW_GetSQLPreview(iret)
    
    If iret = -1 Then
        strinfo = langsupport.SumAllLang("得到Update语句错误", "GetSQLPreview Error:")
        MsgBox ui.errString, vbExclamation, langsupport.GetCurrent(strinfo)
        Exit Sub
    Else
        strinfo = langsupport.SumAllLang("返回Update语句:", "GetSQLPreview return:")
        MsgBox strUpdate, , langsupport.GetCurrent(strinfo)
    End If
    
    If strUpdate = "" Then
        Exit Sub
    End If
    
    If Len(strUpdate) > 1500 Then
        strinfo = langsupport.SumAllLang("Update语句太长", "Update SQL too large")
        MsgBox langsupport.GetCurrent(strinfo), vbExclamation
        Exit Sub
    End If
    iret = ui.DW_Update     '调用更新方法
    
    If iret = -1 Then
        strinfo = langsupport.SumAllLang("保存错误", "Update Error:")
        MsgBox ui.errString, vbExclamation, langsupport.GetCurrent(strinfo)
    Else
        strinfo = langsupport.SumAllLang("保存成功", "Update")
        MsgBox "OK", , langsupport.GetCurrent(strinfo)
    End If
    
End Sub


Private Sub CommandMax_Click()
    Picture1.top = CommandMax.top + CommandMax.height + 200
    Picture1.Left = 0
    Picture1.width = FormWebDWUITest.width - 400
    Picture1.height = FormWebDWUITest.height - Picture1.top - 700
    
    Picture2.Left = 0
    Picture2.top = 0
    Picture2.height = Picture1.height - 300
    Picture2.width = Picture1.width - 2 * Picture2_VScroll_Line.width
        
    Picture2_VScroll_Line.height = Picture1.height - 300
    Picture2_VScroll_Line.Left = Picture1.width - Picture2_VScroll_Line.width
    
    Picture2_VScroll_Page.height = Picture1.height - 300
    Picture2_VScroll_Page.Left = Picture1.width - Picture2_VScroll_Line.width _
                                - Picture2_VScroll_Page.width
    
    Picture2_HScroll_Page.top = Picture1.height - 300
    Picture2_HScroll_Page.width = Picture1.width - 300
    
End Sub

Private Sub CommandR2_Click()
    Dim strinfo As String
    '检索功能的测试按钮
    Dim iret As Long
    iret = ui.DW_Retrieve()     '现在只需要传入检索参数就可以了
    
    If iret = -1 Then   '返回-1代表检索错误
        strinfo = langsupport.SumAllLang("检索出错", "Retrieve Error")
        MsgBox ui.errString, vbExclamation, langsupport.GetCurrent(strinfo)
    End If
End Sub


Private Sub CommandShow_Click()
    '显示数据的功能测试按钮
     ui.DW_SetDataObject FormWebDWUITest.Controls, Picture2, Text1.text
     ui.SetData Text2.text, "new"
     ui.DrawDW
    
End Sub

Private Sub Form_Load()
    '将此窗口居中显示
    Dim screenx As Single
    Dim screeny As Single
    screenx = Screen.width
    screeny = Screen.height
    
    Me.top = (screeny - Me.height) / 2
    Me.Left = (screenx - Me.width) / 2
    
    Set ui = New CWebDWUI                           '设置UI解释器对象
    
    '关闭子数据窗口的显示
    PictureChild.Visible = False
    PictureChild_VScroll_Line.Visible = False
    PictureChild_HScroll_Page.Visible = False
    
    '根据语言选择，修改界面显示
    ChangeTitleLang
     
    LineAuto.Visible = False        '设置竖向移动线为不可见
End Sub

'横向滚动条变化，重新绘图
Private Sub HScroll_Page_Change()
    ui.DrawDW
End Sub


Private Sub Image2_Click()
    
End Sub

Private Sub menu_d_dddw_depart_Click()
    '设置Text1的文本是常量窗口的d_dddw_depart
    Text1.text = FormDWConst.Text_d_dddw_depart.text
    
End Sub

Private Sub menu_d_employee_list_Click()
    '设置Text1的文本是常量窗口的d_employee_list
    Text1.text = FormDWConst.Text_d_employee_list.text
End Sub

Private Sub menu_d_employee_list2_Click()
    Text1.text = FormDWConst.Text_d_employee_list2.text
End Sub

Private Sub menu_d_product_freedom_Click()
    '设置text1的文本是常量窗口的d_product_freedom
    Text1.text = FormDWConst.Text_d_products_freedom.text
End Sub

Private Sub menu_d_product_list_Click()
    Text1.text = FormDWConst.Text_d_products_listform.text
End Sub

Private Sub menuSelectDW_Click()
    FormDWSelect.Show vbModal
End Sub

Private Sub PictChild_ImageClose_Click()
    '在关闭图片上单击，关闭子数据窗口
    PictureChild.Visible = False
    PictureChild_VScroll_Line.Visible = False
    PictureChild_HScroll_Page.Visible = False
    
    Dim obj As Control
    Set obj = GF_GetObjectByName(FormWebDWUITest.Controls, PictureChild.tag)
    If Not obj Is Nothing Then
        obj.SetFocus
    End If
End Sub

Private Sub Picture2_HScroll_Page_Change()
    ui.DrawDW
End Sub

Private Sub Picture2_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    ui.Picture_MouseDown Button, Shift, X, Y
End Sub

'鼠标移动，显示当前坐标
Private Sub Picture2_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    LabelInfo.Caption = "MouseMove X,Y: " & X & " , " & Y
        
    ui.Picture_MouseMove Button, Shift, X, Y
   
End Sub

Private Sub Picture2_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    ui.Picture_MouseUp Button, Shift, X, Y
End Sub

Private Sub Picture2_VScroll_Line_Change()
    '重画数据窗口
    ui.DrawDW
End Sub

Private Sub PictureChild_HScroll_Page_Change()
    '重画子窗口
    ui.DrawChildDW
End Sub

Private Sub PictureChild_VScroll_Line_Change()
    '重画子窗口
    ui.DrawChildDW
End Sub

'双击，将文本框清空
Private Sub Text1_DblClick()
    Text1.text = ""
End Sub



'利用这个Timer事件，间隔检查当前活动控件是否是动态创建的
'如果是设置当前控件名称，以及当前控件的事件处理程序
Private Sub Timer1_Timer()
    Dim sname As String
    Dim control1 As Control
    Dim strinfo As String
    
    Set control1 = FormWebDWUITest.ActiveControl
    
    If control1 Is Nothing Then
        currentControlName = ""
        Exit Sub
    End If
    
    sname = control1.Name
    strinfo = langsupport.SumAllLang("当前控件:", "Current Control:")
    'LabelInfo.Caption = langsupport.GetCurrent(strinfo) & sname
    
    '判断当前控件是否是动态创建出来的，判断依据:名为Picture2_
    If InStr(1, sname, "Picture2_") > 0 And sname <> currentControlName Then
        If TypeOf control1 Is TextBox Then      '当前控件是文本框
            ui.SetTextBox control1
            'ui.myTextBox_GotFocus
            currentControlName = sname
        ElseIf TypeOf control1 Is OptionButton Then '当前控件是一个单选框按钮
            ui.SetOptionButton control1
            currentControlName = sname
        ElseIf TypeOf control1 Is checkbox Then     '当前控件是一个复选框按钮
            ui.SetCheckBox control1
            currentControlName = sname
        ElseIf TypeOf control1 Is combobox Then     '当前控件是一个下拉框
            ui.SetComboBox control1
            currentControlName = sname
        End If
        
    ElseIf InStr(1, sname, "PictureChild_") > 0 And sname <> currentControlName Then
        If TypeOf control1 Is TextBox Then  '当前控件是文本框
            ui.SetChildTextBox control1
            currentControlName = sname
        End If
    Else
        currentControlName = ""
    End If
    
End Sub

'竖向滚动条变化，绘图
Private Sub VScroll_Line_Change()
    ui.DrawDW
End Sub

'根据全局变量中语言的定义，修改当前界面的菜单具体显示内容
Private Function ChangeTitleLang() As Long
    Dim strinfo As String
    
    '窗口标题
    strinfo = langsupport.SumAllLang("WebDW UI功能测试", "WebDW UI Test")
    Me.Caption = langsupport.GetCurrent(strinfo)
    
    '菜单标题
    strinfo = langsupport.SumAllLang("选择测试数据窗口...", "&Choice a DataWindow...")
    menuSelectDW.Caption = langsupport.GetCurrent(strinfo)
    
    'frame
    strinfo = langsupport.SumAllLang("WebDW界面描述:", "WebDW UI Desc:")
    Frame1.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("WebDW显示数据:", "WebDW Show Data:")
    Frame2.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("显示比例设定", "Convert Rate:")
    Frame3.Caption = langsupport.GetCurrent(strinfo)
    
    '按钮显示
    strinfo = langsupport.SumAllLang("设置数据窗口对象", "SetDataObject")
    cmdSetDataObject.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("检索数据", "Retrieve")
    CommandR2.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("删除", "DeleteRow")
    cmdDelete.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("保存", "Update")
    cmdUpdate.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("计数", "RowCount")
    cmdRowCount.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("插入", "InsertRow")
    cmdInsertRow.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("数据填充", "Fill Data")
    CommandShow.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("最大化", "Maxinum")
    CommandMax.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("设置排序条件", "SetSort")
    cmdSetSort.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("读取排序条件", "GetSort")
    cmdGetSort.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("排序", "Sort")
    cmdSort.Caption = langsupport.GetCurrent(strinfo)
    
End Function

Public Function SetDWName(dwname As String) As Long
    Dim iret As Long
    iret = ui.DW_SetDataObjectByName(Me.Controls, Picture2, dwname)
   
    If iret = -1 Then
        errString = ui.errString
    End If
End Function
