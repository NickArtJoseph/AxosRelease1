<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>LLC_BI__approval_ready_for_review</fullName>
        <description>approval ready for review</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LLC_BI__Primary_Officer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/LLC_BI__Product_Package_Ready_For_Approval</template>
    </alerts>
    <fieldUpdates>
        <fullName>LLC_BI__Product_Package_Status_Approved</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Product Package Status: Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Product_Package_Status_In_Review</fullName>
        <description>Product Package Status: In Review</description>
        <field>LLC_BI__Status__c</field>
        <literalValue>In Review</literalValue>
        <name>Product Package Status: In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Product_Package_Status_Itm_Approved</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>Intermediately Approved</literalValue>
        <name>Product Package Status: Itm Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Product_Package_Status_Recalled</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Product Package Status: Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Product_Package_Status_Rejected</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Product Package Status: Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Work_Package_Status_In_Review</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>In Review</literalValue>
        <name>Work Package Status: In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__approve_update</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>Intermediately Approved</literalValue>
        <name>approve update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__itm_approve</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>Approved</literalValue>
        <name>itm approve2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__itm_reject</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>itm reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__update_approval_field</fullName>
        <description>Updates a secondary Approval Status, used to trigger next steps in a reverse propagation approval process</description>
        <field>LLC_BI__Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Update Approval Status Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>LLC_BI__Package Approval Ready</fullName>
        <actions>
            <name>LLC_BI__approval_ready_for_review</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND( ISPICKVAL(LLC_BI__Approval_Status__c, &apos;Ready&apos;), ISPICKVAL(PRIORVALUE(LLC_BI__Approval_Status__c), &apos;Pending&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>LLC_BI__Product_Package_Next_Review_Task</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>LLC_BI__Product_Package__c.LLC_BI__Next_Review_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Product Package Review</subject>
    </tasks>
</Workflow>
