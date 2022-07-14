@isTest
public with sharing class Test_SoqlBuilder {

    @IsTest
    static void testLinebreaks() {
        SoqlBuilder builder = SoqlBuilder.create().addSelect('Name').addFrom('object_01__c').addWhere(SoqlBuilder.eq('Name', 'test'));
        String sql = null;

        sql = builder.toQuery();
        System.assert(sql.toLowerCase().contains('\n'), 'Expected linebreaks, was: ' + sql);

        sql = builder.setLinebreaks(false).toQuery();
        System.assert(!sql.toLowerCase().contains('\n'), 'Expected NO linebreaks, was: ' + sql);
    }

    @IsTest
    static void testSelect() {
        SoqlBuilder builder = SoqlBuilder.create();
        String sql = null;

        sql = builder.addSelect('Id').toQuery();
        System.assert(sql.toLowerCase().startsWith('select id'));

        sql = builder.addSelect(new String[] { 'Name', 'Owner' }).toQuery();
        System.assert(sql.toLowerCase().startsWith('select id, name, owner'));
    }

    @IsTest
    static void testSelectWithoutFields() {
        SoqlBuilder builder = SoqlBuilder.create();
        String sql = null;

        sql = builder.toQuery();
        System.assert(sql.toLowerCase().startsWith('select id'));
    }

    @IsTest
    static void testClearSelect() {
        SoqlBuilder builder = SoqlBuilder.create().addSelect('Id').clearSelects().addSelect('Name');
        String sql = null;

        sql = builder.toQuery();
        System.assert(sql.toLowerCase().startsWith('select name'));
    }

    @IsTest
    static void testCount() {
        SoqlBuilder builder = SoqlBuilder.create().setLinebreaks(false);
        String sql = null;

        sql = builder.toCountQuery();
        System.assert(sql.toLowerCase().startsWith('select count()'));

        sql = builder.toCountQuery(1000);
        System.assert(sql.toLowerCase().endsWith('limit 1000'));
    }

    @IsTest
    static void testFrom() {
        SoqlBuilder builder = SoqlBuilder.create();
        String sql = null;

        sql = builder.addFrom('object_01__c').toQuery();
        System.assert(sql.toLowerCase().contains('from object_01__c'));

        sql = builder.addFrom(new String[] { 'object_02__c', 'object_03__c' }).toQuery();
        System.assert(sql.toLowerCase().contains('from object_01__c, object_02__c, object_03__c'));
    }

    @IsTest
    static void testSort() {
        SoqlBuilder builder = SoqlBuilder.create().setLinebreaks(false);
        String sql = null;

        sql = builder.addSortAsc('id').toQuery();
        System.assert(sql.toLowerCase().endsWith('order by id asc nulls last'), 'Expected query to end with `order by id asc nulls last`, was: ' + sql);

        sql = builder.addSortDesc('name').toQuery();
        System.assert(sql.toLowerCase().endsWith('order by id asc nulls last, name desc nulls first'), 'Expected query to end with `order by id asc nulls last, name desc nulls first`, was: ' + sql);
    }

    @IsTest
    static void testSortDefaultNulls() {
        SoqlBuilder builder = SoqlBuilder.create().setLinebreaks(false);
        String sql = null;

        sql = builder.addSortAscNullsFirst('id').toQuery();
        System.assert(sql.toLowerCase().endsWith('order by id asc nulls first'), 'Expected query to end with `order by id asc nulls first`, was: ' + sql);

        sql = builder.addSortDescNullsLast('name').toQuery();
        System.assert(sql.toLowerCase().endsWith('order by id asc nulls first, name desc nulls last'), 'Expected query to end with `order by id asc nulls first, name desc nulls last`, was: ' + sql);
    }

    @IsTest
    static void testClearSort() {
        SoqlBuilder builder = SoqlBuilder.create().setLinebreaks(false);
        String sql = null;

        sql = builder.addSortAsc('id').clearSorts().toQuery();
        System.assert(!sql.toLowerCase().endsWith('order by id asc nulls last'), 'Expected query NOT to end with `order by id asc nulls last`, was: ' + sql);
    }

    @IsTest
    static void testGroup() {
        SoqlBuilder builder = SoqlBuilder.create().setLinebreaks(false);
        String sql = null;

        sql = builder.addGroup('Id').toQuery();
        System.assert(sql.toLowerCase().endsWith('group by id'));

        sql = builder.addGroup(new String[] {'Name', 'Id', 'Amount'}).toQuery();
        System.assert(sql.toLowerCase().endsWith('group by id, name, amount'));
    }

    @IsTest
    static void testCriteria() {
        SoqlBuilder builder = null;
        String sql = null;

        // eq
        builder = SoqlBuilder.create().setLinebreaks(false);
        sql = builder.addWhere(SoqlBuilder.eq('Id', '123456789')).toQuery();
        System.assert(sql.toLowerCase().endsWith('where id = \'123456789\''), 'Expected `where id = \'123456789\'`, was: ' + sql);

        // ne
        builder = SoqlBuilder.create().setLinebreaks(false);
        sql = builder.addWhere(SoqlBuilder.ne('Id', '123456789')).toQuery();
        System.assert(sql.toLowerCase().endsWith('where id != \'123456789\''), 'Expected `where id != \'123456789\'`, was: ' + sql);

        // gt
        builder = SoqlBuilder.create().setLinebreaks(false);
        sql = builder.addWhere(SoqlBuilder.gt('Amount', 10)).toQuery();
        System.assert(sql.toLowerCase().endsWith('where amount > 10'), 'Expected `where amount > 10`, was: ' + sql);

        // ge
        builder = SoqlBuilder.create().setLinebreaks(false);
        sql = builder.addWhere(SoqlBuilder.ge('Amount', 10)).toQuery();
        System.assert(sql.toLowerCase().endsWith('where amount >= 10'), 'Expected `where amount >= 10`, was: ' + sql);

        // lt
        builder = SoqlBuilder.create().setLinebreaks(false);
        sql = builder.addWhere(SoqlBuilder.lt('Amount', 10)).toQuery();
        System.assert(sql.toLowerCase().endsWith('where amount < 10'), 'Expected `where amount < 10`, was: ' + sql);

        // lt
        builder = SoqlBuilder.create().setLinebreaks(false);
        sql = builder.addWhere(SoqlBuilder.le('Amount', 10)).toQuery();
        System.assert(sql.toLowerCase().endsWith('where amount <= 10'), 'Expected `where amount <= 10`, was: ' + sql);

        // isNull
        builder = SoqlBuilder.create().setLinebreaks(false);
        sql = builder.addWhere(SoqlBuilder.isNull('Amount')).toQuery();
        System.assert(sql.toLowerCase().endsWith('where amount = null'), 'Expected `where amount = null`, was: ' + sql);

        // notNull
        builder = SoqlBuilder.create().setLinebreaks(false);
        sql = builder.addWhere(SoqlBuilder.notNull('Amount')).toQuery();
        System.assert(sql.toLowerCase().endsWith('where amount != null'), 'Expected `where amount != null`, was: ' + sql);

        // bind variable
        builder = SoqlBuilder.create().setLinebreaks(false);
        sql = builder.addWhere(SoqlBuilder.eq('Owner.id', ':userid')).toQuery();
        System.assert(sql.toLowerCase().endsWith('where owner.id = :userid'), 'Expected `where owner.id = :userid`, was: ' + sql);

        // in
        builder = SoqlBuilder.create().setLinebreaks(false);
        sql = builder.addWhere(SoqlBuilder.valueIn('name', ':names')).toQuery();
        System.assert(sql.toLowerCase().endsWith('where name in :names'), 'Expected `where name in :names`, was: ' + sql);

        // in with mixed List of values
        List<Object> objectValues = new List<Object> { null, 'test', 1234 };
        builder = SoqlBuilder.create().setLinebreaks(false);
        sql = builder.addWhere(SoqlBuilder.valueIn('name', objectValues)).toQuery();
        System.assert(sql.toLowerCase().endsWith('where name in (null,\'test\',1234)'), 'Expected `where name in (null,\'test\',1234)`, was: ' + sql);

        // in with List of string values
        List<String> stringValues = new List<String> { null, 'test', 'test2'};
        builder = SoqlBuilder.create().setLinebreaks(false);
        sql = builder.addWhere(SoqlBuilder.valueIn('name', stringValues)).toQuery();
        System.assert(sql.toLowerCase().endsWith('where name in (null,\'test\',\'test2\')'), 'Expected `where name in (null,\'test\',\'test2\')`, was: ' + sql);

        // in with List of integer values
        List<Integer> integerValues = new List<Integer> { null, 1, 2, 3};
        builder = SoqlBuilder.create().setLinebreaks(false);
        sql = builder.addWhere(SoqlBuilder.valueIn('name', integerValues)).toQuery();
        System.assert(sql.toLowerCase().endsWith('where name in (null,1,2,3)'), 'Expected `where name in (null,1,2,3)`, was: ' + sql);

        // in with mixed Set of values
        Set<Object> objectValuesSet = new Set<Object> { null, 'test', 1234 };
        builder = SoqlBuilder.create().setLinebreaks(false);
        sql = builder.addWhere(SoqlBuilder.valueIn('name', objectValuesSet)).toQuery();
        System.assert(sql.toLowerCase().endsWith('where name in (null,\'test\',1234)'), 'Expected `where name in (null,\'test\',1234)`, was: ' + sql);

        // not in
        builder = SoqlBuilder.create().setLinebreaks(false);
        sql = builder.addWhere(SoqlBuilder.valueNotIn('name', ':names')).toQuery();
        System.assert(sql.toLowerCase().endsWith('where name not in :names'), 'Expected `where name not in :names`, was: ' + sql);

        // value like
        builder = SoqlBuilder.create().setLinebreaks(false);
        sql = builder.addWhere(SoqlBuilder.valueLike('name', '%test%')).toQuery();
        System.assert(sql.toLowerCase().endsWith('where name like \'%test%\''), 'Expected `where name like \'%test%\'`, was: ' + sql);

        //distance
        builder = SoqlBuilder.create().setLinebreaks(false);
        sql = builder.addWhere(SoqlBuilder.distance('geolocation__c', 50.001, 4.001, 50)).toQuery();
        System.assert(sql.toLowerCase().endsWith('where (distance(geolocation__c, geolocation(50.001,4.001), \'km\') < 50)'), 'Expected `where (distance(geolocation__c, geolocation(50.001,4.001), \'km\') < 50)`, was: ' + sql);
    }

    @IsTest
    static void testLimit() {
        SoqlBuilder builder = SoqlBuilder.create().setLinebreaks(false);
        String sql = null;

        sql = builder.setLimit(100).toQuery();
        System.assert(sql.toLowerCase().endsWith('limit 100'));
    }

    @IsTest
    static void testOffset() {
        SoqlBuilder builder = SoqlBuilder.create().setLinebreaks(false);
        String sql = null;

        sql = builder.setOffset(50).toQuery();
        System.assert(sql.toLowerCase().endsWith('offset 50'));
    }

    @IsTest
    static void testConjunction() {
        SoqlBuilder builder = SoqlBuilder.create();
        String sql = null;

        sql = builder.addWhere(SoqlBuilder.conjunction()
                .add(SoqlBuilder.gt('amount', 10))
                .add(SoqlBuilder.lt('amount', 100))
        ).toQuery();

        System.debug(sql);

        System.assert(sql.toLowerCase().contains('(amount > 10 and amount < 100)'));
    }

    @IsTest
    static void testDisjunction() {
        SoqlBuilder builder = SoqlBuilder.create();
        String sql = null;

        sql = builder.addWhere(SoqlBuilder.disjunction()
                .add(SoqlBuilder.eq('owner.id', ':userid'))
                .add(SoqlBuilder.isNull('owner.id'))
        ).toQuery();

        System.debug(sql);

        System.assert(sql.toLowerCase().contains('(owner.id = :userid or owner.id = null)'));
    }

    @IsTest
    static void testEmptyDisjunction() {
        SoqlBuilder builder = SoqlBuilder.create().setLinebreaks(false).addFrom('cxsPosition__c');
        String sql = null;

        sql = builder.addWhere(SoqlBuilder.disjunction()).toQuery();

        System.debug(sql.toLowerCase());

    }

    @IsTest
    static void testNestedEmptyJunctions() {
        SoqlBuilder builder = SoqlBuilder.create().setLinebreaks(false).addFrom('Account');
        String sql = null;

        builder.addWhere(
                SoqlBuilder.disjunction()
                        .add(SoqlBuilder.conjunction().add(SoqlBuilder.disjunction()))
        );

        sql = builder.toQuery();

        System.debug(sql.toLowerCase());

        System.assert(sql.toLowerCase() == 'select id from Account');
    }

    @IsTest
    static void testNestedEmptyJunctionsWithAValue() {
        SoqlBuilder builder = SoqlBuilder.create().setLinebreaks(false).addFrom('Account');
        String sql = null;

        builder.addWhere(
                SoqlBuilder.disjunction()
                        .add(
                            SoqlBuilder.conjunction()
                                    .add(SoqlBuilder.disjunction())
                                    .add(SoqlBuilder.eq('Name', 'test'))
                        )
        );

        sql = builder.toQuery();

        System.debug(sql.toLowerCase());

        System.assert(sql.toLowerCase() == 'select id from Account where ((name = \'test\'))');
    }


    @IsTest
    static void testConditionLogic() {

        SoqlBuilder builder = null;
        String sql = null;

        // eq
        builder = SoqlBuilder.create()
                .addWhere(SoqlBuilder.eq('Id', '123456789'))
                .addWhere(SoqlBuilder.eq('Name', 'Test'))
                .addWhere(SoqlBuilder.eq('Amount', 10))
                .setConditionLogic('({A} AND {B}) OR {C}')
                ;
        sql = builder.toQuery();

        System.assert(sql.toLowerCase().contains('(id = \'123456789\' and name = \'test\') or amount = 10'));
    }

    @IsTest
    static void testConditionLogicMissingConditions() {

        SoqlBuilder builder = null;
        String sql = null;

        // eq
        builder = SoqlBuilder.create()
                .addWhere(SoqlBuilder.eq('Id', '123456789'))
                .addWhere(SoqlBuilder.eq('Name', 'Test'))
                .addWhere(SoqlBuilder.eq('Amount', 10))
                .addWhere(SoqlBuilder.valueIn('Name', ':names'))
                .addWhere(SoqlBuilder.eq('Owner.id', ':userid'))
                .setConditionLogic('({A} AND {B}) OR {C}')
                ;
        sql = builder.toQuery();

        System.assert(sql.toLowerCase().contains('((id = \'123456789\' and name = \'test\') or amount = 10) and (name in :names and owner.id = :userid)'));
    }

    @IsTest
    static void testToConditionLogicString() {
        SoqlBuilder builder = null;
        String sql = null;

        builder = SoqlBuilder.create()
                .addWhere(SoqlBuilder.eq('Id', '123456789'))
                .addWhere(
                    SoqlBuilder.disjunction()
                        .add(SoqlBuilder.eq('Name', 'Test'))
                        .add(SoqlBuilder.eq('Name', 'Test2'))
                        .add(
                            SoqlBuilder.conjunction()
                                .add(SoqlBuilder.eq('Field1', 'value1'))
                                .add(SoqlBuilder.eq('Field2', 'value2'))
                        )
                );

        String conditionLogicString = builder.toConditionLogicString();

        System.assert(conditionLogicString == '{A} AND ({B} OR {C} OR ({D} AND {E}))', 'Expected conditionLogicString to be `{A} AND ({B} OR {C} OR ({D} AND {E}))`, was: ' + conditionLogicString);
    }

    @IsTest
    static void testConditionLogicStringThatWasAlreadySet() {
        SoqlBuilder builder = null;
        String sql = null;
        String conditionLogicString = null;

        builder = SoqlBuilder.create()
                .addWhere(SoqlBuilder.eq('Id', '123456789'))
                .addWhere(SoqlBuilder.eq('Name', 'Test'))
                .addWhere(SoqlBuilder.eq('Name', 'Test2'))
                .addWhere(SoqlBuilder.eq('Field1', 'value1'))
                .addWhere(SoqlBuilder.eq('Field2', 'value2'))
        ;

        conditionLogicString = builder.toConditionLogicString();
        System.assert(conditionLogicString == '{A} AND {B} AND {C} AND {D} AND {E}', 'Expected conditionLogicString to be `{A} AND {B} AND {C} AND {D} AND {E}`, was: ' + conditionLogicString);

        builder.setConditionLogic('{A} AND ({B} OR {C} OR ({D} AND {E}))');
        conditionLogicString = builder.toConditionLogicString();
        System.assert(conditionLogicString == '{A} AND ({B} OR {C} OR ({D} AND {E}))', 'Expected conditionLogicString to be `{A} AND ({B} OR {C} OR ({D} AND {E}))`, was: ' + conditionLogicString);
    }

    @IsTest
    static void testFieldSet() {
        String sql = null;
        SoqlBuilder builder = SoqlBuilder.create();

        sql = builder.forFieldSet('Account', 'MC4SF__Account_Filter_Fields').toQuery();
        sql = builder.forFieldSet('Account', 'MC4SF__Account_Filter_Fields').toQuery();

        List<sObject> sobjectList = Database.query(sql);
        System.assert(sobjectList != null);
    }
 
    @IsTest
    static void testFieldSets() {
        String sql = null;
        SoqlBuilder builder = SoqlBuilder.create();

        sql = builder.forFieldSets('Account', new String[] {
                'MC4SF__Account_Filter_Fields'
        }).toQuery();

        List<sObject> sobjectList = Database.query(sql);
        System.assert(sobjectList != null);
    }

    @IsTest
    static void testDateFunctions() {
        String sql = null;
        SoqlBuilder builder = SoqlBuilder.create();

        sql = builder
                .addFrom('Account')
                .addWhere( SoqlBuilder.eq('CALENDAR_YEAR(CreatedDate)', 2017) )
                .toQuery();

        System.assert(!sql.contains('\'CALENDAR_YEAR(CreatedDate)\' = 2017'), 'Expected `CALENDAR_YEAR(CreatedDate) = 2017` without quotes');
        System.assert(sql.contains('CALENDAR_YEAR(CreatedDate) = 2017'), 'Expected `CALENDAR_YEAR(CreatedDate) = 2017` without quotes');

        sql = builder
                .addWhere( SoqlBuilder.eq('FISCAL_QUARTER(CreatedDate)', 1) )
                .toQuery();

        System.assert(!sql.contains('\'FISCAL_QUARTER(CreatedDate)\' = 1'), 'Expected `FISCAL_QUARTER(CreatedDate) = 1` without quotes');
        System.assert(sql.contains('FISCAL_QUARTER(CreatedDate) = 1'), 'Expected `FISCAL_QUARTER(CreatedDate) = 1` without quotes');

        List<sObject> sobjectList = Database.query(sql);

        System.assert(sobjectList != null);
    }

    @IsTest
    static void testDateLiterals() {
        String sql = null;
        SoqlBuilder builder = SoqlBuilder.create();

        sql = builder
                .addFrom('Account')
                .addWhere( SoqlBuilder.eq('CreatedDate', 'THIS_YEAR') )
                .toQuery();

        System.assert(!sql.contains('CreatedDate = \'THIS_YEAR\''), 'Expected `THIS_YEAR` without quotes');
        System.assert(sql.contains('CreatedDate = THIS_YEAR'), 'Expected `THIS_YEAR` without quotes');

        sql = builder
                .addWhere( SoqlBuilder.eq('CreatedDate', 'LAST_N_DAYS:90') )
                .toQuery();

        System.assert(!sql.contains('CreatedDate = \'LAST_N_DAYS:90\''), 'Expected `CreatedDate = LAST_N_DAYS:90` without quotes');
        System.assert(sql.contains('CreatedDate = LAST_N_DAYS:90'), 'Expected `CreatedDate = LAST_N_DAYS:90` without quotes');

        List<sObject> sobjectList = Database.query(sql);

        System.assert(sobjectList != null);
    }

    @IsTest
    static void testDateFormats() {
        String sql = null;
        SoqlBuilder builder = SoqlBuilder.create();

        sql = builder
                .addFrom('Account')
                .addWhere( SoqlBuilder.ge('SCMC__Credit_Card_Expiration_Date__c	', '2017-01-01') )
                .toQuery();

        System.assert(!sql.contains('Date_of_birth__c >= \'2017-01-01\''), 'Expected `2017-01-01` without quotes: ' + sql);
        
        sql = builder
                .addWhere( SoqlBuilder.ge('CreatedDate', '2017-01-01T23:01:01+01:00') )
                .toQuery();

        System.assert(!sql.contains('CreatedDate >= \'2017-01-01T23:01:01+01:00\''), 'Expected `CreatedDate >= 2017-01-01T23:01:01+01:00` without quotes: ' + sql);
        System.assert(sql.contains('CreatedDate >= 2017-01-01T23:01:01+01:00'), 'Expected `CreatedDate >= 2017-01-01T23:01:01+01:00` without quotes: ' + sql);

        sql = builder
                .addWhere( SoqlBuilder.ge('CreatedDate', '2017-01-01T23:01:01-04:00') )
                .toQuery();

        System.assert(!sql.contains('CreatedDate >= \'2017-01-01T23:01:01-04:00\''), 'Expected `CreatedDate >= 2017-01-01T23:01:01-04:00` without quotes: ' + sql);
        System.assert(sql.contains('CreatedDate >= 2017-01-01T23:01:01-04:00'), 'Expected `CreatedDate >= 2017-01-01T23:01:01-04:00` without quotes: ' + sql);

        sql = builder
                .addWhere( SoqlBuilder.ge('CreatedDate', '2017-01-01T23:01:01Z') )
                .toQuery();

        System.assert(!sql.contains('CreatedDate >= \'2017-01-01T23:01:01Z\''), 'Expected `CreatedDate >= 2017-01-01T23:01:01Z` without quotes: ' + sql);
        System.assert(sql.contains('CreatedDate >= 2017-01-01T23:01:01Z'), 'Expected `CreatedDate >= 2017-01-01T23:01:01Z` without quotes: ' + sql);

        List<sObject> sobjectList = Database.query(sql);

        System.assert(sobjectList != null);
    }

    @IsTest
    static void testQuery() {
        String sql = SoqlBuilder.create()
                .addSelect('Id')
                .addFrom('Account')
                .addWhere(SoqlBuilder.notNull('Id'))
                .addSortAsc('Id')
                .setLimit(1)
                .toQuery()
        ;

        List<sObject> sobjectList = Database.query(sql);

        System.assert(sobjectList != null);
    }

    @IsTest
    static void testCountQuery() {
        String sql = SoqlBuilder.create()
                .addSelect('Id')
                .addFrom('Account')
                .addWhere(SoqlBuilder.notNull('Id'))
                .addSortAsc('Id')
                .setLimit(1)
                .setOffset(1)
                .toCountQuery()
        ;

        Integer count = Database.countQuery(sql);

        System.assert(count != null);
    }


    @IsTest
    static void testInvalidQuery() {
        String sql = SoqlBuilder.create()
                .addSelect('someColumn')
                .addFrom('someObject')
                .setLimit(1)
                .toQuery()
        ;

        Boolean failed = false;

        try {
            List<sObject> sobjectList = Database.query(sql);
        }
        catch(Exception e) {
            failed = true;
        }

        System.assert(failed);
    }

    @IsTest
    static void testPages() {
        Integer customPageSize = 10;
        Integer queryOffset;
        SoqlBuilder builder = SoqlBuilder.create().setLinebreaks(false).addSelect('Id').addFrom('Account');
        String sql = null;

        // set first page with default pageSize
        sql = builder.setPage(1).toQuery();
        System.assert(sql.endsWith('LIMIT ' + SoqlBuilder.DEFAULT_PAGE_SIZE), 'query should end with `LIMIT ' + SoqlBuilder.DEFAULT_PAGE_SIZE + '`, was: ' + sql);

        // set first page with custom pagesize
        sql = builder.setPage(1, customPageSize).toQuery();
        System.assert(sql.endsWith('LIMIT ' + customPageSize), 'query should end with `LIMIT ' + customPageSize + '`, was: ' + sql);

        // set 5th page, default pagesize
        sql = builder.setPage(5).toQuery();
        queryOffset = (5 * SoqlBuilder.DEFAULT_PAGE_SIZE) - SoqlBuilder.DEFAULT_PAGE_SIZE;
        System.assert(sql.endsWith('LIMIT ' + SoqlBuilder.DEFAULT_PAGE_SIZE + ' OFFSET ' + queryOffset), 'query should end with `LIMIT ' + SoqlBuilder.DEFAULT_PAGE_SIZE + ' OFFSET ' + queryOffset + '`, was: ' + sql);

        // set 5th page, custom pagesize
        sql = builder.setPage(5, customPageSize).toQuery();
        queryOffset = (5 * customPageSize) - customPageSize;
        System.assert(sql.endsWith('LIMIT ' + customPageSize + ' OFFSET ' + queryOffset), 'query should end with `LIMIT ' + customPageSize + ' OFFSET ' + queryOffset + '`, was: ' + sql);
    }

    @IsTest
    static void testRemoveWhere() {
        SoqlBuilder builder = SoqlBuilder.create().addFrom('Account').setLinebreaks(false);
        String sql;

        // Simple where condition
        sql = builder.addWhere(SoqlBuilder.eq('removedField', 'someValue')).toQuery();
        System.assert(sql.contains('removedField'), 'Expected `removedField` in query, was: ' + sql);

        sql = builder.removeWhereCondition('removedField').toQuery();
        System.assert(!sql.contains('removedField'), 'Not expected `removedField` in query, was: ' + sql);

        // Nested where conditions
        sql = builder.addWhere(
                SoqlBuilder.conjunction()
                    .add(SoqlBUilder.eq('removedField', '1234567890'))
                    .add(SoqlBuilder.eq('someColumn', 'someValue'))
                    .add(SoqlBuilder.disjunction()
                        .add(SoqlBuilder.eq('removedField', '1234567890'))
                        .add(SoqlBuilder.eq('someColumn', 'someValue'))
                        .add(SoqlBuilder.eq('someColumn2', 'someValue2'))
                    )
        ).toQuery();
        System.assert(sql.contains('removedField'), 'Expected `removedField` in query, was: ' + sql);

        sql = builder.removeWhereCondition('removedField').toQuery();
        System.assert(!sql.contains('removedField'), 'Not expected `removedField` in query, was: ' + sql);

        // Try removing where conditions with a fresh and empty soqlbuilder
        builder = SoqlBuilder.create().removeWhereCondition('someField');
    }

    @IsTest
    static void testRemoveWhereNotRecursive() {
 
        SoqlBuilder builder = SoqlBuilder.create().addFrom('Account').setLinebreaks(false);
        String sql;

        builder
            .addWhere(SoqlBuilder.eq('removedField', 'someValue'))
            .addWhere(SoqlBuilder.conjunction().add(SoqlBuilder.eq('removedField', 'someValue')));

        System.assert(builder.toQuery().countMatches('removedField') == 2, 'Expected 2 occurrences of `removedField` in query, was: ' + builder.toQuery().countMatches('removedField'));

        // remove top level conditions
        builder.removeWhereCondition(new SoqlBuilder.RemoveWhereOptions('removedField').setNestedStrategy(SoqlBuilder.RemoveWhereNestedStrategyEnum.ROOT_ONLY));

        System.assert(builder.toQuery().countMatches('removedField') == 1, 'Expected 1 occurrence of `removedField` in query, was: ' + builder.toQuery().countMatches('removedField'));
    }

}