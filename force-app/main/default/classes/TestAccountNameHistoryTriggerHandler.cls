public with sharing class TestAccountNameHistoryTriggerHandler extends TriggerHandler {
    
    private List<TestAccountName__c> newTestAccountNames;
    private Map<Id, TestAccountName__c> oldTestAccountNameMap;

    public TestAccountNameHistoryTriggerHandler() {
        newTestAccountNames = (List<TestAccountName__c>) Trigger.new;
        oldTestAccountNameMap = (Map<Id, TestAccountName__c>) Trigger.oldMap;
    }

    public override void afterInsert() {
        List<TestAccountNameHistory__c> results = new List<TestAccountNameHistory__c>();
        for (TestAccountName__c testAccountName : newTestAccountNames) {
            String description = 'Record with ID: ' + testAccountName.Id + ' was created.';
            results.add(
                new TestAccountNameHistory__c(
                    Name = testAccountName.Name,
                    Description__c = description,
                    TestAccountNameId__c = testAccountName.Id)
            );
        }
        insert results;
    }

    public override void afterUpdate() {
        List<TestAccountNameHistory__c> results = new List<TestAccountNameHistory__c>();
        Set<Id> newIds = new Set<Id>();

        for (TestAccountName__c testAccountName : newTestAccountNames) {
            TestAccountName__c oldTestAccountName = oldTestAccountNameMap.get(testAccountName.Id);
            
            if (testAccountName.Name != oldTestAccountName.Name || testAccountName.Status__c != oldTestAccountName.Status__c) {
                String description = 'Record with ID: ' + testAccountName.Id + 
                                     ' was updated with name = ' + testAccountName.Name + 
                                     ' and status = ' + testAccountName.Status__c;
                results.add(
                    new TestAccountNameHistory__c(
                        Name = testAccountName.Name,
                        Description__c = description,
                        TestAccountNameId__c = testAccountName.Id)
                );
            }

            if (testAccountName.Name != oldTestAccountName.Name) {
                newIds.add(testAccountName.Id);
            }
        }

        if (newIds.size() > 0) {
            database.executeBatch(new TestAccountNameHistoryBatch(newIds));
        }
        
        insert results;
    }
}