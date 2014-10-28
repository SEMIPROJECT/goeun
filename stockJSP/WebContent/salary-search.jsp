<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<title>�޿� ��ȸ</title>
</head>
<body>
<h2>�μ��� ���� �޿� ��ȸ</h2>
<form method="post" action="salary-search.jsp">
	<select name="search">
		<option value="deptno">�μ��ڵ�</option>
		<option value="posname">����</option>
	</select>
	<input type="text" name="searchText"	/>
	<input type="submit" value="�˻�"	/>
</form>
<table border="1">
	<tr>
		<th>�μ��ڵ�</th><th>����</th><th>�⺻�޿�</th>
	</tr>
<%
	request.setCharacterEncoding("euc-kr");
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String sql = "";
	
	String search = request.getParameter("search");
	String searchText = request.getParameter("searchText");
	
	try{
		Class.forName("org.gjt.mm.mysql.Driver");
		String url = "jdbc:mysql://localhost:3306/testboard";
		con = DriverManager.getConnection(url, "root", "1111");
		
		if(searchText.isEmpty()){
			sql = "select * from salary inner join positions on salary.posno=positions.posno";
		}
		else{
			// deptno, posno-posname, salary
			sql = "select * from salary inner join positions "
							+ "on " + search + " like '%" + searchText + "%' and salary.posno=positions.posno";
			//out.println(sql);
		}
		pstmt = con.prepareStatement(sql);
		rs = pstmt.executeQuery();

		while(rs.next()){
%>
	<tr>
		<td><%=rs.getInt("deptno") %></td>
		<td><%=rs.getString("posname") %></td>
		<td><%=rs.getInt("salary") %></td>
	</tr>
<%
		}
	}
	catch(Exception err){
		System.out.println("salary-search.jsp : " + err);
	}
	finally{
		if(rs != null)try{		rs.close();	}	catch(Exception err){}
		if(pstmt != null)try{		pstmt.close();	}	catch(Exception err){}
		if(con != null)try{		con.close();	}	catch(Exception err){}
	}
%>
</table>
</body>
</html>