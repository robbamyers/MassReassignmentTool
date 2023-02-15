public with sharing class MassReassignmentToolBatchTaskUpdate implements Database.Batchable<sObject>{
    public String query;
    public String newUserId;

    public Database.querylocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Task> tl = new List<Task>();
        for(sObject s : scope){
            Task t = (Task) s;
            t.OwnerId = newUserId;
            tl.add(t);
        }
        update tl;

    }
    public void finish(Database.BatchableContext BC){
    }
}