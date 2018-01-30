<%@ page contentType="text/html;charset=utf-8" %>
<%@ page language="java" import="java.io.*,java.util.List,java.lang.Object" %>
<%@ page language="java" import="org.apache.commons.fileupload.*,org.apache.commons.fileupload.disk.*,org.apache.commons.fileupload.servlet.*"%>
<%@ include file="FilePathInfo.jsp"%> 
<%
	List fileItemsList = null;
	Object[] itemsArray= null;
	FileItem secSignFileItem = null;
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
	
	for(int i=0;i<itemsArray.length;i++)
	{
		if(((FileItem)itemsArray[i]).getFieldName().equalsIgnoreCase("SIGNFILE")&&!((FileItem)itemsArray[i]).isFormField())
		{
			secSignFileItem=(FileItem)itemsArray[i];
		}
	}
	try
	{
		String signname = new String((secSignFileItem.getName()).getBytes("gbk"),"utf-8");
		secSignFileItem.write(new File(absoluteSecSignFileDir+signname));
		out.println("印章文件:"+secSignFileItem.getName()+",保存成功");
	}
	catch(Exception error)
	{
		out.println("save to disk error:"+error.getMessage());
	}
	
%>