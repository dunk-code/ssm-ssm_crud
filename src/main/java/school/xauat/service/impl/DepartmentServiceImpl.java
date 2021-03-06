package school.xauat.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import school.xauat.dao.DepartmentMapper;
import school.xauat.entity.Department;
import school.xauat.service.DepartmentService;

import java.util.List;

@Service("departmentService")
public class DepartmentServiceImpl implements DepartmentService {

    @Autowired
    private DepartmentMapper departmentMapper;

    @Override
    public List<Department> getAll() {
        return departmentMapper.selectByExample(null);
    }
}
