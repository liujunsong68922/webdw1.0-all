VERSION 5.00
Begin VB.Form FormDWTransactionTest 
   Caption         =   "事务对象功能测试"
   ClientHeight    =   3600
   ClientLeft      =   3450
   ClientTop       =   2355
   ClientWidth     =   8925
   LinkTopic       =   "Form1"
   ScaleHeight     =   3600
   ScaleWidth      =   8925
   Begin VB.CommandButton cmdRollback 
      Caption         =   "Rollback"
      Height          =   495
      Left            =   6960
      TabIndex        =   7
      Top             =   2760
      Width           =   1575
   End
   Begin VB.Frame Frame2 
      Caption         =   "当前事务编号:"
      Height          =   615
      Left            =   360
      TabIndex        =   5
      Top             =   2040
      Width           =   8175
      Begin VB.Label Label1 
         Caption         =   "Label1"
         Height          =   255
         Left            =   2760
         TabIndex        =   6
         Top             =   240
         Width           =   1815
      End
   End
   Begin VB.CommandButton cmdCommit 
      Caption         =   "Commit"
      Height          =   495
      Left            =   4680
      TabIndex        =   4
      Top             =   2760
      Width           =   1935
   End
   Begin VB.CommandButton cmdAdd 
      Caption         =   "AddCommand"
      Height          =   495
      Left            =   2520
      TabIndex        =   3
      Top             =   2760
      Width           =   1815
   End
   Begin VB.CommandButton cmdStart 
      Caption         =   "BeginTransaction"
      Height          =   495
      Left            =   360
      TabIndex        =   2
      Top             =   2760
      Width           =   1695
   End
   Begin VB.Frame Frame1 
      Caption         =   "加入到事务中的SQL命令"
      Height          =   1695
      Left            =   360
      TabIndex        =   0
      Top             =   240
      Width           =   8175
      Begin VB.TextBox Text1 
         Height          =   1335
         Left            =   120
         TabIndex        =   1
         Text            =   "Text1"
         Top             =   240
         Width           =   7815
      End
   End
End
Attribute VB_Name = "FormDWTransactionTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim sqlca As New CWebDWTransaction      '事务处理对象
Dim langsupport As New CMultiLang       '多语言支持

Private Sub cmdAdd_Click()
    Dim strinfo As String
    If sqlca.transId = "" Then
        strinfo = langsupport.SumAllLang("请先启动事务", "Please call BeginTranaction Frist")
        MsgBox langsupport.GetCurrent(strinfo)
        Exit Sub
    End If
    
    Dim iret As Long
    sqlca.opertype = "addcommand"
    sqlca.command = Text1.text
    sqlca.AddCommand iret
    
    If iret = -1 Then
        strinfo = langsupport.SumAllLang("添加命令失败", "Add Failed")
        MsgBox sqlca.errString, , langsupport.GetCurrent(strinfo)
    Else
        MsgBox "OK"
    End If
End Sub

Private Sub cmdCommit_Click()
    Dim strinfo As String
    If sqlca.transId = "" Then
        strinfo = langsupport.SumAllLang("请先启动事务", "Please call BeginTranaction Frist")
        MsgBox langsupport.GetCurrent(strinfo)
        Exit Sub
    End If

    Dim iret As Long
    sqlca.opertype = "commit"
    sqlca.command = ""
    sqlca.Commit iret
    
    If iret = -1 Then
        strinfo = langsupport.SumAllLang("提交事务失败", "Commit Failed")
        MsgBox sqlca.errString, , langsupport.GetCurrent(strinfo)
    Else
        MsgBox "OK"
        sqlca.transId = ""  '事务已经提交，不可再访问
    End If
    
    Label1.Caption = sqlca.transId
    
End Sub

Private Sub cmdRollback_Click()
    Dim strinfo As String
    If sqlca.transId = "" Then
        strinfo = langsupport.SumAllLang("请先启动事务", "Please call BeginTranaction Frist")
        MsgBox langsupport.GetCurrent(strinfo)
        Exit Sub
    End If

    Dim iret As Long
    sqlca.opertype = "rollback"
    sqlca.command = ""
    sqlca.Commit iret
    
    If iret = -1 Then
        strinfo = langsupport.SumAllLang("提交事务失败", "Commit Failed")
        MsgBox sqlca.errString, , langsupport.GetCurrent(strinfo)
    Else
        MsgBox "OK"
        sqlca.transId = ""  '事务已经提交，不可再访问
    End If
    
    Label1.Caption = sqlca.transId

End Sub

Private Sub cmdStart_Click()
    sqlca.opertype = "begintrans"
    
    Dim iret As Long
    Dim sData As String
    Dim strinfo As String
    sData = sqlca.BeginTransaction(iret)
    
    If iret = -1 Then
        strinfo = langsupport.SumAllLang("事务错误:", "Transaction Error")
        MsgBox sqlca.errString, , langsupport.GetCurrent(strinfo)
    Else
        strinfo = langsupport.SumAllLang("返回事务号:", "Return TransId:")
        MsgBox sData, , langsupport.GetCurrent(strinfo)
    End If
    
    Label1.Caption = sqlca.transId
End Sub

Private Sub Form_Load()
    '将此窗口居中显示
    Dim screenx As Single
    Dim screeny As Single
    screenx = Screen.width
    screeny = Screen.height
    
    Me.top = (screeny - Me.height) / 2
    Me.Left = (screenx - Me.width) / 2

    ChangeTitleLang '修改标题显示
End Sub

'改变界面上的各个标题显示
Private Function ChangeTitleLang() As Long
    Dim strinfo As String
    
    '窗口标题
    strinfo = langsupport.SumAllLang("后台事务功能测试", _
                                    "Testing background transaction support")
    Me.Caption = langsupport.GetCurrent(strinfo)
    
    'frame1
    strinfo = langsupport.SumAllLang("要加入到事务中的SQL命令", _
                                    "Enter the command adding to transaction here:")
    Frame1.Caption = langsupport.GetCurrent(strinfo)
    
    'frame2
    strinfo = langsupport.SumAllLang("当前事务编号:", "current transaction Id:")
    Frame2.Caption = langsupport.GetCurrent(strinfo)
    
    '开始事务按钮
    strinfo = langsupport.SumAllLang("开始事务", "Begin Transaction")
    cmdStart.Caption = langsupport.GetCurrent(strinfo)
    
    'addcommand按钮
    strinfo = langsupport.SumAllLang("添加命令", "Add Command")
    cmdAdd.Caption = langsupport.GetCurrent(strinfo)
    
    'commit按钮
    strinfo = langsupport.SumAllLang("提交事务", "Commit")
    cmdCommit.Caption = langsupport.GetCurrent(strinfo)
    
    'rollback按钮
    strinfo = langsupport.SumAllLang("回滚事务", "Rollback")
    cmdRollback.Caption = langsupport.GetCurrent(strinfo)
    
End Function

