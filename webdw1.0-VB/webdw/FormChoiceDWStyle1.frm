VERSION 5.00
Begin VB.Form FormChoiceDWStyle1 
   Caption         =   "step1:请选择DW的风格"
   ClientHeight    =   3240
   ClientLeft      =   5370
   ClientTop       =   3765
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3240
   ScaleWidth      =   4680
   Begin VB.CommandButton CommandCancel 
      Caption         =   "取 消"
      Height          =   375
      Left            =   2400
      TabIndex        =   2
      Top             =   2760
      Width           =   1215
   End
   Begin VB.CommandButton CommandNext 
      Caption         =   "下一步"
      Height          =   375
      Left            =   840
      TabIndex        =   1
      Top             =   2760
      Width           =   1095
   End
   Begin VB.PictureBox ImageList1 
      BackColor       =   &H80000005&
      Height          =   480
      Left            =   480
      ScaleHeight     =   420
      ScaleWidth      =   1140
      TabIndex        =   4
      Top             =   4320
      Width           =   1200
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
      Height          =   255
      Left            =   360
      TabIndex        =   3
      Top             =   2400
      Width           =   3975
   End
   Begin VB.Image Image2 
      Height          =   525
      Left            =   2520
      Picture         =   "FormChoiceDWStyle1.frx":0000
      Top             =   4320
      Width           =   660
   End
   Begin VB.Image Image1 
      Height          =   555
      Left            =   1680
      Picture         =   "FormChoiceDWStyle1.frx":124E
      Top             =   4320
      Width           =   705
   End
End
Attribute VB_Name = "FormChoiceDWStyle1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private selectType As Integer
Private langsupport As New CMultiLang   '多语言支持功能

'取消按钮,关闭窗口
Private Sub CommandCancel_Click()
    FormChoiceDWStyle1.Hide
End Sub

Private Sub CommandNext_Click()
'判断Listview1的当前选择项，如果没有选择，则不进行到下一步
    'MsgBox "selectType=" & selectType
    'If selectType = 0 Then
    '    MsgBox "请选择合适的数据窗口展示风格!"
    '    Exit Sub
    'End If
    
    selectType = 2
    
    If selectType = 1 Then FormDSQuickSelect3.sDWtype = "freedom"
    If selectType = 2 Then FormDSQuickSelect3.sDWtype = "grid"
    
    FormChoiceDWStyle1.Hide
    FormChoiceDataSource2.Show vbModal
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

    Dim obj As Object
'    ListView1.Icons = ImageList1
    
    Dim strinfo As String
'    strinfo = langsupport.SumAllLang("Freedom自由式", "Freedom")
'    Set obj = ListView1.ListItems.Add(, , langsupport.GetCurrent(strinfo), 1)
'    strinfo = langsupport.SumAllLang("Grid 网格式", "Grid")
'    Set obj = ListView1.ListItems.Add(, , langsupport.GetCurrent(strinfo), 2)

'    selectType = 1 '默认选择Freedom格式
'    strinfo = langsupport.SumAllLang("Freedom自由式", "Freedom")
'    ListView1.SelectedItem = langsupport.GetCurrent(strinfo)
    
    ChangeTitleLang
End Sub

'Private Sub ListView1_ItemClick(ByVal item As MSComctlLib.ListItem)
'    selectType = item.Index '设置selectType
'End Sub

'改变界面上的各个标题显示
Private Function ChangeTitleLang() As Long
    Dim strinfo As String
    
    '窗口标题
    strinfo = langsupport.SumAllLang("step1:请选择DW的显示风格", "step1:Select DW Style")
    Me.Caption = langsupport.GetCurrent(strinfo)
    
    '下一步按钮
    strinfo = langsupport.SumAllLang("下一步", "Next")
    CommandNext.Caption = langsupport.GetCurrent(strinfo)
    
    '取消按钮
    strinfo = langsupport.SumAllLang("取消", "Cacel")
    CommandCancel.Caption = langsupport.GetCurrent(strinfo)
End Function

