VERSION 5.00
Begin VB.Form FormDatabaseConnect 
   Caption         =   "服务器连接配置测试"
   ClientHeight    =   2355
   ClientLeft      =   4590
   ClientTop       =   4155
   ClientWidth     =   6480
   LinkTopic       =   "Form1"
   ScaleHeight     =   2355
   ScaleWidth      =   6480
   Begin VB.CommandButton CommandCancel 
      Caption         =   "取  消"
      Height          =   375
      Left            =   4560
      TabIndex        =   4
      Top             =   1800
      Width           =   1575
   End
   Begin VB.CommandButton CommandOK 
      Caption         =   "确  认"
      Height          =   375
      Left            =   2400
      TabIndex        =   3
      Top             =   1800
      Width           =   1695
   End
   Begin VB.CommandButton commandConnectTest 
      Caption         =   "连接测试"
      Height          =   375
      Left            =   360
      TabIndex        =   2
      Top             =   1800
      Width           =   1575
   End
   Begin VB.Frame Frame1 
      Caption         =   "请输入服务器访问URL："
      Height          =   1335
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   6015
      Begin VB.TextBox TextConnect 
         Height          =   975
         Left            =   120
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   1
         Top             =   240
         Width           =   5775
      End
   End
End
Attribute VB_Name = "FormDatabaseConnect"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem CopyRight Mr.Liu Junsong 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit
Dim langsupport As New CMultiLang   '多语言支持


Private Sub CommandCancel_Click()
    '将父窗口隐藏起来，但不要从内存中卸载
    FormDatabaseConnect.Hide
End Sub

Private Sub commandConnectTest_Click()
    Dim server As New CWebDWTransaction
    Dim strRet As String
    Dim iret As Long
    
    server.opertype = 1                     '做查询操作
    server.command = "select 1 from dual"   '试图访问dual表
    G_ServerURL = TextConnect.text          '设置G_ServerURL
    server.beginPos = 0
    server.readNum = 1
    
    strRet = server.ExecuteSelect(iret)
    
    Dim strinfo As String
    If iret = -1 Then
        strinfo = langsupport.SumAllLang("连接失败", "Connect Failed")
        MsgBox server.errString, , langsupport.GetCurrent(strinfo)
    Else
        If Right(strRet, 2) = "OK" Then
            strinfo = langsupport.SumAllLang("连接成功!", "Connect Success")
            MsgBox langsupport.GetCurrent(strinfo), , "WebDW"
        Else
            MsgBox strRet, vbExclamation, "Connect Failed"
        End If
    End If
End Sub

Private Sub CommandOK_Click()
    '设置公用变量的数值，其他地方将使用此公用变量
    G_ServerURL = TextConnect.text
    FormDatabaseConnect.Hide
    
End Sub

Private Sub Form_Load()
    '将此窗口居中显示
    Dim screenx As Single
    Dim screeny As Single
    screenx = Screen.width
    screeny = Screen.height
    
    Me.top = (screeny - Me.height) / 2
    Me.Left = (screenx - Me.width) / 2

    '显示全局的URL定义
    TextConnect.text = G_ServerURL
    
    '修改界面标题
    ChangeTitleLang
End Sub


'改变界面上的各个标题显示
Private Function ChangeTitleLang() As Long
    Dim strinfo As String
    
    '窗口标题
    strinfo = langsupport.SumAllLang("后台数据库连接配置测试", _
                                    "Testing background Server Connection.")
    Me.Caption = langsupport.GetCurrent(strinfo)

    'frame
    strinfo = langsupport.SumAllLang("请输入服务器访问URL:", _
                                    "Please input the Server URL")
    Frame1.Caption = langsupport.GetCurrent(strinfo)
    
    '连接测试
    strinfo = langsupport.SumAllLang("连接测试", "Test Connection")
    commandConnectTest.Caption = langsupport.GetCurrent(strinfo)
    
    '确认按钮
    strinfo = langsupport.SumAllLang("确 定", "OK")
    CommandOK.Caption = langsupport.GetCurrent(strinfo)
    
    '取消按钮
    strinfo = langsupport.SumAllLang("取 消", "Cancel")
    CommandCancel.Caption = langsupport.GetCurrent(strinfo)
End Function
