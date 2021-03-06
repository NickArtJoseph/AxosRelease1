<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_notification</fullName>
        <description>Approval notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>jcrane@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Consumer_Deposits_Shared_Emails/Approval_Cloning_Request_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Email_Rejection</fullName>
        <description>Case: Email Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Commercial_Deposit_Operations_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Cloning_Request_Rejected</fullName>
        <description>Cloning Request Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ALL/Case_Cloning_Request_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Commercial_Deposit_Operations_Case_Closed</fullName>
        <description>Commercial Deposit Operations Case Closed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Commercial_Deposit_Operations_Closed</template>
    </alerts>
    <alerts>
        <fullName>Customer_Feedback_Complaint_new</fullName>
        <ccEmails>tchung@axosbank.com,glau@axosbank.com</ccEmails>
        <description>Customer Feedback - Complaint</description>
        <protected>false</protected>
        <recipients>
            <recipient>abonilla@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>bfoster@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>cvallejo@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>daniel@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>dgriffith@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eyung@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lprieto@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mtom@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nburnsides@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>smccarty@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ttatum@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ALL/Customer_Feedback_Complaint</template>
    </alerts>
    <alerts>
        <fullName>Customer_Feedback_Resolved_Customer_Complaint_Email_Alert</fullName>
        <ccEmails>tchung@bofi.com,ComplianceTeam@bofifederalbank.com</ccEmails>
        <description>Customer Feedback: Resolved Customer Complaint Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>abonilla@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>bfoster@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>cvallejo@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>daniel@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>dgriffith@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eyung@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jdenton@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lprieto@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mtom@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nburnsides@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>smccarty@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ttatum@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ALL/Resolved_Customer_Feedback_Complaint</template>
    </alerts>
    <alerts>
        <fullName>Customer_Feedback_Resolved_Customer_Complaint_Email_Alert_Nationwide</fullName>
        <ccEmails>tchung@axosbank.com,crogers@axosbank.com,kkallet@axosbank.com,GLau@axosbank.com</ccEmails>
        <description>Customer Feedback: Resolved Customer Complaint Email Alert(Nationwide)</description>
        <protected>false</protected>
        <recipients>
            <recipient>abonilla@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>daniel@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>dberry@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eyung@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jbartolomei@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jdenton@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jsuka@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lprieto@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lruffin@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mtom@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nblackman@bofifederalbank.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nburnsides@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pampil@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>tdavis@bofifederalbank.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>zlara@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ALL/Resolved_Customer_Feedback_Complaint_Nationwide</template>
    </alerts>
    <alerts>
        <fullName>Customer_Feedback_Resolved_Customer_Complaint_Email_Alert_Nationwide_Premier</fullName>
        <ccEmails>ksathe@axosbank.com,lmcwilliams@axosbank.com,hbryanIV@axosbank.com,shill@axosbank.com,tchung@axosbank.com</ccEmails>
        <description>Customer Feedback: Resolved Customer Complaint Email Alert(Nationwide Premier)</description>
        <protected>false</protected>
        <recipients>
            <recipient>athurston@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>bfoster@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>daniel@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eyung@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jbartolomei@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jdenton@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lwong@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nburnsides@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>zlara@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ALL/Resolved_Customer_Feedback_Complaint_Nationwide</template>
    </alerts>
    <alerts>
        <fullName>Email</fullName>
        <ccEmails>ksathe@axosbank.com,lmcwilliams@axosbank.com,hbryanIV@axosbank.com,shill@axosbank.com,tchung@axosbank.com</ccEmails>
        <description>Email QA when Customer Feedback is created(Nationwide Premier)</description>
        <protected>false</protected>
        <recipients>
            <recipient>athurston@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>bfoster@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>daniel@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eyung@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jbartolomei@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jdenton@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lwong@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nburnsides@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>zlara@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ALL/Customer_Feedback_Case_Created_Nationwide</template>
    </alerts>
    <alerts>
        <fullName>Email_QA</fullName>
        <ccEmails>ComplianceTeam@bofifederalbank.com</ccEmails>
        <description>Email QA</description>
        <protected>false</protected>
        <recipients>
            <recipient>jsuka@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lruffin@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>zlara@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ALL/Customer_Feedback_Case_Created</template>
    </alerts>
    <alerts>
        <fullName>Email_QA_Nationwide</fullName>
        <ccEmails>tchung@axosbank.com,crogers@axosbank.com,kkallet@axosbank.com,GLau@axosbank.com</ccEmails>
        <description>Email QA(Nationwide)</description>
        <protected>false</protected>
        <recipients>
            <recipient>abonilla@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>daniel@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>dberry@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eyung@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jbartolomei@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jdenton@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jsuka@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lprieto@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lruffin@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mtom@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nblackman@bofifederalbank.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nburnsides@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pampil@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>tdavis@bofifederalbank.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>zlara@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ALL/Customer_Feedback_Case_Created_Nationwide</template>
    </alerts>
    <alerts>
        <fullName>Notify_Case_Ownership_Change</fullName>
        <description>Notify Case Ownership Change</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Consumer_Deposits_Shared_Emails/Case_Assignment</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_Queue</fullName>
        <description>Send Notification to Queue</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Consumer_Deposits_Shared_Emails/After_Hours_New_VIP</template>
    </alerts>
    <alerts>
        <fullName>X1_Hour_Warning_Before_Milestone_Expires</fullName>
        <ccEmails>jcrane@bofi.com</ccEmails>
        <description>1 Hour Warning Before Milestone Expires</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Consumer_Deposits_Shared_Emails/SLA_Warning_1_Hour</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approved</fullName>
        <description>Approval action</description>
        <field>Status</field>
        <literalValue>In Process</literalValue>
        <name>Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Approval_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Commercial_Deposit_Operations_Approvals</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Approval Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Deposit_CC_Management_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Deposit_CC_Management_Approval_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Deposit CC: Management Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Deposit_Ops_New_Accounts_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Deposit_Ops_New_Accounts</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Deposit Ops New Accounts Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Assign_to_Commercial_Deposit_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Commercial_Deposit_Operations_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case: Assign to Commercial Deposit Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Assign_to_Retirement_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Deposit_Ops_Retirement</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case: Assign to Retirement Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Update_Status_to_New</fullName>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>Case: Update Status to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Update_Status_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>Case: Update Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Update_status_to_Pending_Approval</fullName>
        <field>Status</field>
        <literalValue>Pending Approval</literalValue>
        <name>Case: Update status to Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mark_Rejected_Field</fullName>
        <field>Approval_Rejected__c</field>
        <literalValue>1</literalValue>
        <name>Mark Rejected Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pending_Approval</fullName>
        <description>Approval process for Cloning requests</description>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected</fullName>
        <description>Not approved for Cloning Request</description>
        <field>Status</field>
        <literalValue>On Hold</literalValue>
        <name>Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Final_Review</fullName>
        <field>Status</field>
        <literalValue>Final Review</literalValue>
        <name>Status = Final Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_In_Research</fullName>
        <field>Status</field>
        <literalValue>In Research</literalValue>
        <name>Status = In Research</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Reviewed</fullName>
        <description>Once reviewed by Supervisor, Updates status to Reviewed</description>
        <field>Status</field>
        <literalValue>Reviewed</literalValue>
        <name>Status = Reviewed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Under_Review</fullName>
        <description>Once submitted, updates case status to under review.</description>
        <field>Status</field>
        <literalValue>Under Review</literalValue>
        <name>Status = Under Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_3_Number</fullName>
        <description>Update Field: Account 3 Number to match Account 3 Link relationship field</description>
        <field>Account_3_val__c</field>
        <name>Update: Account 3 Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Origination_Queue</fullName>
        <field>Case_Origination_Queue__c</field>
        <formula>Owner:Queue.Name</formula>
        <name>Update Case Origination Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Q_History</fullName>
        <field>Case_Queue_History__c</field>
        <formula>IF(LEFT(OwnerId,3) = &quot;005&quot;, Case_Queue_History__c, Owner:Queue.Name )</formula>
        <name>Update Case Q History</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Q_History_ID</fullName>
        <field>Case_Queue_History_ID__c</field>
        <formula>IF(LEFT(OwnerId,3) = &quot;005&quot;, Case_Queue_History_ID__c,  OwnerId  )</formula>
        <name>Update Case Q History ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status</fullName>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status1</fullName>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_VIP_Created_Time</fullName>
        <field>VIP_Created_Time__c</field>
        <formula>VALUE( MID( TEXT( CreatedDate - ( (if(	Daylight_Savings_Offset__c, 7,8 ) *60 ) / 1440)), 12, 2 ) )</formula>
        <name>Update VIP Created Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Add Initial Queue to Origination Queue</fullName>
        <actions>
            <name>Update_Case_Origination_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( OR( ISBLANK(Case_Origination_Queue__c  ),  ISNULL(Case_Origination_Queue__c  ),  ISNEW() ), BEGINS(OwnerId, &quot;00G&quot;), (ISPICKVAL(Status, &quot;Pending Customer Response&quot;) = false), (ISPICKVAL(Status, &quot;Future Dated&quot;) = false),  (ISPICKVAL(Status, &quot;Pending Internal Action&quot;) = false) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Add Owner to Queue History</fullName>
        <actions>
            <name>Update_Case_Q_History</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Case_Q_History_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(OR(ISCHANGED(OwnerId),ISBLANK( Case_Queue_History__c ), ISNULL(Case_Queue_History__c), ISNEW()), (ISPICKVAL(Status, &quot;Pending Customer Response&quot;) = false), (ISPICKVAL(Status, &quot;Future Dated&quot;) = false), (ISPICKVAL(Status, &quot;Pending Internal Action&quot;) = false))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Feedback%3A Final Resolution Email Alert</fullName>
        <actions>
            <name>Customer_Feedback_Resolved_Customer_Complaint_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Feedback</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Valid_Feedback__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Feedback_Type__c</field>
            <operation>equals</operation>
            <value>Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Feedback_Business_Unit__c</field>
            <operation>notEqual</operation>
            <value>Nationwide,Nationwide Premier</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Customer Feedback%3A Final Resolution Email Alert%28Nationwide Premier%29</fullName>
        <actions>
            <name>Customer_Feedback_Resolved_Customer_Complaint_Email_Alert_Nationwide_Premier</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Feedback</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Valid_Feedback__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Feedback_Type__c</field>
            <operation>equals</operation>
            <value>Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Feedback_Business_Unit__c</field>
            <operation>equals</operation>
            <value>Nationwide Premier</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Customer Feedback%3A Final Resolution Email Alert%28Nationwide%29</fullName>
        <actions>
            <name>Customer_Feedback_Resolved_Customer_Complaint_Email_Alert_Nationwide</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Feedback</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Valid_Feedback__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Feedback_Type__c</field>
            <operation>equals</operation>
            <value>Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Feedback_Business_Unit__c</field>
            <operation>equals</operation>
            <value>Nationwide</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Customer Feedback%3A Send email once case is valid</fullName>
        <actions>
            <name>Customer_Feedback_Complaint_new</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Valid_Feedback__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Feedback</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Feedback_Type__c</field>
            <operation>equals</operation>
            <value>Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Feedback_Business_Unit__c</field>
            <operation>equals</operation>
            <value>Consumer Deposits,Advisor Firm,Virtus</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Customer Feedback%3A Update Status</fullName>
        <actions>
            <name>Status_In_Research</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Feedback</value>
        </criteriaItems>
        <description>Updates status of customer feedback cases to &quot;In Review&quot; at creation</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email QA when Customer Feedback is created</fullName>
        <actions>
            <name>Email_QA</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Feedback</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email QA when Customer Feedback is created%28Nationwide</fullName>
        <actions>
            <name>Email_QA_Nationwide</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Feedback</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email: NW Complaints</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Feedback_Business_Unit__c</field>
            <operation>equals</operation>
            <value>Nationwide</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email QA when Customer Feedback is created%28Nationwide Premier%29</fullName>
        <actions>
            <name>Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Feedback</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email: NW Premier Complaints</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Feedback_Business_Unit__c</field>
            <operation>equals</operation>
            <value>Nationwide Premier</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send VIP Email After hours</fullName>
        <actions>
            <name>Send_Notification_to_Queue</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send notification of new cases to agents after hours</description>
        <formula>AND( (VIP_Created_Time__c&gt;= 15 &amp;&amp;  VIP_Created_Time__c&lt;= 17) ,  CASE(MOD(  DateValue(CreatedDate)  - DATE(1900, 1, 6), 7), 0, &quot;Saturday&quot;, 1, &quot;Sunday&quot;, 2,&quot;Monday&quot;, 3, &quot;Tuesday&quot;, 4, &quot;Wednesday&quot;, 5, &quot;Thursday&quot;, 6,&quot;Friday&quot;,&quot;&quot;)&lt;&gt; &quot;Saturday&quot; , CASE(MOD(  DateValue(CreatedDate)  - DATE(1900, 1, 6), 7), 0, &quot;Saturday&quot;, 1, &quot;Sunday&quot;, 2,&quot;Monday&quot;, 3, &quot;Tuesday&quot;, 4, &quot;Wednesday&quot;, 5, &quot;Thursday&quot;, 6,&quot;Friday&quot;,&quot;&quot;) &lt;&gt;  &quot;Sunday&quot;,  LEFT(OwnerId,3) &lt;&gt; &quot;005&quot; )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send email to new owner</fullName>
        <actions>
            <name>Notify_Case_Ownership_Change</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Fires when a user changes ownership of a case</description>
        <formula>AND(ISCHANGED(OwnerId) , (LEFT(OwnerId,3) = &quot;005&quot;) , ( LastModifiedById &lt;&gt;  OwnerId  )  ,  (IsChanged(Status)  = False ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set VIP Date Created</fullName>
        <actions>
            <name>Update_VIP_Created_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>contains</operation>
            <value>Escalated,VIP</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Escalation_outside_of_SLA</fullName>
        <assignedTo>jcrane@bofi.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Escalation alert to Supervisor if SLA is exceeded</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.SlaStartDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Escalation outside of SLA</subject>
    </tasks>
</Workflow>
