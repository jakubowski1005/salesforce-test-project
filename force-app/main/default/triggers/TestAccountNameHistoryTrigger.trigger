trigger TestAccountNameHistoryTrigger on TestAccountName__c (after insert, after update) {
    new CustomMDTTriggerHandler().run();
}