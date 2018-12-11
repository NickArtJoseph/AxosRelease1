<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>nFUSE__Change_TransLog_Status</fullName>
        <description>Change the status when timeout occured</description>
        <field>nFUSE__Transaction_Status__c</field>
        <formula>&quot;Timeout Occurred&quot;</formula>
        <name>Change TransLog Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>nFUSE__DocPrepTimeoutRule</fullName>
        <active>false</active>
        <criteriaItems>
            <field>nFUSE__Transaction_Log__c.nFUSE__Transaction_Status__c</field>
            <operation>notEqual</operation>
            <value>Transaction Complete</value>
        </criteriaItems>
        <description>Update the transaction log status when a request is not returned for the transaction</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
