public with sharing class TestAccountNameTriggerHandler extends TriggerHandler {
    
    private List<Account> newAccounts;
    private List<Account> oldAccounts;
    private Map<Id, Account> newAccountNameMap;
    private Map<Id, Account> oldAccountNameMap;

    public TestAccountNameTriggerHandler() {
        this.newAccounts = (List<Account>) Trigger.new;
        this.oldAccounts = (List<Account>) Trigger.old;
        this.newAccountNameMap = (Map<Id, Account>) Trigger.newMap;
        this.oldAccountNameMap = (Map<Id, Account>) Trigger.oldMap;
    }

    public override void afterInsert() {
        List<TestAccountName__c> testAccountNames = new List<TestAccountName__c>();

        for (Account account : newAccounts) {
            testAccountNames.add(
                new TestAccountName__c(Name=account.Name, Status__c='CREATED', AccountId__c=account.Id)
            );
        }
        insert testAccountNames;
    }

    public override void afterUpdate() {
        List<Account> updatedAccounts = new List<Account>();
        Set<Id> updatedAccountsIds = new Set<Id>();
 
        for (Account account : newAccounts) {
            if (account.Name != oldAccountNameMap.get(account.Id).Name) {
                updatedAccounts.add(account);
                updatedAccountsIds.add(account.Id);
            }
        }

        Map<Id, TestAccountName__c> testAccountNames = new Map<Id, TestAccountName__c>([
            SELECT Id, AccountId__c 
            FROM TestAccountName__c 
            WHERE AccountId__c IN :updatedAccountsIds
        ]);
            
        List<TestAccountName__c> results = new List <TestAccountName__c>();
        
        for (TestAccountName__c testAccountName : testAccountNames.values()) {
            if (newAccountNameMap.containsKey(testAccountName.AccountId__c)) {
                testAccountName.Name = newAccountNameMap.get(testAccountName.AccountId__c).Name;
                testAccountName.Status__c = 'UPDATED';
                results.add(testAccountName);
            }
        }
        update results;
    }

    public override void afterDelete() {
        List<TestAccountName__c> results = new List<TestAccountName__c>();
        Set<Id> accountIds = new Set<Id>();

        for (Account account : oldAccounts){ 
            accountIds.add(account.Id);
        }

        for(TestAccountName__c testAccountName : [SELECT Status__c FROM TestAccountName__c WHERE DeletedAccountId__c IN :accountIds]) {
            testAccountName.Status__c='DELETED';
            results.add(testAccountName);
        }
        update results;
    }
}