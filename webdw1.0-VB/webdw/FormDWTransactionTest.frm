VERSION 5.00
Begin VB.Form FormDWTransactionTest 
   Caption         =   "��������ܲ���"
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
      Caption         =   "��ǰ������:"
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
      Caption         =   "���뵽�����е�SQL����"
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

Dim sqlca As New CWebDWTransaction      '���������
Dim langsupport As New CMultiLang       '������֧��

Private Sub cmdAdd_Click()
    Dim strinfo As String
    If sqlca.transId = "" Then
        strinfo = langsupport.SumAllLang("������������", "Please call BeginTranaction Frist")
        MsgBox langsupport.GetCurrent(strinfo)
        Exit Sub
    End If
    
    Dim iret As Long
    sqlca.opertype = "addcommand"
    sqlca.command = Text1.text
    sqlca.AddCommand iret
    
    If iret = -1 Then
        strinfo = langsupport.SumAllLang("�������ʧ��", "Add Failed")
        MsgBox sqlca.errString, , langsupport.GetCurrent(strinfo)
    Else
        MsgBox "OK"
    End If
End Sub

Private Sub cmdCommit_Click()
    Dim strinfo As String
    If sqlca.transId = "" Then
        strinfo = langsupport.SumAllLang("������������", "Please call BeginTranaction Frist")
        MsgBox langsupport.GetCurrent(strinfo)
        Exit Sub
    End If

    Dim iret As Long
    sqlca.opertype = "commit"
    sqlca.command = ""
    sqlca.Commit iret
    
    If iret = -1 Then
        strinfo = langsupport.SumAllLang("�ύ����ʧ��", "Commit Failed")
        MsgBox sqlca.errString, , langsupport.GetCurrent(strinfo)
    Else
        MsgBox "OK"
        sqlca.transId = ""  '�����Ѿ��ύ�������ٷ���
    End If
    
    Label1.Caption = sqlca.transId
    
End Sub

Private Sub cmdRollback_Click()
    Dim strinfo As String
    If sqlca.transId = "" Then
        strinfo = langsupport.SumAllLang("������������", "Please call BeginTranaction Frist")
        MsgBox langsupport.GetCurrent(strinfo)
        Exit Sub
    End If

    Dim iret As Long
    sqlca.opertype = "rollback"
    sqlca.command = ""
    sqlca.Commit iret
    
    If iret = -1 Then
        strinfo = langsupport.SumAllLang("�ύ����ʧ��", "Commit Failed")
        MsgBox sqlca.errString, , langsupport.GetCurrent(strinfo)
    Else
        MsgBox "OK"
        sqlca.transId = ""  '�����Ѿ��ύ�������ٷ���
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
        strinfo = langsupport.SumAllLang("�������:", "Transaction Error")
        MsgBox sqlca.errString, , langsupport.GetCurrent(strinfo)
    Else
        strinfo = langsupport.SumAllLang("���������:", "Return TransId:")
        MsgBox sData, , langsupport.GetCurrent(strinfo)
    End If
    
    Label1.Caption = sqlca.transId
End Sub

Private Sub Form_Load()
    '���˴��ھ�����ʾ
    Dim screenx As Single
    Dim screeny As Single
    screenx = Screen.width
    screeny = Screen.height
    
    Me.top = (screeny - Me.height) / 2
    Me.Left = (screenx - Me.width) / 2

    ChangeTitleLang '�޸ı�����ʾ
End Sub

'�ı�����ϵĸ���������ʾ
Private Function ChangeTitleLang() As Long
    Dim strinfo As String
    
    '���ڱ���
    strinfo = langsupport.SumAllLang("��̨�����ܲ���", _
                                    "Testing background transaction support")
    Me.Caption = langsupport.GetCurrent(strinfo)
    
    'frame1
    strinfo = langsupport.SumAllLang("Ҫ���뵽�����е�SQL����", _
                                    "Enter the command adding to transaction here:")
    Frame1.Caption = langsupport.GetCurrent(strinfo)
    
    'frame2
    strinfo = langsupport.SumAllLang("��ǰ������:", "current transaction Id:")
    Frame2.Caption = langsupport.GetCurrent(strinfo)
    
    '��ʼ����ť
    strinfo = langsupport.SumAllLang("��ʼ����", "Begin Transaction")
    cmdStart.Caption = langsupport.GetCurrent(strinfo)
    
    'addcommand��ť
    strinfo = langsupport.SumAllLang("�������", "Add Command")
    cmdAdd.Caption = langsupport.GetCurrent(strinfo)
    
    'commit��ť
    strinfo = langsupport.SumAllLang("�ύ����", "Commit")
    cmdCommit.Caption = langsupport.GetCurrent(strinfo)
    
    'rollback��ť
    strinfo = langsupport.SumAllLang("�ع�����", "Rollback")
    cmdRollback.Caption = langsupport.GetCurrent(strinfo)
    
End Function

