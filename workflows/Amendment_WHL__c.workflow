<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>WLD_Amendment_Send_Notification</fullName>
        <description>WLD: Amendment - Send Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>csilvius@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nicole@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Warehouse_Lending/WLD_Amendments</template>
    </alerts>
    <fieldUpdates>
        <fullName>WLD_Amendement_Fully_Exec_Email_Sent</fullName>
        <field>Fully_Executed_Email_Sent__c</field>
        <literalValue>1</literalValue>
        <name>WLD: Amendement - Fully Exec Email Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WLD_Amendment_Check_Fully_Executed</fullName>
        <description>Sets Fully Executed to True</description>
        <field>Fully_Executed__c</field>
        <literalValue>1</literalValue>
        <name>WLD: Amendment - Check Fully Executed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WLD_Amendment_Uncheck_Fully_Executed</fullName>
        <field>Fully_Executed__c</field>
        <literalValue>0</literalValue>
        <name>WLD: Amendment - Uncheck Fully Executed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WLD%3A Amendment - Fully Executed</fullName>
        <actions>
            <name>WLD_Amendment_Check_Fully_Executed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Amendment_WHL__c.Amendment_Status__c</field>
            <operation>equals</operation>
            <value>Fully Executed (completed)</value>
        </criteriaItems>
        <description>Sets the Fully Executed checkbox when the corresponding Status is selected on the Amendment</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WLD%3A Amendment - Not Fully Executed</fullName>
        <actions>
            <name>WLD_Amendment_Uncheck_Fully_Executed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Amendment_WHL__c.Amendment_Status__c</field>
            <operation>notEqual</operation>
            <value>Fully Executed (completed)</value>
        </criteriaItems>
        <description>Sets the Fully Executed checkbox to false when the Status of an Amendment is not Fully Executed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WLD%3A Amendment - Send Fully Executed Email</fullName>
        <actions>
            <name>WLD_Amendment_Send_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>WLD_Amendement_Fully_Exec_Email_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Amendment_WHL__c.Amendment_Status__c</field>
            <operation>equals</operation>
            <value>Fully Executed (completed)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Amendment_WHL__c.Fully_Executed_Email_Sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Sends email notification the first time the Amendment Status is set to Fully Executed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
