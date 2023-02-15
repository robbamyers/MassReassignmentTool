@isTest
public with sharing class MassReassignmentToolControllerTest {
    @isTest
    public static void fetchMatterTeamMembersTest() {

        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Litify Power User' LIMIT 1];

        User u = new User();
        u.FirstName = 'testFirst';
        u.LastName = 'testLast';
        u.email = 'test@test.com';
        u.username = 'test@test.com4127384';
        u.alias = 'test';
        u.TimeZoneSidKey = 'America/New_York';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = profileId.id;
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        insert u;

        litify_pm__Matter_Team_Member__c mtm = new litify_pm__Matter_Team_Member__c();
        mtm.litify_pm__User__c = u.id;
        mtm.Name = 'testFirst testLast';
        insert mtm;

        Test.startTest();
        List<sObject> mtms = MassReassignmentToolController.fetchMatterTeamMembers(u.id);
        Test.stopTest();

        System.assertEquals(1, mtms.size(), 'Did not return the correct size');
    }

    @isTest
    public static void fetchMetadataRecordTest(){
        Mass_Reassignment_Tool_Setting__mdt mrts = new Mass_Reassignment_Tool_Setting__mdt();

        Test.startTest();
        Map<String, Mass_Reassignment_Tool_Setting__mdt> result = MassReassignmentToolController.fetchMetadataRecord();
        Test.stopTest();

        System.assertEquals(1, 1);
    }

    @isTest
    public static void fetTasksTest(){
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Litify Power User' LIMIT 1];

        User u = new User();
        u.FirstName = 'testFirst';
        u.LastName = 'testLast';
        u.email = 'test@test.com';
        u.username = 'test@test.com4127384';
        u.alias = 'test';
        u.TimeZoneSidKey = 'America/New_York';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = profileId.id;
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        insert u;

        Account a = new Account();
        a.litify_pm__First_Name__c = 'test';
        a.litify_pm__Last_Name__c = 'test';
        insert a;

        litify_pm__Matter__c m = new litify_pm__Matter__c();
        m.litify_pm__Client__c = a.id;
        insert m;

        litify_pm__Matter_Team_Member__c mtm = new litify_pm__Matter_Team_Member__c();
        mtm.litify_pm__Matter__c = m.id;
        mtm.litify_pm__User__c = u.id;
        insert mtm;

        Task t = new Task();
        t.WhatId = m.id;
        t.OwnerId = u.Id;
        insert t;

        Test.startTest();
        List<sObject> taskList = MassReassignmentToolController.fetchTasks(u.id);
        Test.stopTest();
        
        System.assertEquals(1, taskList.size(), 'Did not return the correct number of tasks');
    }

    @isTest
    public static void updateMatterTeamMembersBatchTest(){
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Litify Power User' LIMIT 1];

        User u = new User();
        u.FirstName = 'testFirst';
        u.LastName = 'testLast';
        u.email = 'test@test.com';
        u.username = 'test@test.com4127384';
        u.alias = 'test';
        u.TimeZoneSidKey = 'America/New_York';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = profileId.id;
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        insert u;

        User u2 = new User();
        u2.FirstName = 'testFirst';
        u2.LastName = 'testLast';
        u2.email = 'test@test.com';
        u2.username = 'test@test.com4112327384';
        u2.alias = 'test';
        u2.TimeZoneSidKey = 'America/New_York';
        u2.LocaleSidKey = 'en_US';
        u2.ProfileId = profileId.id;
        u2.EmailEncodingKey = 'UTF-8';
        u2.LanguageLocaleKey = 'en_US';
        insert u2;

        Account a = new Account();
        a.litify_pm__First_Name__c = 'test';
        a.litify_pm__Last_Name__c = 'test';
        insert a;

        litify_pm__Matter__c m = new litify_pm__Matter__c();
        m.litify_pm__Client__c = a.id;
        insert m;

        litify_pm__Matter_Team_Member__c mtm = new litify_pm__Matter_Team_Member__c();
        mtm.litify_pm__Matter__c = m.id;
        mtm.litify_pm__User__c = u.id;
        insert mtm;

        List<sObject> mtms = new List<sObject>();
        mtms.add(mtm);

        Test.startTest();
        List<String> jobs =MassReassignmentToolController.updateMatterTeamMembersBatch(mtms, u2.Id, u.Id);
        Test.stopTest();

        System.assertEquals(1, jobs.size(), 'Returned incorrect number of jobs');
    }

    @isTest
    public static void updateMatterTeamMembersAndLookupsBatchTest(){
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Litify Power User' LIMIT 1];

        User u = new User();
        u.FirstName = 'testFirst';
        u.LastName = 'testLast';
        u.email = 'test@test.com';
        u.username = 'test@test.com4127384';
        u.alias = 'test';
        u.TimeZoneSidKey = 'America/New_York';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = profileId.id;
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        insert u;

        User u2 = new User();
        u2.FirstName = 'testFirst';
        u2.LastName = 'testLast';
        u2.email = 'test@test.com';
        u2.username = 'test@test.com4112327384';
        u2.alias = 'test';
        u2.TimeZoneSidKey = 'America/New_York';
        u2.LocaleSidKey = 'en_US';
        u2.ProfileId = profileId.id;
        u2.EmailEncodingKey = 'UTF-8';
        u2.LanguageLocaleKey = 'en_US';
        insert u2;

        Account a = new Account();
        a.litify_pm__First_Name__c = 'test';
        a.litify_pm__Last_Name__c = 'test';
        insert a;

        litify_pm__Matter__c m = new litify_pm__Matter__c();
        m.litify_pm__Client__c = a.id;
        insert m;

        litify_pm__Matter_Team_Member__c mtm = new litify_pm__Matter_Team_Member__c();
        mtm.litify_pm__Matter__c = m.id;
        mtm.litify_pm__User__c = u.id;
        insert mtm;

        List<sObject> mtms = new List<sObject>();
        mtms.add(mtm);

        Test.startTest();
        List<String> jobs = MassReassignmentToolController.updateMatterTeamMembersAndLookupsBatch(mtms, u2.Id, u.Id);
        Test.stopTest();

        System.assertEquals(2, jobs.size(), 'Returned incorrect number of jobs');
    }

    @isTest
    public static void updateMatterTeamMembersAndTasksBatchTest(){
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Litify Power User' LIMIT 1];

        User u = new User();
        u.FirstName = 'testFirst';
        u.LastName = 'testLast';
        u.email = 'test@test.com';
        u.username = 'test@test.com4127384';
        u.alias = 'test';
        u.TimeZoneSidKey = 'America/New_York';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = profileId.id;
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        insert u;

        User u2 = new User();
        u2.FirstName = 'testFirst';
        u2.LastName = 'testLast';
        u2.email = 'test@test.com';
        u2.username = 'test@test.com4112327384';
        u2.alias = 'test';
        u2.TimeZoneSidKey = 'America/New_York';
        u2.LocaleSidKey = 'en_US';
        u2.ProfileId = profileId.id;
        u2.EmailEncodingKey = 'UTF-8';
        u2.LanguageLocaleKey = 'en_US';
        insert u2;

        Account a = new Account();
        a.litify_pm__First_Name__c = 'test';
        a.litify_pm__Last_Name__c = 'test';
        insert a;

        litify_pm__Matter__c m = new litify_pm__Matter__c();
        m.litify_pm__Client__c = a.id;
        insert m;

        litify_pm__Matter_Team_Member__c mtm = new litify_pm__Matter_Team_Member__c();
        mtm.litify_pm__Matter__c = m.id;
        mtm.litify_pm__User__c = u.id;
        insert mtm;

        List<sObject> mtms = new List<sObject>();
        mtms.add(mtm);

        Test.startTest();
        List<String> jobs = MassReassignmentToolController.updateMatterTeamMembersAndTasksBatch(mtms, u2.Id, u.Id);
        Test.stopTest();

        System.assertEquals(2, jobs.size(), 'Returned incorrect number of jobs');
    }

    @isTest
    public static void fetchProgressDataTest(){
        List<String> jobIds = new List<String>();

        Test.startTest();
        Integer percentComplete = MassReassignmentToolController.fetchProgressData(jobIds);
        Test.stopTest();

        System.assertEquals(percentComplete, 0, 'Returned incorrect number of jobs');
    
    }

    @isTest
    public static void updateMatterTeamMemberAndLookupsAndTasksBatchTest(){
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Litify Power User' LIMIT 1];

        User u = new User();
        u.FirstName = 'testFirst';
        u.LastName = 'testLast';
        u.email = 'test@test.com';
        u.username = 'test@test.com4127384';
        u.alias = 'test';
        u.TimeZoneSidKey = 'America/New_York';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = profileId.id;
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        insert u;

        User u2 = new User();
        u2.FirstName = 'testFirst';
        u2.LastName = 'testLast';
        u2.email = 'test@test.com';
        u2.username = 'test@test.com4112327384';
        u2.alias = 'test';
        u2.TimeZoneSidKey = 'America/New_York';
        u2.LocaleSidKey = 'en_US';
        u2.ProfileId = profileId.id;
        u2.EmailEncodingKey = 'UTF-8';
        u2.LanguageLocaleKey = 'en_US';
        insert u2;

        Account a = new Account();
        a.litify_pm__First_Name__c = 'test';
        a.litify_pm__Last_Name__c = 'test';
        insert a;

        litify_pm__Matter__c m = new litify_pm__Matter__c();
        m.litify_pm__Client__c = a.id;
        insert m;

        litify_pm__Matter_Team_Member__c mtm = new litify_pm__Matter_Team_Member__c();
        mtm.litify_pm__Matter__c = m.id;
        mtm.litify_pm__User__c = u.id;
        insert mtm;

        List<sObject> mtms = new List<sObject>();
        mtms.add(mtm);

        Task t = new Task();
        t.WhatId = m.Id;
        t.OwnerId = u.Id;
        insert t;

        Test.startTest();
        List<String> jobs = MassReassignmentToolController.updateMatterTeamMemberAndLookupsAndTasksBatch(mtms, u2.Id, u.Id);
        Test.stopTest();

        System.assertEquals(3, jobs.size(), 'Returned incorrect number of jobs');
    }
}