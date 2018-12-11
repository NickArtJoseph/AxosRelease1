<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>C_I_Amendment_Approval_Request_Approved</fullName>
        <description>C&amp;I - Amendment Approval Request Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/Amendment_Approval_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>C_I_Amendment_Approval_Request_Rejected</fullName>
        <description>C&amp;I - Amendment Approval Request Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/Amendment_Approval_Request_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>C_I_Amendment_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>C&amp;I - Amendment - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Amendment_Denied</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Denied</literalValue>
        <name>C&amp;I - Amendment - Denied</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Amendment_Fields_Populated_FALSE</fullName>
        <field>Approval_Fields_Populated__c</field>
        <literalValue>0</literalValue>
        <name>C&amp;I - Amendment Fields Populated - FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Amendment_Fields_Populated_TRUE</fullName>
        <field>Approval_Fields_Populated__c</field>
        <literalValue>1</literalValue>
        <name>C&amp;I - Amendment Fields Populated - TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Amendment_Not_Submitted</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Not Submitted</literalValue>
        <name>C&amp;I - Amendment - Not Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Amendment_Pending_Approval</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>C&amp;I - Amendment - Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>C%26I%3A Amendment Fields Populated - FALSE</fullName>
        <actions>
            <name>C_I_Amendment_Fields_Populated_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I - Checks to see if any Amendment fields required for approval are not populated. Used as entry criteria for the Amendment approval process.</description>
        <formula>ISBLANK( Additional_Fees__c ) || TEXT( Additional_Fees_Changes__c ) = &quot;&quot; || ISBLANK( By1__c ) || ISBLANK( By2__c ) || ISBLANK( CC__c ) || ISBLANK( Collateral__c ) || TEXT( Collateral_Changes__c ) = &quot;&quot; || ISBLANK( Extension_Options__c ) || TEXT( Extension_Options_Changes__c ) = &quot;&quot; || ISBLANK( Guarantors__c ) || TEXT( Guarantors_Changes__c ) = &quot;&quot;|| ISBLANK( Guarantor_Types__c ) || TEXT( Guarantor_Types_Changes__c ) = &quot;&quot; || ISBLANK( Loan_Amount__c ) || TEXT( Loan_Amount_Changes__c ) = &quot;&quot; || TEXT( Loan_Structure__c ) = &quot;&quot; || TEXT( Loan_Structure_Changes__c ) = &quot;&quot; || ISBLANK( Opportunity__c ) || LEN( Other__c ) = 0 || TEXT( Other_Changes__c ) = &quot;&quot;|| ISBLANK( Rate__c ) || TEXT( Rate_Changes__c ) = &quot;&quot; || LEN( Rationale__c ) = 0 || ISBLANK( RE__c ) || LEN( Request__c ) = 0 || LEN( Summary_Recommendation__c ) = 0 || LEN( Supporting_Analysis__c ) = 0 || ISBLANK( Term__c ) || TEXT( Term_Changes__c ) = &quot;&quot; || ISBLANK( To__c ) || LEN( Transaction_Recap__c ) = 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Amendment Fields Populated - TRUE</fullName>
        <actions>
            <name>C_I_Amendment_Fields_Populated_TRUE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I - Checks to see if all Amendment fields required for approval are populated. Used as entry criteria for the Amendment approval process.</description>
        <formula>NOT( ISBLANK( Additional_Fees__c ) || TEXT( Additional_Fees_Changes__c ) = &quot;&quot; || ISBLANK( By1__c ) || ISBLANK( By2__c ) || ISBLANK( CC__c ) || ISBLANK( Collateral__c ) || TEXT( Collateral_Changes__c ) = &quot;&quot; || ISBLANK( Extension_Options__c ) || TEXT( Extension_Options_Changes__c ) = &quot;&quot; || ISBLANK( Guarantors__c ) || TEXT( Guarantors_Changes__c ) = &quot;&quot;|| ISBLANK( Guarantor_Types__c ) || TEXT( Guarantor_Types_Changes__c ) = &quot;&quot; || ISBLANK( Loan_Amount__c ) || TEXT( Loan_Amount_Changes__c ) = &quot;&quot; || TEXT( Loan_Structure__c ) = &quot;&quot; || TEXT( Loan_Structure_Changes__c ) = &quot;&quot; || ISBLANK( Opportunity__c ) || LEN( Other__c ) = 0 || TEXT( Other_Changes__c ) = &quot;&quot;|| ISBLANK( Rate__c ) || TEXT( Rate_Changes__c ) = &quot;&quot; || LEN( Rationale__c ) = 0 || ISBLANK( RE__c ) || LEN( Request__c ) = 0 || LEN( Summary_Recommendation__c ) = 0 || LEN( Supporting_Analysis__c ) = 0 || ISBLANK( Term__c ) || TEXT( Term_Changes__c ) = &quot;&quot; || ISBLANK( To__c ) || LEN( Transaction_Recap__c ) = 0 )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
