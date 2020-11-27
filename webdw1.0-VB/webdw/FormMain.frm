VERSION 5.00
Begin VB.Form FormMain 
   Caption         =   "WebDW1.0主窗口"
   ClientHeight    =   6570
   ClientLeft      =   3210
   ClientTop       =   2700
   ClientWidth     =   12165
   LinkTopic       =   "Form1"
   ScaleHeight     =   6570
   ScaleWidth      =   12165
   Begin VB.Menu menuFile 
      Caption         =   "文件[&F]"
      Begin VB.Menu menuFileNew 
         Caption         =   "新建DW[&N]"
      End
      Begin VB.Menu menuFileOpen 
         Caption         =   "打开DW[&O]"
         Visible         =   0   'False
      End
      Begin VB.Menu menuFileSave 
         Caption         =   "保存DW[&S]"
         Visible         =   0   'False
      End
      Begin VB.Menu menuFileSep1 
         Caption         =   "-"
      End
      Begin VB.Menu menuFileExit 
         Caption         =   "退出[&E]"
      End
   End
   Begin VB.Menu menuDatabase 
      Caption         =   "服务器[&S]"
      Begin VB.Menu menuDatabaseConnection 
         Caption         =   "配置连接[&C]"
      End
   End
   Begin VB.Menu menuUIInterpreterTest 
      Caption         =   "界面解析器测试[&U]"
   End
   Begin VB.Menu menuSQLTest 
      Caption         =   "数据库访问测试 [&D]"
   End
   Begin VB.Menu menuTransactionTest 
      Caption         =   "事务测试[&S]"
   End
   Begin VB.Menu menuHelp 
      Caption         =   "帮助[&H]"
      Begin VB.Menu menuHelpContent 
         Caption         =   "目录[&C]"
         Visible         =   0   'False
      End
      Begin VB.Menu menuHelpAbout 
         Caption         =   "关于[&A]"
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

Dim langsupport As New CMultiLang   '多语言支持对象，用来做界面显示转换

Private Sub Form_Load()
    '将此窗口居中显示
    Dim screenx As Single
    Dim screeny As Single
    screenx = Screen.width
    screeny = Screen.height
    
    Me.top = (screeny - Me.height) / 2
    Me.Left = (screenx - Me.width) / 2
    
    '多语言支持功能增加20090201
    '默认语言是中文
    ChangeMenuLang
    
    Dim strinfo As String
    strinfo = SumAllLang("WebDW0.2主窗口", "WebDW Version0.2")
    Me.Caption = langsupport.GetCurrent(strinfo)
End Sub

Private Sub Form_Unload(Cancel As Integer)
    End
End Sub

'数据库连接配置菜单
'弹出数据库连接配置窗口
'配置完成的数据库连接字符串将保存在本地文件中
Private Sub menuDatabaseConnection_Click()
    FormDatabaseConnect.Show vbModal
End Sub

'退出菜单，关闭应用程序
Private Sub menuFileExit_Click()
    End
End Sub

'新建DW菜单
Private Sub menuFileNew_Click()
'    MsgBox "请使用PowerBuilder软件来创建数据窗口对象！"
    Unload FormChoiceDWStyle1
    FormChoiceDWStyle1.Show vbModal
End Sub

Private Sub menuFileOpen_Click()
    Dim strinfo As String
    strinfo = SumAllLang("暂未提供", "Sorry,not avialabel now")
    MsgBox langsupport.GetCurrent(strinfo), , "WebDW"
End Sub

Private Sub menuFileSave_Click()
    Dim strinfo As String
    strinfo = SumAllLang("暂未提供", "Sorry,not avialabel now")
    MsgBox langsupport.GetCurrent(strinfo), , "WebDW"
End Sub

Private Sub menuHelpAbout_Click()
    frmAbout.Show vbModal
End Sub

Private Sub menuHelpContent_Click()
    Dim strinfo As String
    strinfo = SumAllLang("暂未提供", "Sorry,not avialabel now")
    MsgBox langsupport.GetCurrent(strinfo), , "WebDW"
End Sub

Private Sub menuSQLTest_Click()
    FormWebDWSQLTest.Show
End Sub

Private Sub menuTransactionTest_Click()
    FormDWTransactionTest.Show
End Sub

Private Sub menuUIInterpreterTest_Click()
'打开webdw用户界面解析器测试窗口
    FormWebDWUITest.Show
End Sub

'将输入的字符串按照指定规则进行组合，得到合适的字符串
'spinfo 简体中文信息
'eninfo 英文信息
Private Function SumAllLang(spinfo As String, eninfo As String) As String
        
    SumAllLang = langsupport.SumAllLang(spinfo, eninfo)
End Function


'根据全局变量中语言的定义，修改当前界面的菜单具体显示内容
Private Function ChangeMenuLang() As Long
    Dim strinfo As String
    
    '-------------------文件菜单部分的定义----------------------
    strinfo = SumAllLang("文件[&F]", "&File")
    menuFile.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = SumAllLang("新建DW[&N]", "&New DW")
    menuFileNew.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = SumAllLang("打开DW[&O]", "&Open DW")
    menuFileOpen.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = SumAllLang("保存DW[&S]", "&Save DW")
    menuFileSave.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = SumAllLang("退出[&E]", "&Exit")
    menuFileExit.Caption = langsupport.GetCurrent(strinfo)
    
    '-------------------数据库部分的定义-------------------------
    strinfo = SumAllLang("服务器[&D]", "&Server")
    menuDatabase.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = SumAllLang("配置连接[&C]", "&Config")
    menuDatabaseConnection.Caption = langsupport.GetCurrent(strinfo)
    
    '-------------------界面解析器测试----------------------------
    strinfo = SumAllLang("界面解析器测试[&U]", "&UI Interpreter")
    menuUIInterpreterTest.Caption = langsupport.GetCurrent(strinfo)
    
    '-------------------数据库访问测试----------------------------
    strinfo = SumAllLang("数据库访问测试[&A]", "DB &Access")
    menuSQLTest.Caption = langsupport.GetCurrent(strinfo)
    
    '-------------------事务测试----------------------------------
    strinfo = SumAllLang("事务测试[&T]", "&Transaction")
    menuTransactionTest.Caption = langsupport.GetCurrent(strinfo)
    
    '-------------------帮助--------------------------------------
    strinfo = SumAllLang("帮助[&H]", "&Help")
    menuHelp.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = SumAllLang("目录[&C]", "&Content")
    menuHelpContent.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = SumAllLang("关于[&A]", "&About")
    menuHelpAbout.Caption = langsupport.GetCurrent(strinfo)
End Function

