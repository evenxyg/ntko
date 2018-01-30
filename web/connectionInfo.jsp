<%!
	/******************************************
	说明:此文件是用来显示文件列表的
	*******************************************/
	//这儿需要修改成您的数据库连接信息
	
	public String userName="root";//数据库用户名
	public String userPasswd="mysql"; //密码
	public String dbName="ntko";	   //数据库名
	
	public String officeFileInfoTableName = "ntko.NTKOOFFICEFILE";
	public String htmlFileInfoTableName = "ntko.NTKOHTMLFILE"; //表名	
	public String pdfFileInfoTableName = "ntko.NTKOPDFFILE" ;

	public String DBDriver = "com.mysql.jdbc.Driver"; 
	public String ConnStr = "jdbc:mysql://localhost:3306/"+dbName+"?useUnicode=true&characterEncoding=utf-8&user="+userName+"&password="+userPasswd;

%>