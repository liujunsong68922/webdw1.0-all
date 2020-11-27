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
Rem CWebDWEditMask����һ�������࣬
Rem ��Ҫ������������¼��ʱ��ʽ����������
Rem ���������ʱҲͬ�����и�ʽ��
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @��Ȩ���� ������ 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit


'����һ�������ַ���������һ���༭�����ַ���
'���һ���Ѿ���ʽ���Ժ���ַ���
Public Function GetFormatString(inString As String, sformat As String, _
                                iDataType As Long) As String

End Function

'������Ĵ�����ֵ���ַ���������ָ����ʽ���и�ʽ��
'��һ�������������ֵ�����ݵ�����֧��
'����PB�Ĺ���
'#����1λ����
'0����1λ���֣��޶�Ӧλʱ��0����
'.С����
'�����ָ����
'�㷨���£�
'��С����Ϊ�磬��ͷ��ʼ����ԭ��ֵ���Ӧ�������־��
'�����ԭʼ����λ�� > ����λ�� ��ô��ȡԭʼλ��
'���: ԭʼ����λ�� = ����λ������������Ϊ#
'�����ԭʼ����λ�� < ����λ������������=0 ����ô����0
'����������ж����˷ָ���ţ���#,0)���⣬��ô���طָ����
Public Function GetFormateDecimal(inString As String, sformate As String)
    Dim pos1 As Long    'С������ԭʼ�����е�λ��
    Dim pos2 As Long    'С�����ڸ�ʽ�����е�λ��
    
    Dim orig_data1 As String    'ԭʼ����С����ǰ������
    Dim orig_data2 As String    'ԭʼ����С����������
    
    Dim form1 As String         'С����ǰ�Ķ����ʽ
    Dim form2 As String         'С�����Ķ����ʽ
    
    Dim form_data1 As String    '��ʽ�����С����ǰ�������
    Dim form_data2 As String    '��ʽ�����С������������
    
   
    If Not IsNumeric(inString) Then '����������ݲ���һ�����֣���ô��ʽ��Ϊһ�����ַ���
        GetFormateDecimal = ""
        Exit Function
    End If
    
    pos1 = InStr(inString, ".")     'ԭʼ����С����λ��
    pos2 = InStr(sformate, ".")     '��ʽ����С����λ��
    
    If pos1 > 0 And pos1 < Len(inString) Then
        orig_data1 = Left(inString, pos1 - 1)   '����λ
        orig_data2 = Mid(inString, pos1 + 1)    'С��λ
    Else
        orig_data1 = inString                   'ȫ��Ϊ����λ
        orig_data2 = ""                         'С������Ϊ��
    End If
    
    If pos2 > 0 And pos2 < Len(sformate) Then
        form1 = Left(sformate, pos2 - 1)    '����λ����
        form2 = Mid(sformate, pos2 + 1)     'С��λ����
    Else
        form1 = sformate
        form2 = ""
    End If
    
    
    '�ȼ���С��λ�ı��ֽ��
    form_data2 = ""
    Dim id As Long                          '�����ָ��
    Dim id2 As Long                         'ԭ���ݵ�ָ��
    Dim stemp As String                     '�����ڸ�ʽ����ĵ�ǰλ�õ�����
    Dim sdata As String                     '������ԭʼ���ݵĵ�ǰλ�õ�����
    
    id2 = 1
    For id = 1 To Len(form2)
        stemp = Mid(form2, id, 1)           'С�����ǰ����
        
        If stemp = "," Then                 '����Ƿָ���ţ�ֱ������һ���ָ����
            If id2 <= Len(orig_data2) Then
                form_data2 = form_data2 & ","
            End If
            
        ElseIf stemp = "#" Then             '�����#���жϵ�ǰ�����Ƿ�Ϊ0���߲�Ϊ�����㣬��Ϊ0������
            If id2 <= Len(orig_data2) Then
                sdata = Mid(orig_data2, id2, 1)
                form_data2 = form_data2 & sdata     '����С����������
                id2 = id2 + 1
            End If
                            
        ElseIf stemp = "0" Then
            If id2 <= Len(orig_data2) Then
                sdata = Mid(orig_data2, id2, 1)
                form_data2 = form_data2 & sdata     '����С����������
                id2 = id2 + 1
            Else
                sdata = "0"
                form_data2 = form_data2 & sdata     '����С������0
            End If
        Else                    '���붨�����ֱ���˳�
            GetFormateDecimal = inString
            Exit Function
        End If
    Next
        
    '�����������봦��
    Dim sswr_flag As Long
    If id2 <= Len(orig_data2) Then
        If Mid(orig_data2, id2, 1) > 4 Then
            sswr_flag = 1               '��Ҫ��λ
        Else
            sswr_flag = 0               '����Ҫ��λ
        End If
    End If
    
    '�ٴ���С����ǰ������ݣ����и�ʽ��
    form_data1 = ""
    id2 = Len(orig_data1)
    
    For id = Len(form1) To 1 Step -1
        stemp = Mid(form1, id, 1)
        
        If stemp = "," Then                     '��ǰԪ��Ϊ�ָ���ţ������ӷָ����
            If id2 > 0 Then
                form_data1 = "," & form_data1
            End If
            
        ElseIf stemp = "#" Then                 '��ǰԪ��Ϊ#
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
        Else                            '���붨�����ֱ���˳�
            GetFormateDecimal = inString
            Exit Function
        End If
    Next
    
    'С����֮ǰ�����ݲ����Ա�ʡ�Ե�
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
    
    '�����������������
    If sswr_flag Then
        '�ҵ���һ����Ϊ9�����֣���1���������ָ�Ϊ0
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
