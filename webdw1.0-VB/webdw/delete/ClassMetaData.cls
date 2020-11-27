VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassMetaData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem CopyRight Mr.Liu Junsong 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------
Rem 这个类用来提供数据库的元数据
Rem 供开发人员来访问元数据
Rem 这个类准确的来说只是一个接口定义
Rem 具体的实现要依靠在服务器端的后台功能来实现
Rem 目前先采用一个伪装实现的方式来实现，用来构建原型

Option Explicit

'得到数据库的所有数据表和视图的列表
'返回值存放在一个字符串数组里面
'返回值代表数据表的数量
'具体实现以后进行仔细实现
Public Function getTableList(table() As String, maxNum As Integer) As Integer
    
    Dim sret As String              '执行sql得到的数据结果
        
    Rem 下面是模拟实现，真实代码不可用
    table(1) = "T_Book"
    table(2) = "T_Test"
    getTableList = 2
    Rem 模拟实现结束

End Function

'根据数据表名称，得到所有列名称的列表
'返回值存放在一个字符串数组里面
'返回值代表数据列的数量
'具体实现以后进行仔细实现

Public Function getColumnList(cols() As String, tablename As String) As Integer
    Rem 下面是模拟实现，真实代码不可用
    If tablename = "T_Book" Then
        cols(1) = "book_id"
        cols(2) = "book_name"
        getColumnList = 2
        Exit Function
    End If
    
    If tablename = "T_Test" Then
        cols(1) = "test_id"
        cols(2) = "test_name"
        getColumnList = 2
        Exit Function
    End If
    
    Rem 模拟实现结束
End Function
