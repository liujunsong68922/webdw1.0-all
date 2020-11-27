VERSION 5.00
Begin VB.Form FormDWDefineShow4 
   Caption         =   "自动生成的WebDW文件显示"
   ClientHeight    =   5265
   ClientLeft      =   5145
   ClientTop       =   3120
   ClientWidth     =   9585
   LinkTopic       =   "Form1"
   ScaleHeight     =   5265
   ScaleWidth      =   9585
   Begin VB.CommandButton CommandOK 
      Caption         =   "确定"
      Height          =   375
      Left            =   3960
      TabIndex        =   1
      Top             =   4800
      Width           =   2055
   End
   Begin VB.Frame Frame1 
      Caption         =   "生成的DW定义文件显示"
      Height          =   4575
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   9375
      Begin VB.TextBox Text1 
         Height          =   4215
         Left            =   120
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   2
         Top             =   240
         Width           =   9135
      End
   End
End
Attribute VB_Name = "FormDWDefineShow4"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'这个窗口用来最后显示一下自动生成的DW文件的内容
'DW文件的编辑生成功能暂时不作为系统的功能重点
'还是鼓励用户使用PowerBuilder进行文件的编写编辑
'增加这个功能的目的是使整个应用联合起来成为一个整体

Option Explicit
Public showText As String           '要显示的text数值，由外部直接传入设置
Private langsupport As New CMultiLang   '多语言支持功能


Private Sub CommandOK_Click()
    FormDWDefineShow4.Hide
    
    FormWebDWUITest.Text1.text = showText
    FormWebDWUITest.Text2.text = ""
    FormWebDWUITest.Show
End Sub

Private Sub Form_Load()
    '将此窗口居中显示
    Dim screenx As Single
    Dim screeny As Single
    screenx = Screen.width
    screeny = Screen.height
    
    Me.top = (screeny - Me.height) / 2
    Me.Left = (screenx - Me.width) / 2
    
    Text1.text = showText
    
    ChangeTitleLang     '修改界面的显示
End Sub

'改变界面上的各个标题显示
Private Function ChangeTitleLang() As Long
    Dim strinfo As String
    
    '窗口标题
    strinfo = langsupport.SumAllLang("step4：自动生成的WebDW文件显示", _
                                    "step4: Display the generated WebDW File")
    Me.Caption = langsupport.GetCurrent(strinfo)
    
    'frame标题
    strinfo = langsupport.SumAllLang("生成的DW定义文件显示：", "DW File Content:")
    Frame1.Caption = langsupport.GetCurrent(strinfo)
    
    '确定按钮标题
    strinfo = langsupport.SumAllLang("确定", "OK")
    CommandOK.Caption = langsupport.GetCurrent(strinfo)
    
    
    
End Function

