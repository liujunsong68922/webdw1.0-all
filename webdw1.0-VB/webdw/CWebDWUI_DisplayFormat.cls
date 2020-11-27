VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDWDisplayFormat"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem CWebDWEditMask类是一个掩码类，
Rem 主要功能是在数据录入时格式化数据输入
Rem 在数据输出时也同样进行格式化
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @版权所有 刘峻松 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit


'给定一个输入字符串，加上一个编辑风格的字符串
'输出一个已经格式化以后的字符串
Public Function GetFormatString(inString As String, sformat As String, _
                                iDataType As Long) As String

End Function

'将输入的代表数值的字符串，按照指定格式进行格式化
'这一方法用来获得数值型数据的掩码支持
'按照PB的规则，
'#代表1位数字
'0代表1位数字，无对应位时用0补足
'.小数点
'，带分割符号
'算法如下：
'以小数点为界，从头开始计算原数值与对应的掩码标志。
'如果：原始数据位数 > 掩码位数 那么　取原始位数
'如果: 原始数据位数 = 掩码位数，而且掩码为#
'如果：原始数据位数 < 掩码位数，而且掩码=0 ，那么返回0
'如果：掩码中定义了分割符号（除#,0)以外，那么返回分割符号
Public Function GetFormateDecimal(inString As String, sformate As String)
    Dim pos1 As Long    '小数点在原始数据中的位置
    Dim pos2 As Long    '小数点在格式定义中的位置
    
    Dim orig_data1 As String    '原始数据小数点前的数据
    Dim orig_data2 As String    '原始数据小数点后的数据
    
    Dim form1 As String         '小数点前的定义格式
    Dim form2 As String         '小数点后的定义格式
    
    Dim form_data1 As String    '格式化后的小数点前面的数据
    Dim form_data2 As String    '格式化后的小数点后面的数据
    
   
    If Not IsNumeric(inString) Then '如果输入数据不是一个数字，那么格式化为一个空字符串
        GetFormateDecimal = ""
        Exit Function
    End If
    
    pos1 = InStr(inString, ".")     '原始数据小数点位置
    pos2 = InStr(sformate, ".")     '格式化中小数点位置
    
    If pos1 > 0 And pos1 < Len(inString) Then
        orig_data1 = Left(inString, pos1 - 1)   '整数位
        orig_data2 = Mid(inString, pos1 + 1)    '小数位
    Else
        orig_data1 = inString                   '全部为整数位
        orig_data2 = ""                         '小数部分为空
    End If
    
    If pos2 > 0 And pos2 < Len(sformate) Then
        form1 = Left(sformate, pos2 - 1)    '整数位定义
        form2 = Mid(sformate, pos2 + 1)     '小数位定义
    Else
        form1 = sformate
        form2 = ""
    End If
    
    
    '先计算小数位的表现结果
    form_data2 = ""
    Dim id As Long                          '掩码的指针
    Dim id2 As Long                         '原数据的指针
    Dim stemp As String                     '代表在格式定义的当前位置的掩码
    Dim sdata As String                     '定义在原始数据的当前位置的数据
    
    id2 = 1
    For id = 1 To Len(form2)
        stemp = Mid(form2, id, 1)           '小数点后当前掩码
        
        If stemp = "," Then                 '如果是分割符号，直接增加一个分割符号
            If id2 <= Len(orig_data2) Then
                form_data2 = form_data2 & ","
            End If
            
        ElseIf stemp = "#" Then             '如果是#，判断当前数据是否为0或者不为结束点，不为0则添加
            If id2 <= Len(orig_data2) Then
                sdata = Mid(orig_data2, id2, 1)
                form_data2 = form_data2 & sdata     '增加小数点后的数据
                id2 = id2 + 1
            End If
                            
        ElseIf stemp = "0" Then
            If id2 <= Len(orig_data2) Then
                sdata = Mid(orig_data2, id2, 1)
                form_data2 = form_data2 & sdata     '增加小数点后的数据
                id2 = id2 + 1
            Else
                sdata = "0"
                form_data2 = form_data2 & sdata     '增加小数点后的0
            End If
        Else                    '掩码定义错误，直接退出
            GetFormateDecimal = inString
            Exit Function
        End If
    Next
        
    '进行四舍五入处理
    Dim sswr_flag As Long
    If id2 <= Len(orig_data2) Then
        If Mid(orig_data2, id2, 1) > 4 Then
            sswr_flag = 1               '需要进位
        Else
            sswr_flag = 0               '不需要进位
        End If
    End If
    
    '再处理小数点前面的数据，进行格式化
    form_data1 = ""
    id2 = Len(orig_data1)
    
    For id = Len(form1) To 1 Step -1
        stemp = Mid(form1, id, 1)
        
        If stemp = "," Then                     '当前元素为分割符号，则添加分割符号
            If id2 > 0 Then
                form_data1 = "," & form_data1
            End If
            
        ElseIf stemp = "#" Then                 '当前元素为#
            If id2 > 0 Then
                sdata = Mid(orig_data1, id2, 1)
                form_data1 = sdata & form_data1
                id2 = id2 - 1
            End If
        ElseIf stemp = "0" Then
            If id2 > 0 Then
                sdata = Mid(orig_data1, id2, 1)
                form_data1 = sdata & form_data1
                id2 = id2 - 1
            Else
                sdata = "0"
                form_data1 = sdata & form_data1
            End If
        Else                            '掩码定义错误，直接退出
            GetFormateDecimal = inString
            Exit Function
        End If
    Next
    
    '小数点之前的数据不可以被省略掉
    If id2 > 0 Then
        sdata = Left(orig_data1, id2)
        form_data1 = sdata & form_data1
    End If
    
    Dim sretdata As String
    sretdata = form_data1 & "." & form_data2
    
    Dim firstpos As Long
    For firstpos = Len(sretdata) To 1 Step -1
        sdata = Mid(sretdata, firstpos, 1)
        If sdata <> "9" And sdata <> "," And sdata <> "." Then
            Exit For
        End If
    Next
    
    Dim ivalue As Long
    Dim ilen As Long
    Dim sret2 As String
    
    '考虑四舍五入的问题
    If sswr_flag Then
        '找到第一个不为9的数字，加1，后续数字改为0
        If firstpos > 0 Then
            sdata = Mid(sretdata, firstpos, 1)
            ivalue = sdata
            ivalue = ivalue + 1
            ilen = Len(sretdata)
            sret2 = ""
            For id = 1 To Len(sretdata)
                If id = firstpos Then
                    sret2 = sret2 & ivalue
                ElseIf id > firstpos Then
                    If Mid(sretdata, id, 1) = "9" Then
                        sret2 = sret2 & "0"
                    Else
                        sret2 = sret2 & Mid(sretdata, id, 1)
                    End If
                Else
                    sret2 = sret2 & Mid(sretdata, id, 1)
                End If
            Next
        Else
            sret2 = "1"
            For id = 1 To Len(sretdata)
                If Mid(sretdata, id, 1) = "," Or Mid(sretdata, id, 1) = "." Then
                    sret2 = sret2 & Mid(sretdata, id, 1)
                Else
                    sret2 = sret2 & "0"
                End If
            Next
        End If
    Else
        sret2 = sretdata
    End If
    
    GetFormateDecimal = sret2
End Function

