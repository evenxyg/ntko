<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page language="java" import="java.io.*,java.sql.*" %>
<%@ include file="connectionInfo.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>ntko office文档控件示例-首页</title>
    <meta content="IE=7" http-equiv="X-UA-Compatible" /> 
    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
    <script type=text/javascript>
			function showFileEditPage(URL,tWidth,tHeight)
			{
				//dlgFeatures = "dialogWidth:"+screen.width+"px;dialogHeight:"+screen.height+"px;top:0;left:0;resizable:no;center:yes;location:no;status:no";
				//window.showModalDialog(URL,"",dlgFeatures);
				var winFeatures = "toolbar=yes,location=yes,directories=yes,status=yes,menubar=yes,scrollbars=yes,resizable=yes,copyhistory=no,"+"width="+screen.width+"px,height="+screen.height;
				window.open(URL,"",winFeatures);
				window.location.reload();
			}
		</script>
</head>
<body>
    <form id="form1">
    <div id="default" class="divdefault">
        <div id="top" class="top">
        <img src="images/index_banner.jpg" alt="ntko文档控件示例"/>
        </div>
        <div id="maindiv_top" class="maindiv_top">
                <div id="index_button_div" class="index_button_div">
                <img alt="创建新的word文档" src="images/index_button_word.gif" onclick='javascript:showFileEditPage("editoffice.jsp?fileType=word",900,800);' />
                <img alt="创建新的excel文档" src="images/index_button_xls.gif" onclick='javascript:showFileEditPage("editoffice.jsp?fileType=excel",900,800);'/>
                <img alt="创建新的PPT文档" src="images/index_button_ppt.gif" onclick='javascript:showFileEditPage("editoffice.jsp?fileType=ppt",900,800);'/>
                <!--
                <img alt="创建新的wps文字" src="images/index_button_wps.gif" onclick='javascript:showFileEditPage("editwps.jsp?fileType=wps",900,800);'/>
                <img alt="创建新的WPS 表格" src="images/index_button_et.gif" onclick='javascript:showFileEditPage("editwps.jsp?fileType=et",900,800);'/>
                -->
                <a href="espEdit.jsp" style="color:blue;" target="mSecSign">印章管理</a>
                <a href="配置说明.doc" style="color:blue;">帮助文档</a>
								
                </div>
            <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td><!--示例标题--><b>ntko office文档控件示例-文件列表</b></td>
                </tr>
                <tr>
                    <td><img src="images/index_main_top.gif"  alt="文件列表上框" /></td>
                </tr>
                <tr>
                    <td class="tablebackground"></td>
                </tr>
            </table>
       </div>
       <div id="maindiv_middle" class="maindiv_middle">
           <div id="wordlist" class="officelist">
           <span>OFFICE文件列表:</span>

               <table class="tabletitle">
                   <tr><td width="10%">文&nbsp;件&nbsp;I&nbsp;D</td><td width="30%">文&nbsp;件&nbsp;标&nbsp;题</td><td width="25%">文&nbsp;档&nbsp;类&nbsp;型</td><td width="20%">文&nbsp;件&nbsp;大&nbsp;小</td><td width="25%">相&nbsp;关&nbsp;操&nbsp;作</td></tr>
               </table>
               <table class="tablefilelist">
               <%
									Connection conn = null;
									Statement stmt = null;
									ResultSet rs = null;
									try
									{Class.forName(DBDriver);}
									catch(java.lang.ClassNotFoundException e)
									{out.println("Error:" + e.getMessage());}
									try
									{
										//conn = DriverManager.getConnection(ConnStr,userName,userPasswd);    
										conn = DriverManager.getConnection(ConnStr);
										stmt=conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
										rs = stmt.executeQuery("select * from "+officeFileInfoTableName+" order by filetype");
									} 
									catch(SQLException e)
									{out.println("Error:" + e.getMessage());}
									while(rs.next())
									{
									%>
									<tr><td width="10%"><%=rs.getInt("ID")%></td><td width=30%><%=rs.getString("FileName")%></td><td width="25%"><%=rs.getString("FileType")%></td><td width="20%"><%=rs.getString("FileSize")%></td><td width="25%"><a href="javascript:showFileEditPage('editoffice.jsp?FileId=<%=rs.getInt("ID")%>',900,800);" > 编辑 </a></td></tr>
									<%
									}
									if(rs != null)rs.close();
									%>
									<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
               </table>
           </div>
           <div id="htmllist" class="officelist">
           <span>HTML文件列表:</span>
            <table class="tabletitle">
               <tr><td width="10%">文&nbsp;件&nbsp;I&nbsp;D</td><td width="55%">文&nbsp;件&nbsp;标&nbsp;题</td><td width="20%">文&nbsp;件&nbsp;大&nbsp;小</td><td width="25%">相&nbsp;关&nbsp;操&nbsp;作</td></tr>
           </table>
           <table class="tablefilelist">
                <!--HTML文件列表数据-->
                <% 		
								rs = stmt.executeQuery("select * from "+htmlFileInfoTableName); 
								while(rs.next())
								{
								%>
								<tr><td width="10%"><%=rs.getInt("ID")%></td><td width="55%"><%=rs.getString("FileName")%></td><td width="20%"><%=rs.getString("FileSize")%></td><td width="25%"><a href="<%=rs.getString("FilePath")%>" target=htmlfile>查看 </a></td></tr>
								<%
								}
								%>
								<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
           </table>
           </div>
           <div id="pdflist" class="officelist">
           <span>PDF文件列表:</span>
            <table class="tabletitle">
                 <tr><td width="10%">文&nbsp;件&nbsp;I&nbsp;D</td><td width="55%">文&nbsp;件&nbsp;标&nbsp;题</td><td width="20%">文&nbsp;件&nbsp;大&nbsp;小</td><td width="25%">相&nbsp;关&nbsp;操&nbsp;作</td></tr>
           </table>
           <table class="tablefilelist">
                <!--PDF文件列表数据-->
                
                <% 		
								rs = stmt.executeQuery("select * from "+pdfFileInfoTableName); 
								while(rs.next())
								{
								%>
								<tr><td width="10%"><%=rs.getInt("ID")%></td><td width="55%"><%=rs.getString("pdfFileName")%></td><td width="20%"><%=rs.getString("FileSize")%></td><td width="25%"><a href="<%=rs.getString("pdfFilePath")%>" target=htmlfile>下载 </a></td></tr>
								<%
								}
								if(rs != null)rs.close();
								if(stmt != null)stmt.close();
								if(conn != null)conn.close();
								%>
								<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
           </table>
           </div>
       </div>
       <div id="maindiv_bottom" class="maindiv_bottom">
       <img alt="" src="images/index_main_nether.jpg" />
           <div id="conmpanyinfo" class="conmpanyinfo">
            <img alt="重庆软航科技有限公司" src="images/Companyinfo.jpg" />
              <p>技术支持详见公司网站www.ntko.com “联系我们”</p>
            </div>
       </div>
    </div>
    </form>
</body>
</html>
