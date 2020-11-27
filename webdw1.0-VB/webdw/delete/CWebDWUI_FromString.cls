VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDW_Create"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW的字符串解析功能
Rem 输入一个字符串,将这个字符串解析成一个WebDW结构
Rem 以后就可以直接访问WebDW结构,而不必再去访问字符串进行解析
Rem 这样字符串的解析只需要发生一次就可以了
Rem 这个类对外只提供一个公共方法convertDW，用一个字符串填充local_webdw
Rem 输出：local_webdw,errString
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @版权所有 刘峻松 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------
Option Explicit

Public dwString As String       '这个变量存储要解析的字符串,未来可用来比较,只读
Public errString As String      '解析失败以后的错误信息存储在这里

Private local_webdw As WebDWSyntax  'local_webdw现在是一个局部变量了，而不是全局变量了

'功能描述：设置local_webdw的值
'输入：GG_webdw
'输出：local_webdw
'这一方法应该是无用的，可以去掉，因为在这一过程中,local_webdw是输出项，而不是输入项
Private Function SetLocalWebDW()
    local_webdw = GG_webdw
End Function

'功能描述：读取local_webdw的值
'输入:local_webdw
'输出:GG_webdw
Public Function GetLocalWebDW()
    GG_webdw = local_webdw
End Function


'这个是一个主要的对外公开的解析方法
'输入一个字符串,把它解析成一个webdw结构的数据
'并存储在local_webdw中
'字符串存储在dwString中备用
'返回0代表成功
'如果解析失败,返回-1代表有错误(一般不会)
'不存储字符串,也不存储webdw
'错误信息存储在errString中
Public Function Create(inString As String) As Long
    Dim iflag As Long
   'step1 初始化local_webdw
   
    local_webdw = GG_empty_webdw
    dwString = inString
    errString = ""
    
   'step2 读入datawindow部分,如果出错,退出程序
    If readWebDW01_Datawindow() = -1 Then
        Create = -1: Exit Function
    End If
    
    'step3 读入header部分
    If readWebDW02_Header() = -1 Then
        Create = -1: Exit Function
    End If
    
    'step4 读入summary部分
    If readWebDW03_Summary() = -1 Then
        Create = -1: Exit Function
    End If
    'step5 读入footer部分
    If readWebDW04_Footer() = -1 Then
        Create = -1: Exit Function
    End If
    
    'step6 读入detail部分
    If readWebDW05_Detail() = -1 Then
        Create = -1: Exit Function
    End If
    
    'step7 读入table部分
    If readWebDW06_Table() = -1 Then
        Create = -1: Exit Function
    End If
    
    'step8 读入text部分
    If readWebDW07_Text() = -1 Then
        Create = -1: Exit Function
    End If
    
    'step9 读入column部分
    If readWebDW08_Column() = -1 Then
        Create = -1: Exit Function
    End If
    
    'step10 读入line部分
    If readWebDW09_Line() = -1 Then
        Create = -1: Exit Function
    End If
    'return
    Create = 0
End Function

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
'findPos 输出参数,表示找到的位置,没找到返回-1
Private Function getElementDesc(inString As String, eleName As String, beginPos As Long, ByRef findPos As Long) As String
    Dim iBeg As Long
    Dim leftPos As Long
    Dim iflag As Long
    
    Dim i As Long
    Dim s As String
    
    findPos = -1                                         '初始化findPos的值，如果不改变，返回的就是-1
    
    iBeg = InStr(beginPos, inString, eleName)
    If iBeg <= 0 Then
        getElementDesc = "": Exit Function              '返回空字符串代表没有找到这个元素
    End If
    
    leftPos = InStr(iBeg, inString, "(")                '得到左面括号的位置
    If leftPos <= 0 Then
        getElementDesc = "": Exit Function              '返回空字符串代表没有找到这个元素
    End If
    
    iflag = 0                                           '每找到一个(，iflag++,找到一个) iflag --
    For i = leftPos + 1 To Len(inString)
        s = Mid(inString, i, 1)                         '取当前字符串
        
        If (s = "(" Or s = ")") _
            And Mid(inString, i - 1, 1) = "~" Then      '如果是()，需要判断上个字符是否是~,如果是不操作
            GoTo continueNext
        End If
        
        
        If s = "(" Then
            iflag = iflag + 1
            GoTo continueNext                           '继续进行循环
        End If
        
        If s = ")" Then                                 '当前值为)时需要判断iflag的值
            If iflag = 0 Then                           'iflag=0，可以结束循环
                getElementDesc = Mid(inString, leftPos, i - leftPos + 1)
                findPos = leftPos                       '找到的位置是leftPos
                Exit Function
            Else
                iflag = iflag - 1                       '否则将iflag减去1
            End If
        End If
continueNext:
    Next i
    
    getElementDesc = ""
End Function
'对输入的字符串进行检查
'如果以"开头，以"结束,那么就删除掉前后的两个引号
Private Function removeQuote(ByRef strIn As String)
    Dim ilen As Long
    ilen = Len(strIn)
    
    If strIn = "" Then Exit Function
    If Left(strIn, 1) = """" And Right(strIn, 1) = """" Then
        strIn = Mid(strIn, 2, ilen - 2)
    End If
End Function


'从元素表示的字符串里面，用括号包括起来的
'取出指定的属性的实际属性值
'如果找不到，则返回一个空字符串
'retFlag是一个标志字符串，返回0代表找到了，返回-1代表没有这个指定名称的参数
'eleString 只读
'paraName 只读（大小写敏感）
'begPos   开始查找点
'defValue 找不到时候的默认值
'retFlag  输出参数0代表成功结束-1代表失败
Private Function getElementProp(eleString As String, paraName As String, begPos As Long, defValue As String, ByRef retFlag As Long) As String
    Dim iBeg As Long
    Dim iEnd As Long
    Dim ipos As Long
    Dim i As Long
    Dim iflag As Long
    Dim s As String
    Dim svalue As String
    
'    retFlag = -1
'    ipos = InStr(begPos, eleString, paraName & "=")     '找到属性名称的开始点
'    If ipos <= 0 Then                                   '找不到，退出
'        getElementProp = defValue                       '返回默认值
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
'            GoTo continueNext
'        End If
'
'        If s = " " Then                                 '如果s是空格，需要根据iFlag来判断
'            If iflag = 0 Then                           '如果不在字符串内，那么就退出
'                svalue = Mid(eleString, iBeg, i - iBeg)
'                removeQuote svalue                      '去掉开头和结尾的引号
'                getElementProp = svalue
'                retFlag = 0                             '标志成功结束
'                Exit Function                           '退出此功能
'            End If
'        End If
'
'continueNext:
'    Next i
'
'    getElementProp = defValue                           '返回默认值

    '默认使用空格作为结束标记符号
    svalue = getElementProp2(eleString, paraName, begPos, defValue, retFlag, " ")
    getElementProp = svalue
End Function

'从元素表示的字符串里面，用括号包括起来的
'取出指定的属性的实际属性值
'如果找不到，则返回一个空字符串
'retFlag是一个标志字符串，返回0代表找到了，返回-1代表没有这个指定名称的参数
'eleString 只读
'paraName 只读（大小写敏感）
'begPos   开始查找点
'defValue 找不到时候的默认值
'retFlag  输出参数0代表成功结束-1代表失败
'sep      结束的分割符号，遇到此符号代表结束

Private Function getElementProp2(eleString As String, paraName As String, begPos As Long, _
                        defValue As String, ByRef retFlag As Long, sep As String) As String
    Dim iBeg As Long
    Dim iEnd As Long
    Dim ipos As Long
    Dim i As Long
    Dim iflag As Long
    Dim s As String
    Dim svalue As String
    
    retFlag = -1
    ipos = InStr(begPos, eleString, paraName & "=")     '找到属性名称的开始点
    If ipos <= 0 Then                                   '找不到，退出
        getElementProp2 = defValue                       '返回默认值
        Exit Function
    End If
    
    iBeg = ipos + Len(paraName & "=")                   'iBeg代表值的开始点
    iflag = 0
    For i = iBeg To Len(eleString)
        s = Mid(eleString, i, 1)
        
        If s = """" Then                                '如果当前字符串是引号，那么设置标志
            If iflag = 0 Then
                iflag = 1
            Else
                iflag = 0
            End If
            GoTo continueNext
        End If
        
        If s = sep Then                                 '如果s是结束符号，需要根据iFlag来判断
            If iflag = 0 Then                           '如果不在字符串内，那么就退出
                svalue = Mid(eleString, iBeg, i - iBeg)
                removeQuote svalue                      '去掉开头和结尾的引号
                getElementProp2 = svalue
                retFlag = 0                             '标志成功结束
                Exit Function                           '退出此功能
            End If
        End If
            
continueNext:
    Next i
    
    getElementProp2 = defValue                           '返回默认值
End Function



'读入datawindow部分的属性
'返回0代表成功
'返回-1代表失败
Private Function readWebDW01_Datawindow() As Long
    Dim sDataWindow As String
    Dim ipos As Long
    Dim iflag As Long
    
    '得到datawindow的表示
    sDataWindow = getElementDesc(dwString, "datawindow", 1, ipos)
    
    '如果不存在datawindow定义,视为错误数据,停止执行
    If ipos < 0 Then
        errString = "ERROR:readWebDW01_Datawindow:数据格式不合法:找不到datawindow定义(必须)"
        readWebDW01_Datawindow = -1
        Exit Function
    End If
    
    '如果存在datawindow定义,那么就设置它的属性
    '即使没有,也直接跳过去,不报错误,直接设置一个默认值
    local_webdw.datawindow.unit = getElementProp(sDataWindow, "unit", 1, "0", iflag)
    local_webdw.datawindow.timer_interval = getElementProp(sDataWindow, "time_interval", 1, "0", iflag)
    local_webdw.datawindow.color = getElementProp(sDataWindow, "color", 1, "0", iflag)
    local_webdw.datawindow.processiong = getElementProp(sDataWindow, "processiong", 1, "", iflag)
    local_webdw.datawindow.HTMLDW = getElementProp(sDataWindow, "HTMLDW", 1, "no", iflag)
    local_webdw.datawindow.print_documentname = getElementProp(sDataWindow, "print.documentname", 1, "", iflag)
    local_webdw.datawindow.print_orientation = getElementProp(sDataWindow, "print.orientation", 1, "0", iflag)
    local_webdw.datawindow.print_margin_left = getElementProp(sDataWindow, "print.margin.left", 1, "110", iflag)
    local_webdw.datawindow.print_margin_right = getElementProp(sDataWindow, "print.margin.right", 1, "110", iflag)
    local_webdw.datawindow.print_margin_top = getElementProp(sDataWindow, "print.margin.top", 1, "96", iflag)
    local_webdw.datawindow.print_margin_bottom = getElementProp(sDataWindow, "print.margin.bottom", 1, "96", iflag)
    local_webdw.datawindow.print_paper_source = getElementProp(sDataWindow, "print.paper.source", 1, "0", iflag)
    local_webdw.datawindow.print_paper_size = getElementProp(sDataWindow, "print.paper.size", 1, "0", iflag)
    local_webdw.datawindow.print_prompt = getElementProp(sDataWindow, "print.prompt", 1, "no", iflag)
    local_webdw.datawindow.print_buttons = getElementProp(sDataWindow, "print.buttons", 1, "no", iflag)
    local_webdw.datawindow.print_preview_buttons = getElementProp(sDataWindow, "print.preview.buttons", 1, "no", iflag)
    local_webdw.datawindow.grid_lines = getElementProp(sDataWindow, "grid.lines", 1, "-1", iflag)
    
    readWebDW01_Datawindow = 0
End Function

'读入header部分的属性
'返回0代表成功
'返回-1代表失败
Private Function readWebDW02_Header() As Long
    Dim sHeader As String
    Dim ipos As Long
    Dim iflag As Long
    
    '得到datawindow的表示
    sHeader = getElementDesc(dwString, "header", 1, ipos)
    
    '如果找不到header定义，就退出
    If ipos < 0 Then
        readWebDW02_Header = 0
        Exit Function
    End If
    
    local_webdw.header.height = getElementProp(sHeader, "height", 1, "0", iflag)
    local_webdw.header.color = getElementProp(sHeader, "color", 1, "0", iflag)
    readWebDW02_Header = 0
    
End Function

'读入summary部分的属性
'返回0代表成功
'返回-1代表失败
Private Function readWebDW03_Summary() As Long
    Dim sSummary As String
    Dim ipos As Long
    Dim iflag As Long
    
    '得到summary的表示
    sSummary = getElementDesc(dwString, "summary", 1, ipos)
    
    '如果找不到summary定义，就退出
    If ipos < 0 Then
        errString = "ERROR:readWebDW03_Summary:数据格式不合法:找不到summary定义(必须)"
        readWebDW03_Summary = -1
        Exit Function
    End If
    
    local_webdw.summary.height = getElementProp(sSummary, "height", 1, "0", iflag)
    local_webdw.summary.color = getElementProp(sSummary, "color", 1, "0", iflag)
    readWebDW03_Summary = 0
End Function


'读入footer部分的属性
'返回0代表成功
'返回-1代表失败
Private Function readWebDW04_Footer() As Long
    Dim sFooter As String
    Dim ipos As Long
    Dim iflag As Long
    
    '得到footer的表示
    sFooter = getElementDesc(dwString, "footer", 1, ipos)
    
    '如果找不到footer定义，就退出
    If ipos < 0 Then
        errString = "ERROR:readWebDW04_Footer:数据格式不合法:找不到footer定义(必须)"
        readWebDW04_Footer = -1
        Exit Function
    End If
    
    local_webdw.footer.height = getElementProp(sFooter, "height", 1, "0", iflag)
    local_webdw.footer.color = getElementProp(sFooter, "color", 1, "0", iflag)
    readWebDW04_Footer = 0
End Function

'读入detail部分的属性
'返回0代表成功
'返回-1代表失败
Private Function readWebDW05_Detail() As Long
    Dim sDetail As String
    Dim ipos As Long
    Dim iflag As Long
    
    '得到footer的表示
    sDetail = getElementDesc(dwString, "detail", 1, ipos)
    
    '如果找不到footer定义，就退出
    If ipos < 0 Then
        errString = "ERROR:readWebDW05_Detail:数据格式不合法:找不到detail定义(必须)"
        readWebDW05_Detail = -1
        Exit Function
    End If
    
    local_webdw.detail.height = getElementProp(sDetail, "height", 1, "0", iflag)
    local_webdw.detail.color = getElementProp(sDetail, "color", 1, "0", iflag)
    readWebDW05_Detail = 0
End Function

'读入detail部分的属性
'返回0代表成功
'返回-1代表失败
Private Function readWebDW06_Table() As Long
    Dim stable As String
    Dim ipos As Long
    Dim iflag As Long
    Dim columnArray As Collection
    Dim obj As Variant
    Dim stemp As String
    Dim id As Long
    
    '得到footer的表示
    stable = getElementDesc(dwString, "table", 1, ipos)
    
    '如果找不到footer定义，就退出
    If ipos < 0 Then
        errString = "ERROR:readWebDW06_Table:数据格式不合法:找不到table定义(必须)"
        readWebDW06_Table = -1
        Exit Function
    End If
    
    
    '先读取column属性
    Set columnArray = getAllElement(stable, "column=")
    id = 0
    For Each obj In columnArray
        stemp = obj
        
        id = id + 1
        If id > 100 Then
            errString = "ERROR:readWebDW06_Table:SELECT的列超过100行!"
            readWebDW06_Table = -1
            Exit Function
        End If
           
        local_webdw.table.Columns(id).type = getElementProp(stemp, "type", 1, "", iflag)
        local_webdw.table.Columns(id).update = getElementProp(stemp, "update", 1, "yes", iflag)
        local_webdw.table.Columns(id).updatewhereclause = _
                        getElementProp(stemp, "updatewhereclause", 1, "yes", iflag)
        local_webdw.table.Columns(id).key = getElementProp(stemp, "key", 1, "", iflag)
        local_webdw.table.Columns(id).Name = getElementProp(stemp, "name", 1, "", iflag)
        local_webdw.table.Columns(id).dbname = getElementProp(stemp, "dbname", 1, "", iflag)
        local_webdw.table.Columns(id).values = getElementProp(stemp, "values", 1, "", iflag)
        
    Next
    
    '读取retrieve属性值
    'local_webdw.table.retrieve = getElementProp(stable, "retrieve", 1, "", iflag)
    
    'update,updatewhere,updatekeyinplace
    local_webdw.table.update = getElementProp(stable, "update", 1, "", iflag)
    local_webdw.table.updatewhere = getElementProp(stable, "updatewhere", 1, "", iflag)
    local_webdw.table.updatekeyinplace = getElementProp(stable, "updatekeyinplace", 1, "", iflag)
    
    '将retrieve字符串的属性读取到对应的变量中去
    'retrieve现在不是一个变量，而是一个结构体了。
    Dim strPBSelect As String
    Dim Columns(100) As String          '定义要读取的column的名称，这个column是数据库的名称
    Dim tables(10) As String            '定义要读取的table名称，最多10个
    Dim temparray As Variant
    Dim tempobj As Variant
    Dim iret As Long
    
    Dim select_tablelist As String      'tabel 子句
    Dim select_columnlist As String     'column 子句
    Dim select_join As String           'join 条件子句
    Dim select_where As String          'where子句
    
    
    Dim stablename As String
    Dim table_id As Long
    Dim scolumnname As String
    Dim column_id As Long
    
    Dim join_id As Long
    Dim join_left As String
    Dim join_op As String
    Dim join_right As String
    
    Dim where_id As Long
    Dim exp1 As String
    Dim where_op As String
    Dim exp2 As String
    Dim logic As String
    
    Dim order_id As Long
    Dim order_name As String
    Dim order_asc As String
    
    strPBSelect = getElementProp(stable, "retrieve", 1, "", iflag)  '先读取retrieve属性出来
    
    '读取table属性
    Set temparray = getAllElement(strPBSelect, "TABLE")     '得到TABLE元素的定义
    table_id = 0
    For Each tempobj In temparray
        stemp = tempobj
        stablename = getElementProp2(stemp, "NAME", 1, "", iret, ")")   '采用)作为结束分割符号
        
        If iret = -1 Then GoTo continue1
        
        table_id = table_id + 1
        If table_id > 10 Then
            Exit For
        End If
        local_webdw.table.retrieve.pbselect.table(table_id) = stablename     '存储tableName的值
continue1:
    Next
    
    '读取column属性
    Set temparray = getAllElement(strPBSelect, "COLUMN")    '得到column元素定义
    column_id = 0
    For Each tempobj In temparray
        stemp = tempobj
        scolumnname = getElementProp2(stemp, "NAME", 1, "", iret, ")")
        
        If iret = -1 Then GoTo continue2
                
        column_id = column_id + 1
        If column_id > 100 Then
            Exit For
        End If
        
        local_webdw.table.retrieve.pbselect.column(column_id) = scolumnname     '存储column的NAME
continue2:
    Next
    
    '读取join属性
    Set temparray = getAllElement(strPBSelect, "JOIN ")  '得到JOIN元素定义，后面有一个空格
    join_id = 0
    For Each tempobj In temparray
        stemp = tempobj
        join_left = getElementProp2(stemp, "LEFT", 1, "", iret, " ")
        If iret = -1 Then GoTo continue3
        
        join_op = getElementProp2(stemp, "OP", 1, "", iret, " ")
        If iret = -1 Then GoTo continue3
        
        join_right = getElementProp2(stemp, "RIGHT", 1, "", iret, " ")
        If iret = -1 Then GoTo continue3
        
        join_id = join_id + 1
        If join_id > 10 Then
            Exit For
        End If
        
        local_webdw.table.retrieve.pbselect.join(join_id).join_left = join_left
        local_webdw.table.retrieve.pbselect.join(join_id).join_op = join_op
        local_webdw.table.retrieve.pbselect.join(join_id).join_right = join_right
continue3:
    Next
    
    '读取where属性
    Set temparray = getAllElement(strPBSelect, "WHERE") '得到Where元素定义
    where_id = 0
    For Each tempobj In temparray
        stemp = tempobj
        exp1 = getElementProp2(stemp, "EXP1", 1, "", iret, " ")
        If iret = -1 Then GoTo continue4
        
        where_op = getElementProp2(stemp, "OP", 1, "", iret, " ")
        If iret = -1 Then GoTo continue4
        
        exp2 = getElementProp2(stemp, "EXP2", 1, "", iret, " ")
        If iret = -1 Then GoTo continue4
        
        logic = getElementProp2(stemp, "LOGIC", 1, "", iret, " ")
        
        where_id = where_id + 1
        If where_id > 0 Then
            Exit For
        End If
        
        local_webdw.table.retrieve.pbselect.where(where_id).exp1 = exp1
        local_webdw.table.retrieve.pbselect.where(where_id).op = where_op
        local_webdw.table.retrieve.pbselect.where(where_id).exp2 = exp2
        local_webdw.table.retrieve.pbselect.where(where_id).logic = logic
        
       
continue4:
    Next

    '读取order属性
    Set temparray = getAllElement(strPBSelect, "ORDER") '得到order元素定义
    order_id = 0
    For Each tempobj In temparray
        stemp = tempobj
        order_name = getElementProp2(stemp, "NAME", 1, "", iret, " ")
        If iret = -1 Then GoTo continue5
        
        order_asc = getElementProp2(stemp, "ASC", 1, "yes", iret, " ")  '默认为升序
        If iret = -1 Then GoTo continue5
        
        order_id = order_id + 1
        
        If order_id > 10 Then
            Exit For
        End If
        
        local_webdw.table.retrieve.pbselect.order(order_id).Name = order_name
        local_webdw.table.retrieve.pbselect.order(order_id).Asc = order_asc
continue5:
    Next
    
    readWebDW06_Table = 0
End Function

'功能描述：将输入的字符串切分成包含多个实际元素的array对象
'只获取其中的指定类型对象
Private Function getAllElement(inString As String, eletype As String) As Collection
    Dim myarray As New Collection
    Dim stext As String
    Dim ipos As Long
    
    '分解dwString，将其中的元素取出，描述放入myarray中去
    
    stext = getElementDesc(inString, eletype & "(", 1, ipos)
    While ipos > 0
        myarray.Add stext                              '容器内加入sText
        stext = getElementDesc(inString, eletype & "(", ipos + 1, ipos)
    Wend

    Set getAllElement = myarray
End Function


'读入所有的text的属性
'返回0代表成功
'返回-1代表失败

Private Function readWebDW07_Text() As Long
    Dim textArray As Collection
    Dim obj As Variant
    Dim stemp As String
    Dim id As Long
    Dim iret As Long
    
    Set textArray = getAllElement(dwString, "text")
    id = 0
    '循环处理
    For Each obj In textArray
        stemp = obj
        If Len(stemp) < 10 Then GoTo continueNext
            
        id = id + 1
        
        If id > 100 Then
            readWebDW07_Text = -1
            errString = "ERROR:readWebDW07_Text:最多可读取100个标签!"
            Exit Function
        End If
        
        local_webdw.text(id).band = getElementProp(stemp, "band", 1, "detail", iret)
        local_webdw.text(id).alignment = getElementProp(stemp, "alignment", 1, "1", iret)
        local_webdw.text(id).text = getElementProp(stemp, "text", 1, "", iret)
        local_webdw.text(id).border = getElementProp(stemp, "border", 1, "0", iret)
        local_webdw.text(id).color = getElementProp(stemp, "color", 1, "0", iret)
        local_webdw.text(id).X = getElementProp(stemp, "x", 1, "0", iret)
        local_webdw.text(id).Y = getElementProp(stemp, "y", 1, "0", iret)
        local_webdw.text(id).height = getElementProp(stemp, "height", 1, "0", iret)
        local_webdw.text(id).width = getElementProp(stemp, "width", 1, "0", iret)
        local_webdw.text(id).Name = getElementProp(stemp, "name", 1, "", iret)
        
        '下面是字体属性
        local_webdw.text(id).font.face = getElementProp(stemp, "font.face", 1, "", iret)
        local_webdw.text(id).font.height = getElementProp(stemp, "font.height", 1, "", iret)
        local_webdw.text(id).font.weight = getElementProp(stemp, "font.weight", 1, "", iret)
        local_webdw.text(id).font.family = getElementProp(stemp, "font.family", 1, "", iret)
        local_webdw.text(id).font.pitch = getElementProp(stemp, "font.pitch", 1, "", iret)
        local_webdw.text(id).font.charset = getElementProp(stemp, "font.charset", 1, "", iret)
        local_webdw.text(id).font.italic = getElementProp(stemp, "font.italic", 1, "0", iret)
        local_webdw.text(id).font.underline = getElementProp(stemp, "font.underline", 1, "0", iret)
        local_webdw.text(id).font.strikethrough = getElementProp(stemp, "font.strikethrough", 1, "0", iret)
        
        '下面是颜色属性
        local_webdw.text(id).background_mode = getElementProp(stemp, "background.mode", 1, "", iret)
        local_webdw.text(id).background_color = getElementProp(stemp, "background.color", 1, "", iret)
continueNext:
    Next

End Function

'读入所有的column的属性
'返回0代表成功
'返回-1代表失败
Private Function readWebDW08_Column() As Long
    Dim columnArray As Collection
    Dim obj As Variant
    Dim sColumn As String
    Dim id As Long
    Dim iret As Long
    Dim temp_webdw_column As WebDW_Column
    
    Set columnArray = getAllElement(dwString, "column")
    id = 0
    '循环处理
    For Each obj In columnArray
        sColumn = obj
        id = id + 1
        
        If id > 100 Then
            readWebDW08_Column = -1
            errString = "ERROR:readWebDW08_Column:最多可读取100个列!"
            Exit Function
        End If
        
        
        temp_webdw_column.band = getElementProp(sColumn, "band", 1, "1", iret)
        temp_webdw_column.id = getElementProp(sColumn, "id", 1, "0", iret)
        temp_webdw_column.alignment = getElementProp(sColumn, "alignment", 1, "1", iret)
        temp_webdw_column.tabsequence = getElementProp(sColumn, "tabsequence", 1, "0", iret)
        temp_webdw_column.border = getElementProp(sColumn, "border", 1, "1", iret)
        temp_webdw_column.color = getElementProp(sColumn, "color", 1, "0", iret)
        
        temp_webdw_column.X = getElementProp(sColumn, "x", 1, "0", iret)
        temp_webdw_column.Y = getElementProp(sColumn, "y", 1, "0", iret)
        temp_webdw_column.height = getElementProp(sColumn, "height", 1, "0", iret)
        temp_webdw_column.width = getElementProp(sColumn, "width", 1, "0", iret)
        temp_webdw_column.format = getElementProp(sColumn, "format", 1, "", iret)
        temp_webdw_column.Name = getElementProp(sColumn, "name", 1, "", iret)
        temp_webdw_column.tag = getElementProp(sColumn, "tag", 1, "", iret)
        
        '下面是编辑风格支持
        temp_webdw_column.edit_limit = getElementProp(sColumn, "edit.limit", 1, "0", iret)
        temp_webdw_column.edit_case = getElementProp(sColumn, "edit.case", 1, "any", iret)
        temp_webdw_column.edit_focusrectangle = getElementProp(sColumn, "edit.focusrectangle", 1, "no", iret)
        temp_webdw_column.edit_autoselect = getElementProp(sColumn, "edit.autoselect", 1, "no", iret)
        temp_webdw_column.edit_autohscroll = getElementProp(sColumn, "edit.autohscroll", 1, "yes", iret)
        
        '下面是字体支持
        temp_webdw_column.font.face = getElementProp(sColumn, "font.face", 1, "", iret)
        temp_webdw_column.font.height = getElementProp(sColumn, "font.height", 1, "", iret)
        temp_webdw_column.font.weight = getElementProp(sColumn, "font.weight", 1, "", iret)
        temp_webdw_column.font.family = getElementProp(sColumn, "font.family", 1, "", iret)
        temp_webdw_column.font.pitch = getElementProp(sColumn, "font.pitch", 1, "", iret)
        temp_webdw_column.font.charset = getElementProp(sColumn, "font.charset", 1, "", iret)
        temp_webdw_column.font.italic = getElementProp(sColumn, "font.italic", 1, "0", iret)
        temp_webdw_column.font.underline = getElementProp(sColumn, "font.underline", 1, "0", iret)
        temp_webdw_column.font.strikethrough = getElementProp(sColumn, "font.strikethrough", 1, "0", iret)
        
        
        '下面是background支持
        temp_webdw_column.background_mode = getElementProp(sColumn, "background.mode", 1, "", iret)
        temp_webdw_column.background_color = getElementProp(sColumn, "background.color", 1, "", iret)
        
        '下面是单选按钮的支持定义20090124
        temp_webdw_column.radiobuttons.Columns = getElementProp(sColumn, "radiobuttons.columns", 1, "0", iret)
        
        '下面是选择框按钮的支持定义20090124
        temp_webdw_column.checkbox.text = getElementProp(sColumn, "checkbox.text", 1, "", iret)
        temp_webdw_column.checkbox.on = getElementProp(sColumn, "checkbox.on", 1, "", iret)
        temp_webdw_column.checkbox.off = getElementProp(sColumn, "checkbox.off", 1, "", iret)
        temp_webdw_column.checkbox.scale1 = getElementProp(sColumn, "checkbox.scale", 1, "", iret)
        temp_webdw_column.checkbox.threed = getElementProp(sColumn, "checkbox.threed", 1, "", iret)
        
        '下面是下拉列表编辑风格的支持定义20090124
        temp_webdw_column.combobox.allowedit = getElementProp(sColumn, "ddlb.allowedit", 1, "", iret)
        temp_webdw_column.combobox.limit = getElementProp(sColumn, "ddlb.limit", 1, "0", iret)
        temp_webdw_column.combobox.case = getElementProp(sColumn, "ddlb.case", 1, "", iret)
        temp_webdw_column.combobox.useasborder = getElementProp(sColumn, "ddlb.useasborder", 1, "", iret)
        
        '下面是下拉式数据窗口的支持定义20090125(牛年除夕之夜)
        temp_webdw_column.dddw.allowedit = getElementProp(sColumn, "dddw.allowedit", 1, "", iret)
        temp_webdw_column.dddw.case = getElementProp(sColumn, "dddw.case", 1, "", iret)
        temp_webdw_column.dddw.DataColumn = getElementProp(sColumn, "dddw.datacolumn", 1, "", iret)
        temp_webdw_column.dddw.DisplayColumn = getElementProp(sColumn, "dddw.displaycolumn", 1, "", iret)
        temp_webdw_column.dddw.limit = getElementProp(sColumn, "dddw.limit", 1, "0", iret)
        temp_webdw_column.dddw.Lines = getElementProp(sColumn, "dddw.lines", 1, "0", iret)
        temp_webdw_column.dddw.Name = getElementProp(sColumn, "dddw.name", 1, "", iret)
        temp_webdw_column.dddw.PercentWidth = getElementProp(sColumn, "dddw.percentwidth", 1, "100", iret)
        temp_webdw_column.dddw.useasborder = getElementProp(sColumn, "dddw.useasborder", 1, "", iret)
        temp_webdw_column.dddw.vscrollbar = getElementProp(sColumn, "dddw.vscrollbar", 1, "", iret)
        
        local_webdw.column(temp_webdw_column.id) = temp_webdw_column
    Next
    readWebDW08_Column = 0
End Function

'读取所画线条的属性
Private Function readWebDW09_Line() As Long
    Dim lineArray As Collection
    Dim obj As Variant
    Dim sline As String
    Dim id As Long
    Dim iret As Long

    Set lineArray = getAllElement(dwString, "line")
    id = 0
    '循环处理
    For Each obj In lineArray
        sline = obj
        id = id + 1
        
        If id > 100 Then
            readWebDW09_Line = -1
            errString = "ERROR:readWebDW09_Line:最多可读取100个线条!"
            Exit Function
        End If
        
        local_webdw.lineinfo(id).band = getElementProp(sline, "band", 1, "detail", iret)
        local_webdw.lineinfo(id).x1 = getElementProp(sline, "x1", 1, "0", iret)
        local_webdw.lineinfo(id).y1 = getElementProp(sline, "y1", 1, "0", iret)
        local_webdw.lineinfo(id).x2 = getElementProp(sline, "x2", 1, "0", iret)
        local_webdw.lineinfo(id).y2 = getElementProp(sline, "y2", 1, "0", iret)
        local_webdw.lineinfo(id).Name = getElementProp(sline, "name", 1, "", iret)
        local_webdw.lineinfo(id).pen_style = getElementProp(sline, "pen.style", 1, "", iret)
        local_webdw.lineinfo(id).pen_width = getElementProp(sline, "pen.width", 1, "", iret)
        local_webdw.lineinfo(id).pen_color = getElementProp(sline, "pen.color", 1, "", iret)
        local_webdw.lineinfo(id).background_mode = getElementProp(sline, "background.mode", 1, "", iret)
        local_webdw.lineinfo(id).background_color = getElementProp(sline, "background.color", 1, "", iret)
    Next
        
End Function


