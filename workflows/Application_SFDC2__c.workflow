<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SFDC2_Email_Application_approved_to_MeridianLink_Loan_Officer</fullName>
        <description>SFDC2: Email Application approved to MeridianLink Loan Officer</description>
        <protected>false</protected>
        <recipients>
            <field>Loan_Officer_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC2_Enterprise_Templates/SFDC2_MeridianLink_Loan_Officer_Application_Status_Approved</template>
    </alerts>
    <rules>
        <fullName>SFDC2%3A Email Application approved to MeridianLink Loan Officer</fullName>
        <actions>
            <name>SFDC2_Email_Application_approved_to_MeridianLink_Loan_Officer</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application_SFDC2__c.Application_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>When the Application Status is changed, automatically send an email to the MeridianLink Loan Officer</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
