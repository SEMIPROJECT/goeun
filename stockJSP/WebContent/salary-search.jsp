<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<title>급여 조회</title>
</head>
<body>
<h2>부서별 직급 급여 조회</h2>
<form method="post" action="salary-search.jsp">
	<select name="search">
		<option value="deptno">부서코드</option>
		<option value="posname">직급</option>
	</select>
	<input type="text" name="searchText"	/>
	<input type="submit" value="검색"	/>
</form>
<table border="1">
	<tr>
		<th>부서코드</th><th>직급</th><th>기본급여</th>
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