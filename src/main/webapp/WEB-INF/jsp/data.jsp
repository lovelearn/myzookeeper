<html>
    <head>
        <link rel='stylesheet' href='<%=request.getContextPath()%>/css/stylesheets/style.css'/>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/jsl.parser.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/json2.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/dataformate.js"></script>
        <script type="text/javascript">
            function delete_path(){
                var path=$('#delete_form').find("input[name='path']").val();
                var lastPartIndex=path.lastIndexOf("/");
                var parenPath=path.substring(0,lastPartIndex);

                if(confirm("Are you sure want to delete "+path+" ?")){
                    $.post("<%=request.getContextPath()%>/zk/delete.do",$('#delete_form').serialize(),function(rt){
                        alert(rt);
                        if(rt=='"Delete ok"'){
                            //$(parent.document.body).find('#tree').attr('src', "/node-zk/tree?path="+parenPath);
                            var tree_innerHTML = $(parent.tree.document).contents().find("#zkTree").html();
                            //alert(tree_innerHTML);
                            var deleted_path = 'path="'+path+'"';
                            var index = tree_innerHTML.indexOf(deleted_path);
                            if (index > 0) {
                                var before_part = tree_innerHTML.substring(0, index);
                                var after_part = tree_innerHTML.substring(index);

                                index = before_part.lastIndexOf("<LI");
                                if (index < 0) {
                                    index = before_part.lastIndexOf("<li");
                                }
                                before_part = $.trim(before_part.substring(0, index));

                                index = after_part.indexOf("</LI>");
                                if (index < 0) {
                                    index = after_part.indexOf("</li>");
                                }
                                after_part = $.trim(after_part.substring(index+5));

                                if ((after_part.substring(0,5) == '</UL>' || after_part.substring(0,5) == '</ul>')
                                    && (before_part.substring(before_part.length-4) == '<UL>' || before_part.substring(before_part.length-4) == '<ul>')){
                                    before_part = before_part.substring(0, before_part.length-4);
                                    after_part = after_part.substring(5);
                                }
                                var new_content = before_part + after_part;
                                //alert(new_content);
                                $(parent.tree.document).contents().find("#zkTree").empty();
                                $(parent.tree.document).contents().find("#zkTree").append(new_content);
                            }
                            window.location.href="<%=request.getContextPath()%>/zk/getNode.do?path="+parenPath;
                        }
                    });
                }
            }
            function show_detail(){
                var detail_info=$("#node_detail");
                if(detail_info.is(":hidden")){
                    detail_info.show();
                    $("#show_detail").text('hide');
                }else{
                    detail_info.hide();
                    $("#show_detail").text('show detail');
                }
            }

            var old_value = '';
            var temp_value = '';
            function checkData(){
                 var nodeValue=$.trim($("#new_data").val());
                 if(nodeValue != undefined && nodeValue != '' && nodeValue != null && nodeValue != 'null'){
                     var check_value = JSONDATA.formatJsonData(nodeValue);
                     if (check_value != '') {
                        $('#new_data').val(check_value);
                     } else {
                        return false;
                     }
                 }
                 return true;
            }
            window.onload=function(){
                // old value
                var old_value=$.trim($("#data").val());
                // initial data to json formate
                if(old_value != undefined && old_value != '' && old_value != null && old_value != 'null'){
                    temp_value = JSONDATA.formatJsonData(old_value);
                    if (temp_value != '') {
                       $('#new_data').val(temp_value);
                    } else {
                       $('#new_data').val(old_value);
                    }
                }
                // bind click event
                $("#check_data").click(function(e){
                    var check_result = checkData();
                    if(check_result){
                        // 
                    }
                    $("#new_data").focus();
                });
                $("#save_data").click(function(e){
                    
                    var check_result = checkData();
                    if( !check_result ){
                        $("#new_data").focus();
                        return false;
                    }
                    temp_value = $.trim($("#new_data").val());
                    var compress_data = '';
                    if(temp_value!=undefined && temp_value!='' && temp_value!=null && temp_value!="null"){
                        compress_data = JSONDATA.compressJsonData(temp_value);
                    }

                    // compare compressed value
                    if(compress_data != old_value){

                          $('#new_data').val(compress_data);
                          $.post("<%=request.getContextPath()%>/zk/edit.do",$("#edit_form").serialize(),function(data){
                               //alert(data);
                               //$(parent.content.document).empty();
                               //$(parent.content.document).append(data);
                               window.location.href="<%=request.getContextPath()%>/zk/getNode.do?path=${path}";
                          });
                    }
                    return false;
                });
            }
        </script>
    <head>
    <body>
        <div class= "container">
            <div id='login'>
                <h3>Welcome,<%= request.getAttribute("user") %> </h3>
            </div>
            <table class= "table table-bordered">
               <tr>
                 <td><label style="font-weight:bold;">Path:</label></td>
                 <td><span style="font-weight:bold;"><%= request.getAttribute("path") %></span>
                     <% if(request.getAttribute("user") != null){ %>
                          <a href='#' onclick="delete_path();" class="btnStyle">delete</a><a href="<%=request.getContextPath()%>/zk/gotoadd.do?path=${path}" target="content" class="btnStyle">create</a>
                          <form id='delete_form' onsubmit="return;">
                          <input type='hidden' name='path' value='${path}'/>
                          <input type='hidden' name='version' value='${stat.version}'/>
                          </form>
                     <% } %>
                 </td>
              </tr>
              <tr>
                <td><label>Node Stat:</label></td>
                <td><a href='#' id='show_detail' onclick="show_detail();" class="btnStyle">show detail</a></td>
              </tr>
           </table>
           <table class= "nodetable" id='node_detail' style='display:none;'>
              <tr>
                <th>name</th>
                <th>value</th>
              </tr>
              <tr><td>czxid</td><td>${stat.czxid}</td></tr>
              <tr><td>mzxid</td><td>${stat.mzxid}</td></tr>
              <tr><td>pzxid</td><td>${stat.pzxid}</td></tr>
              <tr><td>dataLength</td><td>${stat.dataLength}</td></tr>
              <tr><td>numChildren</td><td>${stat.numChildren}</td></tr>
              <tr><td>version</td><td>${stat.version}</td></tr>
              <tr><td>cversion</td><td>${stat.cversion}</td></tr>
              <tr><td>aversion</td><td>${stat.aversion}</td></tr>
              <tr><td>ctime</td><td>${stat.ctime}</td></tr>
              <tr><td>mtime</td><td>${stat.mtime}</td></tr>
              <tr><td>ephemeralOwner</td><td>${stat.ephemeralOwner}</td></tr>
           </table>
           <hr/>
           <label>Data (JSON format): </label>
           <input type='hidden' value='${data}' id='data' />
           <div id='data_container' >

               <form id='edit_form'>
                   <input type='hidden' name='path' value='${path}'/>
                   <input type='hidden' name='version' value='${stat.version}'/>
                   <table>
             <% if(request.getAttribute("user") != null){ %>
                   <tr><td colspan='1'><textarea cols='90' rows='15' name='new_data' id='new_data' style="width:650px;"
                       spellcheck="false" placeholder="NO DATA OR EMPTY VALUE. can enter JSON format data."></textarea></td></tr>
                   <tr>
                       <td colspan="1"><input type='button' id='check_data' value="Check data" class="btnStyle"/><input type='submit' value='Save' id='save_data' class="btnStyle" style="margin-left:20px;"/></td>
                   </tr>
             <% }else{ %>
                   <tr><td colspan='1'><textarea cols='90' rows='15' name='new_data' id='new_data' style="width:650px;" readonly='readonly'
                       spellcheck="false" placeholder="NO DATA OR EMPTY VALUE"></textarea></td></tr>
             <% } %>
                   </table>
               </form>

           </div>
       </div>
    </body>
</html>
