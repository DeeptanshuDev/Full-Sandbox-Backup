public without sharing class CustomItemProcessor {
    private static DataMapper   mapper = new DataMapper();
    private static SObjectType  objectType;
    private static SObjectType  TYPE_QUOTE = SCMC__Customer_Quotation_Line__c.getSObjectType();
    private static SObjectType  TYPE_ORDER = SCMC__Sales_Order_Line_Item__c.getSObjectType();
    private static String       FIELD_CUSTOM_ITEM = SCMC__Sales_Order_Line_Item__c.fields.Custom_Item__c.getDescribe().Name;
    private static final String DEFAULT_DESCRIPTION = 'Created automatically.';

    public static void triggerSalesOrderLine() {
        try {
            //Load custom settings
            Custom_Item_Automation_Settings__c settings = Custom_Item_Automation_Settings__c.getOrgDefaults();

            if (settings != null && settings.Active__c == false) {
                //The trigger has been shut down by custom settings
                return;
            }

            identifyObjectType();

            if (Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert)) {
                /* BEFORE UPDATE/INSERT: Create item master records from custom items */

                if (settings == null || settings.Create_Custom_Item_Masters__c) {
                    createCustomItemMasters();
                }
            } else if (Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert) &&
                       objectType == TYPE_ORDER) {
                /* AFTER UPDATE/INSERT: Update the Last Sold value of the item master */

                if (settings == null || settings.Update_Last_Sold_time__c) {
                    updateLastSold();
                }
            }
        } catch (Exception e) {
            if (Test.isRunningTest()) {
                throw e;
            }

            system.debug(System.LoggingLevel.ERROR, 'Custom item failed to create new item master: ' + e.getMessage() + ' - ' + e.getLineNumber());
        }
    }

    private static void identifyObjectType() {
        //Identify what object this trigger is working on
        if (Trigger.new.size() > 0) {
            CustomItemProcessor.objectType = Trigger.new[0].getSObjectType();
        }
    }

    private static void updateLastSold() {
        //Get sales order lines that are either new, or have a changed item master
        List<SCMC__Sales_Order_Line_Item__c> lines = getLinesWithNewItemMaster();

        //Touch each referenced item master
        if (lines.size() > 0) {
            DateTime dtNow = system.now();
            Set<Id> touchedItems = new Set<Id>();
            List<SCMC__Item__c> updatedItems = new List<SCMC__Item__c>();
            for (SCMC__Sales_Order_Line_Item__c line : lines) {
                Id itemId = line.SCMC__Item_Master__c;

                //If the item is already on the list, do not do it again
                if (touchedItems.contains(itemId)) {
                    continue;
                }

                //Create an item master update
                updatedItems.add(new SCMC__Item__c(Id = itemId, Last_Sold__c = dtNow));

                //Mark the item so we don't update it twice
                touchedItems.add(itemId);
            }
            
			Util.BypassAllTriggers= True;
            Database.update(updatedItems, false);
            Util.BypassAllTriggers= false;
        }
    }

    private static List<SCMC__Sales_Order_Line_Item__c> getLinesWithNewItemMaster() {
        Integer lines = Trigger.new.size();
        List<SCMC__Sales_Order_Line_Item__c> result = new List<SCMC__Sales_Order_Line_Item__c>();

        //Iterate over each line to find new ones, or ones where the item master changed
        for (Integer i=0;i < lines;i++) {
            SCMC__Sales_Order_Line_Item__c line = (SCMC__Sales_Order_Line_Item__c)Trigger.new[i];
            SCMC__Sales_Order_Line_Item__c oldLine = (Trigger.isInsert) ? null : (SCMC__Sales_Order_Line_Item__c)Trigger.old[i];

            if (oldLine == null ||
                oldLine.SCMC__Item_Master__c != line.SCMC__Item_Master__c) {
                //Line changed, check that item master is not null
                if (line.SCMC__Item_Master__c != null) {
                    result.add(line);
                }
            }
        }

        return result;
    }

    private static void createCustomItemMasters() {
        //Pick up the lines that have changed, and gather their styling attributes
        LineData ld = getChangedLines();

        //Check that there are actually lines to process
        if (ld.isEmpty()) {
            //There aren't any - stop
            return;
        }

        //Load all custom referenced by the sales order lines
        Map<Id, Custom_Item__c> mapCustomItems = getCustomItemMap(ld);

        //Map all item masters by their styling attributes
        Map<String[], SCMC__Item__c> mapItemMaster = getItemMasterMap(mapCustomItems);

        createNewItemMasters(ld, mapCustomItems, mapItemMaster);

        linkLinesToItemMaster(ld, mapCustomItems, mapItemMaster);
    }

    private static LineData getChangedLines() {
        /* Note: Fortunately, both quote lines  and sales lines have the same field
                 API names when it comes to product styles. If those ever go out of
                 sync, this will need to be refactored - probably into two separate
                 functions.
        */

        LineData ld = new LineData();

        //Count the amount of lines in the trigger context
        Integer lines = Trigger.new.size();

        //Check for lines that have changed custom item and/or style attributes
        for (Integer i = 0; i < lines; i++) {
            SObject line = Trigger.new[i];
            SObject oldLine = (Trigger.isInsert) ? null : Trigger.old[i];

            //New record or change in item
            if (Trigger.isInsert ||
                oldLine.get(FIELD_CUSTOM_ITEM) != line.get(FIELD_CUSTOM_ITEM) ||
                oldLine.get('Style__c') != line.get('Style__c') ||
                oldLine.get('Product_Style__c') != line.get('Product_Style__c') ||
                oldLine.get('Product_Style_Subcategory__c') != line.get('Product_Style_Subcategory__c') ||
                oldLine.get('Style_Subcategory__c') != line.get('Style_Subcategory__c') ||
                oldLine.get('Collection__c') != line.get('Collection__c') ||
                (objectType == TYPE_ORDER && oldLine.get('Sub_Collection__c') != line.get('Sub_Collection__c'))) {

                //Only process lines where the custom item is not null
                if (line.get(FIELD_CUSTOM_ITEM) != null) {
                    ld.add(line);
                }
            }
        }

        return ld;
    }

    private static Map<Id, Custom_Item__c> getCustomItemMap(LineData ld) {
        //Query for all custom items required in this operation
        Set<Id> customItemIds = ld.customItemIds;

        //Build the query with the required fields
        String strQuery = 'SELECT ' + mapper.getRequiredFieldsString() + ', ' +
                              '(SELECT Id, Custom_Item__c, Product_Category__c, Product_Subcategory__c, ' +
                              'Product_Style__c, Product_Style_Subcategory__c, Collection__c, ' +
                              'Sub_Collection__c, Style_Subcategory__c, Name ' +
                              'FROM Items__r)' +
                          ' FROM Custom_Item__c WHERE Id IN :customItemIds';

        //Query the custom items and map them by their ID
        return new Map<Id, Custom_Item__c>((List<Custom_Item__c>)Database.query(strQuery));
    }

    private static Map<String[], SCMC__Item__c> getItemMasterMap(Map<Id, Custom_Item__c> mapCustomItems) {
        //Map each item master by its properties - custom item + styling attributes
        Map<String[], SCMC__Item__c> mapItemByProperties = new Map<String[], SCMC__Item__c>();
        for (Custom_Item__c c : mapCustomItems.values()) {
            for (SCMC__Item__c item : c.Items__r) {
                String[] key = new String[] {
                        c.id,
                        item.Product_Style__c,
                        item.Product_Style_Subcategory__c,
                        item.Style_Subcategory__c,
                        item.Collection__c,
                        item.Sub_Collection__c
                };
                mapItemByProperties.put(key, item);
            }
        }

        return mapItemByProperties;
    }

    private static void createNewItemMasters(LineData ld, Map<Id, Custom_Item__c> mapCustomItems, Map<String[], SCMC__Item__c> mapItemMaster) {
        List<SCMC__Item__c> newItems = new List<SCMC__Item__c>();

        //Figure out which lines don't have existing item masters in the database
        for (SObject line : ld.lines) {
            Custom_Item__c customItem = mapCustomItems.get((Id)line.get(FIELD_CUSTOM_ITEM));

            if (customItem == null) {
                continue;
            }

            String[] key = new String[] {
                    customItem.id,
                    customItem.Product_Style__c,
                    customItem.Product_Style_Subcategory__c,
                    customItem.Style_Subcategory__c,
                    customItem.Collection__c,
                    customItem.Sub_Collection__c
            };

            //Fetch an item for the style properties
            SCMC__Item__c item = mapItemMaster.get(key);

            if (item == null) {
                //Item not found - clone one from the custom item
                item = createNewItem(customItem, line);

                //Put the item back in the map
                mapItemMaster.put(key, item);

                //Mark item to be inserted
                newItems.add(item);
            }
        }

        //Insert new items
        if (newItems.size() > 0) {
            Database.SaveResult[] sr = Database.insert(newItems, true);

            //Error handling
            for (Database.SaveResult s : sr) {
                if (s.success == false) {
                    System.debug(System.LoggingLevel.ERROR, 'Custom item failed to create new item master: ' + s.getErrors().get(0).getMessage());
                }
            }
        }
    }

    private static SCMC__Item__c createNewItem(Custom_Item__c customItem, SObject line) {
        SCMC__Item__c item = new SCMC__Item__c();

        //Create context map
        Map<String, SObject> context = new Map<String, SObject>();
        context.put('', customItem);
        context.put('item', customItem);

        if (objectType == TYPE_ORDER) {
            context.put('line', line);
        } else {
            context.put('quote', line);
        }

        system.debug('Mapping begins. Available contexts: ' + context.keySet());

        //Copy each mapped field into the item
        for (String field : mapper.mappings.keyset()) {
            Item_Master_Mapping__mdt def = mapper.mappings.get(field);
            String val = def.Value__c;
            Object actualValue;

            system.debug('Mapping ' + val + ' to ' + field);
            //Determine whether the value is a constant string or field
            if (val == null || val.length() == 0) {
                //Empty value - treat as a null
                system.debug('Val is empty. Returning empty string.');
                actualValue = null;
            } if (val.startsWith('"')) {
                //Constant
                actualValue = val.substring(1, val.length() - 1);
                system.debug('Val is constant. Returning: ' + actualValue);
            } else {
                //Split the string into a context and field
                ValueContext fld = new ValueContext(val);

                system.debug('Val is a field. Context: ' + fld.context + ', field: ' + fld.field);

                //Get the context record to fetch the field from
                SObject record = context.get(fld.context);

                if (record == null) {
                    //Context not found? Do not map any value. Skip this.
                    system.debug('Context "' + fld.context + '" not found.');
                    continue;
                } else {
                    //Context found - fetch the value from the record
                    actualValue = customItem.get(fld.field);
                    system.debug('Context found. Value: ' + actualValue);
                }
            }

            //Check for transformation functions
            if ('Match to Product Group'.equals(def.Transformation__c)) {
                actualValue = mapper.mapProductGroups.get(String.valueOf(actualValue));
            }

            //Write the value to the item
            item.put(field, actualValue);
        }

        //Make sure the item has a description, as it's a required field
        if (item.SCMC__Item_Description__c == null || item.SCMC__Item_Description__c.length() == 0) {
            item.SCMC__Item_Description__c = DEFAULT_DESCRIPTION;
        }

        //Make sure the name does not already exist (it has to remain unique)
        String baseName = item.Name;
        Integer revision = 0;
        Boolean found = true;
        while (found) {
            found = false;

            //Iterate through all existing items created by this custom item
            for (SCMC__Item__c child : customItem.Items__r) {
                if (item.name.equalsIgnoreCase(child.name)) {
                    found = true;
                    break;
                }
            }

            if (found) {
                //Item exists - change the name and look again
                item.name = baseName + ' Rev. ' + (++revision);
            }
        }

        return item;
    }

    private static void linkLinesToItemMaster(LineData ld, Map<Id, Custom_Item__c> mapCustomItems, Map<String[], SCMC__Item__c> mapItemMaster) {
        //Now match the order lines to the items
        for (SObject line : ld.lines) {
            Custom_Item__c customItem = mapCustomItems.get((Id)line.get(FIELD_CUSTOM_ITEM));

            if (customItem == null) {
                continue;
            }

            String[] key = new String[] {
                    customItem.id,
                    customItem.Product_Style__c,
                    customItem.Product_Style_Subcategory__c,
                    customItem.Style_Subcategory__c,
                    customItem.Collection__c,
                    customItem.Sub_Collection__c
            };

            //Fetch an item for the style properties
            SCMC__Item__c item = mapItemMaster.get(key);

            if (item == null || item.id == null) {
                continue; //This should never happen
            }

            //Relate the line to the item
            if (objectType == TYPE_QUOTE) {
                line.put(SCMC__Customer_Quotation_Line__c.fields.SCMC__Item_Number__c, item.id);
            } else {
                line.put(SCMC__Sales_Order_Line_Item__c.fields.SCMC__Item_Master__c, item.id);
            }

        }
    }

    private class LineData {
        List<SObject> lines;
        Set<Id> customItemIds;

        public LineData() {
            //Initialize all lists
            this.lines = new List<SObject>();
            this.customItemIds = new Set<Id>();
        }

        public void add(SObject line) {
            this.lines.add(line);
            this.customItemIds.add((Id)line.get(FIELD_CUSTOM_ITEM));
        }

        public Boolean isEmpty() {
            return (this.lines.isEmpty());
        }
    }

    private class DataMapper {
        public Map<String, Item_Master_Mapping__mdt> mappings;
        public Map<String, Id> mapProductGroups;
        public List<String> requiredFields;

        public DataMapper() {
            this.requiredFields = new List<String>();

            //Load mappings
            List<Item_Master_Mapping__mdt> fieldMap = [SELECT MasterLabel, Value__c, Transformation__c
                                                         FROM Item_Master_Mapping__mdt];

            //Put it into a Map
            this.mappings = new Map<String, Item_Master_Mapping__mdt>();

            this.requiredFields.addAll(new String[] {'id', 'product_style__c', 'product_style_subcategory__c',
                                                     'style_subcategory__c', 'collection__c', 'sub_collection__c'});

            Set<String> existingFields = new Set<String>();
            existingFields.addAll(this.requiredFields);

            for (Item_Master_Mapping__mdt f : fieldMap) {
                this.mappings.put(f.MasterLabel, f);

                String fieldName = f.Value__c.toLowerCase();

                if (fieldName.startsWith('"')) {
                    //The field has a constant value - no need to query it
                    continue;
                }

                //Break the field down into context
                ValueContext fld = new ValueContext(fieldName);

                //Check whether it's a custom item field
                if (fld.context == '' ||
                    fld.context == 'item') {
                    //Field belongs to the custom item context, we want to query it
                    if (!existingFields.contains(fld.field)) {
                        this.requiredFields.add(fld.field);
                        existingFields.add(fld.field);
                    }
                }
            }

            //Load product groups
            this.mapProductGroups = new Map<String, Id>();
            List<SCMC__Product_Group__c> groups = [SELECT Id, Name FROM SCMC__Product_Group__c LIMIT 1000];
            for (SCMC__Product_Group__c g : groups) {
                this.mapProductGroups.put(g.Name, g.Id);
            }
        }

        public String getRequiredFieldsString() {
            return String.join(this.requiredFields, ',');
        }
    }

    public class ValueContext {
        public String context;
        public String field;

        public ValueContext(String strField) {
            //Split field name into Context.Field
            String[] parts = strField.split('\\.', 2);
            this.context = (parts.size() < 2) ? '' : parts[0];
            this.field = (parts.size() < 2) ? parts[0] : parts[1];

            //Set to lowercase
            this.context = this.context.toLowerCase();
        }
    }
}