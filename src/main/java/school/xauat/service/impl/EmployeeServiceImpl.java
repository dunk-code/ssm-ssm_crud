package school.xauat.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import school.xauat.dao.EmployeeMapper;
import school.xauat.entity.Employee;
import school.xauat.entity.EmployeeExample;
import school.xauat.service.EmployeeService;

import java.util.List;

@Service("employeeService")
public class EmployeeServiceImpl implements EmployeeService {

    @Autowired
    private EmployeeMapper employeeMapper;

    @Override
    public List<Employee> getAll() {
        return employeeMapper.selectByExampleWithDept(null);
    }

    @Override
    public boolean checkEmpName(String empName) {
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        long count = employeeMapper.countByExample(employeeExample);
        return count == 0;
    }

    @Override
    public int addEmp(Employee employee) {
        return employeeMapper.insertSelective(employee);
    }

    @Override
    public Employee getEmpById(Integer empId) {
        return employeeMapper.selectByPrimaryKeyWithDept(empId);
    }

    @Override
    public boolean updateEmp(Employee employee) {
        return employeeMapper.updateByPrimaryKeySelective(employee) == 1;
    }

    @Override
    public boolean delEmpById(Integer empId) {
        return employeeMapper.deleteByPrimaryKey(empId) == 1;
    }

    @Override
    public int deleteBatch(List<Integer> del_ids) {
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmpIdIn(del_ids);
        return employeeMapper.deleteByExample(employeeExample);
    }
}
