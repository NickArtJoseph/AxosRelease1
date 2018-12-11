<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>WLD_Credit_Review_Approved</fullName>
        <description>WLD Credit Review Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>WLD_Account_Management</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Warehouse_Lending/WLD_Credit_Review_Approved</template>
    </alerts>
    <alerts>
        <fullName>WLD_Incomplete_Package</fullName>
        <description>WLD Incomplete Package</description>
        <protected>false</protected>
        <recipients>
            <recipient>WLD_Account_Management</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Warehouse_Lending/WLD_Certification_Incomplete</template>
    </alerts>
    <fieldUpdates>
        <fullName>WLD_Credit_Review_Approved</fullName>
        <description>Sets the Credit Status to Approved after final approval</description>
        <field>Credit_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>WLD: Credit Review - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WLD_Credit_Review_Management_Review</fullName>
        <description>Sets the Credit Status field to Management Review upon approval initiaion</description>
        <field>Credit_Status__c</field>
        <literalValue>Management Review</literalValue>
        <name>WLD: Credit Review - Management Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WLD_Reset_Marked_Incomplete</fullName>
        <description>Resets the Marked Incomplete field to false</description>
        <field>Marked_Incomplete__c</field>
        <literalValue>0</literalValue>
        <name>WLD: Reset Marked Incomplete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WLD_TriggerApprovedProcess</fullName>
        <description>Sets TriggerApprovedProcess to true so that the Certification record can be updated</description>
        <field>TriggerApprovedProcess__c</field>
        <literalValue>1</literalValue>
        <name>WLD TriggerApprovedProcess</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WLD%3A Incomplete Package Notification</fullName>
        <actions>
            <name>WLD_Incomplete_Package</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>WLD_Reset_Marked_Incomplete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WLD_Credit_Review__c.Marked_Incomplete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When user clicks on Incomplete button on Credit review, this workflow should trigger to update the Credit Status, the parent Certification Status, and trigger an email notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
