VERSION 5.00
Begin VB.Form FormChoiceDataSource2 
   Caption         =   "step2:请选择数据源的类型"
   ClientHeight    =   3345
   ClientLeft      =   5175
   ClientTop       =   3960
   ClientWidth     =   4665
   LinkTopic       =   "Form1"
   ScaleHeight     =   3345
   ScaleWidth      =   4665
   Begin VB.PictureBox ImageList1 
      BackColor       =   &H80000005&
      Height          =   480
      Left            =   360
      ScaleHeight     =   420
      ScaleWidth      =   1140
      TabIndex        =   4
      Top             =   3360
      Width           =   1200
   End
   Begin VB.CommandButton CommandCancel 
      Caption         =   "取  消"
      Height          =   375
      Left            =   2640
      TabIndex        =   2
      Top             =   2760
      Width           =   1215
   End
   Begin VB.CommandButton commandNext 
      Caption         =   "下一步"
      Height          =   375
      Left            =   720
      TabIndex        =   1
      Top             =   2760
      Width           =   1215
   End
   Begin VB.PictureBox ListView1 
      BackColor       =   &H80000005&
      ForeColor       =   &H80000008&
      Height          =   2055
      Left            =   240
      ScaleHeight     =   1995
      ScaleWidth      =   4155
      TabIndex        =   0
      Top             =   240
      Width           =   4215
   End
   Begin VB.Label Label1 
      Caption         =   "说明：目前仅支持Quick Select类型的定义。"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   2400
      Width           =   4335
   End
   Begin VB.Image Image2 
      Height          =   540
      Left            =   2520
      Picture         =   "FormChoiceDataSource2.frx":0000
      Top             =   3360
      Width           =   645
   End
   Begin VB.Image Image1 
      Height          =   555
      Left            =   1320
      Picture         =   "FormChoiceDataSource2.frx":0A72
      Top             =   3360
      Width           =   735
   End
End
Attribute VB_Name = "FormChoiceDataSource2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim sqlType As Integer 'sql语句的类型
Private langsupport As New CMultiLang   '多语言支持功能


Private Sub CommandCancel_Click()
    FormChoiceDataSource2.Hide
End Sub

Private Sub CommandNext_Click()
'判断Listview1的当前选择项，如果没有选择，则不进行到下一步
    'MsgBox "sqlType=" & sqlType
    Dim strinfo As String
    
    
    'If sqlType = 0 Then
    '    strinfo = langsupport.SumAllLang("请选择合适的数据源类型!", _
    '                                "Please select right datasource type!")
    '    MsgBox langsupport.GetCurrent(strinfo)
    '    Exit Sub
    'End If
    sqlType = 1
    
    FormChoiceDataSource2.Hide
    '目前先不考虑其他类型，直接打开QuickSelect
    FormDSQuickSelect3.Show vbModal
End Sub

Private Sub Form_Load()
    '将此窗口居中显示
    Dim screenx As Single
    Dim screeny As Single
    screenx = Screen.width
    screeny = Screen.height
    
    Me.top = (screeny - Me.height) / 2
    Me.Left = (screenx - Me.width) / 2


    '先将图片加载ImageList1中去
    Dim imgx As Object
'    Set imgx = ImageList1.ListImages.Add(, , Image1.Picture)
'    Set imgx = ImageList1.ListImages.Add(, , Image2.Picture)

'    Dim obj As Object
'    ListView1.Icons = ImageList1
    'ListView1.SmallIcons = ImageList1
'    Set obj = ListView1.ListItems.Add(, , "Quick select", 1)
'    Set obj = ListView1.ListItems.Add(, , "SQL select", 2)

'    sqlType = 1 '默认选择quick select类型，其他类型暂不支持
    
'    ChangeTitleLang '修改标题的语言

End Sub

'Private Sub ListView1_ItemClick(ByVal item As MSComctlLib.ListItem)
    '设置sqlType
 '   sqlType = item.Index
'End Sub

'改变界面上的各个标题显示
Private Function ChangeTitleLang() As Long
    Dim strinfo As String
    
    '窗口标题
    strinfo = langsupport.SumAllLang("step2:请选择数据源的类型", _
                                    "step2:Select datasource")
    Me.Caption = langsupport.GetCurrent(strinfo)
    
    '下一步按钮
    strinfo = langsupport.SumAllLang("下一步", "Next")
    CommandNext.Caption = langsupport.GetCurrent(strinfo)
    
    '取消按钮
    strinfo = langsupport.SumAllLang("取消", "Cacel")
    CommandCancel.Caption = langsupport.GetCurrent(strinfo)
    
    '界面说明标题
    strinfo = langsupport.SumAllLang("说明：目前仅支持Quick Select类型的定义。", _
                        "Tip: current only Quick Select is supported.")
    Label1.Caption = langsupport.GetCurrent(strinfo)
End Function

