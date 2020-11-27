Attribute VB_Name = "Module1GlobalDefine"
Rem -------------------------------------------------
Rem ModualGlobalDefine是一个全局变量的定义模块,
Rem 以及这些变量的初始化功能定义的模块
Rem CopyRight Mr.Liu Junsong 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit

Public G_ServerURL As String            'g_serverURL代表后台数据库访问连接
Public GG_empty_webdw As WebDWSyntax    'GG_empty_webdw是全局性的变量，表示空对象
Public G_Lang As String                 '全局性的语言显示选项

Public Type LangDef
    Lang_SimpleChinese As String        '简体中文定义
    Lang_English As String              '英文定义
    Lang_French As String               '法文定义
    Lang_Japanese As String             '日文定义
End Type

Public G_LangDef As LangDef             '定义全局常量，语言定义

Public Type EditMaskDataTypeDef
    EditMask_Date As Long
    EditMask_Time As Long
    EditMask_DateTime As Long
    EditMask_Decimal As Long
    EditMask_Numeric As Long
    EditMask_String As Long
End Type

Public G_EditMaskDataType As EditMaskDataTypeDef '定义全局的数据掩码数据类型

'功能描述：初始化系统用到的全局变量功能
Public Function InitGlobalVariable() As Long
    G_ServerURL = "http://localhost/myproj/Table" '设置默认连接
    
    '对全局语言常量赋值
    G_LangDef.Lang_English = "english"
    G_LangDef.Lang_French = "french"
    G_LangDef.Lang_Japanese = "japanese"
    G_LangDef.Lang_SimpleChinese = "simplechinese"
    
    G_Lang = G_LangDef.Lang_SimpleChinese   '默认为简体中文显示

    '对全局数据掩码所用的数据类型来赋值
    G_EditMaskDataType.EditMask_Date = 1
    G_EditMaskDataType.EditMask_Time = 2
    G_EditMaskDataType.EditMask_DateTime = 3
    G_EditMaskDataType.EditMask_Decimal = 4
    G_EditMaskDataType.EditMask_Numeric = 5
    G_EditMaskDataType.EditMask_String = 6
End Function

