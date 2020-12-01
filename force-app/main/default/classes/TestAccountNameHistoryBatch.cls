public class TestAccountNameHistoryBatch implements Database.Batchable<sObject> {

    private Set<Id> ids;

    public TestAccountNameHistoryBatch(Set<Id> ids) {
        this.ids = ids;
    }

    public List<TestAccountNameHistory__c> start(Database.BatchableContext bc) {
        return [SELECT Name, TestAccountNameId__r.Name FROM TestAccountNameHistory__c WHERE TestAccountNameId__c IN :ids];
    }

    public void execute(Database.BatchableContext bc, List<TestAccountNameHistory__c> scope) {
        List<TestAccountNameHistory__c> results = new List<TestAccountNameHistory__c>();

        for(TestAccountNameHistory__c history : scope){
            if (history.Name != history.TestAccountNameId__r.Name) {
                history.Name = history.TestAccountNameId__r.Name;
            }
            results.add(history);
        }

        try {
            System.debug(results);
            update results;
        } catch(Exception e) {
            System.debug(e);
        }
    }    

    public void finish(Database.BatchableContext bc) {
    }    
}

