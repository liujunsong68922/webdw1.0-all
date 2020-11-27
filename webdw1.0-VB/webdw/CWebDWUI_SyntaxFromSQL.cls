VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDW_SyntaxFromSQL"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW的数据窗口自动生成器
Rem 这个类的设计目的是给出一个Select语句，自动填充local_webdw的数值
Rem 这里面没有和后台数据库的交互，所需要的数据事先先提供过来
Rem 根据生成的数据窗口的类型不同，分为多个不同的方法来实现
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @版权所有 刘峻松 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------
Option Explicit

'公用变量定义
Public errString As String      '错误信息存储字符串，输出字符串

'colDefString字符串的数据从外部直接传入
Public colDefString As String   '数据列存储字符串，格式为：第一行列列表，其他行：列的定义信息

Dim columnlist As String    'select语句的列列表
Dim tablelist As String     'select语句的table列表
Dim joinlist As String      'select语句的连接语句
Dim wherelist As String     'select语句的where条件字句

Const color_white = 16777215

Private local_webdw As WebDWSyntax 'local_webdw现在是一个局部变量了，而不是全局变量了

'功能描述：设置local_webdw的值
'输入：glocal_webdw
'输出：local_webdw
Public Function SetLocalWebDW()
    local_webdw = GG_webdw
End Function

'功能描述：读取local_webdw的值
'输入:local_webdw
'输出:glocal_webdw
Public Function GetLocalWebDW()
    GG_webdw = local_webdw
End Function


'根据给定的SQL语句，以及对应的数据窗口类型
'设置到local_webdw中去
'从而再转换，得到一个对应的数据窗口对象出来。
'iret返回值，0 正常 -1 失败
'错误信息存放在errstring中
'这个方法是一个Select语句的小型解析器
Public Function SyntaxFromSQL(strsql As String, stype As String, ByRef iret As Long) As String
    Dim strDW As String
    'step1 判断stype是否合法，是否是支持的DW类型
    If stype <> "freedom" And stype <> "grid" Then
        iret = -1
        SyntaxFromSQL = ""
        errString = "不支持的DW类型:" & stype
        Exit Function
    End If
    
    
    'step2先调用通用功能
    generateDW_0Common strsql, stype, iret
    
    If iret = -1 Then
        SyntaxFromSQL = ""
        Exit Function
    End If
    
    '再根据stype来调用对应的的特殊功能
    If stype = "freedom" Then
        generateDW_1Freedom strsql, stype, iret
    End If
    
    If stype = "grid" Then
        generateDW_2Grid strsql, stype, iret
    End If
    
End Function

'根据给定的SQL语句，以及对应的数据窗口类型
'设置到local_webdw中去
'从而再转换，得到一个对应的数据窗口对象出来。
'iret返回值，0 正常 -1 失败
'错误信息存放在errstring中
'这个方法是一个Select语句的小型解析器
Private Function generateDW_0Common(strsql As String, stype As String, ByRef iret As Long) As String
    local_webdw = GG_empty_webdw    '初始化
    initDW (stype)      '设置初始值，见上面的函数定义
            
    generateDW_0Common = ""
    '先将Where语句切分成四部分，计算其中的四个子句
    Dim selectpos As Long
    Dim frompos As Long
    Dim wherepos As Long
    Dim orderpos As Long
    
    Dim temparray() As String
    Dim tempv As Variant
    Dim temps As String
    Dim id As Long
    
    '暂时先不考虑groupby,having关键字，以后增加
    selectpos = InStr(1, strsql, "select ", vbTextCompare)
    
    '检查select关键字
    If selectpos < 0 Then
        iret = -1
        errString = "SQL语句中找不到select关键字"
        Exit Function
    End If
    
    frompos = InStr(selectpos + 6, strsql, " from ", vbTextCompare)
    '检查from关键字
    If frompos < 0 Then
        iret = -1
        errString = "SQL语句中找不到from关键字"
        Exit Function
    End If
    
    columnlist = Mid(strsql, selectpos + 7, frompos - (selectpos + 7) + 1) '得到数据列的列表
    
    '检查where关键字
    wherepos = InStr(frompos, strsql, " where ", vbTextCompare)
    If wherepos > 0 Then
        tablelist = Mid(strsql, frompos + 6, wherepos - (frompos + 6) + 1)
    Else
        tablelist = Mid(strsql, frompos + 6, Len(strsql) - (frompos + 6) + 1)
    End If
    
    '接下来用得到的columnlist和tablelist来填充local_webdw的数据
    'join子句，where子句，order子句的支持以后再添加，先完成一个基本功能。
    '利用得到的table名称，来填充对应的Table参数
    temparray = Split(tablelist, ",")
    id = 0
    For Each tempv In temparray
        temps = tempv                           '转换成字符串，代表一个数据表名称
        temps = Trim(temps)
        
        id = id + 1
        local_webdw.table.retrieve.pbselect.table(id) = temps
    Next
    
    
    Dim col_datatype As String
    Dim col_length As Long
    Dim stablename As String
    Dim scolname As String
    Dim ipos As Long
    
    temparray = Split(columnlist, ",", -1, vbTextCompare)        '将columnlist切分成数组
    id = 0
    For Each tempv In temparray
        temps = tempv                           '转换成字符串,代表一个列名称
        temps = Trim(temps)
        id = id + 1
        '利用这个column的名称，自动生成text,column,table里面的column
            
        'step1 初始化table.column
        local_webdw.table.Columns(id).dbname = temps
        ipos = InStr(1, temps, ".")
        If ipos < 0 Then
            stablename = local_webdw.table.retrieve.pbselect.table(1)
            scolname = temps
        Else
            stablename = Left(temps, ipos - 1)
            scolname = Right(temps, Len(temps) - ipos)
        End If
        
        '检索得到数据表对应列的字段类型和字段长度
        If getDataType(stablename, scolname, col_datatype, col_length) = -1 Then
            generateDW_0Common = ""
            iret = -1
            errString = "读取数据列的数据类型时发生错误!"
            Exit Function
        End If
        
        local_webdw.table.Columns(id).Name = Replace(temps, ".", "_") '名称的.变成下划线
        local_webdw.table.Columns(id).type = col_datatype & "(" & col_length & ")"
        local_webdw.table.Columns(id).update = "yes"
        local_webdw.table.Columns(id).updatewhereclause = "yes"
        
        'TODO:下一步需要根据此字段是否为主键，以及是否有表连接来判断key的属性
        local_webdw.table.Columns(id).key = "no"
        
        'step2 初始化table.retrieve.column 的值
        local_webdw.table.retrieve.pbselect.column(id) = "~" & """" & temps & "~" & """"
        
        'stemp3 初始化text的值
        local_webdw.text(id).Name = Replace(temps, ".", "_") & "_t"
        local_webdw.text(id).alignment = 2
        local_webdw.text(id).text = Replace(temps, ".", "_")    '未来描述应当从数据库中得到
        local_webdw.text(id).border = 0
        local_webdw.text(id).color = 0
        local_webdw.text(id).font.face = "MS Sans Serif"
        local_webdw.text(id).font.height = "-8"
        local_webdw.text(id).font.weight = 700
        local_webdw.text(id).font.family = 2
        local_webdw.text(id).font.pitch = 2
        local_webdw.text(id).font.charset = 0
        
        local_webdw.text(id).background_mode = 1
        local_webdw.text(id).background_color = color_white
        
        
        'step4 初始化column的属性
        local_webdw.column(id).width = col_length               '暂时把列的数据库定义宽度存在width变量里面
        local_webdw.column(id).Name = Replace(temps, ".", "_")
        local_webdw.column(id).id = id
        local_webdw.column(id).alignment = "0"
        local_webdw.column(id).tabsequence = id * 10
        local_webdw.column(id).border = 1
        local_webdw.column(id).color = 0
        local_webdw.column(id).format = "[general]"
        local_webdw.column(id).tag = Replace(temps, ".", "_")
        local_webdw.column(id).edit_limit = 0
        local_webdw.column(id).edit_case = "any"
        local_webdw.column(id).edit_focusrectangle = "no"
        local_webdw.column(id).edit_autoselect = "no"
        local_webdw.column(id).edit_autohscroll = "no"
        local_webdw.column(id).font.face = "MS Sans Serif"
        local_webdw.column(id).font.height = "-8"
        local_webdw.column(id).font.weight = 400
        local_webdw.column(id).font.family = 2
        local_webdw.column(id).font.pitch = 2
        local_webdw.column(id).font.charset = 0
        local_webdw.column(id).background_mode = 1
        local_webdw.column(id).background_color = color_white
        local_webdw.column(id).band = "detail"
    Next
    
End Function

'根据给定的SQL语句，以及对应的数据窗口类型
'生成一个Freedom风格的DW出来
Private Function generateDW_1Freedom(strsql As String, stype As String, ByRef iret As Long) As String
    Dim temparray() As String
    Dim id As Long
    Dim tempv As Variant
    Dim temps As String
    Dim col_length As Long
    
    temparray = Split(columnlist, ",", -1, vbTextCompare)        '将columnlist切分成数组
    id = 0
    For Each tempv In temparray
        temps = tempv                           '转换成字符串,代表一个列名称
        temps = Trim(temps)
        id = id + 1
        
        '设置text的属性
        local_webdw.text(id).X = 10
        If id = 1 Then
            local_webdw.text(id).Y = 10
        Else
            local_webdw.text(id).Y = local_webdw.column(id - 1).Y _
                         + local_webdw.column(id - 1).height + 50
        End If
                                    
        local_webdw.text(id).width = 500
        local_webdw.text(id).height = 50
        local_webdw.text(id).band = "detail"
        local_webdw.detail.height = local_webdw.text(id).Y + local_webdw.text(id).height + 200
            
        '设置column的属性
        local_webdw.column(id).X = 600
        If id = 1 Then
            local_webdw.column(id).Y = 10
        Else
            local_webdw.column(id).Y = local_webdw.column(id - 1).Y _
                        + local_webdw.column(id - 1).height + 50
        End If
            
        '从width里面取出col_length出来
        col_length = local_webdw.column(id).width
        If col_length <= 30 Then
            If col_length < 10 Then
                local_webdw.column(id).width = 200
                local_webdw.column(id).height = 50
            Else
                local_webdw.column(id).width = 25 * col_length
                local_webdw.column(id).height = 50
            End If
        Else
            local_webdw.column(id).width = 800
            local_webdw.column(id).height = 200
        End If
            
        '对于freedom类型的DW，设置detail的height
        If local_webdw.detail.height < local_webdw.column(id).Y + local_webdw.column(id).height + 100 Then
             local_webdw.detail.height = local_webdw.column(id).Y + local_webdw.column(id).height + 100
        End If
            
    Next
    
End Function

Private Function generateDW_2Grid(strsql As String, stype As String, ByRef iret As Long) As String
    Dim temparray() As String
    Dim tempv As Variant
    Dim temps As String
    Dim id As Long
    Dim ipos As Long
    Dim stablename As String
    Dim scolname As String
    Dim col_length As Long
    Dim sum_width As Long
    
    sum_width = 0
    temparray = Split(columnlist, ",", -1, vbTextCompare)        '将columnlist切分成数组
    id = 0
    For Each tempv In temparray
        temps = tempv                           '转换成字符串,代表一个列名称
        temps = Trim(temps)
        id = id + 1
        '利用这个column的名称，自动生成text,column,table里面的column
            
        'step1 初始化table.column
        local_webdw.table.Columns(id).dbname = temps
        ipos = InStr(1, temps, ".")
        If ipos < 0 Then
            stablename = local_webdw.table.retrieve.pbselect.table(1)
            scolname = temps
        Else
            stablename = Left(temps, ipos - 1)
            scolname = Right(temps, Len(temps) - ipos)
        End If
        
        '设置text的属性
        local_webdw.text(id).Y = 10
        local_webdw.text(id).X = 10 + sum_width
        local_webdw.text(id).height = 200
        local_webdw.text(id).band = "header"
        local_webdw.header.height = 200
        local_webdw.detail.height = 100
        
        
        '设置column的属性
        local_webdw.column(id).border = 0
        local_webdw.column(id).Y = 10
        local_webdw.column(id).X = 10 + sum_width
        col_length = local_webdw.column(id).width
        local_webdw.column(id).width = 500
        
        If col_length <= 20 Then
            If col_length < 10 Then
                local_webdw.column(id).width = 200
                local_webdw.text(id).width = 200
                local_webdw.column(id).height = 50
            Else
                local_webdw.column(id).width = col_length * 25
                local_webdw.text(id).width = col_length * 25
                local_webdw.column(id).height = 50
            End If
        Else
            local_webdw.column(id).width = 500
            local_webdw.text(id).width = 500
            local_webdw.column(id).height = 200
            local_webdw.detail.height = 220
        End If
        
        sum_width = sum_width + 10 + local_webdw.column(id).width
    Next


End Function

'功能描述：初始化local_webdw对象，为其中各个数据赋予初始值
'这个功能在利用SQL语句生成一个Datawindows进行调用
'这一功能直接操作local_webdw对象
Private Function initDW(dwtype As String) As Long

    '初始化datawindow的属性
    local_webdw.datawindow.unit = 0
    local_webdw.datawindow.timer_interval = 0
    local_webdw.datawindow.color = 16777215
    local_webdw.datawindow.processiong = 1
    local_webdw.datawindow.HTMLDW = "no"
    local_webdw.datawindow.print_documentname = ""
    local_webdw.datawindow.print_orientation = 0
    local_webdw.datawindow.print_margin_left = 110
    local_webdw.datawindow.print_margin_right = 110
    local_webdw.datawindow.print_margin_top = 96
    local_webdw.datawindow.print_margin_bottom = 96
    local_webdw.datawindow.print_paper_source = 0
    local_webdw.datawindow.print_paper_size = 0
    local_webdw.datawindow.print_prompt = "no"
    local_webdw.datawindow.print_buttons = "no"
    local_webdw.datawindow.print_preview_buttons = "no"
    
    '初始化header的属性
    '如果是表格型，有头部，否则没有头部
    If dwtype = "grid" Then
        local_webdw.header.height = 96
    Else
        local_webdw.header.height = 0
    End If
    local_webdw.header.color = color_white
    
    '初始化summary的属性
    local_webdw.summary.height = 96
    local_webdw.summary.color = color_white
    
    '初始化footer的属性
    local_webdw.footer.height = 96
    local_webdw.footer.color = color_white
    
    '初始化detail的属性
    local_webdw.detail.height = 96
    local_webdw.detail.color = color_white
    
    '初始化table的属性
    local_webdw.table.updatewhere = 1
    local_webdw.table.updatekeyinplace = "no"
    
    
End Function

'得到表的某一列的具体数据类型
'列的数据类型字符串从colDefString中得到，事先设置
'输入:表名，列名
'输出：数据类型，列长度
'返回：标志位：0 成功 -1 失败
Private Function getDataType(stable As String, scol As String, _
                            ByRef sDataType As String, ByRef collen As Long) As Long
    Dim line() As String
    Dim sdata() As String
    
    Dim aline As Variant
    Dim sline As String
    Dim id As Long
    
    Dim tab_colIndex As Long    'TNAME列的序号
    Dim col_colIndex As Long    'CNAME列的序号
    Dim type_index As Long
    Dim len_index As Long
    
    '判断是否是空字符串
    If colDefString = "" Then
        getDataType = -1
        errString = "尚未设置colDefString的值"
        Exit Function
    End If
        
    '计算Tname列 和 Cname列的序号
    tab_colIndex = getColIndex("TNAME")
    col_colIndex = getColIndex("CNAME")
    type_index = getColIndex("COLTYPE")
    len_index = getColIndex("WIDTH")
    
    If tab_colIndex = -1 Or col_colIndex = -1 _
        Or type_index = -1 Or len_index = -1 Then
        getDataType = -1
        errString = "无法获得TNAME列和CNAME列的下标"
        Exit Function
    End If
    
    '数据切分成多行
    line = Split(colDefString, "" & Chr(13) & Chr(10))
    
    For Each aline In line
        sline = aline
        sdata = Split(sline, "" & Chr(9))
        
        If sdata(tab_colIndex) = stable And sdata(col_colIndex) = scol Then
            sDataType = sdata(type_index)
            collen = sdata(len_index)
            getDataType = 0
            Exit Function
        End If
    Next
    
    getDataType = -1
    Exit Function
End Function

'从colDefString中检索，检索其中第一行
'给出一个列名，检索得到对应的下标号(从0开始)
'返回值:>=0 代表下标号
'返回-1代表找不到,发生错误
Private Function getColIndex(colname As String) As Long
    Dim line() As String
    Dim colnames() As String
    Dim id As Long
    
    On Error GoTo errorHandle
    '数据切分成多行
    line = Split(colDefString, "" & Chr(13) & Chr(10))
    colnames = Split(line(0), "" & Chr(9))
    For id = 0 To UBound(colnames)
        If UCase(colnames(id)) = UCase(colname) Then
            getColIndex = id
            Exit Function
        End If
    Next
errorHandle:
    getColIndex = -1
End Function


