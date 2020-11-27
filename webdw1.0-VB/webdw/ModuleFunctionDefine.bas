Attribute VB_Name = "Module2FunctionDefine"
Rem 全局性的方法定义模块
Rem 为了简化类的层次和结构，将全局性的方法转移到这个模块里面来
Option Explicit

'从一个targetControls容器中，根据给定控件名称来检索控件
'如果控件不存在，则返回Nothing
'这一方法原来在CWebDWUI_ParentDW中
'现在提取成为公用方法
'之所以要自己写一个这个方法的原因，是避免出现运行时错误提示
'以及考虑到控件名称大小写敏感转换的问题
Public Function GF_GetObjectByName(targetControls As Variant, objName As String) As Control
    Dim obj As Control
    Dim vobj As Variant
    
    Set obj = Nothing
    
    If targetControls Is Nothing Then
        Set GF_GetObjectByName = Nothing
        Exit Function
    End If
    
    For Each vobj In targetControls
        If UCase(vobj.Name) = UCase(objName) Then
            Set obj = vobj
            Exit For
        End If
    Next
    
    Set GF_GetObjectByName = obj

End Function

Rem -------------------------------------------------
Rem WebDW的颜色转换功能
Rem PB中的定义的颜色代码，和VB中定义的颜色代码有所差异
Rem 所以需要定义一个转换方法来进行显示的转换
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @版权所有 刘峻松 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------



'功能描述：输入一个PB定义的颜色，可能是系统颜色，也可能不是系统颜色
'如果是系统颜色，就逐一进行转换(这个转换是基于调色板定义的)
'如果不是系统颜色，就直接返回
'判断是否是系统颜色，看它的值是否小于255 * 256 * 256 + 255 * 256 + 255
'如果没有符合条件的判断命中，那么返回一个默认值
'pbColor    :输入的PB颜色值
'defColor   :输入的默认颜色值
Public Function GF_GetVBColor(pbColor As Long, defColor As Long) As Long
    Dim iret As Long
    Const SYSCOLOR = 16777215                       '最大颜色值,256 * 256 * 256 - 1

    If pbColor <= SYSCOLOR Then
        GF_GetVBColor = pbColor
        Exit Function
    End If
    
    iret = defColor                         '设置默认颜色
    If pbColor = 1090519039 Then iret = vbWindowBackground    '如果是windows默认背景色
    If pbColor = 276856960 Then iret = vbApplicationWorkspace ' 如果是应用工作区默认背景色
    If pbColor = 81324524 Then iret = vbButtonFace            ' 如果是按钮表色
    If pbColor = 33554592 Then iret = vbWindowText            'window文本默认颜色
    
    '下面是几种固定定义的颜色转换
    If pbColor = 536870912 Then iret = RGB(255, 255, 255)     '白色
    
    GF_GetVBColor = iret
End Function

'功能描述：给定一个控件集合，从中检索，以得到控件指定的缩放比例
'返回缩放比例
'增加这个函数的目的是为了在调用时不再传递缩放比例
'要正确使用缩放比例，要求界面上有一个名为TextConvertRate的文本框对象
'如果这一对象采用其他形式也可以，但名称必须为"TextConvertRate"
'如果界面上没有这一元素，则默认为4
Public Function GF_GetConvertRate(targetControls As Variant) As Double
    Dim convertRate As Double
    Dim TextConvertRate As Control
    
    Set TextConvertRate = GF_GetObjectByName(targetControls, "TextConvertRate")
    If TextConvertRate Is Nothing Then
        GF_GetConvertRate = 4
        Exit Function
    End If
    
    convertRate = TextConvertRate.text  '获取设置值
    If convertRate <= 1 Or convertRate >= 10 Then
        convertRate = 4
    End If
    
    GF_GetConvertRate = convertRate
End Function

'输入一个字符串语法定义,检索得到对应的数据，并返回这个数据
'如果发生任何错误，则返回一个空字符串
'这个方法在cwebdwUI_ParentDW.retrieveChildDW中被调用
Public Function GF_RetrieveBySyntax(dwSyntax As String) As String
    Dim iret As Long
    Dim temp_webdw As New CWebDW
    Dim temp_sqlca As New CWebDWTransaction
    Dim str_retrieve As String
    Dim sdata As String
    
    If temp_webdw.Create(dwSyntax) = -1 Then     '解析失败，返回空字符串
        GF_RetrieveBySyntax = ""
        Exit Function
    End If
    
    str_retrieve = temp_webdw.GetRetrieveSQL()  '得到检索用的SQL语句
    
    If str_retrieve = "" Then
        GF_RetrieveBySyntax = ""
        Exit Function
    End If
    
    temp_sqlca.opertype = 1
    temp_sqlca.beginPos = 0
    temp_sqlca.readNum = 1000
    temp_sqlca.command = str_retrieve
    sdata = temp_sqlca.ExecuteSelect(iret)      '执行sql,得到数据结果
    
    If iret = -1 Then
        GF_RetrieveBySyntax = ""
        Exit Function
    End If
    
    GF_RetrieveBySyntax = sdata                    '返回数据
        
End Function

'输入一个字符串，计算这个字符串存储需要用到的数据库长度
'默认后台数据库的存储采用GBK或者类似的编码方式
'对于ASCII码，占一位，对于非标准ASCII码，占两位
'这一方法在后台数据库的编码方式发生改变时可能需要重写
Public Function GF_GetDBlength(sdata As String) As Long
    Dim i As Long
    Dim ilen As Long
    Dim stemp As String
    ilen = 0
    For i = 1 To Len(sdata)
        stemp = Mid(sdata, i, 1)
        If Asc(stemp) < 128 And Asc(stemp) > 0 Then
            ilen = ilen + 1
        Else
            ilen = ilen + 2
        End If
    Next
    GF_GetDBlength = ilen
End Function

'一个通用的函数，相当于C语言中的if(,,)函数
'第一个参数是一个逻辑判断
'如果是真，返回第二个参数
'如果是假，返回第三个参数
Public Function GF_IF(ifClause As Boolean, YesValue As String, NoValue As String) As String
    If ifClause Then
        GF_IF = YesValue
    Else
        GF_IF = NoValue
    End If
End Function

'一个通用的函数，相当于C语言中的if(,,)函数
'第一个参数是一个逻辑判断
'如果是真，返回第二个参数
'如果是假，返回第三个参数
Public Function GF_IF_Long(ifClause As Boolean, YesValue As Long, NoValue As Long) As Long
    If ifClause Then
        GF_IF_Long = YesValue
    Else
        GF_IF_Long = NoValue
    End If
End Function


