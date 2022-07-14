/**
*   Purpose         :   Class to have all all url for Rest Service for Fit Freedom
*   Created By      :   
*   Created Date    :   05/18/2020
*   Revision Log    :   v1.0 - Created - 05/18/2020
**/
public class FitFreedomUrlMappings 
{
    public static String BASE_URL = String.valueOf(URL.getSalesforceBaseUrl().toExternalForm());
    public static String REST_SERVICE_INSTANCE = '/services/apexrest';
        
    //Athlete
    public static String URLMAPPING_ATHLETE = '/fitfreedomv3Athlete/';
    public static String ATHLETE_AT_ADD_TEAM_MEMBER = 'add-team-member';
    public static String ATHLETE_AT_GET_ATHLETE_BY_TEAM_ID = 'getAthletebyteam';
    public static String ATHLETE_AT_REMOVE_ATHLETE = 'remove-athlete';
    public static String ATHLETE_AT_CREATE_COACH = 'create-coach';

    
    //Category
    public static String URLMAPPING_CATEGORY = '/fitfreedomv3Category/';
    
    //Edit
    public static String URLMAPPING_EDIT = '/fitfreedomv3Edit/';
    
    //Gym
    public static String URLMAPPING_GYM = '/fitfreedomv3Gym/';
    
    //Measurement
    public static String URLMAPPING_MEASUREMENT = '/fitfreedomv3Measurement/';
    
    //Fit
    public static String URLMAPPING_FIT = '/fitfreedomv3Fit/';
    public static String FIT_AT_DELETE_FIT_BY_ID = 'remove_fit';
    
    //Team
    public static String URLMAPPING_TEAM = '/fitfreedomv3Team/';
    public static String TEAM_AT_GET_ALL_TEAMS = 'getAllTeams';
    public static String TEAM_AT_GET_TEAM_BY_ID = 'getTeamById';
    public static String TEAM_AT_GET_TEAM_BY_GYM_ID = 'getTeamByGymId';
    public static String TEAM_AT_ADD_COACH_TO_TEAM = 'addCoachToTeam';
    public static String TEAM_AT_REMOVE_COACH_FROM_TEAM = 'removeCoachFromTeam';
    public static String TEAM_AT_EDIT_TEAM_NAME = 'editTeamName';
    public static String TEAM_AT_MODIFY_SALES_REP = 'modifysalesrep';
    
    //Specification
    public static String URLMAPPING_SPECIFICATION = '/fitfreedomv3Specification/';
    
    //Order Sizes
    public static String URLMAPPING_ORDER_SIZE = '/fitfreedomv3OrderSize/';
    public static String ORDERSIZE_AT_GET_ALL_ORDER_SIZES = 'getAllOrderSizes';
    public static String ORDERSIZE_AT_CREATE_SINGLE_ORDERSIZE = 'createSingleOrderSize';
    
    //Order Fit
    public static String URLMAPPING_ORDER_FIT = '/fitfreedomv3OrderFit/';
    public static String ORDERFIT_AT_GET_ALL_ORDERFIT = 'getAllOrderFit';
    public static String ORDERFIT_AT_GET_ORDERFIT_BY_ID = 'getOrderFitById';
    public static String ORDERFIT_AT_GET_ORDERFIT_BY_ORDER_ID = 'getOrderFitByOrderId';
    public static String ORDERFIT_AT_CREATE_SINGLE_ORDERFIT = 'createSingleOrderFit';
    public static String ORDERFIT_AT_DELETE_ORDERFIT_BY_ID = 'deleteOrderFitById';
    
    //Order
    public static String URLMAPPING_ORDER = '/fitfreedomv3Order/';
    public static String ORDER_AT_GET_ALL_ORDERS = 'get_orders';
    public static String ORDER_AT_GET_ORDER_BY_ID = 'get_order';
    public static String ORDER_AT_FINALIZE_ORDER = 'finalize-order';
    public static String ORDER_AT_ADD_FIT_TO_ORDER = 'addfitToOrder';
    public static String ORDER_AT_CREATE_ORDER = 'createOrder';
    public static String ORDER_AT_SUBMIT_ORDER = 'submit-order';
    public static String ORDER_AT_UPDATE_ORDER = 'update-order';
    public static String ORDER_AT_DELETE_ORDER = 'delete-order';
    public static String ORDER_AT_GET_ORDER_DETAILS = 'get-order-details';
    
    //User
    public static String URLMAPPING_User = '/fitfreedomv3User/';
    public static String USER_AT_GET_ALL_USERS = 'getallusers';
    public static String USER_AT_GET_USER_BY_GYM_ID = 'getUserByGymId';
    public static String USER_AT_GET_USER_BY_USER_ID = 'getUserByUserId';
    public static String USER_AT_GET_PARENTS = 'get_Parents';
    public static String USER_AT_GET_PARENTS_BY_TEAM = 'get_Parents_By_Team';
    public static String USER_AT_GET_TEAM_COACHES = 'get_Team_Choaches';
    public static String USER_AT_DELETE_PARENT = 'delete-parent';
    public static String USER_AT_ADD_TEAM_TO_USER = 'addTeamToUser';
    public static String USER_AT_REMOVE_TEAM_FROM_USER = 'removeTeam';
    public static String USER_AT_REMOVE_USERS_FROM_GYM = 'removeUsersFromGym';
    public static String USER_AT_ADD_GYMS_AND_TEAMS_TO_USER = 'addGymAndTeamsToUsers';
    public static String USER_AT_UPDATE_PARENT = 'update_parent';
    public static String USER_AT_UPDATE_REP_BY_USER_ID = 'updateRepByUserId';
    public static String USER_AT_CREATE_PARENT = 'createparent';
    public static String USER_AT_CREATE_USER = 'createuser';

}