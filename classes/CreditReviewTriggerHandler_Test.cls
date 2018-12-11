/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CreditReviewTriggerHandler_Test {

    /**
    * Tests the handleCreditReviewApproved trigger functionality
    */
    @isTest
    static void testHandleCreditReviewApproved() {
        Account acct = TestDataFactory.createAndInsertTestBusinessAccount();
        WLD_Certification__c cert = TestDataFactory.createAndInsertTestCertification(acct, TestDataFactory.CertificationType.ACCOUNT);
        WLD_Credit_Review__c cred = TestDataFactory.createTestCreditReview(cert);
        cred.Credit_Status__c = 'QLR Prep';
        insert cred;
        
        System.test.startTest();
        cred.TriggerApprovedProcess__c = true;
        update cred;
        System.test.stopTest();
        
        cred = [
                SELECT TriggerApprovedProcess__c, Certification__r.Status__c 
                FROM WLD_Credit_Review__c 
                WHERE Id = :cred.Id];
        System.assertEquals(false, cred.TriggerApprovedProcess__c, 'TriggerApprovedProcess did not reset');
        System.assertEquals('Completed', cred.Certification__r.Status__c, 'Certification Status did not update');
    }
    
    /**
    * Tests the handleCertFieldUpdates trigger functionality
    */
    @isTest
    static void testHandleCertFieldUpdates() {
        Account acct = TestDataFactory.createAndInsertTestBusinessAccount();
        WLD_Certification__c cert = TestDataFactory.createAndInsertTestCertification(acct, TestDataFactory.CertificationType.ACCOUNT);
        WLD_Credit_Review__c cred = TestDataFactory.createTestCreditReview(cert);
        cred.Obligor_Score__c = 1;
        cred.Risk_Rating__c = 2;
        cred.Credit_Status__c = 'Test1';
        insert cred;
        
        cert = [
                SELECT Obligor_Score__c, Risk_Rating__c, Credit_Review_Status__c 
                FROM WLD_Certification__c
                WHERE Id = :cert.Id];
        System.assertEquals(1, cert.Obligor_Score__c, 'Obligor Score was not updated on Credit Review insert');
        System.assertEquals(2, cert.Risk_Rating__c, 'Risk Rating was not updated on Credit Review insert');
        System.assertEquals('Test1', cert.Credit_Review_Status__c, 'Credit Review Status was not updated on Credit Review insert');
        
        cred.Obligor_Score__c = 3;
        cred.Risk_Rating__c = 4;
        cred.Credit_Status__c = 'Test2';
        update cred;
        
        cert = [
                SELECT Obligor_Score__c, Risk_Rating__c, Credit_Review_Status__c
                FROM WLD_Certification__c
                WHERE Id = :cert.Id];
        System.assertEquals(3, cert.Obligor_Score__c, 'Obligor Score was not updated on Credit Review update');
        System.assertEquals(4, cert.Risk_Rating__c, 'Risk Rating was not updated on Credit Review update');
        System.assertEquals('Test2', cert.Credit_Review_Status__c, 'Credit Review Status was not updated on Credit Review update');
    }
    
    /**
    * Tests the handleCreditReviewUniquenessForCert trigger functionality
    */
    @isTest
    static void testHandleCreditReviewUniquenessForCert() {
        Account acct = TestDataFactory.createAndInsertTestBusinessAccount();
        WLD_Certification__c cert = TestDataFactory.createAndInsertTestCertification(acct, TestDataFactory.CertificationType.ACCOUNT);
        WLD_Credit_Review__c cred = TestDataFactory.createTestCreditReview(cert);
        cred.Credit_Status__c = 'QLR Prep';
        insert cred;
        
        System.test.startTest();
        WLD_Credit_Review__c[] credArray = new List<WLD_Credit_Review__c>{TestDataFactory.createTestCreditReview(cert),TestDataFactory.createTestCreditReview(cert)};
        try {
            insert credArray;
            System.assert(false, 'Should not be able to create more than one Credit Review for a Certification');
        } catch (Dmlexception e) {}
        System.test.stopTest();
    }
    
    /**
    * Tests the handleStatusHistoryCreation trigger functionality
    */
    @isTest
    static void testHandleStatusHistoryCreation() {
        Account acct = TestDataFactory.createAndInsertTestBusinessAccount();
        WLD_Certification__c cert = TestDataFactory.createAndInsertTestCertification(acct, TestDataFactory.CertificationType.ACCOUNT);
        WLD_Credit_Review__c cred = TestDataFactory.createTestCreditReview(cert);
        cred.Credit_Status__c = 'Test1';
        
        System.test.startTest();
        insert cred;
        cred.Credit_Status__c = 'Test2';
        update cred;
        System.test.stopTest();
        
        cred = [
                SELECT Id, 
                    (SELECT 
                        Name, Credit_Review__c, Next_Status__c
                     FROM Status_History__r) 
                FROM WLD_Credit_Review__c WHERE Id = :cred.Id];
        System.assertEquals(2, cred.Status_History__r.size(), 'Did not create appropriate number of Status History records');
        Id linkedStatus;      
        Id latestStatus;
        
        for(WLD_Status_History__c sh : cred.Status_History__r) {
            if(sh.Next_Status__c == null) {
                //last status should be Test2
                latestStatus = sh.Id;
                System.assertEquals('Test2', sh.Name, 'Last status was not created properly');
            } else {
                //first status should be Test1
                linkedStatus = sh.Next_Status__c;
                System.assertEquals('Test1', sh.Name, 'Second status was not created properly');
            }
        }
        System.assertEquals(latestStatus, linkedStatus, 'First Status not linked properly');
    }
    
    /**
    * Tests the handleCreditReviewDenied trigger functionality
    */
    /*@isTest
    static void testHandleCreditReviewDenied() {
        Account acct = TestDataFactory.createAndInsertTestBusinessAccount();
        WLD_Certification__c cert = TestDataFactory.createAndInsertTestCertification(acct, TestDataFactory.CertificationType.ACCOUNT);
        WLD_Credit_Review__c cred = TestDataFactory.createTestCreditReview(cert);
        cred.Credit_Status__c = 'QLR Prep';
        insert cred;
        
        System.test.startTest();
        cred.TriggerDeniedProcess__c = true;
        update cred;
        System.test.stopTest();
        
        cred = [
                SELECT TriggerDeniedProcess__c, Certification__r.Status__c 
                FROM WLD_Credit_Review__c 
                WHERE Id = :cred.Id];
        System.assertEquals(false, cred.TriggerDeniedProcess__c, 'TriggerDeniedProcess did not reset');
        System.assertEquals('Denied', cred.Certification__r.Status__c, 'Certification Status did not update');
    }*/
}