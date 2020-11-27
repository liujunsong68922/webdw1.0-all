Attribute VB_Name = "Module0Start"
Rem -------------------------------------------------
Rem CopyRight Mr.Liu Junsong 2008-2009
Rem 这个模块仅包含从App启动的sub main函数，其他变量定义功能全部转移到
Rem ModualGlobalDefine之中去了
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit

'程序入口方法定义
'未来迁移到用户控件之时,这个模块就可以不被包含进去了
'这一入口仅用于使用应用程序之时
Public Sub Main()
    'step1 初始化所有的全局变量
    InitGlobalVariable
    
    'step2 启动语言选择窗口
    FormLanguageSelect.Show
End Sub

