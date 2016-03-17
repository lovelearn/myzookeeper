<html>
    <head><title>zk-config-manager</title>
	    <link rel='stylesheet', href='<%=request.getContextPath()%>/css/stylesheets/style.css'/>
    </head>
    <frameset cols="30%,*">
          <frame src="<%=request.getContextPath()%>/zk/tree.do" id="tree" name="tree">
          <frame src="<%=request.getContextPath()%>/zk/getNode.do" id="content" name="content"/>
     </frameset>
</html>
