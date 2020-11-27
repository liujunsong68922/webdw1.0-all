VERSION 5.00
Begin VB.Form FormWebDWSQLTest 
   Caption         =   "WebDW数据库访问测试"
   ClientHeight    =   4965
   ClientLeft      =   3450
   ClientTop       =   2925
   ClientWidth     =   7560
   LinkTopic       =   "Form1"
   ScaleHeight     =   4965
   ScaleWidth      =   7560
   Begin VB.TextBox Text3 
      Height          =   375
      Left            =   2040
      TabIndex        =   6
      Text            =   "0"
      Top             =   1440
      Width           =   855
   End
   Begin VB.CommandButton CommandExecute 
      Caption         =   "执行"
      Height          =   375
      Left            =   3000
      TabIndex        =   3
      Top             =   1440
      Width           =   1815
   End
   Begin VB.Frame Frame2 
      Caption         =   "Select执行结果"
      Height          =   3015
      Left            =   240
      TabIndex        =   2
      Top             =   1800
      Width           =   7095
      Begin VB.TextBox Text2 
         Height          =   2655
         Left            =   120
         MultiLine       =   -1  'True
         ScrollBars      =   3  'Both
         TabIndex        =   4
         Text            =   "FormWebDWSQLTest.frx":0000
         Top             =   240
         Width           =   6855
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "请输入要执行的Select语句"
      Height          =   1215
      Left            =   240
      TabIndex        =   0
      Top             =   120
      Width           =   7095
      Begin VB.TextBox Text1 
         Height          =   855
         Left            =   120
         TabIndex        =   1
         Top             =   240
         Width           =   6855
      End
   End
   Begin VB.Label Label1 
      Caption         =   "开始点："
      Height          =   255
      Left            =   360
      TabIndex        =   5
      Top             =   1440
      Width           =   1695
   End
End
Attribute VB_Name = "FormWebDWSQLTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim webdwsql As New CWebDWTransaction
Dim langsupport As New CMultiLang       '多语言支持
Private Sub CommandExecute_Click()
    Dim sret As String
    Dim iret As Long
    
    webdwsql.opertype = 1
    webdwsql.command = Text1.text
    webdwsql.beginPos = Text3.text
    webdwsql.readNum = 100
    
    sret = webdwsql.ExecuteSelect(iret)
    
    If iret = -1 Then
        Text2.text = webdwsql.errString
    Else
        Text2.text = sret
    End If
End Sub

Private Sub Form_Load()
    '将此窗口居中显示
    Dim screenx As Single
    Dim screeny As Single
    screenx = Screen.width
    screeny = Screen.height
    
    Me.top = (screeny - Me.height) / 2
    Me.Left = (screenx - Me.width) / 2

    ChangeTitleLang '修改界面的语言显示
End Sub

'改变界面上的各个标题显示
Private Function ChangeTitleLang() As Long
    Dim strInfo As String
    
    '窗口标题
    strInfo = langsupport.SumAllLang("数据库访问测试", "Database Access Test")
    Me.Caption = langsupport.GetCurrent(strInfo)
    
    'frame1
    strInfo = langsupport.SumAllLang("请输入要执行的Select语句", _
                                    "Please input your Select here:")
    Frame1.Caption = langsupport.GetCurrent(strInfo)
    
    'label1
    strInfo = langsupport.SumAllLang("开始点", "Begin Position:")
    Label1.Caption = langsupport.GetCurrent(strInfo)
    
    '执行按钮
    strInfo = langsupport.SumAllLang("执 行", "execute")
    CommandExecute.Caption = langsupport.GetCurrent(strInfo)
    
    'frame2
    strInfo = langsupport.SumAllLang("Select 执行结果", "execute return:")
    Frame2.Caption = langsupport.GetCurrent(strInfo)
End Function


