VERSION 5.00
Begin VB.Form FormMain 
   Caption         =   "WebDW1.0������"
   ClientHeight    =   6570
   ClientLeft      =   3210
   ClientTop       =   2700
   ClientWidth     =   12165
   LinkTopic       =   "Form1"
   ScaleHeight     =   6570
   ScaleWidth      =   12165
   Begin VB.Menu menuFile 
      Caption         =   "�ļ�[&F]"
      Begin VB.Menu menuFileNew 
         Caption         =   "�½�DW[&N]"
      End
      Begin VB.Menu menuFileOpen 
         Caption         =   "��DW[&O]"
         Visible         =   0   'False
      End
      Begin VB.Menu menuFileSave 
         Caption         =   "����DW[&S]"
         Visible         =   0   'False
      End
      Begin VB.Menu menuFileSep1 
         Caption         =   "-"
      End
      Begin VB.Menu menuFileExit 
         Caption         =   "�˳�[&E]"
      End
   End
   Begin VB.Menu menuDatabase 
      Caption         =   "������[&S]"
      Begin VB.Menu menuDatabaseConnection 
         Caption         =   "��������[&C]"
      End
   End
   Begin VB.Menu menuUIInterpreterTest 
      Caption         =   "�������������[&U]"
   End
   Begin VB.Menu menuSQLTest 
      Caption         =   "���ݿ���ʲ��� [&D]"
   End
   Begin VB.Menu menuTransactionTest 
      Caption         =   "�������[&S]"
   End
   Begin VB.Menu menuHelp 
      Caption         =   "����[&H]"
      Begin VB.Menu menuHelpContent 
         Caption         =   "Ŀ¼[&C]"
         Visible         =   0   'False
      End
      Begin VB.Menu menuHelpAbout 
         Caption         =   "����[&A]"
      End
   End
End
Attribute VB_Name = "FormMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem CopyRight Mr.Liu Junsong 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit

Dim langsupport As New CMultiLang   '������֧�ֶ���������������ʾת��

Private Sub Form_Load()
    '���˴��ھ�����ʾ
    Dim screenx As Single
    Dim screeny As Single
    screenx = Screen.width
    screeny = Screen.height
    
    Me.top = (screeny - Me.height) / 2
    Me.Left = (screenx - Me.width) / 2
    
    '������֧�ֹ�������20090201
    'Ĭ������������
    ChangeMenuLang
    
    Dim strinfo As String
    strinfo = SumAllLang("WebDW0.2������", "WebDW Version0.2")
    Me.Caption = langsupport.GetCurrent(strinfo)
End Sub

Private Sub Form_Unload(Cancel As Integer)
    End
End Sub

'���ݿ��������ò˵�
'�������ݿ��������ô���
'������ɵ����ݿ������ַ����������ڱ����ļ���
Private Sub menuDatabaseConnection_Click()
    FormDatabaseConnect.Show vbModal
End Sub

'�˳��˵����ر�Ӧ�ó���
Private Sub menuFileExit_Click()
    End
End Sub

'�½�DW�˵�
Private Sub menuFileNew_Click()
'    MsgBox "��ʹ��PowerBuilder������������ݴ��ڶ���"
    Unload FormChoiceDWStyle1
    FormChoiceDWStyle1.Show vbModal
End Sub

Private Sub menuFileOpen_Click()
    Dim strinfo As String
    strinfo = SumAllLang("��δ�ṩ", "Sorry,not avialabel now")
    MsgBox langsupport.GetCurrent(strinfo), , "WebDW"
End Sub

Private Sub menuFileSave_Click()
    Dim strinfo As String
    strinfo = SumAllLang("��δ�ṩ", "Sorry,not avialabel now")
    MsgBox langsupport.GetCurrent(strinfo), , "WebDW"
End Sub

Private Sub menuHelpAbout_Click()
    frmAbout.Show vbModal
End Sub

Private Sub menuHelpContent_Click()
    Dim strinfo As String
    strinfo = SumAllLang("��δ�ṩ", "Sorry,not avialabel now")
    MsgBox langsupport.GetCurrent(strinfo), , "WebDW"
End Sub

Private Sub menuSQLTest_Click()
    FormWebDWSQLTest.Show
End Sub

Private Sub menuTransactionTest_Click()
    FormDWTransactionTest.Show
End Sub

Private Sub menuUIInterpreterTest_Click()
'��webdw�û�������������Դ���
    FormWebDWUITest.Show
End Sub

'��������ַ�������ָ�����������ϣ��õ����ʵ��ַ���
'spinfo ����������Ϣ
'eninfo Ӣ����Ϣ
Private Function SumAllLang(spinfo As String, eninfo As String) As String
        
    SumAllLang = langsupport.SumAllLang(spinfo, eninfo)
End Function


'����ȫ�ֱ��������ԵĶ��壬�޸ĵ�ǰ����Ĳ˵�������ʾ����
Private Function ChangeMenuLang() As Long
    Dim strinfo As String
    
    '-------------------�ļ��˵����ֵĶ���----------------------
    strinfo = SumAllLang("�ļ�[&F]", "&File")
    menuFile.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = SumAllLang("�½�DW[&N]", "&New DW")
    menuFileNew.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = SumAllLang("��DW[&O]", "&Open DW")
    menuFileOpen.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = SumAllLang("����DW[&S]", "&Save DW")
    menuFileSave.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = SumAllLang("�˳�[&E]", "&Exit")
    menuFileExit.Caption = langsupport.GetCurrent(strinfo)
    
    '-------------------���ݿⲿ�ֵĶ���-------------------------
    strinfo = SumAllLang("������[&D]", "&Server")
    menuDatabase.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = SumAllLang("��������[&C]", "&Config")
    menuDatabaseConnection.Caption = langsupport.GetCurrent(strinfo)
    
    '-------------------�������������----------------------------
    strinfo = SumAllLang("�������������[&U]", "&UI Interpreter")
    menuUIInterpreterTest.Caption = langsupport.GetCurrent(strinfo)
    
    '-------------------���ݿ���ʲ���----------------------------
    strinfo = SumAllLang("���ݿ���ʲ���[&A]", "DB &Access")
    menuSQLTest.Caption = langsupport.GetCurrent(strinfo)
    
    '-------------------�������----------------------------------
    strinfo = SumAllLang("�������[&T]", "&Transaction")
    menuTransactionTest.Caption = langsupport.GetCurrent(strinfo)
    
    '-------------------����--------------------------------------
    strinfo = SumAllLang("����[&H]", "&Help")
    menuHelp.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = SumAllLang("Ŀ¼[&C]", "&Content")
    menuHelpContent.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = SumAllLang("����[&A]", "&About")
    menuHelpAbout.Caption = langsupport.GetCurrent(strinfo)
End Function

