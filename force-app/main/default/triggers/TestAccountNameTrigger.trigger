trigger TestAccountNameTrigger on Account (after insert, after update, after delete) {
    new CustomMDTTriggerHandler().run();
}