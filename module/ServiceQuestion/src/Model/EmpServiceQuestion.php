<?php
namespace ServiceQuestion\Model;

use Application\Model\Model;

class EmpServiceQuestion extends Model{
    const TABLE_NAME = "HRIS_EMPLOYEE_SERVICE_QA";
    
    const EMP_QA_ID = "EMP_QA_ID";
    const EMPLOYEE_ID = "EMPLOYEE_ID";
    const QA_DATE = "QA_DATE";
    const STATUS = "STATUS";
    const COMPANY_ID = "COMPANY_ID";
    const BRANCH_ID = "BRANCH_ID";
    const CREATED_BY = "CREATED_BY";
    const CREATED_DATE = "CREATED_DATE";
    const MODIFIED_BY = "MODIFIED_BY";
    const MODIFIED_DATE = "MODIFIED_DATE";
    const CHECKED = "CHECKED";
    const APPROVED = "APPROVED";
    const APPROVED_BY = "APPROVED_BY";
    const APPROVED_DATE = "APPROVED_DATE";
    const SERVICE_EVENT_TYPE_ID = "SERVICE_EVENT_TYPE_ID";
    const REMARKS = "REMARKS";
    
    public $empQaId;
    public $employeeId;
    public $qaDate;
    public $status;
    public $companyId;
    public $branchId;
    public $createdBy;
    public $createdDate;
    public $modifiedBy;
    public $modifiedDate;
    public $checked;
    public $approvedBy;
    public $approvedDate;
    public $approved;
    public $serviceEventTypeId;
    public $remarks;
    
    public $mappings = [
        'empQaId'=>self::EMP_QA_ID,
        'employeeId'=>self::EMPLOYEE_ID,
        'qaDate'=>self::QA_DATE,
        'status'=>self::STATUS,
        'companyId'=>self::COMPANY_ID,
        'branchId'=>self::BRANCH_ID,
        'createdBy'=>self::CREATED_BY,
        'createdDate'=>self::CREATED_DATE,
        'modifiedBy'=>self::MODIFIED_BY,
        'modifiedDate'=>self::MODIFIED_DATE,
        'checked'=>self::CHECKED,
        'approvedBy'=>self::APPROVED_BY,
        'approvedDate'=>self::APPROVED_DATE,
        'approved'=>self::APPROVED,
        'remarks'=>self::REMARKS,
        'serviceEventTypeId'=>self::SERVICE_EVENT_TYPE_ID
    ];
}

