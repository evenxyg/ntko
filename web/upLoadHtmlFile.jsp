<%@ page contentType="text/html;charset=utf-8" %>
<%@ page language="java" import="java.io.*,java.sql.*,java.util.*" %>
<%@ page language="java" import="org.apache.commons.fileupload.*,org.apache.commons.fileupload.disk.*,org.apache.commons.fileupload.servlet.*"%>
<%@ include file="connectionInfo.jsp"%>
<%@ include file="FilePathInfo.jsp"%>
<%!
public Connection conn = null;
public Statement stmt = null;
//public PreparedStatement pstmt = null;
public ResultSet rs = null;
public Object[] itemsArray= null;
public String dirPath = null;
public String htmlFileName = "";

public int GetMaxID()
{
	int mResult=0;
	String mSql=new String();
	mSql = "select max(id)+1 as MaxID from "+htmlFileInfoTableName;
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
		mResult=0;
	}
	return (mResult);
}

public boolean deleteFolder(File dir)   
{   
	  boolean result=false;
      File filelist[]=dir.listFiles();   
      int listlen=filelist.length;  
      if(dir.exists()) 
      {
	      for(int i=0;i<listlen;i++)   
	      {   
	          if(filelist[i].isDirectory())   
	          {   
	              deleteFolder(filelist[i]);   
	          }   
	          else   
	          {   
	              filelist[i].delete();   
	          }   
	      }   
	      dir.delete();//删除当前目录 
	      result = true;
      }
      else
      { result = true;}
      return result;
 }
public boolean saveHtmlFilesToDisk()
{
	boolean result=true;
	FileItem curFileItem = null ;
	File upLoadFile = null ;
	String fileName = "";
	for(int i=0;i<itemsArray.length;i++)
	{
		curFileItem=(FileItem)itemsArray[i];
		if(!curFileItem.isFormField())
		{
			fileName = curFileItem.getName();	
			if(fileName!=null)
			{
				fileName=fileName.substring(fileName.lastIndexOf("\\")+1);
				if(curFileItem.getFieldName().equalsIgnoreCase("uploadHtml"))
				{
					upLoadFile =  new File(dirPath+"\\"+fileName);
					try
					{
						curFileItem.write(upLoadFile);
					}
					catch(Exception Error)
					{
						result=false;
						continue;
					}
				}
			}else{continue;}
		}
	}
	return result;
}
%>
<%
	//乱码加这个解决
	request.setCharacterEncoding("utf-8");

	int id=0;
	int totalFileSize = 0;
	String fileName = "";
	String SqlStr ="";
	String fileUrl = "";
	String result = "";
	File htmlFileDir = null ;
	FileItem curFileItem = null ;
	List fileItemsList = null;
	
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
	{out.println("no file upload");return;}
	for(int i=0;i<itemsArray.length;i++)
	{
		curFileItem=(FileItem)itemsArray[i];
		
		if(curFileItem.isFormField()&&curFileItem.getFieldName().equalsIgnoreCase("htmlFileName"))
		{
			htmlFileName = curFileItem.getString("utf-8");
		}
		else{
			totalFileSize+=curFileItem.getSize();
		}
	}
	//out.println("fileName="+htmlFileName+"<br>");
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
		//创建用于保存html文件的目录,目录名称取为:数据库中该的id+".htmlfile."+html文件的名称
		dirPath = absoluteHtmlFileDir + id + ".htmlfile." + htmlFileName ;
		htmlFileDir=new File(dirPath);
		if(htmlFileDir.exists())
		{
			deleteFolder(htmlFileDir);
		}
		if(htmlFileDir.mkdir())
		{
			if(saveHtmlFilesToDisk())
			{
				SqlStr="insert into " +htmlFileInfoTableName+ "(id,FileName,filepath,fileSize)values("+id+",'"+htmlFileName+"','"+relativeHtmlFileUrl+id + ".htmlfile." + htmlFileName+"/"+htmlFileName+"',"+totalFileSize+")";
				try{
					stmt.execute(SqlStr);
					result="文档保存成功。";
				}
				catch(SQLException Error)
				{
					out.println("stmt.execute(SqlStr) Error:"+Error.getMessage());
					return;
				}
			}
			else{result="insert to disk faild";}
			//out.println("创建目录成功");
		}
		else
		{out.println("create folder faild");return;}
	}
	try
	{
		//if(pstmt!=null)pstmt.close(); 
		if(stmt!=null)stmt.close(); 
		if(conn!=null)conn.close(); 
	}
	catch(Exception Error)
	{
		out.println(result+"<br>")	;
		out.println(Error.getMessage());
		out.println("数据库资源清理失败.");
	}
	finally
	{out.println(result);}
	
	//*/	
%>