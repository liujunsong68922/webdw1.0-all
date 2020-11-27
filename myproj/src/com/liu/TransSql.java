// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   TransSql.java

package com.liu;


public class TransSql
{

    public TransSql()
    {
        transId = 0;
        transSQL = "";
        beginDT = "";
        commitDt = "";
        result = "";
    }

    public int transId;
    public String transSQL;
    public String beginDT;
    public String commitDt;
    public String result;
}
