<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Reset_User_Deactivation_Date</fullName>
        <description>Clears the User Deactivation Date/Time field</description>
        <field>Deactivation_Date__c</field>
        <name>Reset User Deactivation Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>User_Deactivation_Date</fullName>
        <description>Set the User Deactivation date/time</description>
        <field>Deactivation_Date__c</field>
        <formula>NOW()</formula>
        <name>User Deactivation Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Enterprise%3A Active is false</fullName>
        <actions>
            <name>User_Deactivation_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Enterprise - Workflow when user is deactivated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Enterprise%3A Active is true</fullName>
        <actions>
            <name>Reset_User_Deactivation_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Enterprise - Workflow when user is reactivated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
