<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<jsp:forward page="/emps"></jsp:forward>--%>
<%
    pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<html>
<head>
    <title>Title</title>
    <!--引入jQuery-->
    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-3.4.1.min.js"></script>
    <!-- Bootstrap -->
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
</head>
<body>
<!-- 员工修改的模态框 -->
<div class="modal fade" id="empEditModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <input type="hidden" name="empId" id="empId_edit_static"/>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_edit_static"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_edit_input" placeholder="email@atguigu.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_edit_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_edit_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <!-- 部门提交部门id即可 -->
                            <select class="form-control" name="dId">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_edit_btn">更新</button>
            </div>
        </div>
    </div>
</div>
<!-- 员工添加的模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@atguigu.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <!-- 部门提交部门id即可 -->
                            <select class="form-control" name="dId">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">

    //清空表单样式
    function reset_form(ele) {
        $(ele)[0].reset();
        //清空表单样式
        $(ele).find("*").removeClass("has-error has-success");
        $(ele).find(".help-block").text("");
        $(ele).find("select").val();
    }

    //页面加载时执行
    $(function() {
        to_page(1);
        $("#emp_add_modal_btn").click(function () {
            $("#empAddModal").modal({
                backdrop : "static"
            })
            //清空表单信息和表单class
            reset_form("#empAddModal form")
            getDepartment("#empAddModal select");
        })

        //给每个编辑按键注册查询和模态框事件
        $(document).on("click",".edit_btn",function(){
            //打开编辑的模态框
            $("#empEditModal").modal({
                backdrop : "static"
            })
            //清空表单信息和表单class
            reset_form("#empEditModal form");
            //发送ajax查询员工信息填入模态框中
            getDepartment("#empEditModal select")
            getEmp($(this).attr("edit_id"));
        })

        //给check_all注册事件
        $("#check_all").click(function(){
            //attr获取的checked是undefined
            //使用修改和读取dom原生属性的值
            $(".check_item").prop("checked",$(this).prop("checked"));
        })

        //给check_item注册事件
        $(document).on("click",".check_item",function () {
            var flag = $(".check_item").length == $(".check_item:checked").length;
            $("#check_all").prop("checked", flag);
        })

        //给delBtn注册事件
        $(document).on("click",".delete_btn", function () {
            var empName = $(this).parents("tr").find("td:eq(2)").text();
            var empId = $(this).parents("tr").find("td:eq(1)").text();
            //发送确定信息确定用户删除用户信息
            if(confirm("确定删除【" +empName+ "】吗?")){
                //发送ajax删除用户信息
                $.ajax({
                    url : "${APP_PATH}/delEmp",
                    data : "empId=" + empId,
                    dataType : "json",
                    type : "POST",
                    success : function (result) {
                        alert(result.msg);
                        if(result.code == 100) {
                            to_page(currenPage);
                        }
                    }
                })
            }
        })

        //给emp_del_btn注册事件
        $("#emp_del_btn").click(function(){
            var empNames = "";
            var del_idstr = "";
            $.each($(".check_item:checked"),function(){
                empNames += $(this).parents("tr").find("td:eq(2)").text() + ",";
                del_idstr += $(this).parents("tr").find("td:eq(1)").text() + "-";
            })
            empNames = empNames.substring(0, empNames.length - 1);
            del_idstr = del_idstr.substring(0, del_idstr.length - 1);
            //确定用户是否删除员工信息
            if(empNames.length != 0) {
                if(confirm("确定删除【" +empNames+"】吗?")){
                    $.ajax({
                        url : "${APP_PATH}/delEmps",
                        dataType : "json",
                        data : "empIds="+del_idstr,
                        type : "POST",
                        success : function (result) {
                            alert(result.msg);
                            to_page(currenPage);
                        }
                    })
                }
            }
        })
    })






    //给保存用户信息按键注册事件
    $("#emp_save_btn").click(function(){
        //给员工姓名注册修改判断是否重复事件
        checkEmpName("#empName_add_input")
        saveEmp();
    })


    //给编辑按键注册事件更新员工信息
    $("#emp_edit_btn").click(function () {
        updateEmp();
    })




    //填充部门select
    function build_dept_select(result,ele) {
        var depts = result.extend.depts;
        $("#department_add_input").empty();
        var options;
        $.each(depts, function (index, item) {
            options = $("<option></option>").append(item.deptName).attr("value",item.deptId);
            options.appendTo(ele);
        })
    }

    //填充员工表
    function build_emps_table(result) {
        //清空表格
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        $.each(emps, function(index, item){
            var checkBox = $("<td><input type='checkbox' class='check_item' /></td>")
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var genderTd = $("<td></td>").append(item.gender);
            var emailTd = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.deptName);
            var editBtnTd = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                .append($("<span></span>")).addClass("glyphicon glyphicon-pencil").append("编辑");
            editBtnTd.attr("edit_id", item.empId);
            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                .append($("<span></span>")).addClass("glyphicon glyphicon-trash").append("删除");
            delBtn.attr("del_id", item.empId);
            var btnTd = $("<td></td>").append(editBtnTd).append(" ").append(delBtn);
            $("<tr></tr>").append(checkBox)
                .append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(emailTd)
                .append(deptNameTd)
                .append(btnTd)
                .appendTo("#emps_table tbody");
            /*
            <button class="btn btn-primary btn-sm">
                            <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                            编辑
                        </button>
                        <button class="btn btn-danger btn-sm">
                            <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                            删除
                        </button>
            */
        })
    }

    //填充分页信息
    function build_page_info(result) {
        var pageInfo = result.extend.pageInfo;
        //清空
        $("#page_info_area").empty();
        /*当前页，总页，总条记录*/
        $("#page_info_area").append("当前 " + pageInfo.pageNum +" 页，总 "
            + pageInfo.pages + "页，总 "
            + pageInfo.total +" 条记录");
        totalRecord = pageInfo.pages;
        currenPage = pageInfo.pageNum;

    }

    //填充分页条信息
    function build_page_nav(result){
        //page_nav_area
        $("#page_nav_area").empty();
        var ul = $("<ul></ul>").addClass("pagination");
        //构建元素
        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
        var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
        if(result.extend.pageInfo.hasPreviousPage == false){
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        }else{
            //为元素添加点击翻页的事件
            firstPageLi.click(function(){
                to_page(1);
            });
            prePageLi.click(function(){
                to_page(result.extend.pageInfo.pageNum -1);
            });
        }
        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
        if(result.extend.pageInfo.hasNextPage == false){
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        }else{
            nextPageLi.click(function(){
                to_page(result.extend.pageInfo.pageNum +1);
            });
            lastPageLi.click(function(){
                to_page(result.extend.pageInfo.pages);
            });
        }
        //添加首页和前一页 的提示
        ul.append(firstPageLi).append(prePageLi);
        //1,2，3遍历给ul中添加页码提示
        $.each(result.extend.pageInfo.navigatepageNums,function(index,item){

            var numLi = $("<li></li>").append($("<a></a>").append(item));
            if(result.extend.pageInfo.pageNum == item){
                numLi.addClass("active");
            }
            numLi.click(function(){
                to_page(item);
            });
            ul.append(numLi);
        });
        //添加下一页和末页 的提示
        ul.append(nextPageLi).append(lastPageLi);

        //把ul加入到nav
        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }

    //翻页查询
    function to_page(pn){
        //清空check_all的状态
        $("#check_all").prop("checked",false);
        $.ajax({
            url:"${APP_PATH}/emps",
            data:"pn="+pn,
            type:"GET",
            success:function(result){
                //console.log(result);
                //1、解析并显示员工数据
                build_emps_table(result);
                //2、解析并显示分页信息
                build_page_info(result);
                //3、解析显示分页条数据
                build_page_nav(result);
            }
        });
    }

    //清空表单样式及内容
    function reset_form(ele){
        $(ele)[0].reset();
        //清空表单样式
        $(ele).find("*").removeClass("has-error has-success");
        $(ele).find(".help-block").text("");
    }

    //检验表单数据
    function validate_add_form() {
        //1、拿到要校验的数据，使用正则表达式
        var empName = $("#empName_add_input").val();
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        if(!regName.test(empName)){
            //alert("用户名可以是2-5位中文或者6-16位英文和数字的组合");
            show_validate_msg("#empName_add_input", "error", "用户名可以是2-5位中文或者6-16位英文和数字的组合");
            return false;
        }else{
            show_validate_msg("#empName_add_input", "success", "");
        };

        //2、校验邮箱信息
        var email = $("#email_add_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if(!regEmail.test(email)){
            //alert("邮箱格式不正确");
            //应该清空这个元素之前的样式
            show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
            /* $("#email_add_input").parent().addClass("has-error");
            $("#email_add_input").next("span").text("邮箱格式不正确"); */
            return false;
        }else{
            show_validate_msg("#email_add_input", "success", "");
        }
        return true;
    }

    //显示校验结果的提示信息
    function show_validate_msg(ele,status,msg){
        //清除当前元素的校验状态
        $(ele).parent().removeClass("has-success has-error");
        $(ele).next("span").text("");
        if("success" == status){
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
        }else if("error" == status){
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }

    //发送ajax显示部门信息
    function getDepartment(ele) {
        //清楚原有部门信息
        $(ele).empty();
        $.ajax({
            url : "${APP_PATH}/depts",
            dataType : "json",
            type : "GET",
            success : function (result) {
                build_dept_select(result, ele);
            }
        })
    }

    //发送ajax获取员工信息填入edit模态框中
    function getEmp(edit_id) {
        $.ajax({
            url : "${APP_PATH}/getEmp",
            data : "empId="+edit_id,
            dataType : "json",
            type : "POST",
            success : function (result) {
                var item = result.extend.emp;
                //alert(result.msg);
                $("#empId_edit_static").val(item.empId);
                $("#empName_edit_static").text(item.empName);
                $("#email_edit_input").val(item.email);
                $("#empEditModal input[name=gender]").val([item.gender]);
                $("#empEditModal select").val([item.dId]);

            }
        })
    }

    //检验用户名是否重复
    function checkEmpName(ele) {
        $(ele).change(function () {
            var empName = $("#empName_add_input").val();
            $.ajax({
                url : "${APP_PATH}/checkEmpName",
                data : "empName=" + empName,
                dataType : "json",
                type : "POST",
                success : function (result) {
                    if(result.code == 100) {
                        show_validate_msg("#empName_add_input","success","用户名可用");
                        $("#emp_save_btn").attr("ajax-va","success");
                    } else {
                        show_validate_msg("#empName_add_input","error", result.extend.va_msg);
                        $("#emp_save_btn").attr("ajax-va","error");
                    }
                }
            })
        })
    }

    //保存用户信息
    function saveEmp() {
        if(!validate_add_form()){
            return false;
        }
        if($(this).attr("ajax-va") == "error") {
            return false;
        }
        $.ajax({
            url : "${APP_PATH}/saveEmp",
            type : "POST",
            data : $("#empAddModal form").serialize(),
            success : function (result) {
                if(result.code == 100) {
                    //alert(result.msg);
                    //1、退出模态框
                    $("#empAddModal").modal('toggle');
                    //2、跳转到最后一页
                    to_page(totalRecord + 1);
                } else {
                    if(undefined != result.extend.errorFields.empName) {
                        show_validate_msg("#empName_add_input", "error", result.extend.errorFields.empName);
                    }
                    if(undefined != result.extend.errorFields.email) {
                        show_validate_msg("#email_add_input", "error", result.extend.errorFields.email);
                    }
                }

            }
        })
    }

    //修改员工信息
    function updateEmp() {
        var email = $("#email_edit_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if(!regEmail.test(email)){
            show_validate_msg("#email_edit_input", "error", "邮箱格式不正确");
            return false;
        }else{
            show_validate_msg("#email_edit_input", "success", "");
        }
        //发送ajax请求修改用户信息
        $.ajax({
            url : "${APP_PATH}/updateEmp",
            data : $("#empEditModal form").serialize(),
            dataType : "json",
            type : "POST",
            success : function(result) {
                if(result.code == 100){
                    alert("修改成功");
                    //关闭对话框
                    $("#empEditModal").modal('hide')
                    //回到当前页面
                    to_page(currenPage);
                }
            }
        })

    }
</script>
<div class="container">
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <div class="row">
        <div class="col-md-2 col-md-offset-10">
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger" id="emp_del_btn">删除</button>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-striped" id="emps_table">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="check_all" />
                    </th>
                    <th>
                        #
                    </th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>operation</th>
                </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6" id="page_info_area">
        </div>
        <div class="col-md-6" id="page_nav_area">

        </div>
    </div>
</div>

</body>
</html>
