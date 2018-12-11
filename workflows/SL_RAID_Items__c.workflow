<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SL_Work_Item_Assignment</fullName>
        <description>Work Item Assignment</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SL_Work_Item_Assignment</template>
    </alerts>
    <rules>
        <fullName>Work Item Assignment</fullName>
        <actions>
            <name>SL_Work_Item_Assignment</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends an email alert to the newly assigned user.</description>
        <formula>OR(ISNEW(), ISCHANGED(Assigned_To__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
