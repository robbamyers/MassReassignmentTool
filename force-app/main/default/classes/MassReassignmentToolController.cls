public with sharing class MassReassignmentToolController {
    
    @AuraEnabled(cacheable=true)
    public static List<sObject> fetchMatterTeamMembers(String userId){
        if(litify_pm__Matter_Team_Member__c.SObjectType.getDescribe().isAccessible()){
            return [SELECT id FROM litify_pm__Matter_Team_Member__c WHERE litify_pm__User__c = :userId];
        }
        else{
            return null;
        }
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Mass_Reassignment_Tool_Setting__mdt> fetchMetadataRecord(){
        return Mass_Reassignment_Tool_Setting__mdt.getAll();
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> fetchTasks(String userId){
        if(litify_pm__Matter_Team_Member__c.SObjectType.getDescribe().isAccessible() && Task.SObjectType.getDescribe().isAccessible()){
            return [SELECT Id FROM Task WHERE WhatId IN (SELECT litify_pm__Matter__c FROM litify_pm__Matter_Team_Member__c WHERE litify_pm__User__c = :userId) AND Status = 'Not Started' AND OwnerId = :userId];
        }
        else{
            return null;
        }
    }

    @AuraEnabled
    public static List<String> updateMatterTeamMembersBatch(List<sObject> matterTeamMembers, String newUserId, String currentUserId){
        List<String> jobIds = new List<String>();
        MassReassignmentToolBatchMTMUpdate b = new MassReassignmentToolBatchMTMUpdate();
        b.query = 'SELECT id FROM litify_pm__Matter_Team_Member__c WHERE litify_pm__User__c =\'' + currentUserId + '\'';
        b.newUserId = newUserId;
        b.currentUserId = currentUserId;
        jobIds.add(Database.executeBatch(b, 5));
        return jobIds;
    }

    @AuraEnabled
    public static List<String> updateMatterTeamMembersAndLookupsBatch(List<sObject> matterTeamMembers, String newUserId, String currentUserId){
        List<String> jobIds = new List<String>();
        Map<String, Mass_Reassignment_Tool_Setting__mdt> metadata = Mass_Reassignment_Tool_Setting__mdt.getAll();
        List<String> lookupApiNames = new List<String>();
        for(String key : metadata.keySet()) {
            lookupApiNames.add(metadata.get(key).get('Field_API_Name__c').toString());
        }
        List<litify_pm__Matter__c> mattersToUpdate = new List<litify_pm__Matter__c>();
        String query = 'Select Id, ' + String.join(lookupApiNames, ', ') + ' FROM litify_pm__Matter__c WHERE Id IN (SELECT litify_pm__Matter__C FROM litify_pm__Matter_Team_Member__c WHERE litify_pm__User__c = \'' + currentUserId + '\')';
        
        MassReassignmentToolBatchUpdate b = new MassReassignmentToolBatchUpdate();
        b.query = query;
        b.lookupApiNames = lookupApiNames;
        b.currentUserId = currentUserId;
        b.newUserId = newUserId;    
        jobIds.add(Database.executeBatch(b, 5));
        List<String> mtmtJobId = updateMatterTeamMembersBatch(matterTeamMembers, newUserId, currentUserId);
        for(String s : mtmtJobId){
            jobIds.add(s);
        }
        return jobIds;
    }

    @AuraEnabled
    public static List<String> updateMatterTeamMembersAndTasksBatch(List<sObject> matterTeamMembers, String newUserId, String currentUserId){
        List<String> jobIds = new List<String>();
        String query = 'SELECT Id, OwnerId FROM Task WHERE WhatId IN (SELECT litify_pm__Matter__c FROM litify_pm__Matter_Team_Member__c WHERE litify_pm__User__c = \'' + currentUserId + '\') AND Status = \'Not Started\'';
        MassReassignmentToolBatchTaskUpdate b = new MassReassignmentToolBatchTaskUpdate();
        b.query = query;
        b.newUserId = newUserId;
        jobIds.add(Database.executeBatch(b, 5));
        List<String> updateJobIds = updateMatterTeamMembersBatch(matterTeamMembers, newUserId, currentUserId);
        for(String s : updateJobIds){
            jobIds.add(s);
        }
        return jobIds;
    }

    @AuraEnabled
    public static Integer fetchProgressData(List<String> jobIds){
        if(jobIds.size() == 0){
            return 0;
        }
        else{
            String query = 'SELECT Id, TotalJobItems, JobItemsProcessed FROM AsyncApexJob WHERE ';
            for(String s : jobIds){
                query += 'Id = \'' + s + '\' OR ';
            }
            String newQuery = query.substring(0,query.length() - 4);
            List<AsyncApexJob> batchJobs = Database.query(newQuery);
            Integer totalJobs = 0;
            Integer totalCompleted = 0;
            for(AsyncApexJob a : batchJobs){
                totalJobs += a.TotalJobItems;
                totalCompleted += a.JobItemsProcessed;
            }
            if (totalJobs != 0) {
                return Math.round((totalCompleted * 100.0) / totalJobs);
            } else {
                return 0;
            }
        }
    }

    @AuraEnabled
    public static List<String> updateMatterTeamMemberAndLookupsAndTasksBatch(List<sObject> matterTeamMembers, String newUserId, String currentUserId){
        List<String> jobIds = new List<String>();
        // Update Tasks
        String query = 'SELECT Id, OwnerId FROM Task WHERE WhatId IN (SELECT litify_pm__Matter__c FROM litify_pm__Matter_Team_Member__c WHERE litify_pm__User__c = \'' + currentUserId + '\') AND Status = \'Not Started\'';
        MassReassignmentToolBatchTaskUpdate b = new MassReassignmentToolBatchTaskUpdate();
        b.query = query;
        b.newUserId = newUserId;
        jobIds.add(Database.executeBatch(b, 5));
        // Update Lookups and MTMs
        List<String> mtmLookupBatchJobs = updateMatterTeamMembersAndLookupsBatch(matterTeamMembers, newUserId, currentUserId);
        // Add batches to jobIds
        for(String s : mtmLookupBatchJobs){
            jobIds.add(s);
        }
        return jobIds;
    }

    
}

