public with sharing class TestAccountNameHistoryHandler {
    
    @AuraEnabled
    public static Integer deleteAllRelatedHistories(Id recordId) {
        List<TestAccountNameHistory__c> histories = [SELECT Id FROM TestAccountNameHistory__c WHERE TestAccountNameId__c = :recordId];
        
        delete histories;
        return histories.size();
    }
}
