VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWedDWData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW控件对应的数据存储及访问类
Rem 这个类是专门用来操作实际数据的
Rem 数据通过一个固定格式的字符串来进行初始化
Rem 数据存储在CWebDWData中
Rem 这样可以明确代码的功能划分，避免代码混乱
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @版权所有 刘峻松 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit
Option Base 1

Dim Columns() As String '列名的集合，来自返回数据，而不是DW定义
Dim DataArray() As String   '数据行的集合，来自返回数据，一行一个字符串来存储

'Dim lineState() As Long     '每一行的数据库对应状态0 正常 1 修改 2 删除 3 插入 4 无效（不连DB）
Dim sorgData As String      '传入的原始数据字符串，存储用，不修改
Public errString As String  '如果调用失败，输出的错误信息。

'功能描述：从输入的字符串中读取数据，填充columnArray和lineArray
'返回0 成功
'返回-1 失败，错误信息保存在errString中
Public Function ReadData(sindata As String) As Long
    Dim sDataArray As Variant   '原始数据按行分解得到的数组
    Dim vline As Variant        '原始数据每一行
    Dim sline As String         '转换成字符串的原始数据每一行
    Dim lineId As Long          '原始数据的行号，0代表标题，其余代表数据
    
    Dim sdarray As Variant      '中间变量，每一行分解成数据列的数组
    
    Dim colid As Long           '列的序号
    Dim colNum As Long          '列的数量
    
    sorgData = sindata          '存储原始数据
    
    ReDim DataArray(1)          '先清空原始数据
    
    sDataArray = Split(sindata, "" & Chr(13) & Chr(10))     '利用回车符号进行分解
    lineId = 0                                              '原始数据的行号
    For Each vline In sDataArray
        sline = vline                                       '读出一行,转成字符串
        If sline = "" Then                                  '遇到空行，退出
            Exit For
        End If
        
        If lineId = 0 Then
            Columns = Split(sline, Chr(9))                 '按chr(9)来分解成列,存到columns里面
            colNum = UBound(Columns) - LBound(Columns) + 1 '列的数量
        Else
            sdarray = Split(sline, Chr(9))                 '按chr(9)来分解列,分解成多个数据列
            
            If UBound(sdarray) = 0 Then
                Exit Function
            End If
            
            If UBound(sdarray) <> UBound(Columns) Then      '检查数据列是否足够
                ReadData = -1
                errString = "CWebDWData.ReadDataq数据格式错误:数据列数量不足!行:" & lineId
                Exit Function
            End If
            
            ReDim Preserve DataArray(lineId * colNum + 1)     '重新定义数据大小，保留原来数据
            
            For colid = 1 To colNum
                DataArray((lineId - 1) * colNum + colid) = sdarray(LBound(sdarray) - 1 + colid) '列的数据存储
            Next
        End If
        
        lineId = lineId + 1
    Next
    
End Function
'得到行的数量
Public Function GetRowCount() As Long
    Dim iTotalNum As Long
    iTotalNum = UBound(DataArray) - LBound(DataArray) + 1
    If getColumnNumber() > 0 Then
        GetRowCount = iTotalNum / getColumnNumber()
    Else
        GetRowCount = 0
    End If
End Function

'得到列的数量
Public Function getColumnNumber() As Long
    getColumnNumber = UBound(Columns) - LBound(Columns) + 1
End Function

'得到指定行列的数据
Public Function getItemString(row As Long, col As Long) As String
    Dim id As Long
    id = (row - 1) * getColumnNumber() + col
    
    If id > UBound(DataArray) Then
        getItemString = ""
    Else
        getItemString = DataArray(id)
    End If
        
End Function
'设置指定行列的数据
Public Function setItemString(row As Long, col As Long, sData As String) As String
    Dim id As Long
    id = (row - 1) * getColumnNumber() + col
    
    If id > UBound(DataArray) Then
        setItemString = "Err:setItemString:数组越界!"
        Exit Function
    Else
        DataArray(id) = sData
        setItemString = ""
    End If

End Function
'根据列的序号，得到列的名称
Public Function getColumnName(colid) As String
    If colid <= getColumnNumber Then
        getColumnName = Columns(colid + LBound(Columns) - 1)
    Else
        getColumnName = ""
    End If
End Function

Private Sub Class_Initialize()
    ReDim DataArray(1)
    ReDim Columns(1)
End Sub
