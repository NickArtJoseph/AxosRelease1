<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Weekly_User_Report_Checkbox</fullName>
        <field>Weekly_User_Report_Weekly_Trigger__c</field>
        <literalValue>1</literalValue>
        <name>Update Weekly User Report Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>New Automatic Record Created</fullName>
        <actions>
            <name>Update_Weekly_User_Report_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Automatically_Created_Record__c=TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
