<script type="text/javascript" src="http://localhost:8080/myzk/js/jquery-1.11.3.js"></script>
<script type="text/javascript" src="http://localhost:8080/myzk/js/jstree.min.js"></script>
<script type="text/javascript">
    String.prototype.endsWith = function(suffix) {
        return this.indexOf(suffix, this.length - suffix.length) !== -1;
    };
    $(function () {
		var to = false;
		$('#search').keyup(function () {
			if(to) { clearTimeout(to); }
			to = setTimeout(function () {
				var v = $('#search').val();
				$('#zkTree').jstree(true).search(v);
			}, 250);
		});
    	// ajax demo
    	$('#zkTree').jstree({
    		'core' : {
    			'data' : {
    				"url" : "http://localhost:8080/myzk/zk/children.do",
    				"dataType" : "json" // needed only if you do not supply JSON headers
    			}
    		},
			"types" : {
				"#" : { "max_children" : 100, "max_depth" : 20, "valid_children" : ["root"] },
				"root" : { "icon" : "/static/3.1.1/assets/images/tree_icon.png", "valid_children" : ["default"] },
				"default" : { "valid_children" : ["default","file"] },
				"file" : { "icon" : "glyphicon glyphicon-file", "valid_children" : [] }
			},
			"plugins" : [ "contextmenu", "search", "state", "types", "wholerow" ,"ui","unique"]
    	
    	});
     });
     function searchnodes(){
         var searchPath=$('#search_path').val();
         window.location.href='/node-zk/tree?path='+searchPath;
         $(parent.document.body).find('#content').attr('src', "/node-zk/get?path="+searchPath);
     }
    var zkhosts = '<%= request.getAttribute("host") %>';
    window.onload=function(){
        var splitstr= new Array();
        splitstr=zkhosts.split(',');
        $("#zkhosts").append(splitstr.join('<br/>'));
    }
</script>
  <link rel="stylesheet" href="http://localhost:8080/myzk/css/style.min.css" />
<link rel='stylesheet', href='http://localhost:8080/myzk/js/themes/classic/style.css'/>
<!--<link rel='stylesheet', href='stylesheets/style.css'/>  -->
<div id="container">
     <h2><a target="_blank" href="https://github.com/killme2008/node-zk-browser" style='text-decoration:none;'>Node-ZK-Browser</a></h2>
     <div>ZK Cluster :</div>
     <div style='margin-bottom:25px;margin-top:5px;' id='zkhosts'></div>
     <div>
         <input type="text" id="search_path" value='<%= request.getAttribute("path") %>' style='height:30px;font-size:18px;'/>
         <input type="button" id="search_op" onclick="searchnodes()" value="Goto" class="btnStyle"/>
     </div>
     <div id="zkTree"></div>
</div>
