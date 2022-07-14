/**
*   Purpose         :   Class to have rest resources and services for Fit Freedom App.
*   Created By      :   Ayush Gupta
*   Created Date    :   03/30/2020
*   Revision Log    :   v1.0 - Created - 03/30/2020
**/
public without sharing class FitFreedomMappings 
{             
    public static Map<String,String> mapOfAthleteSQLAndSFDCFields = new Map<String,String>
    {
        'device_ids' => 'device_ids__c',
        'dob' => 'dob__c',
        'email' => 'email',
        'first_login' => 'first_login__c',
        'first_name' => 'firstname',
        'gender' => 'gender__c',
        'gym_id' => 'gym_id__c',
        'is_active' => 'is_active__c',
        'is_deleted' => 'is_deleted__c',
        'last_name' => 'lastname',
        'pass' => 'pass__c',
        'phone' => 'phone',
        'role' => 'role__c',
        'social_handles' => 'social_handles__c',
        'team_id' => 'team_id__c',
        'created_at' => 'created_at__c',
        'modified_at' => 'modified_at__c',
        'member_id' => 'member_id__c',
        'user_id' => 'member_id__c',
        'age' => 'age__c',
        'createdAt' => 'created_at__c',
        'measured' =>  'FF_Measured__c',
        'user_id' => 'user_id__c'   
    };

    public static Map<String,String> mapOfAthleteSFDCFieldsAndTypes = new Map<String,String>
    {
        'device_ids__c' => 'Text',
        'dob__c' => 'Text',
        'email' => 'Email',
        'first_login__c' => 'Text',
        'firstname' => 'Text',
        'gender__c' => 'Text',
        'gym_id__c' => 'Text',
        'is_active__c' => 'Text',
        'is_deleted__c' => 'Text',
        'lastmame' => 'Text',
        'pass__c' => 'Text',
        'phone' => 'Integer',
        'role__c' => 'Text',
        'social_handles__c' => 'Text',
        'team_id__c' => 'Text',
        'created_at__c' => 'Text',
        'modified_at__c' => 'Text',
        'member_id__c' => 'Text',
        'FF_Measured__c' => 'Text',
        'lastname'  => 'Text',
        'age__c'    => 'Text',
        'user_id__c' => 'Text'   
    };

    public static Map<String,String> mapOfCategorySQLAndSFDCFields = new Map<String,String>
    {
        'category_id' => 'category_id__c',
        'edit_options' => 'edit_options__c',
        'name' => 'Name',
        'category_type' => 'category_type__c',
        'sort' => 'sort__c',
        'created_at' => 'created_at__c',
        'modified_at' => 'modified_at__c',
        'createdAt' => 'created_at__c'
    };

    public static Map<String,String> mapOfEditSQLAndSFDCFields = new Map<String,String>
    {
        'edit_id' => 'edit_id__c',
        'cap_max' => 'cap_max__c',
        'cap_min' => 'cap_min__c',
        'default_index' => 'default_index__c',
        'edit_measure' => 'edit_measure__c',
        'edit_name' => 'Name',    
        'edit_type' => 'edit_type__c',
        'map_max' => 'map_max__c',
        'map_min' => 'map_min__c',
        'max' => 'max__c',
        'min' => 'min__c',
        'options' => 'options__c',
        'sensitivity' => 'sensitivity__c',
        'created_at' => 'created_at__c',
        'modified_at' => 'modified_at__c',
        'createdAt' => 'created_at__c'
    };

    public static Map<String,String> mapOfGymSQLAndSFDCFields = new Map<String,String>
    {
        'gym_id' => 'gym_id__c',
        'active' => 'active__c',
        'gym_name' => 'name',
        'gym_type' => 'gym_type__c',
        'location' => 'location__c',
        'owner' => 'owner__c',
        'owner_name' => 'owner_name__c',
        'Sales_rep_ids' => 'sales_rep_ids__c',
        'Created_at' => 'created_at__c',
        'modified_at' => 'modified_at__c',
        'createdAt' => 'created_at__c',
        'team_id' => 'team_id__c'    
    };

    public static Map<String,String> mapOfGymSFDCFieldsAndTypes = new Map<String,String>
    {
        'gym_id__c' => 'Text',
        'active__c' => 'Text',
        'name' => 'Text',
        'location__c' => 'Text',
        'gym_type__c' => 'Text',
        'owner__c' => 'Text',
        'owner_mame__c' => 'Text',
        'sales_rep_ids__c' => 'Text',    
        'created_at__c' => 'Text',
        'modified_at__c' => 'Text',
        'team_id__c' => 'Text'    
    };

    // Measurement --> Measurement__c
    public static Map<String,String> mapOfMeasurementSQLAndSFDCFields = new Map<String,String>
    {
        'y_values' => 'y_values__c',
        'person_height' => 'person_height__c',
        'member_id' => 'member_id__c',
        'measured_sizes' => 'measured_sizes__c',
        'team_id' => 'team_id__c',
        'measured_by' => 'measured_by__c',
        'measure_id' => 'measure_id__c',
        'name' => 'Name',
        'active' => 'active__c',
        'created_at' => 'created_at__c',
        'modified_at' => 'modified_at__c',
        'createdAt' => 'created_at__c'
    };

    public static Map<String,String> mapOfMeasurementSFDCFieldsAndTypes = new Map<String,String>
    {
        'y_values__c' => 'Text',
        'person_height__c' => 'Text',
        'member_id__c' => 'Text',
        'measured_sizes__c' => 'Text',
        'team_id__c' => 'Text',
        'measured_by__c' => 'Text',
        'measure_id__c' => 'Text',
        'name' => 'Text',
        'active__c' => 'Text',
        'created_at__c' => 'Text',
        'modified_at__c' => 'Text'
    }; 

    // Fits --> Fit__c
    public static Map<String,String> mapOfFitSQLAndSFDCFields = new Map<String,String>
    {
        'fit_id' => 'fit_id__c',
        'category_id' => 'categories_id__c',
        'spec_id' => 'spec_id__c',
        'fit_desc' => 'fit_desc__c',
        'fit_number' => 'fit_number__c',
        'conditions_apply' => 'condition_apply__c',
        'created_by' => 'created_by__c',
        'edit_id' => 'edit_id__c',
        'fabric' => 'fabric__c',
        'fit_image' => 'fit_image__c',
        'lining' => 'lining__c' , 
        'Name' => 'name',
        'is_deleted' => 'is_deleted__c',   
        'created_at' => 'created_at__c',
        'modified_at' => 'modified_at__c',
        'createdAt' => 'created_at__c'    
    };
        
        // Fits --> Fit__c
   
    public static Map<String,String> mapOfFitSFDCFieldsAndTypes = new Map<String,String>
    {
        'fit_id__c' => 'Text',
        'categories_id__c' => 'Text',
        'spec_id__c' => 'Text',
        'fit_desc__c' => 'Text',
        'fit_number__c' => 'Text',
        'condition_apply__c' => 'Text',
        'created_by__c' => 'Text',
        'edit_id__c' => 'Text',
        'fabric__c' => 'Text',
        'fit_image__c' => 'Text',
        'lining__c' => 'Text' ,
        'name' => 'Text',
        'is_deleted__c' => 'Text',
        'created_at__c' => 'Text',
        'modified_at__c' => 'Text'                
    }; 

    // Admin/User --> Contact
    public static Map<String, String> mapOfAdminSQLAndSFDCFields = new Map<String,String>
    {
        'email' => 'Email',
        'first_name' => 'FirstName',
        'last_name' => 'LastName',
        'gym_id' => 'gym_id__c',
        'role' => 'role__c',
        'phone' => 'phone',
        'user_id' => 'user_id__c',
        'device_ids' => 'device_ids__c',
        'dob' => 'dob__c',
        'first_login' => 'first_login__c',
        'gender' => 'gender__c',
        'is_active' => 'is_active__c',
        'is_deleted' => 'is_deleted__c',
        'pass' => 'pass__c',
        'social_handles' => 'social_handles__c',
        'team_id' => 'team_id__c',
        'created_at' => 'created_at__c',
        'modified_at' => 'modified_at__c',
        'member_id' =>'member_id__c',
        'age' => 'age__c',
        'createdAt' => 'created_at__c',
        'measured' =>  'FF_Measured__c'
    };

    public static Map<String,String> mapOfAdminSFDCFieldsAndTypes = new Map<String,String>
    {
        'Email' => 'Text',
        'FirstName' => 'Text',
        'Lastname' => 'Text',
        'Gym_Id__c' => 'Text',
        'Role__c' => 'Text',
        'Phone' => 'Text',
        'user_id__c' => 'Text',
        'device_ids__c' => 'Text',
        'dob__c' => 'Text',
        'first_login__c' => 'Text',
        'gender__c' => 'Text',
        'is_active__c' => 'Text',
        'is_deleted__c' => 'Text',
        'pass__c' => 'Text',
        'social_handles__c' => 'Text',
        'team_id__c' => 'Text',
        'created_at__c' => 'Text',
        'modified_at__c' => 'Text',
        'member_id__c' => 'Text',
        'age__c' => 'Text',
        'FF_Measured__c' => 'Text'   
    };

    // Order Size
    public static Map<String,String> mapOfOrderSizeSQLAndSFDCFields = new Map<String,String>
    {
        'order_size_id'  => 'order_size_id__c',
        'order_id'  => 'order_id__c',
        'member_id'  => 'member_id__c',
        'active'  => 'active__c',
        'approved_by'  => 'approved_by__c',
        'changed'  => 'changed__c',
        'computed_diff'  => 'computed_diff__c',
        'deviated'  => 'deviated__c',
        'full_recommended_sizes'  => 'full_recommended_sizes__c',
        'measure_id'  => 'measure_id__c',
        'modified_by'  => 'modified_by__c',
        'order_sizes'  => 'order_sizes__c',
        'recommended_sizes'  => 'recommended_sizes__c',
        'team_id'  => 'team_id__c',
        'created_at'  => 'created_at__c',
        'modified_at'  => 'modified_at__c'
    };

    // Order Size
    public static Map<String,String> mapOfOrderSizeSFDCFieldAndType = new Map<String,String>
    {
        'order_size_id__c' => 'text',
        'order_id__c' => 'text',
        'member_id__c' => 'text',
        'active__c' => 'text',
        'approved_by__c' => 'text',
        'changed__c' => 'text',
        'computed_diff__c' => 'text',
        'deviated__c' => 'text',
        'full_recommended_sizes__c' => 'text',
        'measure_id__c' => 'text',
        'modified_by__c' => 'text',
        'order_sizes__c' => 'text',
        'recommended_sizes__c' => 'text',
        'team_id__c' => 'text',
        'created_at__c' => 'text',
        'modified_at__c' => 'text'
    };

    // Order Fit
    public static Map<String,String> mapOfOrderFitSQLAndSFDCFields = new Map<String,String>
    {
        'index'  =>  'index__c',
        'fit_id'  =>  'fit_id__c',
        'order_id'  =>  'order_id__c',
        'submitted_order_id'  =>  'submitted_order_id__c',
        'created_at'  =>  'created_at__c',
        'modified_at'  =>  'modified_at__c',
        'custom_item_number'  => 'Custom_Item_Numbers__c',
        'standard_item_number'  => 'Standard_Items_Number__c'
    };

    // Order Fit
    public static Map<String,String> mapOfOrderFitSFDCFieldAndType = new Map<String,String>
    {
        'index__c' => 'text',
        'fit_id__c' => 'text',
        'order_id__c' => 'text',
        'submitted_order_id__c' => 'text',
        'created_at__c' => 'text',
        'modified_at__c' => 'text',
        'Standard_Items_Number__c' => 'text',
        'Custom_Item_Numbers__c' => 'text'
    };    

    // order --> Opportunity
    public static Map<String,String> mapOfOrderSQLAndSFDCFields = new Map<String,String>
    {
        'order_name' => 'ff_order_name__c',
        'team_id' => 'Team_Id__c',
        'order_id' => 'order_id__c',
        'finalize' => 'finalize__c',
        'fits' => 'fits__c',
        'is_deleted' => 'is_deleted__c',
        'is_finalized' => 'is_finalized__c',
        'is_submitted' => 'is_submitted__c',
        'created_at' => 'created_at__c',
        'modified_at' => 'modified_at__c',
        'createdAt' => 'created_at__c',
        'old_order_id' => 'order_id__c'
    };

    public static Map<String,String> mapOfOrderSFDCFieldsAndTypes = new Map<String,String>
    {
        'ff_order_name__c' => 'Text',
        'Team_Id__c' => 'Text',
        'finalize__c' => 'Text',
        'order_id__c' => 'Text',
        'fits__c' => 'Text',
        'is_deleted__c' => 'Text',
        'is_finalized__c' => 'Text',
        'is_submitted__c' => 'Text',
        'created_at__c' => 'Text',
        'modified_at__c' => 'Text'
    };

    // Team --> Team__c
    public static Map<String,String> mapOfTeamSQLAndSFDCFields = new Map<String,String>
    {
        'team_id' => 'rosters_id__c',
        'gym_id' => 'gym_id__c',
        'member_count' => 'member_count__c',
        'team_name' => 'Name' ,
        'sales_rep_ids' => 'sales_rep_ids__c' ,
        'coach_ids' => 'coach_ids__c' ,
        'created_at' => 'created_at__c',
        'modified_at' => 'modified_at__c',
        'createdAt' => 'created_at__c'
    };

    public static Map<String,String> mapOfTeamSFDCFieldsAndTypes = new Map<String,String>
    {
        'Name' => 'Text',
        'Gym_Id__c' => 'Text',
        'Member_Count__c' => 'Text',
        'Team_Id__c' => 'Text',
        'sales_rep_ids__c' => 'Text',
        'coach_ids__c' => 'Text',
        'created_at__c' => 'Text',
        'modified_at__c' => 'Text'
    };

    // Spec --> Specification__c
    public static Map<String,String> mapOfSpecificationSQLAndSFDCFields = new Map<String,String>
    {
        'name' => 'Name',
        'id' => 'Spec_Id__c',
        'active' => 'Active__c',
        'finalized' => 'Finalized__c',
        'defined_measures' => 'Defined_Measures__c',
        'Created_at' => 'created_at__c',
        'Modified_at' => 'modified_at__c'   
    };

    public static Map<String,String> mapOfSpecificationSFDCFieldsAndTypes = new Map<String,String>
    {
        'Name' => 'Text',
        'Spec_Id__c' => 'Text',
        'Active__c' => 'Text',
        'Finalized__c' => 'Text',
        'Defined_Measures__c' => 'Text',
        'created_at__c' => 'Text',
        'modified_at__c'  => 'Text'  
    };
}