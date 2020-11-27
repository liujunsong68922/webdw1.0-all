// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   TableServlet.java

package com.liu;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

import javax.servlet.*;
import javax.servlet.http.*;

// Referenced classes of package com.liu:
//            TransSql, CEmpty

public class TableServlet extends HttpServlet {

	public TableServlet() {
		s_ok = "OK";
		s_error = "ERROR";
		s_oper_query = "1";
		s_oper_exec = "2";
		s_oper_tablelist = "3";
		s_oper_columnlist = "4";
		s_oper_beginTrans = "begintrans";
		s_oper_addcommand = "addcommand";
		s_oper_commit = "commit";
		s_oper_rollback = "rollback";
		s_oper_getdwdefine = "getdwdefine";
		s_oper_getvbfile = "getvbfile";
		ClassInfo = "";
	}

	public void init(ServletConfig config) throws ServletException {
		System.out.println("____________TableServlet init....");
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("GBK");
		int beginpos = 0;
		int readnum = 100;
		System.out.println("enter service TableServlet.Welcome.");
		String operType = request.getParameter("opertype");
		String command = request.getParameter("command");
		String param = request.getParameter("param");
		String strans = request.getParameter("transid");
		System.out.println("command=" + command);
		if (request.getParameter("beginpos") != null && request.getParameter("beginpos").trim().length() > 0)
			beginpos = Integer.parseInt(request.getParameter("beginpos"));
		if (request.getParameter("readnum") != null && request.getParameter("readnum").trim().length() > 0)
			readnum = Integer.parseInt(request.getParameter("readnum"));
		int col = 0;
		if (operType == null)
			operType = "";
		if (command == null)
			command = "";
		if (param == null)
			param = "";
		response.setContentType("text/html;charset=GBK");
		// ServletOutputStream out = response.getOutputStream();
		ServletOutputStream out = null;

		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		
		//test connection
		if (operType.equals("")) {
			if (out == null) {
				out = response.getOutputStream();
			}
			out.print(s_ok);
			return;
		}
		
		//get dwfile
		if (operType.equals(s_oper_getdwdefine)) {
			try {
				doGetDWFile(command,   response);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if (out == null) {
			out = response.getOutputStream();
		}
		
		try {
			conn = getConnection();
			conn.setAutoCommit(false);
			stat = conn.createStatement();
		} catch (Exception e) {
			e.printStackTrace();
			out.print("OK");
			return;
		}
		if (operType.equals(s_oper_tablelist))
			command = "select TNAME,TABTYPE from tab";
		if (operType.equals(s_oper_columnlist))
			command = "Select CNAME from col where TNAME='" + command + "'";
		if (operType.equals(s_oper_query) || operType.equals(s_oper_tablelist) || operType.equals(s_oper_columnlist))
			try {
				doExecuteSelect(stat, rs, out, command, col, beginpos, readnum);
				conn.rollback();
			} catch (Exception e) {
				try {
					conn.rollback();
				} catch (Exception e1) {
					e1.printStackTrace();
				}
				e.printStackTrace();
				out.println(e.toString());
			}
		if (operType.equals(s_oper_exec))
			try {
				doExecuteUpdate(command, stat, conn);
			} catch (Exception e) {
				try {
					conn.rollback();
				} catch (Exception e1) {
					e1.printStackTrace();
				}
				e.printStackTrace();
				out.println(e.toString());
			}
		if (operType.equals(s_oper_beginTrans))
			try {
				doBeginTransaction(out);
			} catch (Exception e) {
				e.printStackTrace();
			}
		if (operType.equals(s_oper_addcommand))
			doAddCommand(strans, command);
		if (operType.equals(s_oper_commit))
			try {
				doCommit(strans, conn, stat);
			} catch (Exception e) {
				try {
					e.printStackTrace();
					Integer transId = new Integer(strans);
					TransSql sql = (TransSql) transHash.get(transId);
					if (sql != null) {
						sql.result = "commit failed";
						sql.commitDt = (new Date()).toString();
					}
					conn.rollback();
					out.println(e.toString());
				} catch (Exception e1) {
					e1.printStackTrace();
				}
			}
		if (operType.equals(s_oper_rollback))
			doRollback(strans);

		if (operType.equals(s_oper_getvbfile))
			try {
				doGetVBFile(command, out);
			} catch (Exception e) {
				e.printStackTrace();
			}
		out.print(s_ok);
		try {
			if (rs != null)
				rs.close();
			if (stat != null)
				stat.close();
			if (conn != null)
				conn.close();
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Database connection close failed.");
		} finally {
			try {
				conn.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return;
	}

	private Connection getConnection() throws Exception {
		String configfile = "com/liu/database.properties";
		String url = "";
		String driver = "";
		String userid = "";
		String passwd = "";
		ClassLoader loader = (new CEmpty()).getClass().getClassLoader();
		java.io.InputStream stream = loader.getResourceAsStream(configfile);
		Properties prop = new Properties();
		prop.load(stream);
		url = prop.getProperty("url");
		driver = prop.getProperty("driver");
		userid = prop.getProperty("userid");
		passwd = prop.getProperty("passwd");
		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, userid, passwd);
		return conn;
	}

	private void doExecuteSelect(Statement stat, ResultSet rs, ServletOutputStream out, String command, int col,
			int beginpos, int readnum) throws Exception {
		System.out.println("Sql = " + command);
		rs = stat.executeQuery(command);
		ResultSetMetaData meta = rs.getMetaData();
		String sline = "";
		for (col = 1; col <= meta.getColumnCount(); col++)
			if (col < meta.getColumnCount())
				sline = sline + meta.getColumnName(col) + "\t";
			else
				sline = sline + meta.getColumnName(col);

		out.println(sline);
		System.out.println("colname=" + sline);
		for (; beginpos > 0; beginpos--)
			if (!rs.next())
				break;

		for (; rs.next() && beginpos == 0 && readnum > 0; out.println(sline)) {
			sline = "";
			for (col = 1; col <= meta.getColumnCount(); col++)
				if (col < meta.getColumnCount())
					sline = sline + rs.getString(col) + "\t";
				else
					sline = sline + rs.getString(col);

			readnum--;
		}

	}

	private void doExecuteUpdate(String command, Statement stat, Connection conn) throws Exception {
		System.out.println("Sql = " + command);
		if (command != null || command.trim().length() >= 1) {
			String sqls[] = command.split("----------");
			for (int i = 0; i < sqls.length; i++) {
				System.out.println("sqls[i]:" + sqls[i]);
				if (sqls[i] == null || sqls[i].trim().length() == 0)
					break;
				stat.executeUpdate(sqls[i]);
			}

			conn.commit();
		}
	}

	private void doBeginTransaction(ServletOutputStream out) throws Exception {
		System.out.println("enter begintrans");
		synchronized (transId) {
			int id = transId.intValue();
			if (++id >= 1000)
				id = 0;
			transId = new Integer(id);
		}
		TransSql sql = (TransSql) transHash.get(transId);
		if (sql != null)
			transHash.remove(transId);
		sql = new TransSql();
		sql.transId = transId.intValue();
		sql.beginDT = (new Date()).toString();
		transHash.put(transId, sql);
		System.out.println(transId.toString());
		out.println(transId.toString());
	}

	private void doAddCommand(String stransId, String command) {
		Integer transId = new Integer(stransId);
		TransSql sql = (TransSql) transHash.get(transId);
		if (sql != null && command != null && !command.trim().equals(""))
			if (sql.transSQL.equals(""))
				sql.transSQL = command;
			else
				sql.transSQL = sql.transSQL + "\r\n" + command;
	}

	private void doCommit(String stransId, Connection conn, Statement stat) throws Exception {
		Integer transId = new Integer(stransId);
		TransSql sql = (TransSql) transHash.get(transId);
		if (sql != null && sql.result.trim().length() <= 0) {
			sql.result = "commit begin";
			String sqls[] = sql.transSQL.split("\r\n");
			for (int i = 0; i < sqls.length; i++) {
				System.out.println("sqls[i]:" + sqls[i]);
				if (sqls[i] == null || sqls[i].trim().length() == 0)
					break;
				stat.executeUpdate(sqls[i]);
			}

			conn.commit();
			sql.commitDt = (new Date()).toString();
			sql.result = "commit finish";
		}
	}

	private void doRollback(String stransId) {
		Integer transId = new Integer(stransId);
		TransSql sql = (TransSql) transHash.get(transId);
		if (sql != null && sql.result.trim().length() <= 0) {
			sql.result = "rollback";
			sql.commitDt = (new Date()).toString();
		}
	}

	private void doGetDWFile(String command, HttpServletResponse response) throws Exception {
		String filepath = "C://webdwfile//dwfile//";
		String filename = "";
		if (command.indexOf(".") > 0)
			filename = filepath + command;
		else
			filename = filepath + command + ".srd";
		System.out.println("Want file:" + filename);
		File dwfile = new File(filename);
		if (dwfile.exists()) {
			FileReader fstream = new FileReader(filename);
			BufferedReader in = new BufferedReader(fstream);
			String sout = "";
			for (String record = ""; (record = in.readLine()) != null;) {
				sout += record;
			}
			response.getWriter().write(sout);
			response.getWriter().close();
			//out.println(sout);

			in.close();
		}
	}

	private void doGetVBFile(String command, ServletOutputStream out) throws Exception {
		String filepath = "C://webdwfile//VBfile//";
		String filename = "";
		filename = filepath + command;
		System.out.println("Want VB file:" + filename);
		File vbfile = new File(filename);
		if (vbfile.exists()) {
			FileReader fstream = new FileReader(filename);
			BufferedReader in = new BufferedReader(fstream);
			for (String record = ""; (record = in.readLine()) != null;)
				out.println(record);

			in.close();
		}
	}

	public static Hashtable transHash = new Hashtable();
	private String s_ok;
	private String s_error;
	private String s_oper_query;
	private String s_oper_exec;
	private String s_oper_tablelist;
	private String s_oper_columnlist;
	private String s_oper_beginTrans;
	private String s_oper_addcommand;
	private String s_oper_commit;
	private String s_oper_rollback;
	private String s_oper_getdwdefine;
	private String s_oper_getvbfile;
	private static Integer transId = new Integer(0);
	private String ClassInfo;

}
