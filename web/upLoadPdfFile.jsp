<%@ page contentType="text/html;charset=utf-8" %>
<%@ page language="java" import="java.io.*,java.sql.*,oracle.jdbc.*,java.util.*" %>
<%@ page language="java" import="org.apache.commons.fileupload.*,org.apache.commons.fileupload.disk.*,org.apache.commons.fileupload.servlet.*"%>
<%@ include file="connectionInfo.jsp"%>
<%@ include file="FilePathInfo.jsp"%>
<%!
public Connection conn = null;
public Statement stmt = null;
public ResultSet rs = null;
public Object[] itemsArray= null;
public int id = 0;
public String pdfFileName = "";
public String ErrorMessage ="";
public FileItem pdfFileItem = null;

public int GetMaxID()
{
	int mResult=0;
	String mSql=new String();
	mSql = "select max(id)+1 as MaxID from "+pdfFileInfoTableName;
	try
	{
		rs = stmt.executeQuery(mSql); 
		if(rs.next())
		{
			mResult=rs.getInt("MaxID");

		}
		rs.close();
		if(mResult==0) mResult=1;
	}
	catch(SQLException e)
	{
		System.out.println("error:"+e.getMessage());
		ErrorMessage+="GetMaxID SQLException:"+e.getMessage();		
		mResult=0;
	}
	return (mResult);
}
public boolean savePdfFileToDisk()
{
	boolean result=false;
	FileItem curFileItem = null;
	ErrorMessage="";
	for(int i=0;i<itemsArray.length;i++)
	{
		curFileItem=(FileItem)itemsArray[i];
		//判断该域是否是控件提交的pdf文件,"uploadPdf"为PublishAsPdfToURL中的第2个参数,域名
		if(!curFileItem.isFormField()&&curFileItem.getFieldName().equalsIgnoreCase("uploadPdf"))
		{
			pdfFileItem = curFileItem;
			pdfFileName = curFileItem.getName();
			pdfFileName = pdfFileName.substring(pdfFileName.lastIndexOf("\\")+1);
			pdfFileName = id + ".pdffile."+pdfFileName;//为防止重名,取名为ID+".pdffile."+原文件名称
			File pdfFile =  new File(absolutePdfFileDir+pdfFileName);
			try
			{
				curFileItem.write(pdfFile);
				result = true;
			}
			catch(Exception Error)
			{
				ErrorMessage +="curFileItem.write error:"+Error.getMessage()+"<br>";
				result=false;
			}
			break;
		}
	}
	return 	result;
}
%>
<%
	String result ="";
	String SqlStr ="";
	List fileItemsList = null;
	int fileSize = 0;
	
	DiskFileItemFactory factory = new DiskFileItemFactory();
	// 设置最多只允许在内存中存储的数据,单位:字节
	factory.setSizeThreshold(4096);
	// 设置一旦文件大小超过setSizeThreshold()的值时数据存放在硬盘的目录
	factory.setRepository(new File(tempFileDir));
	ServletFileUpload upload = new ServletFileUpload(factory);
	//设置允许用户上传文件大小,单位:字节
	upload.setSizeMax(1024*1024*4);
	
	fileItemsList = upload.parseRequest(request);
	itemsArray=fileItemsList.toArray();
	if(itemsArray.length==0)
	{out.println("no file upload");return;}//absolutePdfFileDir
	try
	{
		Class.forName(DBDriver);
	}catch(ClassNotFoundException e)
	{out.println("error"+e.getMessage());return;}
	try
	{
		conn = DriverManager.getConnection(ConnStr,userName,userPasswd);    
		stmt=conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	}catch(SQLException e)
	{out.println("error:"+e.getMessage());return;}
	id=GetMaxID();
	if(id!=0)
	{
		if(savePdfFileToDisk())
		{
			fileSize = (int)pdfFileItem.getSize();
			SqlStr="insert into "+pdfFileInfoTableName+" (id,pdffilename,pdffilepath,filesize)values("+id+",'"+pdfFileName+"','"+relativePdfFileUrl+pdfFileName+"'," +fileSize+")";
			try
			{
				stmt.execute(SqlStr);
				result =  "文档保存成功。";
			}
			catch(SQLException Error)
			{
				out.println(SqlStr+"<br>");
				out.println(Error.getMessage());
				result="save to database failed";}
		}
		else{result="failed to save pdffile to server disk";}
	}
	out.println(result);
%>