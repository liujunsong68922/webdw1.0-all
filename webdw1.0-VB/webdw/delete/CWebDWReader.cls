VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDWReader"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW的的数据访问功能类
Rem 输入：g_webdw
Rem g_webdw是由CWebDW构建生成的
Rem 生成以后，对于g_webdw的所有数据读取请求，全部集中在CWebDWReader中实现
Rem 这样可以明确代码的功能划分，避免代码混乱
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @版权所有 刘峻松 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit
Option Base 1
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


'得到label的总数
Private Function getLableNum() As Long
    Dim id As Long
    For id = 1 To 100
        If g_webdw.text(id).name = "" Then
            getLableNum = id - 1
            Exit Function
        End If
    Next
    getLableNum = id - 1
End Function
'得到元素的描述
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

Private Function getElementProp(eleString As String, paraName As String, begPos As Long, _
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
        getElementProp = defValue                       '返回默认值
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
                getElementProp = svalue
                retFlag = 0                             '标志成功结束
                Exit Function                           '退出此功能
            End If
        End If
            
continueNext:
    Next i
    
    getElementProp = defValue                           '返回默认值
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



'功能描述：从DW定义中，分解得到数据库检索用的Select语句
'为下一步执行SQL操作打下基础
'这个SQL语句可能会带有参数
Public Function GetRetrieveSQL() As String
    
    Dim id As Long
    Dim select_tablelist As String      'tabel 子句
    Dim select_columnlist As String     'column 子句
    Dim select_join As String           'join 条件子句
    Dim select_where As String          'where子句
    
    select_tablelist = ""
    For id = 1 To 10
        If g_webdw.table.retrieve.pbselect.table(id) = "" Then
            Exit For
        End If
        
        If select_tablelist = "" Then
            select_tablelist = g_webdw.table.retrieve.pbselect.table(id)
        Else
            select_tablelist = select_tablelist & "," _
                & g_webdw.table.retrieve.pbselect.table(id)  '拼装Table子句
        End If
        
    Next
    
    select_columnlist = ""
    For id = 1 To 100
        If g_webdw.table.retrieve.pbselect.column(id) = "" Then
            Exit For
        End If
        
        If select_columnlist = "" Then
            select_columnlist = g_webdw.table.retrieve.pbselect.column(id)
        Else
            select_columnlist = select_columnlist & "," _
                & g_webdw.table.retrieve.pbselect.column(id)
        End If
    Next
    
   
    select_join = ""
    For id = 1 To 10
        If g_webdw.table.retrieve.pbselect.join(id).join_left = "" Then
            Exit For
        End If
        
        If select_join = "" Then
            select_join = "(" & g_webdw.table.retrieve.pbselect.join(id).join_left _
            & " " & g_webdw.table.retrieve.pbselect.join(id).join_op _
            & " " & g_webdw.table.retrieve.pbselect.join(id).join_right & ")"
        Else
            select_join = select_join & " AND " & _
                    "(" & g_webdw.table.retrieve.pbselect.join(id).join_left _
                    & " " & g_webdw.table.retrieve.pbselect.join(id).join_op _
                    & " " & g_webdw.table.retrieve.pbselect.join(id).join_right & ")"
        End If
    Next
    
   
    select_where = select_join
    For id = 1 To 10
        If g_webdw.table.retrieve.pbselect.where(id).exp1 = "" Then
            Exit For
        End If
        
        If select_where = "" Then
            select_where = "(" & g_webdw.table.retrieve.pbselect.where(id).exp1 _
                            & " " & g_webdw.table.retrieve.pbselect.where(id).op _
                            & " " & g_webdw.table.retrieve.pbselect.where(id).exp2 & ") " _
                            & g_webdw.table.retrieve.pbselect.where(id).logic
        Else
            select_where = select_where & " And " & _
                        "(" & g_webdw.table.retrieve.pbselect.where(id).exp1 _
                        & " " & g_webdw.table.retrieve.pbselect.where(id).op _
                        & " " & g_webdw.table.retrieve.pbselect.where(id).exp2 & ") " _
                        & g_webdw.table.retrieve.pbselect.where(id).logic
        End If
    Next
    
    If select_where > "" Then
        select_where = " Where " & select_where
    End If
    
    GetRetrieveSQL = "Select " & select_columnlist & " from " & select_tablelist & select_where
    GetRetrieveSQL = Replace(GetRetrieveSQL, "~""", "")
End Function
