<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=utf-8" %>
<%@ page language="java" import="java.io.*,java.util.*" %>
<%@ include file="FilePathInfo.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>ntko office文档控件示例&nbsp; 安全电子印章列表</title>
    <meta content="IE=7" http-equiv="X-UA-Compatible" /> 
    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" language="JavaScript">
        //安全电子印章系统函数
        var ntkosignctl = null; //初始化印章管理控件对象
        var filename = ""; //磁盘印章文件名
        var Signname = "";//印章文件名称
        //初始化控件对象
        function init(){
          ntkosignctl=document.all("ntkosignctl");
        }
        function CreateNewSign() {
            Signname = document.forms(0).SignName.value;
            document.forms(0).filename.value = Signname + ".esp";
            if ((Signname == '') || (undefined == typeof (Signname))) {
                alert('请输入印章名称');
                return false;
            }
            var Signuser = document.forms(0).SignUser.value;
            if ((Signuser == '') || (undefined == typeof (Signuser))) {
                alert('请输入印章使用人');
                return false;
            }
            var Password1 = document.forms(0).Password1.value;
            var Password2 = document.forms(0).Password2.value;
            if ((Password1 == '') || (Password2 == '') || (Password1 != Password2) || (undefined == typeof (Password1))) {
                alert('印章口令不能为空或者不一致');
                return false;
            }
            var Filename = document.forms(0).Filename.value;
            if ((Filename == '') || (undefined == typeof (Filename))) {
                alert('请选择印章源文件');
                return false;
            }
            //  alert("应该在此处增加代码，判断用户选择的源文件是否是图片文件。");
            ntkosignctl.CreateNew(Signname, Signuser, Password1, Filename);
            if (0 != ntkosignctl.StatusCode) {
                alert("创建印章错误.");
                return false;
            }
            alert("创建成功 请点击保存到服务器或者本地按钮.");
            return true;
        }
        //编辑印章文件
        function editesp(url) {
            ntkosignctl.OpenFromURL(url);
            document.forms(0).filename.value = url.substring(url.lastIndexOf("/") + 1, url.length);
            document.forms(0).SignName.value = ntkosignctl.SignName;
            document.forms(0).SignUser.value = ntkosignctl.SignUser;
            document.forms(0).Password1.value = ntkosignctl.PassWord;
            document.forms(0).Password2.value = ntkosignctl.PassWord;
            //ntkosignctl.height = ntkosignctl.SignHeight;
        }
        function savetourl() {
            //在后台，可以根据上传文件的inputname是否为"SIGNFILE"来判断
            //是否是印章控件上传的文件
            var Password1 = document.forms(0).Password1.value;
            var Password2 = document.forms(0).Password2.value;
            filename=document.forms(0).filename.value;
            if ((Password1 == '') || (Password2 == '') || (Password1 != Password2) || (undefined == typeof (Password1))) {
                alert('印章口令不能为空或者不一致');
                return false;
            }
            ntkosignctl.SignName= document.forms(0).SignName.value;
            ntkosignctl.SignUser = document.forms(0).SignUser.value;
            ntkosignctl.PassWord = document.forms(0).Password1.value;
            //SaveToURL方法保存印章文件
            var retStr = ntkosignctl.SaveToURL(document.forms(0).action, "SIGNFILE", "savetype=4", filename, 0);
            //判断是否保存成功，如果成功，刷新窗口
            if(ntkosignctl.StatusCode==0)
            {
            	alert("保存成功。");
            	window.close();
          	}
          	else{alert(retStr);}
        }

        function SaveToLocal() {
            ntkosignctl.SaveToLocal('', true);
            if (0 == ntkosignctl.StatusCode) {
                alert("保存成功!");
            }
            else {
                alert("保存错误.");
            }
            if(window.opener)
            window.opener.location.reload();
        }

</script>

</head>
<body onload="init()">
    <form id="sealform" method="post" enctype="multipart/form-data" action="upLoadEsp.jsp">
    <div id="default" class="divdefault">
        <div id="top" class="top">
        <img src="images/index_banner.jpg" alt="ntko文档控件示例"/>
        </div>
        <div id="maindiv_top" class="maindiv_top">
            <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td><!--示例标题-->ntko office文档控件示例</td>
                </tr>
                <tr>
                    <td><img src="images/index_main_top.gif"  alt="印章列表上框" /></td>
                </tr>
                <tr>
                    <td class="tablebackground"></td>
                </tr>
            </table>
       </div>
       <div id="maindiv_middle" class="maindiv_middle">
       <div id="esp_button_div" class="espbar">
            <ul>
                <li onclick="CreateNewSign();">创建印章</li>
                <li onclick="savetourl();">保存印章</li>
                <li onclick="SaveToLocal();">保存印章到本机</li>
                <li onclick="javascript:window.close();">关闭窗口</li>
            </ul>
            </div>
            <div id="espobject">
<SPAN STYLE="color:red">如果不能装载控件。请确认你可以连接网络或者检查浏览器的选项中安全设置。<a href="http://www.ntko.com/control/officecontrol/officecontrol.zip">下载演示产品</a></SPAN>
          	  <script type="text/javascript" src="http://www.ntko.com/control/officecontrol/signtoolcontrol.js"></script>
            <table>
                    <tr><td width="19%">正在编辑：</td><td width="81%"><input id="filename" name="filename" value="" type="text" disabled="disabled"/></td></tr>
                  <tr><td width="19%">印章名称：</td><td width="81%"><input name="SignName"/></td></tr>
                  <tr><td>印章使用者：</td><td><input name="SignUser"/></td></tr>
                  <tr><td>印章口令：</td><td><input type="password" name="Password1" value=""></td></tr>
                  <tr><td>确认口令：</td><td><input type="password" name="Password2" value=""/></td></tr>
                  <tr><td>印章源文件：</td><td><input type="file" name="Filename" class="fileup"/></td></tr>
                  <!--<tr><td>&nbsp;</td><td><img id="previewimg"></td></tr>-->
                </table>
            </div>
           <div id="wordlist" class="officelist">
           <span>电子印章文件列表:</span>
               <table class="tabletitle">
                   <tr><td width="25%">文&nbsp;件&nbsp;名&nbsp;称</td><td width="30%">修&nbsp;改&nbsp;日&nbsp;期</td><td width="20%">文&nbsp;件&nbsp;大&nbsp;小</td><td width="25%">相&nbsp;关&nbsp;操&nbsp;作</td></tr>
               </table>
               <table>
               <!--esp文件列表-->
               <%
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
				          %>
				          <TR class=mouseout onmouseover='this.className="mouseover"'onmouseout='this.className="mouseout"'>
									<TD width="25%"><%=fileList[i].getName()%></TD>
									<TD width="30%"><%=new Date(fileList[i].lastModified()).toString()%></TD>
									<TD width="20%"><%=fileList[i].length()%></TD>
									<TD width="25%"><A href='javascript:editesp("<%=relativeSecSignFileDir+fileList[i].getName()%>");'>&nbsp;编 辑&nbsp;</A></td>
									</tr>
				       <%
				       }
               %>
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