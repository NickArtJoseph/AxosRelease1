<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SF_Funded_Closed_Won_FVR_Task_Notify</fullName>
        <description>SF - Funded Closed Won FVR Task Notify</description>
        <protected>false</protected>
        <recipients>
            <recipient>abussey@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF_Funded_Closed_Won_FVR_Notification</template>
    </alerts>
    <alerts>
        <fullName>Task_Email_Reminder</fullName>
        <description>Task Email Reminder</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Consumer_Deposits_Shared_Emails/Task_Reminder</template>
    </alerts>
    <fieldUpdates>
        <fullName>Comment_Field_update</fullName>
        <field>Comments__c</field>
        <formula>LEFT( Description , 255)</formula>
        <name>Comment Field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_Set_SF_Account_Owner</fullName>
        <field>SF_Account_Owner__c</field>
        <formula>Account.Owner.FirstName + &quot; &quot; + Account.Owner.LastName</formula>
        <name>SF - Set SF Account Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_Set_SF_Sales_Status</fullName>
        <field>SF_Sales_Status__c</field>
        <formula>TEXT(Account.Sales_Status_Person__c)</formula>
        <name>SF - Set SF Sales Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_Update_Task_DocReq</fullName>
        <description>When doc request task comes in update the task type to Doc Request</description>
        <field>Type</field>
        <literalValue>Doc Request</literalValue>
        <name>SF_Update_Task_DocReq</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_Update_Task_FVR</fullName>
        <description>Update FVR task type when subject = Doc Request Submitted</description>
        <field>Type</field>
        <literalValue>FVR Request</literalValue>
        <name>SF_Update_Task_FVR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Summary_to_Short_Description</fullName>
        <description>Set the Summary to the first 252 characters of comments</description>
        <field>Summary__c</field>
        <formula>LEFT( Description , 252) &amp;&quot;...&quot;</formula>
        <name>Set Summary to Short Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Task_Completed</fullName>
        <description>Sets the Task Completed field to the current date/time</description>
        <field>Task_Completed__c</field>
        <formula>NOW()</formula>
        <name>Set Task Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Task_Started</fullName>
        <description>Sets the Task Started date to the current date/time</description>
        <field>Task_Started__c</field>
        <formula>NOW()</formula>
        <name>Set Task Started</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Waiting_End</fullName>
        <description>Sets the Waiting on Someone Else End field to the current date/time</description>
        <field>Waiting_on_Someone_Else_End__c</field>
        <formula>NOW()</formula>
        <name>Set Waiting End</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Waiting_Start</fullName>
        <description>Sets the Waiting on Someone Else Start field to the current date/time</description>
        <field>Waiting_on_Someone_Else_Start__c</field>
        <formula>NOW()</formula>
        <name>Set Waiting Start</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Account_Review</fullName>
        <apiVersion>30.0</apiVersion>
        <description>BB account review option within InsideSales</description>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/apptsheld</endpointUrl>
        <fields>CreatedById</fields>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>api@bofi.com</integrationUser>
        <name>Account Review</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>BB%3A Activities Tracked</fullName>
        <actions>
            <name>Account_Review</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>contains</operation>
            <value>Account Review,Call,Email,Due Diligence,EDD,Servicing</value>
        </criteriaItems>
        <description>Business Banking [REVIEW] - Activities Tracked as KPI in InsideSales; not restricted based on Record Type so affects Enterprise</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A All Needs List Items Received</fullName>
        <actions>
            <name>All_Needs_List_Items_Received</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>equals</operation>
            <value>Send Needs List</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>C&amp;I [REVIEW] - Creates a task when Subject is Send Needs List and Status is Completed; not based on record type so could affect Enterprise</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Enterprise%3A Always run</fullName>
        <actions>
            <name>Set_Summary_to_Short_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Enterprise - Set the summary for tasks to the first 252 characters of the comments</description>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Enterprise%3A Status is Completed</fullName>
        <actions>
            <name>Set_Task_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>Sets the Task Completed field with the current date time if the status changes to &quot;Completed&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Enterprise%3A Status is In Progress and Task Started is empty</fullName>
        <actions>
            <name>Set_Task_Started</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Task_Started__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <description>Enterprise - Sets the Task Started field with the current date time if it is not populated and the status changes to &quot;In Progress&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Enterprise%3A Status is Waiting on someone else and Waiting on Someone Else Start is empty</fullName>
        <actions>
            <name>Set_Waiting_Start</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Waiting_on_Someone_Else_Start__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Waiting on someone else</value>
        </criteriaItems>
        <description>Enterprise - Sets the Waiting on Someone Else Start field with the current date time if it is not populated when the status changes to &quot;Waiting on someone else&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Enterprise%3A Status is changed from Waiting on someone else to a different value</fullName>
        <actions>
            <name>Set_Waiting_End</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Enterprise - Sets the Waiting on Someone Else End field with the current date time if it is not populated when the status changes to &quot;Waiting on someone else&quot;</description>
        <formula>AND( ISPICKVAL(PRIORVALUE(Status), &quot;Waiting on someone else&quot;), NOT(ISPICKVAL(Status, &quot;Waiting on someone else&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Enterprise%3A Subject is not empty</fullName>
        <actions>
            <name>Comment_Field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Enterprise - Sets Comments field to the first 255 characters of the Description</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Record Type begins with Specialty Finance and Type is Call</fullName>
        <actions>
            <name>SF_Set_SF_Account_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_Set_SF_Sales_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SF - track certain Account fields at time of Task creation.</description>
        <formula>AND( ISPICKVAL(Type, &quot;Call&quot;),  BEGINS(Account.RecordType.DeveloperName, &quot;Specialty_Finance&quot;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Type is FVR Request and Subject is FVR Request - Wholesale Funding and Record Type is SF - Info Task</fullName>
        <actions>
            <name>SF_Funded_Closed_Won_FVR_Task_Notify</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>equals</operation>
            <value>FVR Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>equals</operation>
            <value>FVR Request - Wholesale Funding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance – Info Task</value>
        </criteriaItems>
        <description>SF - Sends email notification when FVR task is created from Process Builder for Funded - Closed Won opportunities</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Type is empty and Subject is Doc Request Submitted</fullName>
        <actions>
            <name>SF_Update_Task_DocReq</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>equals</operation>
            <value>Doc Request Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>SF - Tasks to update fields for FVR and Doc Requested</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Type is empty and Subject is FVR Request - Doc Requested</fullName>
        <actions>
            <name>SF_Update_Task_FVR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>equals</operation>
            <value>FVR Request - Doc Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>SF - Tasks to update fields for FVR and Doc Requested</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Task Email Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Deposits</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>notEqual</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Task_Email_Reminder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Task.ReminderDateTime</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>All_Needs_List_Items_Received</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>All Needs List Items Received</subject>
    </tasks>
    <tasks>
        <fullName>SF_Advance_Request</fullName>
        <assignedTo>Processing_Counsel</assignedTo>
        <assignedToType>role</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Task.ActivityDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Advance Request</subject>
    </tasks>
</Workflow>
