<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_email_to_alert_that_Advance_has_final_approval</fullName>
        <description>Send email to alert that Advance has final approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>Processing_Counsel</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Processing_Team</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Processors</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Structured_Settlement</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>kharty@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF_Advance_Approved</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Approval_Status_to_Approved</fullName>
        <field>Approval_Status__c</field>
        <formula>&quot;Approved&quot;</formula>
        <name>Set Approval Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Status_to_Pending</fullName>
        <field>Approval_Status__c</field>
        <formula>&quot;Pending&quot;</formula>
        <name>Set Approval Status to Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Status_to_Rejected</fullName>
        <field>Approval_Status__c</field>
        <formula>&quot;Rejected&quot;</formula>
        <name>Set Approval Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <tasks>
        <fullName>Prepare_Advance_Docs</fullName>
        <assignedTo>abussey@bofi.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Prepare Advance Docs</subject>
    </tasks>
</Workflow>
