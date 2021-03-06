package school.xauat.service;

import school.xauat.entity.Employee;

import java.util.List;

public interface EmployeeService {

    List<Employee> getAll();

    boolean checkEmpName(String empName);

    int addEmp(Employee employee);

    Employee getEmpById(Integer empId);

    boolean updateEmp(Employee employee);

    boolean delEmpById(Integer empId);

    int deleteBatch(List<Integer> del_ids);
}
