public with sharing class MassReassignmentToolBatchMTMUpdate implements Database.Batchable<sObject>{
    public String query;
    public String currentUserId;
    public String newUserId;

    public Database.querylocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope){
        List<litify_pm__Matter_Team_Member__c> mtmList = new List<litify_pm__Matter_Team_Member__c>();
        for (sObject s : scope) {
            litify_pm__Matter_Team_Member__c m = (litify_pm__Matter_Team_Member__c) s;
            m.litify_pm__User__c = newUserId;
            mtmList.add(m);
        }
        if(Schema.sObjectType.litify_pm__Matter_Team_Member__c.fields.litify_pm__User__c.isUpdateable()){
            update mtmList;
        }
    }
    public void finish(Database.BatchableContext BC){}
}