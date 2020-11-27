VERSION 5.00
Begin VB.Form FormDatabaseConnect 
   Caption         =   "�������������ò���"
   ClientHeight    =   2355
   ClientLeft      =   4590
   ClientTop       =   4155
   ClientWidth     =   6480
   LinkTopic       =   "Form1"
   ScaleHeight     =   2355
   ScaleWidth      =   6480
   Begin VB.CommandButton CommandCancel 
      Caption         =   "ȡ  ��"
      Height          =   375
      Left            =   4560
      TabIndex        =   4
      Top             =   1800
      Width           =   1575
   End
   Begin VB.CommandButton CommandOK 
      Caption         =   "ȷ  ��"
      Height          =   375
      Left            =   2400
      TabIndex        =   3
      Top             =   1800
      Width           =   1695
   End
   Begin VB.CommandButton commandConnectTest 
      Caption         =   "���Ӳ���"
      Height          =   375
      Left            =   360
      TabIndex        =   2
      Top             =   1800
      Width           =   1575
   End
   Begin VB.Frame Frame1 
      Caption         =   "���������������URL��"
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
Dim langsupport As New CMultiLang   '������֧��


Private Sub CommandCancel_Click()
    '����������������������Ҫ���ڴ���ж��
    FormDatabaseConnect.Hide
End Sub

Private Sub commandConnectTest_Click()
    Dim server As New CWebDWTransaction
    Dim strRet As String
    Dim iret As Long
    
    server.opertype = 1                     '����ѯ����
    server.command = "select 1 from dual"   '��ͼ����dual��
    G_ServerURL = TextConnect.text          '����G_ServerURL
    server.beginPos = 0
    server.readNum = 1
    
    strRet = server.ExecuteSelect(iret)
    
    Dim strinfo As String
    If iret = -1 Then
        strinfo = langsupport.SumAllLang("����ʧ��", "Connect Failed")
        MsgBox server.errString, , langsupport.GetCurrent(strinfo)
    Else
        If Right(strRet, 2) = "OK" Then
            strinfo = langsupport.SumAllLang("���ӳɹ�!", "Connect Success")
            MsgBox langsupport.GetCurrent(strinfo), , "WebDW"
        Else
            MsgBox strRet, vbExclamation, "Connect Failed"
        End If
    End If
End Sub

Private Sub CommandOK_Click()
    '���ù��ñ�������ֵ�������ط���ʹ�ô˹��ñ���
    G_ServerURL = TextConnect.text
    FormDatabaseConnect.Hide
    
End Sub

Private Sub Form_Load()
    '���˴��ھ�����ʾ
    Dim screenx As Single
    Dim screeny As Single
    screenx = Screen.width
    screeny = Screen.height
    
    Me.top = (screeny - Me.height) / 2
    Me.Left = (screenx - Me.width) / 2

    '��ʾȫ�ֵ�URL����
    TextConnect.text = G_ServerURL
    
    '�޸Ľ������
    ChangeTitleLang
End Sub


'�ı�����ϵĸ���������ʾ
Private Function ChangeTitleLang() As Long
    Dim strinfo As String
    
    '���ڱ���
    strinfo = langsupport.SumAllLang("��̨���ݿ��������ò���", _
                                    "Testing background Server Connection.")
    Me.Caption = langsupport.GetCurrent(strinfo)

    'frame
    strinfo = langsupport.SumAllLang("���������������URL:", _
                                    "Please input the Server URL")
    Frame1.Caption = langsupport.GetCurrent(strinfo)
    
    '���Ӳ���
    strinfo = langsupport.SumAllLang("���Ӳ���", "Test Connection")
    commandConnectTest.Caption = langsupport.GetCurrent(strinfo)
    
    'ȷ�ϰ�ť
    strinfo = langsupport.SumAllLang("ȷ ��", "OK")
    CommandOK.Caption = langsupport.GetCurrent(strinfo)
    
    'ȡ����ť
    strinfo = langsupport.SumAllLang("ȡ ��", "Cancel")
    CommandCancel.Caption = langsupport.GetCurrent(strinfo)
End Function
