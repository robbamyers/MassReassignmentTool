public with sharing class MassReassignmentToolMatterBatchUpdate implements Database.Batchable<sObject>{
    public String query;
    public String currentUserId;
    public String newUserId;
    public List<String> lookupApiNames;

    public Database.querylocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope){
        List<litify_pm__Matter__c> mtrs = new List<litify_pm__Matter__c>();

        Boolean fieldUpdated = false;
        for(sObject s : scope){
            litify_pm__Matter__c mat = (litify_pm__Matter__c) s;
            for(String field : lookupApiNames){
                if(mat.get(field) == currentUserId){
                    mat.put(field, newUserId);
                    fieldUpdated = true;
                }
            }
            if(fieldUpdated){ //this is required because otherwise the loop will put in the same record twice to the list if the user appears in multiple lookups
                mtrs.add(mat);
                fieldUpdated = false;
            }
        }
        update mtrs;
    }
    public void finish(Database.BatchableContext BC){}
}