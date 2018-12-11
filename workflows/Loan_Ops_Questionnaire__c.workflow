<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>C_I_LOQ_Approved</fullName>
        <description>C&amp;I: LOQ Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Initial_Submitter__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/C_I_LOQ_Approved</template>
    </alerts>
    <alerts>
        <fullName>C_I_LOQ_Rejected</fullName>
        <description>C&amp;I: LOQ Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>Initial_Submitter__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/C_I_LOQ_Rejected</template>
    </alerts>
    <alerts>
        <fullName>LOQ_Status_Notification_Approval</fullName>
        <description>LOQ Status Notification Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Deal_Team_Member_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Deal_Team_Member_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Deal_Team_Member_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/C_I_LOQ_Status_Notifications</template>
    </alerts>
    <alerts>
        <fullName>LOQ_Status_Notification_Approval_Process</fullName>
        <description>LOQ Status Notification Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>QA</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Loan_Ops_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/C_I_LOQ_Status_Notifications</template>
    </alerts>
    <alerts>
        <fullName>LOQ_Status_Notification_Approval_process_a</fullName>
        <description>LOQ Status Notification Approval_process_a</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Deal_Team_Member_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Deal_Team_Member_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Deal_Team_Member_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>QA</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/C_I_LOQ_Status_Notifications</template>
    </alerts>
    <alerts>
        <fullName>LOQ_Status_Notification_Rejected</fullName>
        <description>LOQ Status Notification Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Deal_Team_Member_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Deal_Team_Member_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Deal_Team_Member_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>QA</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/C_I_LOQ_Status_Notifications</template>
    </alerts>
    <alerts>
        <fullName>LOQ_Status_Notification_Submitted_for_Approval</fullName>
        <description>LOQ Status Notification Submitted for Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>Loan_Ops_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/C_I_LOQ_Status_Notifications</template>
    </alerts>
    <alerts>
        <fullName>SFDC2_LOQ_24h_Reminder_Alert</fullName>
        <description>SFDC2: LOQ 24h Reminder Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>QA</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Loan_Ops_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC2_Enterprise_Templates/SFDC2_LOQ_24h_Reminder_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>C_I_LOQ_ApprovalSubmitted</fullName>
        <field>ApprovalSubmitted__c</field>
        <literalValue>1</literalValue>
        <name>C&amp;I: LOQ ApprovalSubmitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_LOQ_Approved</fullName>
        <field>LOQ_Status__c</field>
        <literalValue>LOQ Approved</literalValue>
        <name>C&amp;I: LOQ Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_LOQ_Initial_Submitter</fullName>
        <field>Initial_Submitter__c</field>
        <formula>$User.Email</formula>
        <name>C&amp;I: LOQ Initial Submitter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_LOQ_Recalled</fullName>
        <field>LOQ_Status__c</field>
        <literalValue>LOQ Recalled</literalValue>
        <name>C&amp;I: LOQ Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_LOQ_Rejected</fullName>
        <field>LOQ_Status__c</field>
        <literalValue>LOQ Rejected</literalValue>
        <name>C&amp;I: LOQ Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_LOQ_Submitted_for_Approval</fullName>
        <field>LOQ_Status__c</field>
        <literalValue>LOQ Submitted for approval</literalValue>
        <name>C&amp;I: LOQ Submitted for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LOQ_Approved</fullName>
        <description>The Loan Ops Manager  Aprroved the LOQ</description>
        <field>LOQ_Status__c</field>
        <literalValue>LOQ Approved</literalValue>
        <name>LOQ Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LOQ_ReCalled_SFDC2</fullName>
        <field>LOQ_Status__c</field>
        <literalValue>LOQ Recalled</literalValue>
        <name>LOQ ReCalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LOQ_Rejected_SFDC2</fullName>
        <description>LOQ rejected the aprroval process</description>
        <field>LOQ_Status__c</field>
        <literalValue>LOQ Rejected</literalValue>
        <name>LOQ Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prior_LOQ_Status</fullName>
        <description>Save the prior LOQ Status</description>
        <field>OldLOQStatus__c</field>
        <formula>TEXT(PRIORVALUE(LOQ_Status__c))</formula>
        <name>Prior  LOQ Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prior_LOQ_Status_Approval</fullName>
        <description>Save the prior LOQ Status</description>
        <field>OldLOQStatus__c</field>
        <formula>TEXT(PRIORVALUE(LOQ_Status__c))</formula>
        <name>Prior LOQ Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_RT_Master_LOQ_SFDC2</fullName>
        <description>Return to Master LOQ RecordType</description>
        <field>RecordTypeId</field>
        <lookupValue>LOQ</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update RT  Master LOQ</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_RT_SubForApp_SFDC2</fullName>
        <description>Show button submitted for Approval</description>
        <field>RecordTypeId</field>
        <lookupValue>LOQ_SubmmitedForApproval</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update RT SubForApp SFDC2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_RecT_SubForApp_SFDC2</fullName>
        <description>Update page layout with the submited for approval button</description>
        <field>RecordTypeId</field>
        <lookupValue>LOQ_SubmmitedForApproval</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update RecT SubForApp SFDC2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SFDC2 Update RecordType for SummitedForApproval</fullName>
        <actions>
            <name>Update_RT_SubForApp_SFDC2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8 AND 9</booleanFilter>
        <criteriaItems>
            <field>Loan_Ops_Questionnaire__c.Collateral_Type__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Loan_Ops_Questionnaire__c.Term_Type__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Loan_Ops_Questionnaire__c.Interest_Rate_Type__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Loan_Ops_Questionnaire__c.Borrower_Relationship__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Loan_Ops_Questionnaire__c.Collateral_Secured__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Loan_Ops_Questionnaire__c.Property_Type__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Loan_Ops_Questionnaire__c.Collateral_Type_RE__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Loan_Ops_Questionnaire__c.Addl_LOQ_Options__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Loan_Ops_Questionnaire__c.LOQ_Status__c</field>
            <operation>equals</operation>
            <value>LOQ In Progress</value>
        </criteriaItems>
        <description>Update the recordtype to show the Submmited for Approval button</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
