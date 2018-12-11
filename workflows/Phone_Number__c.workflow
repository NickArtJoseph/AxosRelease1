<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Contact_made_sales_status_update</fullName>
        <description>change sales status field to contact made</description>
        <field>Sales_Status_Person__c</field>
        <literalValue>Contact Made</literalValue>
        <name>Contact made sales status update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Account_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SMS_Neustar_off</fullName>
        <description>Uncheck the SMS neustar</description>
        <field>SMS_Enabled_SFDC2__c</field>
        <literalValue>0</literalValue>
        <name>SMS Neustar off</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SMS_Enabled</fullName>
        <description>SMS Enabled is true</description>
        <field>SMS_Enabled_SFDC2__c</field>
        <literalValue>1</literalValue>
        <name>Update SMS Enabled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SF%3A Account%3ASales Status is not a certain value and Phone Number%3AStatus is Correct Contact</fullName>
        <actions>
            <name>Contact_made_sales_status_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Lottery Winners,Specialty Finance - SS Annuitants,Specialty Finance - IGT Winners</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Sales_Status_Person__c</field>
            <operation>notEqual</operation>
            <value>Contact Made,Relationship Established,Pricing Soon,Deal In Process,Remarket</value>
        </criteriaItems>
        <criteriaItems>
            <field>Phone_Number__c.Status__c</field>
            <operation>equals</operation>
            <value>Correct Contact</value>
        </criteriaItems>
        <description>SF - change the sales status to correct contact when a phone # result reflects as correct contact</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SMS Embebed</fullName>
        <actions>
            <name>Update_SMS_Enabled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Phone_Number__c.Neustar_Prepaid_Phone_Attributes__c</field>
            <operation>equals</operation>
            <value>N,n</value>
        </criteriaItems>
        <criteriaItems>
            <field>Phone_Number__c.Neustar_In_Service_Indicator__c</field>
            <operation>equals</operation>
            <value>A1,A2,A3,A4,A5,A6,A7,a1,a2,a3,a4,a5,a6,a7</value>
        </criteriaItems>
        <criteriaItems>
            <field>Phone_Number__c.Neustar_Phone_Type_Indicator__c</field>
            <operation>equals</operation>
            <value>W,w</value>
        </criteriaItems>
        <description>The phone number field for the Consumer Person Account Page Layout for the Phone Number custom object needs to reflect the Mobile value for the Consumer Person Account SFDC2</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SMS Embebed off</fullName>
        <actions>
            <name>SMS_Neustar_off</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Phone_Number__c.Neustar_Prepaid_Phone_Attributes__c</field>
            <operation>notEqual</operation>
            <value>N,n</value>
        </criteriaItems>
        <criteriaItems>
            <field>Phone_Number__c.Neustar_In_Service_Indicator__c</field>
            <operation>notEqual</operation>
            <value>A1,A2,A3,A4,A5,A6,A7,a1,a2,a3,a4,a5,a6,a7</value>
        </criteriaItems>
        <criteriaItems>
            <field>Phone_Number__c.Neustar_Phone_Type_Indicator__c</field>
            <operation>notEqual</operation>
            <value>W,w</value>
        </criteriaItems>
        <description>The phone number field for the Consumer Person Account Page Layout for the Phone Number custom object needs to reflect the Mobile value for the Consumer Person Account SFDC2</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
