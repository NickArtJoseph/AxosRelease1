<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BF_Status_Notification_Approval</fullName>
        <description>BF Status Notification Approval</description>
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
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/C_I_BF_Status_Notifications</template>
    </alerts>
    <alerts>
        <fullName>BF_Status_Notification_Pre_Approval_Approval</fullName>
        <description>BF Status Notification Pre-Approval, Approval</description>
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
        <template>C_I_Email_Templates/C_I_BF_Status_Notifications</template>
    </alerts>
    <alerts>
        <fullName>BF_Status_Notification_Pre_Approval_WF</fullName>
        <description>BF Status Notification Pre-Approval WF</description>
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
        <template>C_I_Email_Templates/C_I_BF_Submitted_for_Approval</template>
    </alerts>
    <alerts>
        <fullName>BF_Status_Notification_Rejected</fullName>
        <description>BF Status Notification Rejected</description>
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
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/C_I_BF_Status_Notifications</template>
    </alerts>
    <alerts>
        <fullName>BF_Status_Notification_Submitted_Approval</fullName>
        <description>BF Status Notification Submitted Approval</description>
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
        <template>C_I_Email_Templates/C_I_BF_Status_Notifications</template>
    </alerts>
    <alerts>
        <fullName>BF_Status_Notification_Submitted_for_Approval_and_Rejected</fullName>
        <description>BF Status Notification Submitted for Approval and Rejected</description>
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
        <template>C_I_Email_Templates/C_I_BF_Status_Notifications</template>
    </alerts>
    <alerts>
        <fullName>C_I_BF_Approved</fullName>
        <description>C&amp;I: BF Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>Collateral_Analyst</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Collateral_Manager</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Relationship_Manager</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Sr_Relationship_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/C_I_BF_Approved</template>
    </alerts>
    <alerts>
        <fullName>C_I_BF_In_Progress</fullName>
        <description>C&amp;I: BF In Progress</description>
        <protected>false</protected>
        <recipients>
            <field>Opportunity_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>Loan_Ops</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Loan_Ops_Manager</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <field>Primary_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/C_I_BF</template>
    </alerts>
    <alerts>
        <fullName>C_I_BF_Rejected</fullName>
        <description>C&amp;I: BF Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>Opportunity_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Primary_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/C_I_BF_Rejected</template>
    </alerts>
    <alerts>
        <fullName>SFDC2_BF_24h_Reminder_Alert</fullName>
        <description>SFDC2: BF 24h Reminder Alert</description>
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
        <template>SFDC2_Enterprise_Templates/SFDC2_BF_24h_Reminder_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>BF_Status_BF_Submitted_for_Approval</fullName>
        <field>BF_Status__c</field>
        <literalValue>BF Submitted for Approval</literalValue>
        <name>BF Status: BF Submitted for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_BF_Approved</fullName>
        <field>BF_Status__c</field>
        <literalValue>BF Approved</literalValue>
        <name>C&amp;I: BF Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_BF_Approver_Name</fullName>
        <field>Approver_Name__c</field>
        <formula>TRIM($User.FirstName + &quot; &quot; + $User.LastName)</formula>
        <name>C&amp;I: BF Approver Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_BF_Initial_Submitter</fullName>
        <field>Initial_Submitter__c</field>
        <formula>$User.Email</formula>
        <name>C&amp;I: BF Initial Submitter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_BF_Opportunity_Owner_Email</fullName>
        <field>Opportunity_Owner_Email__c</field>
        <formula>Opportunity__r.Owner.Email</formula>
        <name>C&amp;I: BF Opportunity Owner Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_BF_Recalled</fullName>
        <field>BF_Status__c</field>
        <literalValue>BF Recalled</literalValue>
        <name>C&amp;I: BF Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_BF_Rejected</fullName>
        <field>BF_Status__c</field>
        <literalValue>BF Rejected</literalValue>
        <name>C&amp;I: BF Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_BF_Submitted_for_Approval</fullName>
        <field>BF_Status__c</field>
        <literalValue>BF Submitted for Approval</literalValue>
        <name>C&amp;I: BF Submitted for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lock_the_Record</fullName>
        <field>Record_Locked_SFDC2__c</field>
        <literalValue>1</literalValue>
        <name>Record Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prior_BF_Status</fullName>
        <description>Save the prior BF Status</description>
        <field>OldBFStatus__c</field>
        <formula>TEXT(PRIORVALUE(BF_Status__c))</formula>
        <name>Prior BF Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prior_BF_Status_2</fullName>
        <description>Save prior Status value</description>
        <field>OldBFStatus__c</field>
        <formula>TEXT(PRIORVALUE(BF_Status__c))</formula>
        <name>Prior BF Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prior_BF_Status_AppPro</fullName>
        <description>Save the prior BF Status</description>
        <field>OldBFStatus__c</field>
        <formula>TEXT(PRIORVALUE(BF_Status__c))</formula>
        <name>Prior BF Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prior_BF_Status_Apro_Rejec</fullName>
        <description>Save the Prior Value</description>
        <field>OldBFStatus__c</field>
        <formula>TEXT(PRIORVALUE(BF_Status__c))</formula>
        <name>Prior BF Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>C%26I%3A BF Status is BF in Progress and Opportunity Owner Email is not empty</fullName>
        <actions>
            <name>C_I_BF_In_Progress</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Boarding_Form__c.BF_Status__c</field>
            <operation>equals</operation>
            <value>BF In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Boarding_Form__c.Opportunity_Owner_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>C&amp;I - Email notification when Boarding Form is created and marked in progress</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Opportunity is not blank</fullName>
        <actions>
            <name>C_I_BF_Opportunity_Owner_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I - Populates Opportunity Owner field when BF is created</description>
        <formula>!ISBLANK(Opportunity__c)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
