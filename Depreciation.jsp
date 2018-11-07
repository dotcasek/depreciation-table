
<html> 
	<head>
		<title>Depreciation Calculator</title>
	</head>
	<body>
	<a href="http://localhost:8080/derek/Depreciation.htm">Return Home</a>
		<table width = "60%" align = "center" border = "5" bgcolor="lightblue">
		<col width ="20%">
		<col width ="20%">
		<col width ="20%">
			<tr>
			<th align ="center"> Year</th>
			<th align ="center"> Depreciation</th>
			<th align ="center"> Accum. Depreciation</th>
			</tr>

			<%
			try{
			double cost = Double.parseDouble(request.getParameter("value"));
			double scrap = Double.parseDouble(request.getParameter("scrap"));
			int years = Integer.parseInt(request.getParameter("years"));
			int mode = Integer.parseInt(request.getParameter("depMode"));				
			
			double accum = 0;
			switch (mode){

				// Straight Line
				case 1: 
				for (int i = 1; i <= years; i++){
					double dep = (cost-scrap)/years; %>
					<tr>
					<td><center><%=i%></center></td>
					<td><center><%=String.format("$%.2f", dep)%></center></td>
					<td><center><%=String.format("$%.2f", accum+=dep)%></center></td>
					</tr>
				<%}
				break;
				
				// Sum of Years
				case 2:
				double sumYears = (years *(years+1))/2;
				int temp = years;
				for (int i = 1; i <= years; i++){
					double dep = temp/sumYears*(cost-scrap); %>
					<tr>
					<td><center><%=i%></center></td>
					<td><center><%=String.format("$%.2f", dep)%></center></td>
					<td><center><%=String.format("$%.2f", accum+=dep)%></center></td>
					</tr>
				<% temp--;
				}
				break;
				
				// Units of Production
				case 3:
				
				String units[] = request.getParameterValues("unitsPerYear");
				if(units[0].equals("-999")){
					 %>
				<form method = "get">
				<table width = "60%" align = "center" border = "5" bgcolor="lightgreen">
				<tr>
				<td align = "center">
				<table>
				<tr><th>Enter total units of Production: </th>
				<td><input type = "text" name = "totalUnits"></td></tr>
				<input type="hidden" name="value" value="<%=cost%>" />
				<input type="hidden" name="scrap" value="<%=scrap%>" />
				<input type="hidden" name="years" value="<%=years%>" />
				<input type="hidden" name="depMode" value="<%=mode%>" />
				
				<%for (int i = 1; i <= years; i++){%>
				
					<tr><td align = "right">Enter units for year <% out.print(i); %>: </td>
					<td><input type = "text" name = "unitsPerYear"></td></tr>
				<%}%>
				</table>
				</td>
				</tr>
				</table>
				<center>
				<br>
				<input type = "submit" name = "submit"></td>
				</center>
				<%}
				else{
				
					double total = Double.parseDouble(request.getParameter("totalUnits"));
					double sum = 0;
	
					for(int i = 0; i< years; i++){
						sum += (Double.parseDouble(units[i])*(cost-scrap)/total);	
					}
					if(sum != (cost-scrap)){
						%>
						<center>
						<h1>Invalid Data</h1>
						</center>
						<center>expected: <%=cost-scrap%> | actual: <%=sum%></center>
												
						<%
					}
					else{
						for (int i = 1; i <= years; i++){
							double dep = Double.parseDouble(units[i-1]); %>
						 <tr>
						 <td><center><%=i%></center></td>
						 <td><center><%=String.format("$%.2f", dep*(cost-scrap)/total)%></center></td>
						 <td><center><%=String.format("$%.2f", accum+=(dep*(cost-scrap)/total))%></center></td>
						 </tr>
						<%}
					}
				}
			
				%>
				</table>
				<%
				
				break;
				
				// Double Declining Balance
				case 4:
				
				double varCost = cost;
				for (int i = 1; i <= years; i++){
					double dep = (2.0/years)*varCost;
					if(i == years){
						dep = (cost-scrap)-accum;
					}
					%>
					<tr>
					<td><center><%=i%></center></td>
					<td><center><%=String.format("$%.2f", dep)%></center></td>
					<td><center><%=String.format("$%.2f", accum+=dep)%></center></td>
					</tr>
				<% varCost-=dep;
				}
				break;
			}
			}
			catch (Exception e){%>
				<center>
				<h1>Invalid Data</h1>
				</center>
			<% } %>
	</table>
	</body>
	</html>