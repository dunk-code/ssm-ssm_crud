package school.xauat;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import school.xauat.dao.DepartmentMapper;
import school.xauat.dao.EmployeeMapper;
import school.xauat.entity.Department;
import school.xauat.entity.Employee;
import school.xauat.entity.EmployeeExample;
import school.xauat.service.EmployeeService;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * spring的项目推荐使用spring的单元测试，可以自动注入我们需要的组件
 * 1、导入spring-test的依赖
 * 2、添加ContextConfiguration注解
 * 3、添加RunWith通知JUnit使用spring的Test进行单元测试
 */
@RunWith(value = SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:application.xml"})
public class Test1 {

    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;

    @Autowired
    EmployeeService employeeService;

    @Test
    public void TestSelectDept() {
        List<Department> departments = departmentMapper.selectByExample(null);
        System.out.println(departments);
    }

    @Test
    public void TestInsertDept() {
        departmentMapper.insertSelective(new Department(null, "技术部"));
    }

    /**
     * 为了进行批量添加
     * 添加SQLSession对象
     */
    @Test
    public void TestInsertBatch() {
        //员工姓名使用UUID随机获取
        EmployeeMapper employeeMapper = sqlSession.getMapper(EmployeeMapper.class);
        for(int i = 0; i < 50; i++) {
            String uid = UUID.randomUUID().toString().substring(0, 5) + i;
            employeeMapper.insertSelective(new Employee(null, uid, "M", uid + "@qq.com",1));
        }
    }


    @Test
    public void Test() {
        List<Employee> emps = employeeMapper.selectByExampleWithDept(null);
        System.out.println(emps);
    }

    @Test
    public void TestPageHelper() {
        PageHelper.startPage(1, 5);
        List<Employee> emps = employeeService.getAll();
        PageInfo pageInfo = new PageInfo(emps);
        System.out.println(pageInfo);
    }

    @Test
    public void TestCheckEmpName() {
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmpNameEqualTo("9a5e138");
        long count = employeeMapper.countByExample(employeeExample);
        System.out.println(count);
        System.out.println(count == 0);
    }

    @Test
    public void TestUpdateEmp() {
        Employee employee = new Employee();
        employee.setEmpName("张三");
        employee.setEmail("zhangsan@qq.com");
        employee.setdId(1);
        employee.setEmpId(1001);
        boolean count = employeeService.updateEmp(employee);
        System.out.println(count);
    }

    @Test
    public void TestDelBatch() {
        List<Integer> list = new ArrayList<>();
        list.add(1008);
        list.add(1009);
        int res = employeeService.deleteBatch(list);
        System.out.println(res);
    }

}
