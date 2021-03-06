package school.xauat.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import school.xauat.entity.Department;
import school.xauat.entity.Employee;
import school.xauat.entity.EmployeeExample;
import school.xauat.entity.Msg;
import school.xauat.service.DepartmentService;
import school.xauat.service.EmployeeService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class EmpController {

    @Autowired
    EmployeeService employeeService;

    @Autowired
    DepartmentService departmentService;


    /**
     * 将查询到的结果封装成json格式
     * 1、添加ResponseBody注解
     * 2、添加jackson的依赖
     */
    @ResponseBody
    @RequestMapping("/emps")
    public Msg getEmpToJson(@RequestParam(value = "pn",defaultValue= "1")Integer pn){
        //查询之前传入页码，以及每页的大小
        PageHelper.startPage(pn,5);
        //查询
        List<Employee> emps = employeeService.getAll();
        //使用PageInfo封装结果
        PageInfo pageInfo = new PageInfo(emps, 5);
        return Msg.success().add("pageInfo", pageInfo);
    }


    /*@RequestMapping("/emps")
    public String getEmp(@RequestParam(value = "pn",defaultValue = "1")Integer pn, Model model) {
        //查询之前传入页码，以及每页的大小
        PageHelper.startPage(pn,5);
        List<Employee> emps = employeeService.getAll();
        //使用PageInfo封装查询结果
        //封装了详细的分页信息，包括有我们查询出来的数据，传入需要连续显示的页数
        PageInfo pageInfo = new PageInfo(emps,5);
        model.addAttribute("pageInfo",pageInfo);
        //pageInfo.getNavigatePages();
        return "list";
    }*/

    //查询部门信息
    @ResponseBody
    @RequestMapping("/depts")
    public Msg getDeptToJson() {
        List<Department> depts = departmentService.getAll();
        return Msg.success().add("depts", depts);
    }

    @ResponseBody
    @RequestMapping(value = "/checkEmpName", method = RequestMethod.POST)
    public Msg checkEmpName(String empName) {
        //检验用户名是否合法
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
        if(!empName.matches(regx)) {
            return Msg.fail().add("va_msg", "用户名必须是6-16位数字和字母的组合或者2-5位中文");
        }
        if(employeeService.checkEmpName(empName)) {
            return Msg.success();
        } else {
            return Msg.fail().add("va_msg", "用户名不可用");
        }
    }

    @ResponseBody
    @RequestMapping(value = "/saveEmp", method = RequestMethod.POST)
    public Msg saveEmp(@Validated Employee employee, BindingResult result) {
        if(result.hasErrors()) {
            Map<String, Object> map = new HashMap<>();
            List<FieldError> errors = result.getFieldErrors();
            for(FieldError error : errors) {
                map.put(error.getField(),error.getDefaultMessage());
            }
            return Msg.fail().add("errorFields", map);
        } else {
            employeeService.addEmp(employee);
            return Msg.success();
        }
    }

    @ResponseBody
    @RequestMapping(value = "/getEmp", method = RequestMethod.POST)
    public Msg getEmp(@RequestParam()Integer empId) {
        Employee employee = employeeService.getEmpById(empId);
        return Msg.success().add("emp",employee);
    }

    @ResponseBody
    @RequestMapping(value = "/updateEmp", method = RequestMethod.POST)
    public Msg updateEmp(Employee employee) {
        boolean res = employeeService.updateEmp(employee);
        if(res) {
            return Msg.success();
        } else {
            return Msg.fail();
        }
    }

    //单个删除员工信息
    @ResponseBody
    @RequestMapping(value = "/delEmp", method = RequestMethod.POST)
    public Msg deleteEmp(@RequestParam("empId")Integer empId) {
        boolean res = employeeService.delEmpById(empId);
        if(res) {
            Msg msg = Msg.success();
            msg.setMsg("删除成功");
            return msg;
        } else {
            return Msg.fail();
        }
    }

    //批量删除员工信息
    @ResponseBody
    @RequestMapping(value = "/delEmps", method = RequestMethod.POST)
    public Msg deleteEmps(@RequestParam("empIds")String empIds){
        if(empIds.contains("-")) {
            List<Integer> del_ids = new ArrayList<>();
            String[] str_ids = empIds.split("-");
            for(String string : str_ids) {
                del_ids.add(Integer.parseInt(string));
            }
            return employeeService.deleteBatch(del_ids) == del_ids.size() ? Msg.success() : Msg.fail();
        } else {
            return employeeService.delEmpById(Integer.parseInt(empIds)) ? Msg.success() : Msg.fail();
        }
    }
}
