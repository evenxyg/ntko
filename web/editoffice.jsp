<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page language="java" import="java.io.*,java.sql.*,oracle.jdbc.*" %>
<%@ include file="connectionInfo.jsp"%>
<%@ include file="FilePathInfo.jsp"%>
<%
    request.setCharacterEncoding("iso-8859-1");
    response.setCharacterEncoding("UTF-8");
%>
<%
boolean isNewFile ;
String filetype="";
String fileId="";
String fileName="";
String fileUrl="";
String attachFileName="";
String attachFileDescribe="";
String attachFileUrl="";
String templateFileUrl="templateFile/";//新建文档模板url
String otherData="";
Connection conn = null;
Statement stmt = null;
ResultSet rs = null;
fileId = request.getParameter("FileId")==null?"":request.getParameter("FileId").toString().trim();
if(fileId=="")
{isNewFile = true;}
else
{isNewFile = false;}
if(isNewFile)
{
	filetype=request.getParameter("fileType")==null?"":request.getParameter("fileType").trim();//如果filetype参数为空,默认为word文档.
	if(filetype.equalsIgnoreCase("excel"))
	{	
		fileName="新建Excel文档.xls";
		templateFileUrl=templateFileUrl+"newExcelTemplate.xls";
	}
	else if(filetype.equalsIgnoreCase("word")){
		fileName="新建word文档.doc";
		templateFileUrl=templateFileUrl+"newWordTemplate.doc";
	}
	else if(filetype.equalsIgnoreCase("ppt"))
	{
		fileName="新建ppt文档.ttp";
		templateFileUrl=templateFileUrl+"newPptTemplate.ppt";	
	}
	else{
		filetype="word";
		fileName="新建word文档.doc";
		templateFileUrl=templateFileUrl+"newWordTemplate.doc";
	}
	fileUrl=templateFileUrl;//如果是新文档，控件打开新建模板文档
}
else
{
	try
	{Class.forName(DBDriver);}
	catch(java.lang.ClassNotFoundException e)
	{out.println("Error:" + e.getMessage());}
	try
	{
		conn = DriverManager.getConnection(ConnStr,userName,userPasswd);    
		stmt=conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	} 
	catch(SQLException e)
	{out.println("Error:" + e.getMessage());}
	rs = stmt.executeQuery("select * from "+officeFileInfoTableName+" where id="+fileId); 
	if(rs.next())
	{
		fileName = rs.getString("FILENAME");	
		fileUrl = relativeOfficeFileUrl+rs.getString("FILENAMEDISK");
		otherData = rs.getString("OTHERDATA");
		filetype=rs.getString("filetype");
		if(filetype.equalsIgnoreCase("Word.Document"))
		{filetype="word";}
		else if(filetype.equalsIgnoreCase("Excel.Sheet"))
		{filetype="excel";}
		else if(filetype.equalsIgnoreCase("PowerPoint.Show"))
		{filetype="ppt";}
		else{filetype="othertype";}
		attachFileDescribe = rs.getString("ATTACHFILEDESCRIBE")==null?"":rs.getString("ATTACHFILEDESCRIBE").trim();
		attachFileName = rs.getString("ATTACHFILENAMEDISK")==null?"":rs.getString("ATTACHFILENAMEDISK").trim();
		attachFileUrl=attachFileName.equalsIgnoreCase("")?"":(relativeAttachFileUrl+attachFileName);
	}
	if(rs != null)rs.close();
	if(stmt != null)stmt.close();
	if(conn != null)conn.close();	
}
	/***************************************************************
	计算印章列表的字符串
	***************************************************************/
									String espFilesList="";
                  class Filter implements FilenameFilter   
								  {   
									  String extension;      
									  Filter(String extension)   
									  {   
									  	this.extension = extension;   
									  }    
									  public boolean accept(File myFile,String filename)   
									  {   
									  	return filename.endsWith("."+extension);   
									  }   
								  }   
									File espPath = new File(absoluteSecSignFileDir);   
				          File[] fileList;     
				          fileList=espPath.listFiles(new Filter("esp"));   

				          for(int i=0;i<fileList.length;i++) 
				          {
				          	espFilesList+=" <option value=\""+relativeSecSignFileDir+fileList[i].getName()+"\">"+fileList[i].getName()+"</option>";
				          }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>ntko office文档控件示例-ms office文档编辑</title>
<meta content="IE=7" http-equiv="X-UA-Compatible" /> 
		<!--设置缓存-->
		<meta http-equiv="cache-control" content="no-cache,must-revalidate">
		<meta http-equiv="pragram" content="no-cache">
		<meta http-equiv="expires" content="0">
    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
   <script type="text/javascript" src="OfficeContorlFunctions.js"></script>
</head>
<body  onload='intializePage("<%=fileUrl%>")' onbeforeunload ="onPageClose()">
    <form id="form1" action="upLoadOfficeFile.jsp" enctype="multipart/form-data" style="padding:0px;margin:0px;">
    <div id="editmain" class="editmain">
        <div id="edittop" class="top">
        <img alt="重庆软航科技有限公司示例程序" src="images/edit_banner.jpg" />
        </div>
        <div id="editmain_top" class="editmain_top">
                <div id="edit_button_div" class="edit_button_div">
                <img alt="保存office文档" src="images/edit_save_office.gif" onclick="saveFileToUrl();" />
                <img alt="保存html文档" src="images/edit_save_html.gif" onclick="saveFileAsHtmlToUrl();"/>
                <img alt="保存PDF" src="images/edit_save_pdf.gif" onclick="saveFileAsPdfToUrl();"/>
                <img alt="示例程序帮助文档" src="images/demohelp.jpg" onclick="NtkoHelp();"/>
                </div>
            <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td><img src="images/edit_main_top.jpg"  alt="文件列表上框" /></td>
                </tr>
                <tr>
                    <td class="edittablebackground"><!--示例标题--><b>ntko office文档控件示例-ms office文档编辑</b></td>
                </tr>
            </table>
        </div>
        <div id="editmain_middle" class="editmain_middle">
            <div id="editmain_left" class="editmain_left">
                <div class="funbutton">
                    <ul class="ul">
                    <li class="listtile">界面设置:</li>
                    <li onclick="OFFICE_CONTROL_OBJ.Menubar=!OFFICE_CONTROL_OBJ.Menubar;">菜单栏栏切换</li>
                    <li onclick="OFFICE_CONTROL_OBJ.ToolBars=!OFFICE_CONTROL_OBJ.ToolBars;">工具栏栏切换</li>
                    <li onclick="OFFICE_CONTROL_OBJ.IsShowInsertMenu=!OFFICE_CONTROL_OBJ.IsShowInsertMenu;">"插入"菜单切换</li>
                    <li onclick="OFFICE_CONTROL_OBJ.IsShowEditMenu=!OFFICE_CONTROL_OBJ.IsShowEditMenu;">"编辑"菜单切换</li>
                    <li onclick="OFFICE_CONTROL_OBJ.IsShowToolMenu=!OFFICE_CONTROL_OBJ.IsShowToolMenu;">"工具"菜单切换</li>
                    </ul>
                </div>
                <div class="funbutton">
                    <ul class="ul">
                    <li class="listtile">打印控制:</li>
                    <li onclick="setFilePrint(true);">允许打印</li>
                    <li onclick="setFilePrint(false);">禁止打印</li>
                    <li onclick="OFFICE_CONTROL_OBJ.showDialog(5);">页面设置</li>
                    <li onclick="OFFICE_CONTROL_OBJ.PrintPreview();">打印预览</li>
                    </ul>
                </div>
                <div class="funbutton">
                    <ul class="ul">
                    <li class="listtile">印章和图片功能:</li>
                    <li class="listtile">
                    <select id="SignFileUrl" onchange="var signUrl=document.all('SignFileUrl').options[document.all('SignFileUrl').selectedIndex].value;if(signUrl==''){}else  addServerSign(signUrl);">
                    <option value="" "selected">请选择服务器印章</option>
										<%=espFilesList%>
                    </select>
                  </li>
                  <li class="listtile">
										<select id="picFileUrl" onchange="var picURL=document.all('picFileUrl').options[document.all('picFileUrl').selectedIndex].value;if(picURL==''){}else addPicFromUrl(picURL);">
	                    <option value="" "selected">请选择服务器图片</option>
											<option value="secSignFile/smallattproduct.jpg">服务器图片1</option>
											<option value="secSignFile/smalldocproduct.jpg">服务器图片2</option>
											<option value="secSignFile/smallsgnproduct.jpg">服务器图片3</option>
											<option value="secSignFile/standard.gif">服务器图片4</option>
	                  </select>
	                </li>
                    <li onclick="addLocalSign();">添加本地印章</li>
                    <li onclick="doHandSign();">手写签名</li>
                    <li onclick="OFFICE_CONTROL_OBJ.SetReadOnly(true,'',1);">保护印章</li>
                    <li onclick="OFFICE_CONTROL_OBJ.SetReadOnly(false);">取消保护</li>
                    <li onclick="DoCheckSign();">印章验证</li>
                    <li onclick="OFFICE_CONTROL_OBJ.ActiveDocument.AcceptAllRevisions();">接受修订</li>
                    </ul>
                </div>
                <div class="funbutton">
                    <ul class="ul">
                    <li class="listtile">模板套红功能:</li>
                    <%
                    if(filetype.equalsIgnoreCase("word"))
                    {
                    %>
                    <li>
                    <select id="redHeadTemplateFile" onchange="var headFileURL=document.all('redHeadTemplateFile').options[document.all('redHeadTemplateFile').selectedIndex].value;if(headFileURL==''){};else insertRedHeadFromUrl(headFileURL);">
                        <option value="" "selected">请选择模板进行套红</option>
                        <option value="templateFile/sendFileRedHead.doc">发送文件红头</option>
                        <option value="templateFile/receiveReadHead.doc">接收文件红头</option>
                        <option value="templateFile/archivesRedHead.doc">办公文件红头</option>
                    </select>
                  </li>
                  <li>
                    <select id="templateFile" onchange="var templateFileUrl=document.all('templateFile').options[document.all('templateFile').selectedIndex].value;if(templateFileUrl==''){};else openTemplateFileFromUrl(templateFileUrl);">
                    <option value="" "selected">请选择模板进行打开</option>
                        <option value="templateFile/elegantReportTemplate.doc">典雅型报告模板</option>
                        <option value="templateFile/elegantMemoTemplate.doc">典雅型备忘录模板</option>
                        <option value="templateFile/elegantCommunicationTemplate.doc">典雅型通讯模板</option>
                        <option value="templateFile/theNorthSTLimitedCompanyTemplate.doc">北方科技有限公司模板</option>
                    </select>
                  </li>
                    <li onclick="TANGER_OCX_AddDocHeader('某某政府机关红头文件');">动态编程套红</li>
                    <%
                    }
                  	else if(filetype.equalsIgnoreCase("excel"))
                  	{
                  	%>
                  <li>
                  	<select id="templateFile" onchange="var templateFileUrl=document.all('templateFile').options[document.all('templateFile').selectedIndex].value;if(templateFileUrl==''){};else openTemplateFileFromUrl(templateFileUrl);">
                    <option value="" "selected">请选择模板进行打开</option>
                        <option value="templateFile/financialReportTemplate.xls">财务报表模板</option>
                        <option value="templateFile/cashFluxTemplate.xls">现金流量模板</option>
                    </select>
                  </li>
                  	<%
                  	}
                  	else if(filetype.equalsIgnoreCase("ppt"))
                  	{
                  	%>
                  	<li>
                  	<select id="templateFile" onchange="var templateFileUrl=document.all('templateFile').options[document.all('templateFile').selectedIndex].value;if(templateFileUrl==''){};else openTemplateFileFromUrl(templateFileUrl);">
                    <option value="" "selected">请选择模板进行打开</option>
                        <option value="templateFile/marketPanningTemplate.ppt">市场计划演示模板</option>
                        <option value="templateFile/humanResourcePolicyTemplate.ppt">人事政策演示模板</option>
                        <option value="templateFile/ideaTemplate.ppt">集思广义演示模板</option>
                    </select>
                  </li>
                  	<%
                  	}
                    %>
                    </ul>
                </div>
                <div class="funbutton">
                    <ul class="ul">
                    <li class="listtile">痕迹保留功能:</li>
                    <li onclick="SetReviewMode(true);">保留痕迹</li>
                    <li onclick="SetReviewMode(false);">取消留痕</li>
                    <li onclick="setShowRevisions(true);">显示痕迹</li>
                    <li onclick="setShowRevisions(false);">隐藏痕迹</li>
                    <li onclick="OFFICE_CONTROL_OBJ.ActiveDocument.AcceptAllRevisions();">接受修订</li>
                    </ul>
                </div>
                <div class="funbutton">
                    <ul class="ul">
                    <li class="listtile">权限控制:</li>
                    <li onclick="OFFICE_CONTROL_OBJ.SetReadOnly(true);">禁止编辑</li>
                    <li onclick="OFFICE_CONTROL_OBJ.SetReadOnly(false);">允许编辑</li>
                    <li onclick="setFileNew(true);">允许新建</li>
                    <li onclick="setFileNew(false);">禁止新建</li>
                    <li onclick="setFileSaveAs(true);">允许另存</li>
                    <li onclick="setFileSaveAs(false);">禁止另存</li>
                    <li onclick="setIsNoCopy(false);">允许拷贝</li>
                    <li onclick="setIsNoCopy(true);">禁止拷贝</li>
                    </ul>
                </div>
            </div>
            <div id="editmain_right" class="editmain_right">
                <div id="formtop">
                    <table>
                        <tr>
                            <td colspan="5"  class="edit_tabletitle">文件表单数据:</td>
                        </tr>
                        <tr>
                            <td colspan="5">&nbsp;</td>
                        </tr>
                        <tr>
                            <td width="7%"> 文&nbsp;件&nbsp;ID:</td>
                            <td width="20%"><input name="fileId" id="fileId" readOnly  type="text" value="<%=fileId%>" /></td>
                            <td width="8%">文件名称:</td>
                            <td width="40%"><input name="filename" id="filename" type="text" value="<%=fileName%>" /></td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>其它数据:</td>
                            <td><input id="otherData" name="otherData" align="left" type="text" value="<%=otherData%>" /></td>
                            <td>上传文件:</td>
                            <td><input class=fileup name="attachFile" type=file id="attachFile" />&nbsp;(选择附件)<br><input name="attachFileDescribe" type=text id=attachFileDescribe value="<%=attachFileDescribe%>" >&nbsp;(附件说明)</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr><td>文档附件:</td>
                            <td colspan="4">
                            <!--附件列表-->
                            <%if(!isNewFile&&!attachFileUrl.equalsIgnoreCase(""))
														{
														%>
														<a href="<%=attachFileUrl%>" target=uploadattachfile>点击下载</a>&nbsp;(<%=attachFileDescribe==""?"没有说明":"附件说明："+attachFileDescribe%>)<br>
														<%
														}
														else
														out.println("没有附件");
														%>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="esptoolbar" class="esptoolbar">
                <span class="listtile">安全电子印章系统功能:</span>
                    <select id="secSignFileUrl" style="width:100px;">
				         <%=espFilesList%>
                    </select>
                    <div id="esptoolbutton" class="esptoolbutton">
                    <ul>
                        <li onclick="addServerSecSign();">加盖选择印章</li>
                        <li onclick="addLocalSecSign();">从本机盖章</li>
                        <li onclick="addHandSecSign();">手写签名</li>
                        <li onclick="">服务器印章管理</li>
                    </ul>
                    </div>
                    <!--<b style="font-size:12px;color:red;">[以上为最基本的文档调用电子印章功能演示,如不能使用,请点击<a href="downLoadedFiles\NTKOSecHandSignDemoSetup.exe">这里</a>下载"安全签名印章系统"]</b><br>-->
                </div>
                <div id="officecontrol">
<SPAN STYLE="color:red">如果不能装载控件。请确认你可以连接网络或者检查浏览器的选项中安全设置。<a href="http://www.ntko.com/control/officecontrol/officecontrol.zip">下载演示产品</a></SPAN>
                <script type="text/javascript" src="http://www.ntko.com/control/officecontrol/ntkoofficecontrol.js"></script>
                <div id=statusBar style="height:20px;width:100%;background-color:#c0c0c0;font-size:12px;"></div>
								<script language="JScript" for=TANGER_OCX event="OnDocumentClosed()">
									setFileOpenedOrClosed(false);
								</script>
								<script language="JScript" for="TANGER_OCX" event="OnDocumentOpened(TANGER_OCX_str,TANGER_OCX_obj)">
									
									OFFICE_CONTROL_OBJ.activeDocument.saved=true;//saved属性用来判断文档是否被修改过,文档打开的时候设置成ture,当文档被修改,自动被设置为false,该属性由office提供.
									//获取文档控件中打开的文档的文档类型
									switch (OFFICE_CONTROL_OBJ.doctype)
									{
										case 1:
											fileType = "Word.Document";
											fileTypeSimple = "wrod";
											break;
										case 2:
											fileType = "Excel.Sheet";
											fileTypeSimple="excel";
											break;
										case 3:
											fileType = "PowerPoint.Show";
											fileTypeSimple = "ppt";
											break;
										case 4:
											fileType = "Visio.Drawing";
											break;
										case 5:
											fileType = "MSProject.Project";
											break;
										case 6:
											fileType = "WPS Doc";
											fileTypeSimple="wps";
											break;
										case 7:
											fileType = "Kingsoft Sheet";
											fileTypeSimple="et";
											break;
										default :
											fileType = "unkownfiletype";
											fileTypeSimple="unkownfiletype";
									}
									setFileOpenedOrClosed(true);
								</script>
									<script language="JScript" for=TANGER_OCX event="BeforeOriginalMenuCommand(TANGER_OCX_str,TANGER_OCX_obj)">
									alert("BeforeOriginalMenuCommand事件被触发");
								</script>
								<script language="JScript" for=TANGER_OCX event="OnFileCommand(TANGER_OCX_str,TANGER_OCX_obj)">
									if (TANGER_OCX_str == 3) 
									{
										alert("不能保存！");
										CancelLastCommand = true;
									}
								</script>
								<script language="JScript" for=TANGER_OCX event="AfterPublishAsPDFToURL(result,code)">
									result=trim(result);
									alert(result);
									document.all("statusBar").innerHTML="服务器返回信息:"+result;
									if(result=="文档保存成功。")
									{window.close();}
								</script>
								<script language="JScript" for=TANGER_OCX event="OnCustomMenuCmd2(menuPos,submenuPos,subsubmenuPos,menuCaption,menuID)">
								alert("第" + menuPos +","+ submenuPos +","+ subsubmenuPos +"个菜单项,menuID="+menuID+",菜单标题为\""+menuCaption+"\"的命令被执行.");
								</script>
                </div>
            </div>
        </div>
       <div id="edit_bottom" class="edit_bottom">
       <img alt="" src="images/edit_main_nether.jpg" />
           <div id="conmpanyinfo" class="conmpanyinfo">
            <img alt="重庆软航科技有限公司" src="images/Companyinfo.jpg" />
             <p>技术支持详见公司网站www.ntko.com “联系我们”</p>
            
            </div>
        </div>
    </div>
    </form>
</body>
</html>
