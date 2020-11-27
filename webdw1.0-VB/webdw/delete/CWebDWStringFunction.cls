VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDWStringFunction"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW用户界面解析器所用到的各种字符串处理功能
Rem 主要功能：解析字符串，从中获取数据，以及拼装字符串
Rem 这个类已经废弃掉，功能迁移到CWebDW中去了。废弃日期:2008-12-17
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @版权所有 刘峻松 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------
'对输入的字符串进行检查
'如果以"开头，以"结束,那么就删除掉前后的两个引号
'Private Function removeQuote(ByRef strIn As String)
'    Dim ilen As Long
'    ilen = Len(strIn)
'
'    If strIn = "" Then Exit Function
'    If Left(strIn, 1) = """" And Right(strIn, 1) = """" Then
'        strIn = Mid(strIn, 2, ilen - 2)
'    End If
'End Function


'从inString字符串中，根据元素的名称，得到这个元素的整体描述字符串
'查找的算法是：
'从原始字符串中开始查找，找到eleName，它的后面应该跟随一个(，标志这个元素的开始
'元素中可能嵌套定义内部元素，因此需要对找到的()进行计数
'返回的字符串，不再包括()
'查找的算法受限于webdw的具体表示，目前采用和PB7一致的表示方法
'按照初步设计，webdw应该可以支持PB7导出的DW的正常显示功能
'或者说，webdw和PB7是兼容的。
'inString 总的字符串
'eleName 元素名称
'beginPos 开始检索位置
'Public Function getElementDesc(inString As String, eleName As String, beginPos As Long, ByRef findPos As Long) As String
'    Dim iBeg As Long
'    Dim leftPos As Long
'    Dim iflag As Long
'
'    Dim i As Long
'    Dim s As String
'
'    findPos = 0                                         '初始化findPos的值，如果不改变，返回的就是0
'
'    iBeg = InStr(beginPos, inString, eleName)
'    If iBeg <= 0 Then
'        getElementDesc = "": Exit Function              '返回空字符串代表没有找到这个元素
'    End If
'
'    leftPos = InStr(iBeg, inString, "(")                '得到左面括号的位置
'    If leftPos <= 0 Then
'        getElementDesc = "": Exit Function              '返回空字符串代表没有找到这个元素
'    End If
'
'    iflag = 0                                           '每找到一个(，iflag++,找到一个) iflag --
'    For i = leftPos + 1 To Len(inString)
'        s = Mid(inString, i, 1)                         '取当前字符串
'
'        If (s = "(" Or s = ")") _
'            And Mid(inString, i - 1, 1) = "~" Then      '如果是()，需要判断上个字符是否是~,如果是不操作
'            GoTo ContinueNext
'        End If
        
        
'        If s = "(" Then
'            iflag = iflag + 1
'            GoTo ContinueNext                           '继续进行循环
'        End If
'
'        If s = ")" Then                                 '当前值为)时需要判断iflag的值
'            If iflag = 0 Then                           'iflag=0，可以结束循环
'                getElementDesc = Mid(inString, leftPos, i - leftPos + 1)
'                findPos = leftPos                       '找到的位置是leftPos
'                Exit Function
'            Else
'                iflag = iflag - 1                       '否则将iflag减去1
'            End If
'        End If
'ContinueNext:
'    Next i
'
'    getElementDesc = ""
'End Function

'从元素表示的字符串里面，用括号包括起来的
'取出指定的属性的实际属性值
'如果找不到，则返回一个空字符串
'retFlag是一个标志字符串，返回0代表找到了，返回-1代表没有这个指定名称的参数
'eleString 只读
'paraName 只读（大小写敏感）
'begPos   开始查找点
'retFlag  输出参数0代表成功结束-1代表失败
'Public Function getElementProp(eleString As String, paraName As String, begPos As Long, ByRef retFlag As Long) As String
'    Dim iBeg As Long
'    Dim iEnd As Long
'    Dim ipos As Long
'    Dim i As Long
'    Dim iflag As Long
'   Dim s As String
'    Dim svalue As String
'
'    retFlag = -1
'    ipos = InStr(begPos, eleString, paraName & "=")     '找到属性名称的开始点
'    If ipos <= 0 Then                                   '找不到，退出
'        getElementProp = ""
'        Exit Function
'    End If
'
'    iBeg = ipos + Len(paraName & "=")                   'iBeg代表值的开始点
'    iflag = 0
'    For i = iBeg To Len(eleString)
'        s = Mid(eleString, i, 1)
'
'        If s = """" Then                                '如果当前字符串是引号，那么设置标志
'            If iflag = 0 Then
'                iflag = 1
'            Else
'                iflag = 0
'            End If
'            GoTo ContinueNext
'        End If
'
'        If s = " " Then                                 '如果s是空格，需要根据iFlag来判断
'            If iflag = 0 Then                           '如果不在字符串内，那么就退出
'                svalue = Mid(eleString, iBeg, i - iBeg)
'                removeQuote svalue             '去掉开头和结尾的引号
'                getElementProp = svalue
'                retFlag = 0                             '标志成功结束
'                Exit Function                           '退出此功能
'            End If
'        End If
'
'ContinueNext:
'    Next i
'
'    getElementProp = ""
'End Function

'功能描述：将输入的字符串切分成包含多个实际元素的array对象
'只获取其中的指定类型对象
'Public Function getAllElement(dwString As String, eletype As String) As Collection
'    Dim myarray As New Collection
'    Dim stext As String
'    Dim ipos As Long
'
'    '分解dwString，将其中的元素取出，描述放入myarray中去
'
'    stext = getElementDesc(dwString, eletype & "(", 1, ipos)
'    While ipos > 0
'        myarray.Add stext                              '容器内加入sText
'        stext = getElementDesc(dwString, eletype & "(", ipos + 1, ipos)
'    Wend
'
'    Set getAllElement = myarray
'End Function

'获得某个指定元素的指定属性，如果有多个，只返回第一个
'stext要查找的字符串
'eleName 元素名称
'paraName 参数名称
'iflag 查找标志,0失败 其他找到的位置
'Public Function getElementParam2(stext As String, eleName As String, paraName As String, ByRef iflag As Long) As String
'    iflag = 0
'    getElementParam2 = ""
'
'    Dim sElement As String
'    Dim ipos As Long
'    Dim svalue As String
'
'    sElement = getElementDesc(stext, eleName, 1, ipos)
'    If ipos = 0 Then
'        Exit Function
'    End If
'
'    svalue = getElementProp(sElement, paraName, 1, iflag)
'    If iflag = -1 Then
'        getElementParam2 = ""
'    Else
'        removeQuote svalue                          '去掉引号
'        iflag = 1
'        getElementParam2 = svalue                   '返回字符串
'    End If
'End Function

'从一个字符串里面，构建出text的属性对象出来
'输入 sText代表一个原文件中的text对象
'输出 webDW_text结构，表示它的属性值
'输出结果暂时存放在g_webdw_text对象中
'Public Function getTextProp(stext As String) As Long
'    Dim iret As Long
'    g_webdw_text.band = getElementProp(stext, "band", 1, iret)
'    g_webdw_text.alignment = getElementProp(stext, "alignment", 1, iret)
'    g_webdw_text.text = getElementProp(stext, "text", 1, iret)
'    g_webdw_text.border = getElementProp(stext, "border", 1, iret)
'    g_webdw_text.color = getElementProp(stext, "color", 1, iret)
'    g_webdw_text.x = getElementProp(stext, "x", 1, iret)
'    g_webdw_text.y = getElementProp(stext, "y", 1, iret)
'    g_webdw_text.height = getElementProp(stext, "height", 1, iret)
'    g_webdw_text.width = getElementProp(stext, "width", 1, iret)
'    g_webdw_text.name = getElementProp(stext, "name", 1, iret)
'    g_webdw_text.font_face = getElementProp(stext, "font.face", 1, iret)
'    g_webdw_text.font_height = getElementProp(stext, "font.height", 1, iret)
'    g_webdw_text.font_weight = getElementProp(stext, "font.weight", 1, iret)
'    g_webdw_text.font_family = getElementProp(stext, "font.family", 1, iret)
'    g_webdw_text.font_pitch = getElementProp(stext, "font.pitch", 1, iret)
'    g_webdw_text.font_charset = getElementProp(stext, "font.charset", 1, iret)
'    g_webdw_text.background_mode = getElementProp(stext, "background.mode", 1, iret)
'    g_webdw_text.background_color = getElementProp(stext, "background.color", 1, iret)
'
'    getTextProp = 0
'End Function

'Public Function getColumnProp(scolumn As String) As Long
'    Dim iret As Long
'    Dim i As Long
'    Dim stemp As String
'    g_webdw_column.band = getElementProp(scolumn, "band", 1, iret)
'    g_webdw_column.alignment = getElementProp(scolumn, "alignment", 1, iret)
'    g_webdw_column.tabsequence = getElementProp(scolumn, "tabsequence", 1, iret)
'    g_webdw_column.border = getElementProp(scolumn, "border", 1, iret)
'    g_webdw_column.color = getElementProp(scolumn, "color", 1, iret)
'
'    g_webdw_column.x = getElementProp(scolumn, "x", 1, iret)
'    g_webdw_column.y = getElementProp(scolumn, "y", 1, iret)
'    g_webdw_column.height = getElementProp(scolumn, "height", 1, iret)
'    g_webdw_column.width = getElementProp(scolumn, "width", 1, iret)
'    g_webdw_column.format = getElementProp(scolumn, "format", 1, iret)
'    g_webdw_column.name = getElementProp(scolumn, "name", 1, iret)
'    g_webdw_column.tag = getElementProp(scolumn, "tag", 1, iret)
'
'    '下面是编辑风格支持
'    stemp = getElementProp(scolumn, "edit.limit", 1, iret)
'    If iret = 0 Then
'        g_webdw_column.edit_limit = stemp
'    Else
'        g_webdw_column.edit_limit = 0
'    End If
'    g_webdw_column.edit_case = getElementProp(scolumn, "edit.case", 1, iret)
'    g_webdw_column.edit_focusrectangle = getElementProp(scolumn, "edit.focusrectangle", 1, iret)
'    g_webdw_column.edit_autoselect = getElementProp(scolumn, "edit.autoselect", 1, iret)
'    g_webdw_column.edit_autohscroll = getElementProp(scolumn, "edit.autohscroll", 1, iret)
'
    '下面是字体支持
'    g_webdw_column.font_face = getElementProp(scolumn, "font.face", 1, iret)
'    g_webdw_column.font_height = getElementProp(scolumn, "font.height", 1, iret)
'    g_webdw_column.font_weight = getElementProp(scolumn, "font.weight", 1, iret)
'    g_webdw_column.font_family = getElementProp(scolumn, "font.family", 1, iret)
'    g_webdw_column.font_pitch = getElementProp(scolumn, "font.pitch", 1, iret)
'    g_webdw_column.font_charset = getElementProp(scolumn, "font.charset", 1, iret)
    
'    '下面是background支持
'    g_webdw_column.background_mode = getElementProp(scolumn, "background.mode", 1, iret)
'    g_webdw_column.background_color = getElementProp(scolumn, "background.color", 1, iret)
'
'    getColumnProp = 0
'End Function
