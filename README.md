# ntko
ntko使用示例for mysql


本示例为ntko office文档控件的jsp+mysql示例，所有文档的信息保存到mysql数据库中，文档文件保存到服务器磁盘。

1请先以管理员身份进入mysql，创建数据库,代码如下【createdatabse.sql文件为建立数据及表的sql语句】：
1）:创建数据库代码
create database ntko DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

2):添加用户权限
GRANT ALL ON ntko.* TO root@localhost;

3):进入数据库
USE ntko;

4):创建office文档信息表【ntkoofficefile】
create table ntkoofficefile (id int not null primary key auto_increment,
filename varchar(256),
filesize int,
otherdata varchar(128),
filetype varchar(64),
filenamedisk varchar(256),
attachfilenamedisk varchar(256),
attachfiledescribe varchar(256)
);
 

5):创建html文件信息表【ntkohtmlfile】
create table ntkohtmlfile( id int not null primary key auto_increment,
filename varchar(256),
filepath varchar(256),
filesize int);
 

6):创建pdf文件信息表【ntkopdffile】
create table ntkopdffile(id int not null primary key auto_increment,
pdffilename varchar(256),
pdffilepath varchar(256),
filesize int);
 
2程序各文件夹说明，由于程序可能会在以下文件夹中创建或修改文件，请授予相关用户修改以下文件夹的权限。

downLoadedFiles 用于存放文档控件的cab包和安全签名印章系统安装程序.
secSignFile 存放电子印章系统使用的印章文件
tempFile 上传所需的临时文件文件夹
templateFile 放置文档模板的文件夹
uploadAttachFile 存放上传附件的文件夹
uploadHtmlFile  office文档保存为html格式到服务器,存放html文件的文件夹
uploadOfficeFile 保存office文档的文件夹
uploadPdfFile  保存pdf文件的文件夹

请配置示例程序时,在FilePathInfo.jsp中设置tempFile（临时文件目录）, uploadAttachFile（文档附件目录）,uploadHtmlFile（html文件目录）, uploadOfficeFile（文档目录），secSignFile（印章文件目录）文件夹的服务器绝对磁盘路径.

3:本示例使用mysql数据库,tomcat服务器.
如有中文名称的文件不能打开,有可能是tomcat服务器配置,不支持中文url.   打开server.xml,并在在Connector中添加  URIEncoding="UTF-8"
类似:
<Connector port="8080" protocol="HTTP/1.1" connectionTimeout="20000" redirectPort="8443" URIEncoding="UTF-8"/>
注意：
若文档控件调用安全电子印章系统功能不能使用，请先关闭所有应用程序，再安装downLoadedFiles目录下的安全印章系统【TKOSecHandSignDemoSetup.exe】。
若word文档保存为pdf功能不能使用，请先关闭所有应用程序，到这里下载安装pdf虚拟打印机[pdfcreator-0_9_5_setup.exe].


