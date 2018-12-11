<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>C_I_Opp_Send_email_notification_as_the_opportunity_stage_is_set_to_C_I_Closed_Wo</fullName>
        <ccEmails>C&amp;ILoanAudits@bofi.com</ccEmails>
        <description>C&amp;I - Opportunity - Send email notification as the opportunity stage is set to C&amp;I Closed Won</description>
        <protected>false</protected>
        <recipients>
            <recipient>jfairchild@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/C_I_Opportunity_stage_is_set_to_Closed_Won</template>
    </alerts>
    <alerts>
        <fullName>C_I_Opportunity_Send_email_notification_as_the_opportunity_stage_is_set_to_C_I_C</fullName>
        <description>C&amp;I - Opportunity - Send email notification as the opportunity stage is set to C&amp;I Closing</description>
        <protected>false</protected>
        <recipients>
            <recipient>jfairchild@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/C_I_Opportunity_stage_is_set_to_C_I_Closing</template>
    </alerts>
    <alerts>
        <fullName>C_I_Send_Projected_Close_Date_Notification</fullName>
        <description>C&amp;I - Send Projected Close Date Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/Opportunity_Projected_Close_Date_Notification</template>
    </alerts>
    <alerts>
        <fullName>Closing_Binder_Complete_Review_Email</fullName>
        <description>Closing Binder Complete Review Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>Processing_Counsel</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF_Wholesale_Review</template>
    </alerts>
    <alerts>
        <fullName>Closing_Binder_Complete_Review_Email_Retail</fullName>
        <description>Closing Binder Complete Review Email - Retail</description>
        <protected>false</protected>
        <recipients>
            <recipient>Processing_Counsel</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF_Retail_Review</template>
    </alerts>
    <alerts>
        <fullName>LLC_BI__Close_Date_Moved</fullName>
        <ccEmails>Demo@Bankr.com</ccEmails>
        <description>Close Date Moved</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/LLC_BI__Workflow_Alert_Close_Date_Accelerated</template>
    </alerts>
    <alerts>
        <fullName>LLC_BI__Guarantee_Fee_Not_Paid</fullName>
        <ccEmails>Demo@Bankr.com</ccEmails>
        <description>Guarantee Fee Not Paid</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/LLC_BI__Guarantee_Fee_Not_Paid</template>
    </alerts>
    <alerts>
        <fullName>LLC_BI__Loan_Withdrawn_Declined</fullName>
        <ccEmails>Demo@Bankr.com</ccEmails>
        <description>Loan Withdrawn / Declined</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/LLC_BI__Loan_Withdrawn_Declined</template>
    </alerts>
    <alerts>
        <fullName>LLC_BI__Order_New_Appraisal_Alert</fullName>
        <ccEmails>Demo@Bankr.com</ccEmails>
        <description>Order New Appraisal Alert</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/LLC_BI__Order_Appraisal</template>
    </alerts>
    <alerts>
        <fullName>LLC_BI__Stage_Change_to_Compliance</fullName>
        <ccEmails>Demo@Bankr.com</ccEmails>
        <description>Stage Change to Compliance</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/LLC_BI__Stage_Change_Alert</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Owner_Changed</fullName>
        <description>Opportunity Owner Changed</description>
        <protected>false</protected>
        <recipients>
            <recipient>daniel@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ALL/Opportunity_Ower_Change</template>
    </alerts>
    <alerts>
        <fullName>SFDC2_Email_Notification_to_Opportunity_owner_for_stage_change_to_8</fullName>
        <description>SFDC2: Email Notification to Opportunity owner for stage change to 8</description>
        <protected>false</protected>
        <recipients>
            <field>Opportunity_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC2_Enterprise_Templates/SFDC2_Email_to_Opportunity_Owner_for_Stage_8</template>
    </alerts>
    <alerts>
        <fullName>SFDC2_Opportunity_72h_Reminder_Alert</fullName>
        <description>SFDC2: Opportunity 72h Reminder Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>QA</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>Team_Member_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Team_Member_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Team_Member_3__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC2_Enterprise_Templates/SFDC2_Opp_72h_Reminder_Template</template>
    </alerts>
    <alerts>
        <fullName>SFDC2_Opportunity_No_Activity_Notification</fullName>
        <description>SFDC2: Opportunity No Activity Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC2_Enterprise_Templates/SFDC2_Opportunity_Record_No_Activity</template>
    </alerts>
    <alerts>
        <fullName>SF_FVR_In_House_Council_Review_Complete</fullName>
        <description>SF: FVR In House Council Review Complete</description>
        <protected>false</protected>
        <recipients>
            <recipient>SF_New_FVR_Notification</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF_FVR_In_House_Council_Review_Complete</template>
    </alerts>
    <alerts>
        <fullName>SF_FVR_Request_EmailAlert</fullName>
        <description>SF: New FVR Request Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>SF_New_FVR_Notification</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF_FVRRequest_Email</template>
    </alerts>
    <alerts>
        <fullName>SF_FVR_Request_Order_Received</fullName>
        <description>SF - FVR Request - Order Received</description>
        <protected>false</protected>
        <recipients>
            <recipient>SF_New_FVR_Notification</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF_FVR_Request_Order_Received</template>
    </alerts>
    <alerts>
        <fullName>SF_HearingDate_EmailAlert</fullName>
        <description>SF_HearingDate_EmailAlert</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
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
            <recipient>Sales_Team</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Structured_Settlement</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF_Hearing_Date</template>
    </alerts>
    <alerts>
        <fullName>SF_HearingDate_EmailAlert2</fullName>
        <description>SF_HearingDate_EmailAlert2</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
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
            <recipient>Sales_Team</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Structured_Settlement</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF_Hearing_Date</template>
    </alerts>
    <alerts>
        <fullName>SF_HearingDate_EmailAlert_21Days</fullName>
        <description>SF_HearingDate_EmailAlert_21Days</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>Sales_Team</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Structured_Settlement</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF_Hearing_Date_21_Day_Reminder</template>
    </alerts>
    <alerts>
        <fullName>SF_HearingDate_EmailAlert_7Days</fullName>
        <description>SF_HearingDate_EmailAlert_7Days</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>Sales_Team</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Structured_Settlement</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF_Hearing_Date_7_Day_Reminder</template>
    </alerts>
    <alerts>
        <fullName>SF_IHC_Drafts_Notification</fullName>
        <description>SF - IHC Drafts Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Processing_Counsel</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF_IHC_Drafts_Email</template>
    </alerts>
    <alerts>
        <fullName>SF_Notification_for_In_house_Council_Review_Complete</fullName>
        <description>SF - Notification for In-house Council Review Complete</description>
        <protected>false</protected>
        <recipients>
            <recipient>Processing_Team</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Processors</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF</template>
    </alerts>
    <alerts>
        <fullName>SF_OrderReceived_EmailAlert</fullName>
        <description>SF_OrderReceived_EmailAlert</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
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
            <recipient>Sales_Team</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Structured_Settlement</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF_Order_Received</template>
    </alerts>
    <alerts>
        <fullName>SF_OrderSigned_EmailAlert</fullName>
        <description>SF_OrderSigned_EmailAlert</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
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
            <recipient>Sales_Team</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Structured_Settlement</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF_Order_Signed</template>
    </alerts>
    <alerts>
        <fullName>SF_PetitionFiled_EmailAlert</fullName>
        <description>SF_PetitionFiled_EmailAlert</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>Sales_Team</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Structured_Settlement</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>abussey@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF_Petition_Filed</template>
    </alerts>
    <alerts>
        <fullName>SF_PetitionStatus_EmailAlert</fullName>
        <description>SF_PetitionStatus_EmailAlert</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
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
            <recipient>Sales_Team</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Structured_Settlement</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF_Petition_Status</template>
    </alerts>
    <alerts>
        <fullName>SF_Petition_Status_Approved_Email</fullName>
        <description>SF - Petition Status Approved Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>Processors</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Sales_Team</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>abussey@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF_Petition_Status_Approved_Email</template>
    </alerts>
    <alerts>
        <fullName>SF_PrepToFile_EmailAlert</fullName>
        <description>SF_PrepToFile_EmailAlert</description>
        <protected>false</protected>
        <recipients>
            <recipient>SF_Prep_To_File_Email_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>SF_SS_Exec_Bankers</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Processors</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Sales_Team</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF_Prep_to_File</template>
    </alerts>
    <alerts>
        <fullName>SF_Prep_To_Fund_notification</fullName>
        <description>SF - Prep To Fund notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>abussey@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF_Prep_To_Fund_Costs_Exp</template>
    </alerts>
    <alerts>
        <fullName>SF_Termination_Announcement</fullName>
        <description>SF Termination Announcement</description>
        <protected>false</protected>
        <recipients>
            <recipient>Information_Specialist</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Processing_Counsel</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Processors</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>SF_Research_Info_Manager</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Sales_Team</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>abussey@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>daniel@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ALL/SF_Notification_of_Termination</template>
    </alerts>
    <alerts>
        <fullName>SF_document_request_email_alert_to_the_processing_counsel</fullName>
        <description>A new document request email alert to the processing counsel</description>
        <protected>false</protected>
        <recipients>
            <recipient>Processing_Counsel</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Processors</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Specialty_Finance/SF_DocRequest_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>Advisor_Firm</fullName>
        <description>Sets the opportunity record type to Advisor Firm Recruiting</description>
        <field>RecordTypeId</field>
        <lookupValue>Advisor_Recruiting_SFDC2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Advisor Firm Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BB_Client_Status_Yes</fullName>
        <field>Business_Banking_Client__c</field>
        <literalValue>Yes</literalValue>
        <name>BB Client Status = Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BB_Record_Type_Update</fullName>
        <description>Sets the opportunity record type to Business Banking Opportunity</description>
        <field>RecordTypeId</field>
        <lookupValue>Business_Banking_SFDC2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>BB Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CD_Opp_Incr_Number_Calls</fullName>
        <field>Opportunity_Number_of_Calls__c</field>
        <formula>Opportunity_Number_of_Calls__c + 1</formula>
        <name>CD - Opp - Incr Number Calls</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_Update_Stage_to_CAM</fullName>
        <description>Updates the Stage to &quot;C&amp;I - CAM&quot; when any step in the CAM Approval Process is rejected, the CAM Approval Process is recalled, or the CAM Approval Process is submitted.</description>
        <field>StageName</field>
        <literalValue>C&amp;I - CAM</literalValue>
        <name>C&amp;I - Update Stage to CAM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_Update_Stage_to_Closing</fullName>
        <description>Updates the Stage to &quot;C&amp;I - Closing&quot; when the final step in the CAM Approval Process is approved.</description>
        <field>StageName</field>
        <literalValue>C&amp;I - Closing</literalValue>
        <name>C&amp;I - Update Stage to Closing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_Update_Stage_to_LOI</fullName>
        <description>Updates the Stage to &quot;C&amp;I - LOI&quot; when the final step in the PIC Approval Process is approved.</description>
        <field>StageName</field>
        <literalValue>C&amp;I - LOI</literalValue>
        <name>C&amp;I - Update Stage to LOI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_Update_Stage_to_PIC</fullName>
        <description>Updates the Stage to &quot;C&amp;I - PIC&quot; when any step in the PIC Approval Process is rejected, the PIC Approval Process is recalled, or the PIC Approval Process is submitted.</description>
        <field>StageName</field>
        <literalValue>C&amp;I - PIC</literalValue>
        <name>C&amp;I - Update Stage to PIC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_Update_SubStage_to_CAM_Revision</fullName>
        <description>Updates the Sub-Stage to &quot;CAM - Revision&quot; when any step in the CAM Approval Process is rejected, or the CAM Approval Process is recalled.</description>
        <field>SubStage__c</field>
        <literalValue>CAM Revision</literalValue>
        <name>C&amp;I - Update SubStage to CAM Revision</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_Update_SubStage_to_CAM_Submitted</fullName>
        <description>Updates the Sub-Stage to &quot;CAM - Submitted&quot; when the CAM Approval Process is submitted.</description>
        <field>SubStage__c</field>
        <literalValue>CAM Submitted</literalValue>
        <name>C&amp;I - Update SubStage to CAM Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_Update_SubStage_to_LOI_Preparation</fullName>
        <description>Updates the Sub-Stage to &quot;LOI - Preparation&quot; when the final step in the PIC Approval Process is approved.</description>
        <field>SubStage__c</field>
        <literalValue>LOI Preparation</literalValue>
        <name>C&amp;I - Update SubStage to LOI Preparation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_Update_SubStage_to_NULL</fullName>
        <description>Updates the Sub-Stage to NULL when the final step in the CAM Approval Process is approved.</description>
        <field>SubStage__c</field>
        <name>C&amp;I - Update SubStage to NULL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_Update_SubStage_to_PIC_Submitted</fullName>
        <description>Updates the Stage to &quot;C&amp;I - PIC&quot; and the Sub-Stage to &quot;PIC - Revision&quot; when the PIC Approval Process is submitted.</description>
        <field>SubStage__c</field>
        <literalValue>PIC Submitted</literalValue>
        <name>C&amp;I - Update SubStage to PIC Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CW_Record_Type_Update</fullName>
        <description>Sets the opportunity record type to ConsumerWholesale Opportunity</description>
        <field>RecordTypeId</field>
        <lookupValue>Consumer_Wholesale_SFDC2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CW Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Credit_Final_Approval</fullName>
        <description>Updates the date/time for Credit Final Approval based on Oppty Sub-Stage of Legal Engagement - Internal.</description>
        <field>CI_Credit_Final_Approval__c</field>
        <formula>NOW()</formula>
        <name>C&amp;I - Credit Final Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Deposit_Received</fullName>
        <field>CI_Deposit_Received__c</field>
        <formula>NOW()</formula>
        <name>C&amp;I - Deposit Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Final_LOI_Received</fullName>
        <field>CI_Final_LOI_Received__c</field>
        <formula>NOW()</formula>
        <name>C&amp;I - Final LOI Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Legal_Received_Date</fullName>
        <description>Updates based on Credit Document Review sub-stage change.</description>
        <field>CI_Legal_Received__c</field>
        <formula>NOW()</formula>
        <name>C&amp;I - Legal Received Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Legal_Requested_Date</fullName>
        <field>CI_Legal_Requested__c</field>
        <formula>NOW()</formula>
        <name>C&amp;I - Legal Requested Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Opp_AB_Record_Type_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CI_AB_Participation</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>C&amp;I - Opp AB Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Opp_Bridge_Record_Type_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CI_Bridge</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>C&amp;I - Opp Bridge Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Opp_General_Record_Type_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CI_General</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>C&amp;I - Opp General Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Opp_Lender_Fin_Record_Type_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CI_Lender_Finance</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>C&amp;I - Opp Lender Fin Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Opportunity_Originator</fullName>
        <description>Updates the Opportunity Originator with the Opportunity Owner when the Opportunity record is created.</description>
        <field>CI_Opportunity_Originator__c</field>
        <formula>Owner.FirstName + &quot; &quot; +  Owner.LastName</formula>
        <name>C&amp;I - Opportunity Originator</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_Close_Date_for_Closed_Won</fullName>
        <description>Updates the Close Date when the Stage changes to Closed/Won.</description>
        <field>CloseDate</field>
        <formula>TODAY ()</formula>
        <name>C&amp;I - Update Close Date for Closed Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_Close_Date_to_Projected</fullName>
        <description>When the Projected Close Date changes, updates the Close Date to the Projected Close Date value, except for when the Opportunity Stage is Closed Won.</description>
        <field>CloseDate</field>
        <formula>CI_Projected_Close_Date__c</formula>
        <name>C&amp;I - Update Close Date to Projected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_Native_Amount</fullName>
        <description>Updates the native Amount field with the value from Loan Amount within Origination Documentation.</description>
        <field>Amount</field>
        <formula>CI_Loan_Amount__c</formula>
        <name>C&amp;I - Update Native Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_SubStage_to_PIC_Revision</fullName>
        <description>Updates the Sub-Stage to &quot;PIC - Revision&quot; when any step in the PIC Approval Process is rejected, or the PIC Approval Process is recalled.</description>
        <field>SubStage__c</field>
        <literalValue>PIC Revision</literalValue>
        <name>C&amp;I - Update SubStage to PIC Revision</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Commercial_2_0_Populate_Broker_Email</fullName>
        <field>Broker_Email_SFDC2__c</field>
        <formula>Broker_Name__r.Email</formula>
        <name>Commercial 2.0: Populate Broker Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Commercial_2_0_Populate_Broker_Phone</fullName>
        <field>Broker_Phone_SFDC2__c</field>
        <formula>IF(ISBLANK( Broker_Name__r.MobilePhone), 
IF(ISBLANK(  Broker_Name__r.HomePhone  ),Broker_Name__r.Phone, Broker_Name__r.HomePhone)
, Broker_Name__r.MobilePhone)</formula>
        <name>Commercial 2.0: Populate Broker Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Consumer_Deposits_Default_Oppt_Stage</fullName>
        <description>Set Opportunity stage to Open Unfunded for records created from Lead conversion</description>
        <field>StageName</field>
        <literalValue>Opened Unfunded</literalValue>
        <name>Consumer Deposits - Default Oppt Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Consumer_Deposits_Record_Type_Update</fullName>
        <description>Sets the opportunity record type to Consumer Deposits</description>
        <field>RecordTypeId</field>
        <lookupValue>Consumer_Deposits_SFDC2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Consumer Deposits Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Opp_App_for_Loan_Record_Type_Update</fullName>
        <description>Sets the opportunity record type to Dealer Services - Application for Loan</description>
        <field>RecordTypeId</field>
        <lookupValue>Dealer_Services_Application_for_Loan</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>DS: Opp App for Loan Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Opp_Applicant_Record_Type_Update</fullName>
        <description>Sets the opportunity record type to Dealer Services - Applicant</description>
        <field>RecordTypeId</field>
        <lookupValue>Dealer_Services_Applicant</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>DS: Opp Applicant Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Died_Stage</fullName>
        <field>Deal_Died_Stage__c</field>
        <formula>TEXT(PRIORVALUE( StageName ))</formula>
        <name>Deal Died Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Dealer_Recruiting_Record_Type_Update</fullName>
        <description>Sets the opportunity record type to Dealership Recruiting</description>
        <field>RecordTypeId</field>
        <lookupValue>Dealership_Recruiting_SFDC2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Dealer Recruiting Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Description</fullName>
        <description>SFDC2 automation to backfill Description from the Account Record</description>
        <field>Description</field>
        <formula>Account.Description</formula>
        <name>Opportunity: Backfill Opp Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPL_2_0_Populate_LTV</fullName>
        <description>For IPL SFDC2 opportunities</description>
        <field>LTV__c</field>
        <formula>IF(Property_Value__c=0,0,CI_Loan_Amount__c / Property_Value__c)</formula>
        <name>IPL 2.0: Populate LTV</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Update_Start_Date_of_Current_Stage</fullName>
        <field>LLC_BI__Start_Date_at_Current_Stage__c</field>
        <formula>TODAY()</formula>
        <name>Update Start Date of Current Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Conv_Opp_Type_Advisors</fullName>
        <field>StageName</field>
        <literalValue>Reviewing Registration</literalValue>
        <name>Lead Conv Opp Type - Advisors</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Conv_Opp_Type_stage</fullName>
        <field>StageName</field>
        <literalValue>Contract – Negotiation</literalValue>
        <name>Lead Conv Opp Type stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_DAL_Record_Type_Update</fullName>
        <description>Handles the update of the Opportunity record type for DAL on Lead Conversion</description>
        <field>RecordTypeId</field>
        <lookupValue>Dealer_Services_Applicant_SFDC2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SFDC2 DAL Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Default_Opp_Stage_for_Lead_Conv</fullName>
        <description>Sets the default Opportunity Stage when a Lead is converted</description>
        <field>StageName</field>
        <literalValue>1 - New</literalValue>
        <name>SFDC2: Default Opp Stage for Lead Conv</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Epiq_Record_Type_Update</fullName>
        <description>Handles the update of the Opportunity record type for Epic on Lead Conversion</description>
        <field>RecordTypeId</field>
        <lookupValue>Epiq_SFDC2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SFDC2 Epiq Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Opp_BU_Owner_Change_Count_to_0</fullName>
        <description>SFDC2 - resets counter to 0</description>
        <field>BU_Owner_Change_Count_SFDC2__c</field>
        <formula>0</formula>
        <name>SFDC2: Opp BU Owner Change Count to 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Opp_Cross_Sell_True</fullName>
        <description>SFDC2 - ticks the cross-sell field to trigger automated opportunity creation</description>
        <field>Cross_Sell_SFDC2__c</field>
        <literalValue>1</literalValue>
        <name>SFDC2: Opp Cross-Sell True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Opp_Incr_BU_Owner_Change_Count</fullName>
        <description>SFDC2: Increments counter when opportunity ownership changes to API Service Account</description>
        <field>BU_Owner_Change_Count_SFDC2__c</field>
        <formula>BU_Owner_Change_Count_SFDC2__c + 1</formula>
        <name>SFDC2: Opp Incr BU Owner Change Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Opp_Reassign_to_Queue</fullName>
        <description>Ticks checkbox to indicate Opportunity needs to be reassigned to business lead queue</description>
        <field>Reassign_To_Queue_SFDC2__c</field>
        <literalValue>1</literalValue>
        <name>SFDC2: Opp Reassign to Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Opp_Stage_to_0_Closed_Lost</fullName>
        <description>SFDC2 - Sets Opportunity Stage to 0 - Closed Lost</description>
        <field>StageName</field>
        <literalValue>0 - Closed - Lost</literalValue>
        <name>SFDC2: Opp Stage to 0 - Closed Lost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Opportunity_Owner_email_for_stage</fullName>
        <description>Opportunity owners are notified by email when the stage for their opportunity equals stage 8.</description>
        <field>Opportunity_Owner_Email__c</field>
        <formula>Owner.Email</formula>
        <name>SFDC2:Opportunity Owner email for stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Set_Last_Activity_SFDC2_Opp</fullName>
        <description>Sets the Opportunity Last Activity SFDC2 field to the current date</description>
        <field>Last_Activity_SFDC2__c</field>
        <formula>TODAY()</formula>
        <name>SFDC2: Set Last Activity SFDC2 Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_ULP_Record_Type_Update</fullName>
        <description>Handles the update of the Opportunity record type for ULP on Lead Conversion</description>
        <field>RecordTypeId</field>
        <lookupValue>ULP_SFDC2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SFDC2 ULP Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Update_Commercial_Banking_SFDC2_Op</fullName>
        <description>Update the RecordType for Commercial Banking SFDC2</description>
        <field>RecordTypeId</field>
        <lookupValue>Commercial_Banking_SFDC2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SFDC2 Update Commercial Banking SFDC2 Op</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Update_HBD_Opportunity_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>HBD_SFDC2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SFDC2 Update HBD Opportunity Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Updated_C_I_EQF</fullName>
        <description>Update EQF RecordType for C&amp;I SFDC2 Users</description>
        <field>RecordTypeId</field>
        <lookupValue>EQF_SFDC2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SFDC2: Updated C&amp;I EQF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_copy_Loan_Amount_to_Amount</fullName>
        <description>SFDC2: copy Loan Amount value to the Amount field</description>
        <field>Amount</field>
        <formula>CI_Loan_Amount__c</formula>
        <name>SFDC2: copy Loan Amount to Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC_2_0_Set_Opportunity_Owner_to_API</fullName>
        <description>SFDC 2.0: Sets the Opportunity Owner field to API Service Account</description>
        <field>OwnerId</field>
        <lookupValue>api@bofi.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>SFDC 2.0: Set Opportunity Owner to API</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFR_TPO_IPL_Opportunity_Amount_Field</fullName>
        <description>Updates Opportunity Amount with Loan Amount</description>
        <field>Amount</field>
        <formula>Loan_Amount__c</formula>
        <name>SFR,TPO,IPL Opportunity Amount Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_AssignedPayments_PaymentsVerified</fullName>
        <description>Assigned Payments workflow for updated sub stage to payments verified</description>
        <field>SubStage__c</field>
        <literalValue>Payments Verified</literalValue>
        <name>SF_AssignedPayments_PaymentsVerified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_AssignedPymts_DocsBack</fullName>
        <description>Assigned Payments workflow for updating the stage to docs back</description>
        <field>StageName</field>
        <literalValue>Docs Back</literalValue>
        <name>SF_AssignedPymts_DocsBack</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_Close_Date_Equals_Current_Date</fullName>
        <field>CloseDate</field>
        <formula>TODAY()</formula>
        <name>SF - Close Date Equals Current Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_ClosingBinderComplete_SS</fullName>
        <description>When closing binder review complete WF occurs, update the sub stage to closing binder complete</description>
        <field>SubStage__c</field>
        <literalValue>Closing Binder Review Complete</literalValue>
        <name>SF_ClosingBinderComplete_SS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_ClosingBinderComplete_Stage</fullName>
        <description>When closing binder review complete WF occurs, update the stage to closing binder received.</description>
        <field>StageName</field>
        <literalValue>Closing Binder Received</literalValue>
        <name>SF_ClosingBinderComplete_Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_ClosingBinderRec_SS</fullName>
        <description>When closing binder received WF occurs, update the sub stage to Closing Binder received</description>
        <field>SubStage__c</field>
        <literalValue>Closing Binder Received</literalValue>
        <name>SF_ClosingBinderRec_SS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_ClosingBinderRec_Stage</fullName>
        <description>When Closing  Binder received WF occurs, update the stage to closing binder received</description>
        <field>StageName</field>
        <literalValue>Closing Binder Received</literalValue>
        <name>SF_ClosingBinderRec_Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_ContractOut_DocsOut</fullName>
        <description>SF Documents Out Field Update</description>
        <field>StageName</field>
        <literalValue>Docs Out</literalValue>
        <name>SF_ContractOut_DocsOut</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_ContractPkg_ContractBack</fullName>
        <description>Contract Pkg Workflow, update Sub Stage Contract Back field</description>
        <field>SubStage__c</field>
        <literalValue>Contract Back</literalValue>
        <name>SF_ContractPkg_ContractBack</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_ContractPkg_ContractOut</fullName>
        <description>Contract Package Workflow for Contract Out Sub Stage</description>
        <field>SubStage__c</field>
        <literalValue>Contract Out</literalValue>
        <name>SF_ContractPkg_ContractOut</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_ContractPkg_DocsBack</fullName>
        <description>Contract Pkg Received Workflow, change Docs Back Status</description>
        <field>StageName</field>
        <literalValue>Docs Back</literalValue>
        <name>SF_ContractPkg_DocsBack</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_DisclosurePack_DocsBack</fullName>
        <description>Docs Back for SF Disclosure Pack Update</description>
        <field>StageName</field>
        <literalValue>Docs Back</literalValue>
        <name>SF_DisclosurePack_DocsBack</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_DisclosuresBack_Update</fullName>
        <description>SF Disclosures Update Disclosures Back</description>
        <field>SubStage__c</field>
        <literalValue>Disclosures Back</literalValue>
        <name>SF_DisclosuresBack_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_Disclosures_Out</fullName>
        <description>Sub-Stage Disclosures Out Update</description>
        <field>SubStage__c</field>
        <literalValue>Disclosures Out</literalValue>
        <name>SF_Disclosures_Out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_Docs_Out</fullName>
        <description>Update Stage to Docs Out</description>
        <field>StageName</field>
        <literalValue>Docs Out</literalValue>
        <name>SF_Docs_Out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_FP_Confirmation_Status_Date_Change</fullName>
        <field>FP_Confirmation_Status_Date__c</field>
        <formula>NOW()</formula>
        <name>SF: FP Confirmation Status Date Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_HearingDate_CloseDate</fullName>
        <description>When HearingDate workflow occurs, update the Close Date = Hearing Date + 20Days</description>
        <field>CloseDate</field>
        <formula>Hearing_Date__c + 20</formula>
        <name>SF_HearingDate_CloseDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_HearingDate_CloseDate2</fullName>
        <description>When HearingDate workflow occurs, update the Close Date = Hearing Date + 20Days</description>
        <field>CloseDate</field>
        <formula>Hearing_Date__c + 20</formula>
        <name>SF_HearingDate_CloseDate2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_HearingDate_HearingSet</fullName>
        <description>When the Hearing Date workflow occurs update the sub-stage to Hearing Set</description>
        <field>SubStage__c</field>
        <literalValue>Hearing Set</literalValue>
        <name>SF_HearingDate_HearingSet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_HearingDate_HearingSet2</fullName>
        <description>When the Hearing Date workflow occurs update the sub-stage to Hearing Set</description>
        <field>SubStage__c</field>
        <literalValue>Hearing Set</literalValue>
        <name>SF_HearingDate_HearingSet2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_HearingDate_Legal</fullName>
        <description>Update Stage to Legal when HearingDate workflow occurs</description>
        <field>StageName</field>
        <literalValue>Legal</literalValue>
        <name>SF_HearingDate_Legal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_HearingDate_Legal2</fullName>
        <description>Update Stage to Legal when HearingDate workflow occurs</description>
        <field>StageName</field>
        <literalValue>Legal</literalValue>
        <name>SF_HearingDate_Legal2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_ISA_Stage</fullName>
        <description>When Issuer Acknowledgement workflow occurs, update the stage to Prep to Fund</description>
        <field>StageName</field>
        <literalValue>Prep to Fund</literalValue>
        <name>SF_ISA_Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_ISA_SubStage</fullName>
        <description>When Issuer Acknowledgement WF occurs, update the sub stage to acknowledgement</description>
        <field>SubStage__c</field>
        <literalValue>Acknowledgment Received</literalValue>
        <name>SF_ISA_SubStage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_OCBinderToCounsel_SS</fullName>
        <description>When OC Binder to Counsel occurs update the sub stage to OC Binder to Counsel</description>
        <field>SubStage__c</field>
        <literalValue>OC Binder to Counsel</literalValue>
        <name>SF_OCBinderToCounsel_SS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>NextValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_OCBinder_Legal</fullName>
        <description>When OC Binder Workflow Occurs then trigger docs back stage field update</description>
        <field>StageName</field>
        <literalValue>Legal</literalValue>
        <name>SF_OCBinder_Legal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_OCBinder_OCBC</fullName>
        <description>When OC Binder Workflow Occurs, Trigger OC Binder Complete Sub Stage Field Update</description>
        <field>SubStage__c</field>
        <literalValue>OC Binder Complete</literalValue>
        <name>SF_OCBinder_OCBC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_OrderReceived_StagePTF</fullName>
        <description>When Order Received workflow occurs, update stage to PTF</description>
        <field>StageName</field>
        <literalValue>Prep to Fund</literalValue>
        <name>SF_OrderReceived_StagePTF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_OrderReceived_SubStage</fullName>
        <description>When order received workflow occurs, change sub stage to order received</description>
        <field>SubStage__c</field>
        <literalValue>Order Received</literalValue>
        <name>SF_OrderReceived_SubStage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_OrderSigned_Petition</fullName>
        <description>When order signed workflow occurs update the petition status to approved</description>
        <field>Petition_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>SF_OrderSigned_Petition</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_OrderSigned_Stage</fullName>
        <description>Change the Stage to Legal when the Order Signed Workflow occurs</description>
        <field>StageName</field>
        <literalValue>Legal</literalValue>
        <name>SF_OrderSigned_Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_OrderSigned_SubStage</fullName>
        <description>When the order signed workflow occurs change sub-stage to order signed</description>
        <field>SubStage__c</field>
        <literalValue>Order Signed</literalValue>
        <name>SF_OrderSigned_SubStage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_PetitionFiled_CloseDate</fullName>
        <description>Close Date Updated; Petition Close Date =  50 days + Petition Filed</description>
        <field>CloseDate</field>
        <formula>Petition_Filed__c + 50</formula>
        <name>SF_PetitionFiled_CloseDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_PetitionFiled_Legal</fullName>
        <description>Update Legal Field when Workflow Petition Filed Occurs</description>
        <field>StageName</field>
        <literalValue>Legal</literalValue>
        <name>SF_PetitionFiled_Legal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_PetitionFiled_PF</fullName>
        <description>Petition Filed Workflow to Update Sub Stage PetitionFiled</description>
        <field>SubStage__c</field>
        <literalValue>Petition Filed</literalValue>
        <name>SF_PetitionFiled_PF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_PetitionFiled_Pending</fullName>
        <description>When PF Workflow Occurs, create pending petition status</description>
        <field>Petition_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>SF_PetitionFiled_Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_PetitionStatus_Approved</fullName>
        <field>Petition_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>SF_PetitionStatus_Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_PrepToFile_Legal</fullName>
        <description>When Prep to File occurs update stage to Legal</description>
        <field>StageName</field>
        <literalValue>Legal</literalValue>
        <name>SF_PrepToFile_Legal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_PrepToFile_PTF</fullName>
        <description>Update PTF workflow for PTF sub stage</description>
        <field>SubStage__c</field>
        <literalValue>Prep to File</literalValue>
        <name>SF_PrepToFile_PTF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_Pricing_Requested</fullName>
        <field>SubStage__c</field>
        <literalValue>Pricing Requested</literalValue>
        <name>SF - Pricing Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_Reason_Lost_Equals_Pricing_Expired</fullName>
        <field>Reason_Lost__c</field>
        <literalValue>Pricing Expired</literalValue>
        <name>SF - Reason Lost Equals Pricing Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_SentToUW_DocsBack</fullName>
        <description>Sent to UW Workflow to Update the Stage &quot;Docs Back&quot;</description>
        <field>StageName</field>
        <literalValue>Docs Back</literalValue>
        <name>SF_SentToUW_DocsBack</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_SentToUW_MUW</fullName>
        <description>Sent to UW workflow to update sub stage with Medical Underwriter</description>
        <field>SubStage__c</field>
        <literalValue>Submitted to Medical Underwriter</literalValue>
        <name>SF_SentToUW_MUW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_Stage_Equals_Terminated</fullName>
        <field>StageName</field>
        <literalValue>Terminated</literalValue>
        <name>SF - Stage Equals Terminated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_Terminated_CloseDate</fullName>
        <description>When Terminated workflow action occurs, set Close Date to Today</description>
        <field>CloseDate</field>
        <formula>TODAY()</formula>
        <name>SF_Terminated_CloseDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_UpdateAmountWithNetSpread</fullName>
        <description>Update the Amount field with the Net Spread value</description>
        <field>Amount</field>
        <formula>Net_Spread__c</formula>
        <name>SF_UpdateAmountWithNetSpread</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_UpdateAmountWithQuotedSpread</fullName>
        <description>Update the Amount field with the Quoted Spread value</description>
        <field>Amount</field>
        <formula>Qouted_Spread__c</formula>
        <name>SF_UpdateAmountWithQuotedSpread</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CD_WF_StageName</fullName>
        <field>CD_WF_StageChange__c</field>
        <literalValue>1</literalValue>
        <name>Set CD_WF_StageName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Record_Type_Dealer_Services_Dealer</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Dealer_Services_Applicant</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Record Type Dealer Services - Dealer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Record_Type_to_BB</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Business_Banking_Opportunity</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Record Type to BB</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Record_Type_to_Dealer_Services_App</fullName>
        <description>Set Record Type to Dealer Services - Applicant.</description>
        <field>RecordTypeId</field>
        <lookupValue>Dealer_Services_Application_for_Loan</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Record Type to Dealer Services - App</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Record_Type_to_SFR_TPO_IPL</fullName>
        <description>This has been updated to &quot;TPO&quot; record type. Support ticket 47697</description>
        <field>RecordTypeId</field>
        <lookupValue>TPO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Record Type to TPO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Sales_Call_Attempts_to_Attempt_4</fullName>
        <field>Sales_Call_Attempts__c</field>
        <literalValue>Attempt 4 - Not contacted</literalValue>
        <name>Set Sales Call Attempts to Attempt 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Service_Call_Attempt_to_Abandoned</fullName>
        <description>Sets Service Call Attempt to &quot;Service Call Abandoned&quot;</description>
        <field>Service_Call_Attempts__c</field>
        <literalValue>Service Call Abandoned</literalValue>
        <name>Set Service Call Attempt to Abandoned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Closed_Sale_Lost</fullName>
        <description>Sets Opportunity Stage to Closed - Sale Lost</description>
        <field>StageName</field>
        <literalValue>Closed - Sale Lost</literalValue>
        <name>Set Stage to Closed - Sale Lost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage</fullName>
        <field>StageName</field>
        <literalValue>Docs Out</literalValue>
        <name>Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sub_stage</fullName>
        <field>SubStage__c</field>
        <literalValue>Disclosures Out</literalValue>
        <name>Sub stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Close_Date</fullName>
        <field>CloseDate</field>
        <formula>Contract_Pack_Received__c + 60</formula>
        <name>Update Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_EffectiveToBroker</fullName>
        <description>When ETB WF occurs, update the BOFI Effective Rate from Price to Broker</description>
        <field>BofI_Effective_Date__c</field>
        <formula>Effective_Rate_to_to_Broker__c</formula>
        <name>Update_EffectiveToBroker</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_EffectiveToCustomer</fullName>
        <description>When ETC workflow occurs, update the BOFI Effective Rate from Effective Rate to Customer</description>
        <field>BofI_Effective_Date__c</field>
        <formula>Effective_Rate_to_Customer__c</formula>
        <name>Update_EffectiveToCustomer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opp_NameSFDC2</fullName>
        <description>Takes value of Opportunity Name Holder and updates Opp Name</description>
        <field>Name</field>
        <formula>Opportunity_Name_HolderSFDC2__c</formula>
        <name>Update Opp Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PriceToBroker</fullName>
        <description>When PTB occurs, update the BOFI Price to Broker</description>
        <field>BofI_Purchase_Price__c</field>
        <formula>Purchase_Price_to_Broker__c</formula>
        <name>Update_PriceToBroker</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PriceToCustomer</fullName>
        <description>When PTC WF occurs, update the price to customer to BOFI Price</description>
        <field>BofI_Purchase_Price__c</field>
        <formula>Purchase_Price_to_Customer__c</formula>
        <name>Update_PriceToCustomer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_RT_Factoring_C_I_SFDC2</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Factoring_SFDC2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update RT  Factoring C&amp;I SFDC2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_RT_IPL_SFDC2</fullName>
        <description>Update Opportunity Record Type to IPL</description>
        <field>RecordTypeId</field>
        <lookupValue>IPL_SFDC2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update RT IPL SFDC2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_RT_LF_CRESL_C_I_SFDC2</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CRESL_SFDC2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update RT  LF CRESL C&amp;I SFDC2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_RT_NRELF_SFDC2</fullName>
        <description>When Sub-Branch Field on Lead Record Type C&amp;I SFDC2 equals Non-Real Estate
Lead Record Type C&amp;I SFDC2 converts  to Opportunity Record Type NRELF SFDC2</description>
        <field>RecordTypeId</field>
        <lookupValue>NRELF_SFDC2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update RT NRELF SFDC2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_RT_RELF_SFDC2</fullName>
        <description>Update RecordType to C&amp;I SFDC2 REFL Users</description>
        <field>RecordTypeId</field>
        <lookupValue>RELF_SFDC2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update RT  RELF SFDC2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_for_Mortgage</fullName>
        <description>Update Stage for Mortgage Record Type on Lead Conversion</description>
        <field>StageName</field>
        <literalValue>Lead</literalValue>
        <name>Update Stage for Mortgage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Virtus_Record_Type_Update</fullName>
        <description>Sets the opportunity record type to Virtus</description>
        <field>RecordTypeId</field>
        <lookupValue>Virtus_SFDC2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Virtus Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WLD_Reset_Proposed_Line_Amount</fullName>
        <field>Current_Line_Amount__c</field>
        <name>WLD: Reset Proposed Line Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WLD_Set_Proposed_Line_Amount_Pending</fullName>
        <field>Current_Line_Amount__c</field>
        <formula>Proposed_Line_Amount__c</formula>
        <name>WLD: Set Proposed Line Amount - Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>change_SF_sales_status_to_deal_in_progre</fullName>
        <description>change SF account sales status to deal in progress when documents are submitted</description>
        <field>Sales_Status_Person__c</field>
        <literalValue>Deal In Process</literalValue>
        <name>change SF sales status to deal in progre</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>change_SF_sales_status_to_rel_estb_d</fullName>
        <description>change SF sales status to relationship established</description>
        <field>Sales_Status_Person__c</field>
        <literalValue>Relationship Established</literalValue>
        <name>change SF sales status to rel estb&apos;d</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>change_sales_status_to_pricing_soon</fullName>
        <description>change SF account sales status to pricing soon when an opportunity moves into pricing stage, pricing requested sub stage</description>
        <field>Sales_Status_Person__c</field>
        <literalValue>Pricing Soon</literalValue>
        <name>change sales status to pricing soon</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>pricing_to_customer_stage_update</fullName>
        <description>change sub stage to pricing provided to customer</description>
        <field>SubStage__c</field>
        <literalValue>Pricing Provided to Customer</literalValue>
        <name>pricing to customer stage update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>InsideSales_OppWon_KPI</fullName>
        <apiVersion>32.0</apiVersion>
        <description>Send message to InsideSales to increment KPI for OppWon</description>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/oppwon</endpointUrl>
        <fields>Id</fields>
        <fields>OwnerId</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>api@bofi.com</integrationUser>
        <name>InsideSales OppWon KPI</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>QTRX_Survey_Closed_Won_Opp_ConsDep_3_Day</fullName>
        <apiVersion>37.0</apiVersion>
        <description>Send survey after 3 days.</description>
        <endpointUrl>https://bofifederalbank.co1.qualtrics.com/WRQualtricsServer/sfApi.php?r=outboundMessage&amp;u=UR_7Qbmmv4iP4BKGLX&amp;s=SV_1FA6OtldxEFtU4B&amp;t=TR_3ZQGVqHtScOpVMp</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>api@bofi.com</integrationUser>
        <name>QTRX Survey Closed Won Opp ConsDep 3 Day</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Qualtrics_Survey_Closed_Won_Opps_ConsDep</fullName>
        <apiVersion>37.0</apiVersion>
        <description>Qualtrics Survey Closed Won Opps ConsDep</description>
        <endpointUrl>https://bofifederalbank.co1.qualtrics.com/WRQualtricsServer/sfApi.php?r=outboundMessage&amp;u=UR_7Qbmmv4iP4BKGLX&amp;s=SV_1FA6OtldxEFtU4B&amp;t=TR_3ZQGVqHtScOpVMp</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>api@bofi.com</integrationUser>
        <name>Qualtrics Survey Closed Won Opps ConsDep</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Qualtrics_Survey_WC</fullName>
        <apiVersion>36.0</apiVersion>
        <endpointUrl>https://bofifederalbank.co1.qualtrics.com/WRQualtricsServer/sfApi.php?r=outboundMessage&amp;u=UR_d1fH5cXQUN5dAJD&amp;s=SV_ei0fi3xuPq1dVqd&amp;t=TR_cTpdeKzkMjohH4F</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>api@bofi.com</integrationUser>
        <name>Qualtrics Survey WC</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Qualtrics_Survey_WC2</fullName>
        <apiVersion>36.0</apiVersion>
        <endpointUrl>https://bofifederalbank.co1.qualtrics.com/WRQualtricsServer/sfApi.php?r=outboundMessage&amp;u=UR_7Qbmmv4iP4BKGLX&amp;s=SV_ei0fi3xuPq1dVqd&amp;t=TR_cTpdeKzkMjohH4F</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>api@bofi.com</integrationUser>
        <name>Qualtrics Survey WC2</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Qualtrics_Survey_WC3</fullName>
        <apiVersion>36.0</apiVersion>
        <endpointUrl>https://bofifederalbank.co1.qualtrics.com/WRQualtricsServer/sfApi.php?r=outboundMessage&amp;u=UR_7Qbmmv4iP4BKGLX&amp;s=SV_ei0fi3xuPq1dVqd&amp;t=TR_cTpdeKzkMjohH4F</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>api@bofi.com</integrationUser>
        <name>Qualtrics Survey WC2</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Qualtrics_Survey_WC4</fullName>
        <apiVersion>36.0</apiVersion>
        <endpointUrl>https://bofifederalbank.co1.qualtrics.com/WRQualtricsServer/sfApi.php?r=outboundMessage&amp;u=UR_7Qbmmv4iP4BKGLX&amp;s=SV_ei0fi3xuPq1dVqd&amp;t=TR_cTpdeKzkMjohH4F</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>api@bofi.com</integrationUser>
        <name>Qualtrics Survey WC4</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>BB%3A Lead Type is Business Banking and Created Date is not empty</fullName>
        <actions>
            <name>Set_Record_Type_to_BB</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Lead_Type__c</field>
            <operation>equals</operation>
            <value>Business Banking</value>
        </criteriaItems>
        <description>BB - Set the appropriate Record Type based on Lead Type. DO NOT TURN BACK ON</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BB%3A Oppty Won Client Status Update</fullName>
        <actions>
            <name>BB_Client_Status_Yes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Business Banking Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <description>Business Banking - Triggered when Record Type is Business Banking Opportunity and Stage is Closed Won</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A AB Participation%3A Update Opportunity Record Type</fullName>
        <actions>
            <name>C_I_Opp_AB_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CI_Record_Type_Lead_Conversion_Workflow__c</field>
            <operation>equals</operation>
            <value>C&amp;I - AB Participation</value>
        </criteriaItems>
        <description>C&amp;I - AB Participation: Updates the record type after Lead Conversion to match the record type from Lead Conversion.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A CAM Approval is 1</fullName>
        <actions>
            <name>CI_Update_Stage_to_CAM</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CI_Update_SubStage_to_CAM_Submitted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>C&amp;I - Lender Finance,C&amp;I - AB Participation,C&amp;I - General,C&amp;I - Bridge</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CAM_Approval__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Stage to &quot;C&amp;I - CAM&quot; and the Sub-Stage to &quot;CAM - Revision&quot; when the CAM Approval Process is submitted.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A CAM Approval is 2</fullName>
        <actions>
            <name>CI_Update_Stage_to_CAM</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CI_Update_SubStage_to_CAM_Revision</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>C&amp;I - Lender Finance,C&amp;I - AB Participation,C&amp;I - General,C&amp;I - Bridge</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CAM_Approval__c</field>
            <operation>equals</operation>
            <value>2</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Stage to &quot;C&amp;I - CAM&quot; and the Sub-Stage to &quot;CAM - Revision&quot; when any step in the CAM Approval Process is rejected, or the CAM Approval Process is recalled.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A CAM Approval is 3</fullName>
        <actions>
            <name>CI_Update_Stage_to_Closing</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CI_Update_SubStage_to_NULL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>C&amp;I - Lender Finance,C&amp;I - AB Participation,C&amp;I - General,C&amp;I - Bridge</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CAM_Approval__c</field>
            <operation>equals</operation>
            <value>3</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Stage to &quot;C&amp;I - Closing&quot; when the final step in the CAM Approval Process is approved.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A General - Update Opportunity Record Type</fullName>
        <actions>
            <name>C_I_Opp_General_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CI_Record_Type_Lead_Conversion_Workflow__c</field>
            <operation>equals</operation>
            <value>C&amp;I - General</value>
        </criteriaItems>
        <description>C&amp;I General - Updates the record type after Lead Conversion to match the record type from Lead Conversion.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Lender Finance - Update Opportunity Record Type</fullName>
        <actions>
            <name>C_I_Opp_Lender_Fin_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CI_Record_Type_Lead_Conversion_Workflow__c</field>
            <operation>equals</operation>
            <value>C&amp;I - Lender Finance</value>
        </criteriaItems>
        <description>C&amp;I Lender Finance - Updates the record type after Lead Conversion to match the record type from Lead Conversion.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Opportunity Originator is empty</fullName>
        <actions>
            <name>C_I_Opportunity_Originator</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CI_Opportunity_Originator__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>C&amp;I - AB Participation,C&amp;I - Bridge,C&amp;I - General,C&amp;I - Lender Finance</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Opportunity Originator with the Opportunity Owner upon Opportunity record creation.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A PIC Approval is 1</fullName>
        <actions>
            <name>CI_Update_Stage_to_PIC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CI_Update_SubStage_to_PIC_Submitted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>C&amp;I - Lender Finance,C&amp;I - AB Participation,C&amp;I - General,C&amp;I - Bridge</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.PIC_Approval__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Stage to &quot;C&amp;I - PIC&quot; and the Sub-Stage to &quot;PIC - Revision&quot; when the PIC Approval Process is submitted.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A PIC Approval is 2</fullName>
        <actions>
            <name>CI_Update_Stage_to_PIC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>C_I_Update_SubStage_to_PIC_Revision</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>C&amp;I - Lender Finance,C&amp;I - AB Participation,C&amp;I - General,C&amp;I - Bridge</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.PIC_Approval__c</field>
            <operation>equals</operation>
            <value>2</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Stage to &quot;C&amp;I - PIC&quot; and the Sub-Stage to &quot;PIC - Revision&quot; when any step in the PIC Approval Process is rejected, or the PIC Approval Process is recalled.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A PIC Approval is 3</fullName>
        <actions>
            <name>CI_Update_Stage_to_LOI</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CI_Update_SubStage_to_LOI_Preparation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>C&amp;I - Lender Finance,C&amp;I - AB Participation,C&amp;I - General,C&amp;I - Bridge</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.PIC_Approval__c</field>
            <operation>equals</operation>
            <value>3</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Stage to &quot;C&amp;I - LOI&quot; and the Sub-Stage to &quot;LOI - Preparation&quot; when the final step in the PIC Approval Process is approved.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Projected Close Date is changed and Closed is False</fullName>
        <actions>
            <name>C_I_Update_Close_Date_to_Projected</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I - When the Projected Close Date changes, updates the Close Date to the Projected Close Date value, except for when the Opportunity Stage is Closed Won.</description>
        <formula>ISCHANGED ( CI_Projected_Close_Date__c ) &amp;&amp; IsClosed = FALSE &amp;&amp;  CONTAINS ( RecordType.Name, &quot;C&amp;I&quot; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Projected Close Date is not empty and Closed is False</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CI_Projected_Close_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>C&amp;I - Lender Finance,C&amp;I - AB Participation,C&amp;I - General,C&amp;I - Bridge</value>
        </criteriaItems>
        <description>C&amp;I - Sends an email alert to the Oppty Owner within 15 days of the Projected Close Date, if the Opportunity is open.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>C_I_Send_Projected_Close_Date_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CI_Projected_Close_Date__c</offsetFromField>
            <timeLength>-15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>C%26I%3A Record Type is C%26I</fullName>
        <actions>
            <name>C_I_Update_Native_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>C&amp;I - Lender Finance,C&amp;I - AB Participation,C&amp;I - General,C&amp;I - Bridge</value>
        </criteriaItems>
        <description>C&amp;I - Updates the native Amount field with the value from the Origination Document Loan Amount field.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Record Type is C%26I - Bridge</fullName>
        <actions>
            <name>C_I_Opp_Bridge_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CI_Record_Type_Lead_Conversion_Workflow__c</field>
            <operation>equals</operation>
            <value>C&amp;I - Bridge</value>
        </criteriaItems>
        <description>C&amp;I Bridge - Updates the record type after Lead Conversion to match the record type from Lead Conversion.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Stage is C%26I Closing</fullName>
        <actions>
            <name>C_I_Opportunity_Send_email_notification_as_the_opportunity_stage_is_set_to_C_I_C</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>C&amp;I - Closing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>C&amp;I - AB Participation,C&amp;I - Bridge,C&amp;I - General,C&amp;I - Lender Finance</value>
        </criteriaItems>
        <description>C&amp;I - Send email notification as the opportunity stage is set to &quot;C&amp;I Closing&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Stage is Closed Won</fullName>
        <actions>
            <name>C_I_Opp_Send_email_notification_as_the_opportunity_stage_is_set_to_C_I_Closed_Wo</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>C_I_Update_Close_Date_for_Closed_Won</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>C_I_Define_Certification_Requirements</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>C&amp;I - Lender Finance,C&amp;I - AB Participation,C&amp;I - General,C&amp;I - Bridge</value>
        </criteriaItems>
        <description>C&amp;I Updates the Close Date when the Stage changes to Closed Won; creates task for Josh Butensky to set up Certification requirements</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Sub-Stage is Credit Document Review</fullName>
        <actions>
            <name>C_I_Legal_Received_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.SubStage__c</field>
            <operation>equals</operation>
            <value>Credit Document Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>C&amp;I - AB Participation,C&amp;I - Bridge,C&amp;I - General,C&amp;I - Lender Finance</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Legal Received with the date/time of the Sub-Stage change to Credit Document Review.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Sub-Stage is LOI Sent - 15 Days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.SubStage__c</field>
            <operation>equals</operation>
            <value>LOI Sent</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>C&amp;I - AB Participation,C&amp;I - Bridge,C&amp;I - General,C&amp;I - Lender Finance</value>
        </criteriaItems>
        <description>C&amp;I - Creates a task for the Opportunity Owner if the Sub-Stage has not changed from LOI Sent within 15 Days.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>LOI_Status_Check_Received_Date_Approaching</name>
                <type>Task</type>
            </actions>
            <timeLength>15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>C%26I%3A Sub-Stage is LOI Sent - 20 Days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.SubStage__c</field>
            <operation>equals</operation>
            <value>LOI Sent</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>C&amp;I - AB Participation,C&amp;I - Bridge,C&amp;I - General,C&amp;I - Lender Finance</value>
        </criteriaItems>
        <description>C&amp;I - Creates a task for the Opportunity Owner if the Sub-Stage has not changed from LOI Sent within 20 Days.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>LOI_Status_Check_Received_Date_Approaching</name>
                <type>Task</type>
            </actions>
            <timeLength>20</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>C%26I%3A Sub-Stage is LOI Sent - 25 Days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.SubStage__c</field>
            <operation>equals</operation>
            <value>LOI Sent</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>C&amp;I - AB Participation,C&amp;I - Bridge,C&amp;I - General,C&amp;I - Lender Finance</value>
        </criteriaItems>
        <description>C&amp;I - Creates a task for Josh Butensky if the Sub-Stage has not changed from LOI Sent within 25 Days.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>LOI_Status_Check_Received_Date_Approaching_25</name>
                <type>Task</type>
            </actions>
            <timeLength>25</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>C%26I%3A Sub-Stage is LOI Sent - 31 Days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.SubStage__c</field>
            <operation>equals</operation>
            <value>LOI Sent</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>C&amp;I - AB Participation,C&amp;I - Bridge,C&amp;I - General,C&amp;I - Lender Finance</value>
        </criteriaItems>
        <description>Creates a task for Brian Swanson if the Sub-Stage has not changed from LOI Sent within 31 Days.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>LOI_Overdue</name>
                <type>Task</type>
            </actions>
            <timeLength>31</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>C%26I%3A Sub-Stage is LOI Signed %26 Received w%2FDeposit</fullName>
        <actions>
            <name>C_I_Deposit_Received</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>C_I_Final_LOI_Received</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Order_Third_Party_Diligence</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Schedule_Site_Visit</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Send_Needs_List</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.SubStage__c</field>
            <operation>equals</operation>
            <value>LOI Signed &amp; Received w/Deposit</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>C&amp;I - AB Participation,C&amp;I - Bridge,C&amp;I - General,C&amp;I - Lender Finance</value>
        </criteriaItems>
        <description>C&amp;I - Creates multiple tasks and field updates when Opportunity Sub-Stage is changed to &quot;LOI Signed &amp; Received w/Deposit&quot;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Sub-stage is Legal Engagement - Internal</fullName>
        <actions>
            <name>C_I_Credit_Final_Approval</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>C_I_Legal_Requested_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.SubStage__c</field>
            <operation>equals</operation>
            <value>Legal Engagement - Internal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>C&amp;I - AB Participation,C&amp;I - Bridge,C&amp;I - General,C&amp;I - Lender Finance</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Legal Requested with the date/time of the Sub-Stage change to Legal Engagement - Internal.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CD%3A Created from Lead is true</fullName>
        <actions>
            <name>Consumer_Deposits_Default_Oppt_Stage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Consumer Deposits</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Created_from_Lead__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>CD - Sets the Opportunity stage to Open Unfunded when it is created from a Lead conversion</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CD%3A Deposit Relationship is Welcome List et al and Stage is New Assigned or Open</fullName>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Consumer Deposits</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Deposit_Relationship__c</field>
            <operation>startsWith</operation>
            <value>Welcome List</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Deposit_Relationship__c</field>
            <operation>equals</operation>
            <value>Large Dollar Variance,10 Day Funding,45 Day Funding,Funding Call,30 Day No Signature Card,45 Day No Signature Card,Rewards Checking Engagement,45 Day Zero Balance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>New Assigned,Open</value>
        </criteriaItems>
        <description>CD - When an Deposit Relationship value is a specific value and the Stage is &quot;New Assigned&quot; or &quot;Open&quot;, set Service Call Attempts to &quot;Service Call Abandoned&quot; and Stage to &quot;Closed - Sale Lost&quot;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_CD_WF_StageName</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_Service_Call_Attempt_to_Abandoned</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_Stage_to_Closed_Sale_Lost</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CD%3A Increment Call Count</fullName>
        <actions>
            <name>CD_Opp_Incr_Number_Calls</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CD - Increments the &quot;Opportunity - Number of Calls&quot; field if criteria is met</description>
        <formula>AND(
   ISCHANGED(Sales_Call_Attempts__c),
   DATEVALUE(CreatedDate) &gt;= DATE(2016,4,7),   NOT(ISNEW()),   RecordType.DeveloperName = &quot;Consumer_Deposits&quot;,   OR(     AND(ISPICKVAL(PRIORVALUE(Sales_Call_Attempts__c),&quot;No Attempts&quot;),         NOT(ISPICKVAL(Sales_Call_Attempts__c,&quot;Attempt 2&quot;)),         NOT(ISPICKVAL(Sales_Call_Attempts__c,&quot;Attempt 3 - Voicemail&quot;)),         NOT(ISPICKVAL(Sales_Call_Attempts__c,&quot;Attempt 4 - Not Contacted&quot;))     ),     AND(ISPICKVAL(PRIORVALUE(Sales_Call_Attempts__c), &quot;Attempt 1&quot;),         NOT(ISPICKVAL(Sales_Call_Attempts__c,&quot;No Attempts&quot;)),         NOT(ISPICKVAL(Sales_Call_Attempts__c,&quot;Attempt 3 - Voicemail&quot;)),         NOT(ISPICKVAL(Sales_Call_Attempts__c,&quot;Attempt 4 - Not Contacted&quot;))     ),     AND(ISPICKVAL(PRIORVALUE(Sales_Call_Attempts__c), &quot;Attempt 2&quot;),         NOT(ISPICKVAL(Sales_Call_Attempts__c,&quot;No Attempts&quot;)),         NOT(ISPICKVAL(Sales_Call_Attempts__c,&quot;Attempt 1&quot;)),         NOT(ISPICKVAL(Sales_Call_Attempts__c,&quot;Attempt 4 - Not Contacted&quot;))     ),     AND(ISPICKVAL(PRIORVALUE(Sales_Call_Attempts__c), &quot;Attempt 3 - Voicemail&quot;),         NOT(ISPICKVAL(Sales_Call_Attempts__c,&quot;No Attempts&quot;)),         NOT(ISPICKVAL(Sales_Call_Attempts__c,&quot;Attempt 1&quot;)),         NOT(ISPICKVAL(Sales_Call_Attempts__c,&quot;Attempt 2&quot;))     ),     AND(ISPICKVAL(PRIORVALUE(Sales_Call_Attempts__c), &quot;Contacted - Call Back&quot;),         OR(           ISPICKVAL(Sales_Call_Attempts__c,&quot;Contacted - Not Interested&quot;),           ISPICKVAL(Sales_Call_Attempts__c,&quot;Contacted - Sale Won&quot;),           ISPICKVAL(Sales_Call_Attempts__c,&quot;Contacted - Sale Lost&quot;)         )     )   ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CD%3A Qualtrics - Stage is Closed - Service and Record Type is Consumer Deposits and Deposit Relationship is Welcome List</fullName>
        <actions>
            <name>Qualtrics_Survey_WC4</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>CD - Qualtrics survey for Closed - Service</description>
        <formula>ISPICKVAL( StageName, &quot;Closed - Service&quot;) &amp;&amp;   RecordTypeId = &quot;012i0000001AbiI&quot; &amp;&amp; ISPICKVAL( Deposit_Relationship__c, &quot;Welcome List&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CD%3A Qualtrics - Stage is Sale Won and Record Type is Consumer Deposits</fullName>
        <actions>
            <name>Qualtrics_Survey_Closed_Won_Opps_ConsDep</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <description>Send out the survey automatically when the opportunity is marked as &quot;sale-won&quot;.</description>
        <formula>ISPICKVAL( StageName, &quot;Sale Won&quot;) &amp;&amp;   RecordTypeId = &quot;012i0000001AbiI&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CD%3A Qualtrics - Stage is Sale Won and Record Type is Consumer Deposits - 3 Days</fullName>
        <active>true</active>
        <description>CD - Qualtrics Survey Closed Won Opps ConsDep - sent out after three days</description>
        <formula>ISPICKVAL( StageName, &quot;Sale Won&quot;) &amp;&amp;   RecordTypeId = &quot;012i0000001AbiI&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>QTRX_Survey_Closed_Won_Opp_ConsDep_3_Day</name>
                <type>OutboundMessage</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CD%3A Stage is New Assigned or Open and Deposit Relationship is Maturing CD Customer</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Consumer Deposits</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Deposit_Relationship__c</field>
            <operation>equals</operation>
            <value>Maturing CD Customer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>New Assigned,Open</value>
        </criteriaItems>
        <description>CD - For all Opportunities which have a Deposit Relationship of “Maturing CD Customer” and which have a Stage of either “New Assigned” or “Open”, set Stage to &quot;Closed - Sale Lost&quot; and Sales Call Attempts to 4</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Sales_Call_Attempts_to_Attempt_4</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_Stage_to_Closed_Sale_Lost</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CD%3A Stage is Sale Won</fullName>
        <actions>
            <name>InsideSales_OppWon_KPI</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Consumer Deposits</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Sale Won</value>
        </criteriaItems>
        <description>CD - This workflow is based on the Consumer Deposits Opportunity record type and sets the KPI when the Opportunity Stage = Closed - Funded</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Commercial%3A Pre-fill the Broker Data Fields</fullName>
        <actions>
            <name>Commercial_2_0_Populate_Broker_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Commercial_2_0_Populate_Broker_Phone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For EQF, Factoring, CRESL, NRELF, RELF, IPL opportunities</description>
        <formula>AND( NOT(ISBLANK( Broker_Name__c  )),  ISCHANGED(Broker_Name__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DS%3A Dealer - Update Opportunity Record Type</fullName>
        <actions>
            <name>DS_Opp_Applicant_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CI_Record_Type_Lead_Conversion_Workflow__c</field>
            <operation>equals</operation>
            <value>Dealer Services - Dealer</value>
        </criteriaItems>
        <description>DS - Handles the update of the Opportunity record type for Dealer Services - Dealer Lead conversions</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Enterprise%3A Stage is Closed Lost</fullName>
        <actions>
            <name>Deal_Died_Stage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Lost</value>
        </criteriaItems>
        <description>Enterprise - Capture stage where deal was lost [REVIEW]</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPL 2%2E0%3A Pre-fill the LTV field</fullName>
        <actions>
            <name>IPL_2_0_Populate_LTV</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>IPL SFDC2</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CI_Loan_Amount__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Property_Value__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.LTV__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Update Start Date of Current Stage</fullName>
        <actions>
            <name>LLC_BI__Update_Start_Date_of_Current_Stage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(StageName)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A FP Confirmation Status is changed</fullName>
        <actions>
            <name>SF_FP_Confirmation_Status_Date_Change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SF - Sets the FP Confirmation Status Date to the current date/time when the FP Confirmation Status field changes</description>
        <formula>ISCHANGED(FP_Confirmation_Status__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Money Raised Funded is changed</fullName>
        <actions>
            <name>SF_UpdateAmountWithNetSpread</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SF - When the Money Raised [Money_Raised_Funded__c] field is updated, then update the Amount field with the Net Spread value.</description>
        <formula>AND(BEGINS(RecordType.Name, &quot;Specialty Finance -&quot;),ISCHANGED( Money_Raised_Funded__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Quoted Spread is changed and greater than 0%2C Money Raised Funded is empty</fullName>
        <actions>
            <name>SF_UpdateAmountWithQuotedSpread</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SF - When the Quoted Spread field is updated and greater than 0 and Money Raised is NULL, then update the Amount field with the Quoted Spread value.</description>
        <formula>AND(BEGINS(RecordType.Name, &quot;Specialty Finance -&quot;),ISCHANGED( Qouted_Spread__c ), Qouted_Spread__c &gt; 0, ISNULL(Money_Raised_Funded__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Report Issue Date is empty%2C OC Binder Sent to Counsel is empty%2C Prep to File is empty%2C Sent to Underwriters is not e</fullName>
        <actions>
            <name>SF_SentToUW_DocsBack</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_SentToUW_MUW</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Sent_to_Underwriters__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Retail SS,Specialty Finance - Retail Lottery</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Prep_to_File__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.OC_Binder_Sent_to_Counsel__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Report_Issue_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>SF - when Sent to Underwriters is changed from Null to Not Null And Stage=Docs Back &amp; Sub-Stage=Submitted to Medical Underwriter</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Retail - Always run</fullName>
        <actions>
            <name>Update_EffectiveToCustomer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Retail SS,Specialty Finance - Retail Lottery</value>
        </criteriaItems>
        <description>When Effective Rate to Customer is changed; Set (hidden field) BofI Effective Rate = Effective Rate to Customer</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Retail - Petition Status is changed to one of Approved%2C Continued%2C or Denied</fullName>
        <actions>
            <name>SF_PetitionStatus_EmailAlert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>SF - When Petition Status is changed to Continued, Denied, or Approved</description>
        <formula>AND(
  OR(
    RecordType.DeveloperName = &quot;Specialty_Finance_Retail&quot;,
    RecordType.DeveloperName = &quot;Specialty_Finance_Retail_Lottery&quot;),
  ISCHANGED(Petition_Status__c),
  OR(
    ISPICKVAL(Petition_Status__c, &quot;Approved&quot;),
    ISPICKVAL(Petition_Status__c, &quot;Continued&quot;),
    ISPICKVAL(Petition_Status__c, &quot;Denied&quot;)
  )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Retail - Petition Status is one of Approved%2C Dismissed%2C Denied</fullName>
        <actions>
            <name>SF_Prep_To_Fund_notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Retail SS,Specialty Finance - Retail Lottery</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Petition_Status__c</field>
            <operation>equals</operation>
            <value>Approved,Dismissed,Denied</value>
        </criteriaItems>
        <description>SF - Triggered when Retail opportunity Petition Status is Approved, Dismissed or Denied</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Retail - Purchase Price to Customer is changed</fullName>
        <actions>
            <name>Update_PriceToCustomer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SF - When Purchase Price to Customer is changed, set (hidden field) BofI Purchase Price = Purchase Price to Customer (needs to populate from BofI Purchase Price)</description>
        <formula>AND(
  OR(
    RecordType.DeveloperName = &apos;Specialty_Finance_Retail&apos;,
    RecordType.DeveloperName = &apos;Specialty_Finance_Retail_Lottery&apos;
  ),
  OR(
    ISCHANGED(Purchase_Price_to_Customer__c),
    ISNEW()
  )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Retail - Stage is Legal and IHC Drafts is Yes</fullName>
        <actions>
            <name>SF_IHC_Drafts_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Retail SS,Specialty Finance - Retail Lottery</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Legal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IHC_Drafts__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>SF - Send email notification to Processing Counsel role members when Opportunity Stage = Legal and IHC Drafts = Yes for Retail SS and Retail Lottery Opps</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Retail - Stage is Pricing</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Retail SS,Specialty Finance - Retail Lottery,Specialty Finance - Retail IGT</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Pricing</value>
        </criteriaItems>
        <description>SF - For Opportunities in the Pricing stage, 30 days after creation set Stage to Terminated, Reason Lost to Pricing Expired, and Close Date to current date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SF_Close_Date_Equals_Current_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>SF_Reason_Lost_Equals_Pricing_Expired</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>SF_Stage_Equals_Terminated</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.CreatedDate</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SF%3A Retail - Stage is changed to Terminated but prior value is not Pricing</fullName>
        <actions>
            <name>SF_Termination_Announcement</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SF_Terminated_CloseDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SF - When opportunity stage is set to Terminated And Close Date=Today</description>
        <formula>AND(
   OR(
      RecordType.Name = &quot;Specialty Finance - Retail SS&quot;, 
      RecordType.Name = &quot;Specialty Finance - Retail Lottery&quot;),
   ISCHANGED(StageName), 
   ISPICKVAL(StageName, &quot;Terminated&quot;),
   NOT(ISPICKVAL(PRIORVALUE(StageName), &quot;Pricing&quot;)),
   NOT(ISNEW())
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Retail%2FWholesale - In House Counsel Review Complete is not empty</fullName>
        <actions>
            <name>SF_Notification_for_In_house_Council_Review_Complete</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>SF - Sends an email notification when the In-house Council Review Complete field has a date entered</description>
        <formula>AND(
  OR(
    BEGINS(RecordType.DeveloperName, &quot;Specialty_Finance_Retail&quot;),
    BEGINS(RecordType.DeveloperName, &quot;Specialty_Finance_Wholesale&quot;)
  ),
  !ISBLANK(In_House_Counsel_Review_Complete__c),
ISNULL(PRIORVALUE(In_House_Counsel_Review_Complete__c))
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Closing Binder Received and Closing Binder Review Complete is not empty</fullName>
        <actions>
            <name>Closing_Binder_Complete_Review_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SF_ClosingBinderComplete_SS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_ClosingBinderComplete_Stage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Closing_Binder_Review_Complete__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Wholesale SS,Specialty Finance - Wholesale Lottery,Specialty Finance - Wholesale IGT</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closing Binder Received</value>
        </criteriaItems>
        <description>SF - when Closing Binder Review Complete is changed from Null to Not Null	Upon Saving Update		Stage=Closing Binder Received &amp; Sub-Stage=Closing Binder Review Complete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Docs Back%2C OC Binder Complete is empty%2C Prep to File is not empty</fullName>
        <actions>
            <name>SF_PrepToFile_EmailAlert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SF_PrepToFile_Legal</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_PrepToFile_PTF</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Prep_to_File__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Retail SS,Specialty Finance - Retail Lottery</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.OC_Binder_Complete__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Docs Back</value>
        </criteriaItems>
        <description>SF - when Prep to File is changed from Null to Not Null And Stage=Docs Back &amp; Sub-Stage=Prep to File, Email Alert to Processing Counsel</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Docs Back%2C Prep to File is empty%2C Assigned Payments Conf is not empty%2C Contract Pack Recvd is not empty</fullName>
        <actions>
            <name>SF_AssignedPayments_PaymentsVerified</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_AssignedPymts_DocsBack</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Assigned_Payments_Confirmed__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contract_Pack_Received__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>contains</operation>
            <value>Specialty Finance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Docs Back</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Prep_to_File__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>SF - when Assigned Payments Confirmed is changed from Null to Not Null And Stage=Docs Back &amp; Prep to File is blank</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Docs Out or Docs Back and Contract Pack Received is not empty</fullName>
        <actions>
            <name>SF_ContractPkg_ContractBack</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_ContractPkg_DocsBack</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Contract_Pack_Received__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Retail SS,Specialty Finance - Retail Lottery</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Docs Out,Docs Back</value>
        </criteriaItems>
        <description>SF - When Contract Pack Received is changed from Null to Not Null And Stage=Docs Back &amp; Sub-Stage=Contract Back</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Docs Out%2C Contract Pack Received is empty%2C Disclosure Pack Received is not empty</fullName>
        <actions>
            <name>SF_DisclosurePack_DocsBack</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_DisclosuresBack_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Disclosure_Pack_Received__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contract_Pack_Received__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Retail SS,Specialty Finance - Retail Lottery</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Docs Out</value>
        </criteriaItems>
        <description>SF - when Disclosure Pack Received is changed from Null to Not Null And Stage=Docs Back &amp; Sub-Stage=Disclosures Back</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Docs Out%2C Contract Package Complete is empty%2C Disclosure Package Completed is not empty</fullName>
        <actions>
            <name>SF_Disclosures_Out</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_Docs_Out</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Disclosure_Package_Completed__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Doc_Request_Completed__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>contains</operation>
            <value>Specialty Finance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Docs Out</value>
        </criteriaItems>
        <description>SF - When Disclosure Package Completed is changed from Null to Not Null And Stage=Docs Out &amp; Sub-Stage=Disclosures Out</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Docs Out%2C Disclosure Pack Received is empty%2C Contract Package Completed is not empty</fullName>
        <actions>
            <name>SF_ContractOut_DocsOut</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_ContractPkg_ContractOut</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Doc_Request_Completed__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Disclosure_Pack_Received__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Retail SS,Specialty Finance - Retail Lottery</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Docs Out</value>
        </criteriaItems>
        <description>SF - when Contract Package Completed is changed from Null to Not Null  And Stage=Docs Out &amp; Sub-Stage=Contract Out</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Docs Out%2C Sub-Stage is Doc Request Submitted%2C Sales Status is not Deal In Process or Remarket</fullName>
        <actions>
            <name>change_SF_sales_status_to_deal_in_progre</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Lottery Winners,Specialty Finance - SS Annuitants,Specialty Finance - IGT Winners</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Docs Out</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SubStage__c</field>
            <operation>equals</operation>
            <value>Doc Request Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Sales_Status_Person__c</field>
            <operation>notEqual</operation>
            <value>Deal In Process,Remarket</value>
        </criteriaItems>
        <description>SF - change account sales status to deal in progress when an opportunity enters into docs out, document request submitted status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Legal and Order Received is not empty</fullName>
        <actions>
            <name>SF_OrderReceived_EmailAlert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SF_OrderReceived_StagePTF</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_OrderReceived_SubStage</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_PetitionStatus_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Order_Received__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Retail SS,Specialty Finance - Retail Lottery</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Legal</value>
        </criteriaItems>
        <description>SF - When Order Received is changed from Null to Not Null And Stage=Prep to Fund, Sub-Stage=Order Received</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Legal and Petition Filed is not empty</fullName>
        <actions>
            <name>SF_PetitionFiled_EmailAlert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SF_PetitionFiled_CloseDate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_PetitionFiled_Legal</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_PetitionFiled_PF</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_PetitionFiled_Pending</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Petition_Filed__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Retail SS,Specialty Finance - Retail Lottery</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Legal</value>
        </criteriaItems>
        <description>SF - When Petition Filed is changed from Null to Not Null And Stage=Legal, Sub-Stage=Petition Filed, Petition Status=Pending, Close Date = (Petition Filed + 50 days)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Legal%2C OC Binder Complete is not empty%2C OC Binder Sent to Counsel is not empty</fullName>
        <actions>
            <name>SF_OCBinderToCounsel_SS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.OC_Binder_Sent_to_Counsel__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.OC_Binder_Complete__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Retail SS,Specialty Finance - Retail Lottery</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Legal</value>
        </criteriaItems>
        <description>SF - When OC Binder Sent to Counsel is changed from Null to Not Null And Stage=Legal &amp; Sub-Stage=OC Binder to Counsel</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Legal%2C OC Binder Sent to Counsel is empty%2C OC Binder Complete is not empty</fullName>
        <actions>
            <name>SF_OCBinder_Legal</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_OCBinder_OCBC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.OC_Binder_Complete__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.OC_Binder_Sent_to_Counsel__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Retail SS,Specialty Finance - Retail Lottery</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Legal</value>
        </criteriaItems>
        <description>SF - When OC Binder Complete is changed from Null to Not Null And Stage=Legal &amp; Sub-Stage=OC Binder Complete</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Legal%2C Order Received is empty%2C Order Signed is not empty</fullName>
        <actions>
            <name>SF_OrderSigned_EmailAlert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SF_OrderSigned_Petition</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_OrderSigned_Stage</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_OrderSigned_SubStage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Order_Signed__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Order_Received__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Retail SS,Specialty Finance - Retail Lottery</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Legal</value>
        </criteriaItems>
        <description>SF - When Order Signed is changed from Null to Not Null And Stage=Legal, Sub-Stage=Order Signed, Petition Status=Approved</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Legal%2C Order Signed is empty%2C Hearing Date is not empty</fullName>
        <actions>
            <name>SF_HearingDate_EmailAlert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SF_HearingDate_CloseDate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_HearingDate_HearingSet</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_HearingDate_Legal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Hearing_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Order_Signed__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>contains</operation>
            <value>Specialty Finance - Retail SS,Specialty Finance - Retail Lottery</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Legal</value>
        </criteriaItems>
        <description>SF - When Hearing Date is changed from Null to Not Null And Stage=Legal, Sub-Stage=Hearing Set, Close Date=(Hearing Date + 20 days)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SF_HearingDate_EmailAlert_7Days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Hearing_Date__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SF_HearingDate_EmailAlert_21Days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Hearing_Date__c</offsetFromField>
            <timeLength>-21</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Legal%2C Order Signed is empty%2C Hearing Date is not empty - Retail Lottery</fullName>
        <actions>
            <name>SF_HearingDate_EmailAlert2</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SF_HearingDate_CloseDate2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_HearingDate_HearingSet2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_HearingDate_Legal2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Hearing_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Order_Signed__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>contains</operation>
            <value>Specialty Finance - Retail Lottery</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Legal</value>
        </criteriaItems>
        <description>SF - When Hearing Date is changed from Null to Not Null And Stage=Legal, Sub-Stage=Hearing Set, Close Date=(Hearing Date + 20 days)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Legal%2C Order Signed is empty%2C Hearing Date is not empty - Retail SS</fullName>
        <actions>
            <name>SF_HearingDate_EmailAlert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SF_HearingDate_CloseDate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_HearingDate_HearingSet</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_HearingDate_Legal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Hearing_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Order_Signed__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>contains</operation>
            <value>Specialty Finance - Retail SS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Legal</value>
        </criteriaItems>
        <description>SF - When Hearing Date is changed from Null to Not Null And Stage=Legal, Sub-Stage=Hearing Set, Close Date=(Hearing Date + 20 days)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SF_HearingDate_EmailAlert_7Days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Hearing_Date__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SF_HearingDate_EmailAlert_21Days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Hearing_Date__c</offsetFromField>
            <timeLength>-21</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Prep to Fund and Closing Binder Review Complete is not empty</fullName>
        <actions>
            <name>Closing_Binder_Complete_Review_Email_Retail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Closing_Binder_Review_Complete__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Retail SS,Specialty Finance - Retail Lottery,Specialty Finance - Retail IGT</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Prep to Fund</value>
        </criteriaItems>
        <description>SF - when Closing Binder Review Complete is changed from Null to Not Null	Upon Saving Update		Stage=Closing Binder Received &amp; Sub-Stage=Closing Binder Review Complete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Prep to Fund and Issuer Acknowledgment Received is not empty</fullName>
        <actions>
            <name>SF_ISA_Stage</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_ISA_SubStage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Issuer_Acknowledgment_Received__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Prep to Fund</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Retail SS,Specialty Finance - Retail Lottery</value>
        </criteriaItems>
        <description>When Issuer Acknowledgment Received is changed from Null to Not Null And Stage=Prep to Fund, Sub-Stage=Acknowledgment Received</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Pricing%2C Sub-Stage is Pricing Requested%2C Account%3ASales Status is not certain values</fullName>
        <actions>
            <name>change_sales_status_to_pricing_soon</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Lottery Winners,Specialty Finance - SS Annuitants,Specialty Finance - IGT Winners</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Pricing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SubStage__c</field>
            <operation>equals</operation>
            <value>Pricing Requested</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Sales_Status_Person__c</field>
            <operation>notEqual</operation>
            <value>Pricing Soon,Deal In Process,Remarket</value>
        </criteriaItems>
        <description>SF - update account sales status to pricing soon when opportunity enters pricing requested sub status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Pricing%2C Sub-Stage is Pricing Requested%2C Purchase Price to Customer is not empty</fullName>
        <actions>
            <name>pricing_to_customer_stage_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Lottery Winners,Specialty Finance - SS Annuitants,Specialty Finance - IGT Winners</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Purchase_Price_to_Customer__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Pricing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SubStage__c</field>
            <operation>equals</operation>
            <value>Pricing Requested</value>
        </criteriaItems>
        <description>SF - change opportunity sub stage to pricing provided to customer when net pricing provided to customer field is populated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Submission and Closing Binder Received is not empty</fullName>
        <actions>
            <name>SF_ClosingBinderRec_SS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_ClosingBinderRec_Stage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Closing_Binder_Received__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Wholesale SS,Specialty Finance - Wholesale Lottery</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Submission</value>
        </criteriaItems>
        <description>SF - when Closing Binder Received Received is changed from Null to Not Null and Stage = Submission: update Stage=Closing Binder Received &amp; Sub-Stage=Closing Binder Received</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Stage is Terminated</fullName>
        <actions>
            <name>change_SF_sales_status_to_rel_estb_d</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Retail SS,Specialty Finance - Retail Lottery,Specialty Finance - Retail IGT</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Terminated</value>
        </criteriaItems>
        <description>SF - change SF account sales status back to relationship established when an opportunity terminates</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Sub-Stage is Doc Request Submitted</fullName>
        <actions>
            <name>SF_FVR_Request_EmailAlert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SF_document_request_email_alert_to_the_processing_counsel</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Doc_Request_Submitted_Task</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>FVR_Request_Doc_Request</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Retail SS,Specialty Finance - Retail Lottery</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SubStage__c</field>
            <operation>equals</operation>
            <value>Doc Request Submitted</value>
        </criteriaItems>
        <description>SF - Create tasks when Doc Request substage = doc request submitted; email alerts</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Wholesale - Always run</fullName>
        <actions>
            <name>Update_EffectiveToBroker</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Wholesale SS,Specialty Finance - Wholesale Lottery</value>
        </criteriaItems>
        <description>SF - When Effective Rate to Broker is changed; Set (hidden field) BofI Effective Rate = Effective Rate to Broker</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Wholesale - Purchase Price to Broker is changed</fullName>
        <actions>
            <name>Update_PriceToBroker</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SF - When Purchase Price to Broker is changed; Set (hidden field) BofI Purchase Price = Purchase Price to Broker (needs to populate from BofI Purchase Price)</description>
        <formula>AND(  OR(   RecordType.DeveloperName = &apos;Specialty_Finance_Wholesale&apos;,   RecordType.DeveloperName = &apos;Specialty_Finance_Wholesale_Lottery&apos;  ),  ISCHANGED(Purchase_Price_to_Broker__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2 Opportunity Name from Lead</fullName>
        <actions>
            <name>Update_Opp_NameSFDC2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Takes the mapped field from lead &quot;Opportunity Name Holder&quot; and updates the Opportunity name if there was one entered in.</description>
        <formula>AND(     SFDC2__c ,     NOT(ISBLANK( Opportunity_Name_HolderSFDC2__c )) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2 Update Advisor Firm Opportunity Record Type</fullName>
        <actions>
            <name>Advisor_Firm</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Lead_RT_SFDC2__c</field>
            <operation>equals</operation>
            <value>Advisor Firm SFDC2</value>
        </criteriaItems>
        <description>Handles the update of the Opportunity record type for Advisor Firm on Lead Conversion</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2 Update Business Banking Opportunity Record Type</fullName>
        <actions>
            <name>BB_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Lead_RT_SFDC2__c</field>
            <operation>equals</operation>
            <value>Business Banking SFDC2</value>
        </criteriaItems>
        <description>Handles the update of the Opportunity record type for Business Banking on Lead Conversion</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2 Update C%26I Opportunity Record Type  Factoring SFDC2</fullName>
        <actions>
            <name>Update_RT_Factoring_C_I_SFDC2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  Lead_RT_SFDC2__c  = &quot;C&amp;I SFDC2&quot;,   ISPICKVAL(Sub_Branch_sfdc2__c , &quot;Factoring&quot; ) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2 Update C%26I Opportunity Record Type  NRELF SFDC2</fullName>
        <actions>
            <name>Update_RT_NRELF_SFDC2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  Lead_RT_SFDC2__c  = &quot;C&amp;I SFDC2&quot;,   ISPICKVAL(Sub_Branch_sfdc2__c , &quot;NRELF&quot; ) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2 Update C%26I Opportunity Record Type  RELF SFDC2</fullName>
        <actions>
            <name>Update_RT_RELF_SFDC2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  Lead_RT_SFDC2__c  = &quot;C&amp;I SFDC2&quot;,   ISPICKVAL(Sub_Branch_sfdc2__c , &quot;RELF&quot; ) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2 Update C%26I Opportunity Record Type CRESL SFDC2</fullName>
        <actions>
            <name>Update_RT_LF_CRESL_C_I_SFDC2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  Lead_RT_SFDC2__c  = &quot;C&amp;I SFDC2&quot;,   ISPICKVAL(Sub_Branch_sfdc2__c , &quot;CRESL&quot; ) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2 Update C%26I Opportunity Record Type EQF SFDC2</fullName>
        <actions>
            <name>SFDC2_Updated_C_I_EQF</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  Lead_RT_SFDC2__c  = &quot;C&amp;I SFDC2&quot;,   ISPICKVAL(Sub_Branch_sfdc2__c , &quot;EQF&quot; ) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2 Update Commercial Banking SFDC2 Opportunity Record Type</fullName>
        <actions>
            <name>SFDC2_Update_Commercial_Banking_SFDC2_Op</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CI_Record_Type_Lead_Conversion_Workflow__c</field>
            <operation>equals</operation>
            <value>Commercial Banking SFDC2</value>
        </criteriaItems>
        <description>SFDC2 Update Commercial Banking SFDC2 Opportunity Record Type</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2 Update Consumer Deposits Opportunity Record Type</fullName>
        <actions>
            <name>Consumer_Deposits_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Lead_RT_SFDC2__c</field>
            <operation>equals</operation>
            <value>Consumer Deposits SFDC2</value>
        </criteriaItems>
        <description>Handles the update of the Opportunity record type for Consumer Deposits on Lead Conversion</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2 Update ConsumerWholesale Opportunity Record Type</fullName>
        <actions>
            <name>CW_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Lead_RT_SFDC2__c</field>
            <operation>equals</operation>
            <value>Consumer Wholesale SFDC2</value>
        </criteriaItems>
        <description>Handles the update of the Opportunity record type for ConsumerWholesale on Lead Conversion</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2 Update DAL Opportunity Record Type</fullName>
        <actions>
            <name>SFDC2_DAL_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Lead_RT_SFDC2__c</field>
            <operation>equals</operation>
            <value>Dealer Services - Applicant SFDC2</value>
        </criteriaItems>
        <description>Handles the update of the Opportunity record type for DAL on Lead Conversion</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2 Update Dealer Services Opportunity Record Type</fullName>
        <actions>
            <name>Dealer_Recruiting_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Lead_RT_SFDC2__c</field>
            <operation>equals</operation>
            <value>Dealer Services - Dealer SFDC2</value>
        </criteriaItems>
        <description>Handles the update of the Opportunity record type for Dealer Services - Dealer on Lead Conversion</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2 Update Epiq Opportunity Record Type</fullName>
        <actions>
            <name>SFDC2_Epiq_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Lead_RT_SFDC2__c</field>
            <operation>equals</operation>
            <value>Epiq SFDC2</value>
        </criteriaItems>
        <description>Handles the update of the Opportunity record type for Epic on Lead Conversion</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2 Update HBD Opportunity Record Type</fullName>
        <actions>
            <name>SFDC2_Update_HBD_Opportunity_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CI_Record_Type_Lead_Conversion_Workflow__c</field>
            <operation>equals</operation>
            <value>HBD SFDC2</value>
        </criteriaItems>
        <description>Handles the update of the Opportunity record type for HBD on Lead Conversion</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2 Update IPL Opportunity Record Type from C%26I Lead</fullName>
        <actions>
            <name>Update_RT_IPL_SFDC2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Opportunity record type for C&amp;I Lead conversion if sub-ranch is IPL</description>
        <formula>AND( OR(Lead_RT_SFDC2__c  = &quot;C&amp;I SFDC2&quot; ,         Lead_RT_SFDC2__c  = &quot;IPL SFDC2&quot;        ),         ISPICKVAL(Sub_Branch_sfdc2__c , &quot;IPL&quot; ) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2 Update ULP Opportunity Record Type</fullName>
        <actions>
            <name>SFDC2_ULP_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Lead_RT_SFDC2__c</field>
            <operation>equals</operation>
            <value>ULP SFDC2</value>
        </criteriaItems>
        <description>Handles the update of the Opportunity record type for ULP on Lead Conversion</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2 Update Virtus Opportunity Record Type</fullName>
        <actions>
            <name>Virtus_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Lead_RT_SFDC2__c</field>
            <operation>equals</operation>
            <value>Virtus SFDC2</value>
        </criteriaItems>
        <description>Handles the update of the Opportunity record type for Virtus on Lead Conversion</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2%3A BU Owner Change Count is 3</fullName>
        <actions>
            <name>SFDC2_Opp_BU_Owner_Change_Count_to_0</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SFDC2_Opp_Stage_to_0_Closed_Lost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.SFDC2__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.BU_Owner_Change_Count_SFDC2__c</field>
            <operation>greaterOrEqual</operation>
            <value>3</value>
        </criteriaItems>
        <description>SFDC2 - When the owner change count hits 3, reset to 0 and change Opportunity Stage to 0 - Closed Lost</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2%3A Email to Opportunity Owner when stage change</fullName>
        <actions>
            <name>SFDC2_Email_Notification_to_Opportunity_owner_for_stage_change_to_8</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SFDC2_Opportunity_Owner_email_for_stage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>8 - Boarded/Funded/Won</value>
        </criteriaItems>
        <description>Opportunity owners are notified by email when the stage for their opportunity equals stage 8.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2%3A Loan Amount Updates Amount</fullName>
        <actions>
            <name>SFDC2_copy_Loan_Amount_to_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I opp workflow rule</description>
        <formula>NOT( ISBLANK(CI_Loan_Amount__c  ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2%3A Opportunity No Activity Notification</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.SFDC2__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>notEqual</operation>
            <value>API Service Account</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>1 - New,2 - Attempting Contact,3 - Committed to Complete Application,4 - Application in Progress,5 - Pending Review,6 - Pending Documentation,7 - Approved Unfunded</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Last_Activity_SFDC2__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>equals</operation>
            <value>8/25/2017 3:00 AM</value>
        </criteriaItems>
        <description>Send email to user about inactive opporunity record when in stage 1-7, when the last activity date and last modified date has not changed in 10 or 15 days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Opportunity_No_Activity_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Last_Activity_SFDC2__c</offsetFromField>
            <timeLength>15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Opportunity_No_Activity_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Last_Activity_SFDC2__c</offsetFromField>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Opp_Reassign_to_Queue</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.Last_Activity_SFDC2__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SFDC2%3A Opportunity Set Last Activity</fullName>
        <actions>
            <name>SFDC2_Set_Last_Activity_SFDC2_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.SFDC2__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notContain</operation>
            <value>Marketing,System Administrator,Salesforce</value>
        </criteriaItems>
        <description>Every time the Opportunity record is updated, set the Last Activity SFDC2 field to the current date</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2%3A Owner Changes to API</fullName>
        <actions>
            <name>SFDC2_Opp_Incr_BU_Owner_Change_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC2 - Increments counter field when ownership changes to API Service Account (implies reassignment to opportunity queue)</description>
        <formula>AND( SFDC2__c,  ISCHANGED(OwnerId), Owner.LastName  = &quot;API Service Account&quot; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2%3A Pull Description from Account</fullName>
        <actions>
            <name>Description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Description</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>IPL SFDC2</value>
        </criteriaItems>
        <description>Only for IPL SFDC2 Opps right now</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2%3A Set Opportunity Owner to API Service</fullName>
        <actions>
            <name>SFDC_2_0_Set_Opportunity_Owner_to_API</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.LeadSource</field>
            <operation>equals</operation>
            <value>RMI,Cross-Sell</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Created_from_Lead__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>SFDC 2.0: When an Opportunity is created that meets the criteria, it sets the Opportunity to the API Service Account (trigger handles creation of Opportunity Queue record)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2%3A Set Opportunity Stage from Lead Conversion</fullName>
        <actions>
            <name>SFDC2_Default_Opp_Stage_for_Lead_Conv</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Enterprise User,System Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Created_from_Lead__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sets the Opportunity stage to &quot;1 - New&quot; when it is created from a Lead conversion for SFDC 2 record types</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2%3A Virtus%2FBB Opp Close Date 30 Days Past</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Virtus SFDC2,Business Banking SFDC2</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SFDC2__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>SFDC2 - Ticks the cross-sell checkbox 30 days from when a Virtus or Business Banking opportunity is Closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Opp_Cross_Sell_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SFR%3A Always run</fullName>
        <actions>
            <name>SFR_TPO_IPL_Opportunity_Amount_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>&quot;SFR, TPO, IPL&quot;</value>
        </criteriaItems>
        <description>SFR - Fill native amount field with loan amount for standard reporting</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SFR%3A Lead Type is SFR%2C TPO%2C IPL</fullName>
        <actions>
            <name>Update_Stage_for_Mortgage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Lead_Type__c</field>
            <operation>equals</operation>
            <value>&quot;SFR, TPO, IPL&quot;</value>
        </criteriaItems>
        <description>SFR - Set stage on Lead conversion for SFR, TPO, IPL Record Type</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFR%3A Lead Type is SFR%2C TPO%2C IPL and Created Date is not empty</fullName>
        <actions>
            <name>Set_Record_Type_to_SFR_TPO_IPL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Lead_Type__c</field>
            <operation>equals</operation>
            <value>&quot;SFR, TPO, IPL&quot;</value>
        </criteriaItems>
        <description>SFR - Set the appropriate Record Type based on Lead Type</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WLD%3A Update Proposed Line Amount on Account for Non-Pending Opps</fullName>
        <actions>
            <name>WLD_Reset_Proposed_Line_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>WLD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Status__c</field>
            <operation>notEqual</operation>
            <value>Pending</value>
        </criteriaItems>
        <description>Clears the Proposed Line Amount field on the parent Account when the Opportunity status is  not &quot;Pending&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WLD%3A Update Proposed Line Amount on Account for Pending Opps</fullName>
        <actions>
            <name>WLD_Set_Proposed_Line_Amount_Pending</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the Proposed Line Amount field on the parent Account when the Opportunity status is set to &quot;Pending&quot;</description>
        <formula>RecordType.DeveloperName = &quot;WLD&quot; &amp;&amp; TEXT(Status__c) = &quot;Pending&quot; &amp;&amp; OR(ISCHANGED(Status__c), ISCHANGED(Proposed_Line_Amount__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>C_I_Define_Certification_Requirements</fullName>
        <assignedTo>jbutensky@bofifederalbank.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>The associated Opportunity has been marked as Closed Won. Please ensure the Certification requirements have been defined.</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>C&amp;I - Define Certification Requirements</subject>
    </tasks>
    <tasks>
        <fullName>Doc_Request_Submitted_Task</fullName>
        <assignedTo>abussey@bofi.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Doc Request Submitted</subject>
    </tasks>
    <tasks>
        <fullName>FVR_Request_Doc_Request</fullName>
        <assignedTo>abussey@bofi.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>FVR Request - Doc Request</subject>
    </tasks>
    <tasks>
        <fullName>LOI_Overdue</fullName>
        <assignedTo>bhines@bofi.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>LOI Overdue</subject>
    </tasks>
    <tasks>
        <fullName>LOI_Status_Check_Received_Date_Approaching</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>LOI Status Check/Received Date Approaching</subject>
    </tasks>
    <tasks>
        <fullName>LOI_Status_Check_Received_Date_Approaching_25</fullName>
        <assignedTo>jbutensky@bofifederalbank.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>LOI Status Check/Received Date Approaching</subject>
    </tasks>
    <tasks>
        <fullName>Order_Third_Party_Diligence</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Order Third-Party Diligence</subject>
    </tasks>
    <tasks>
        <fullName>Please_Submit_Pre_LOI_Draft_for_Approval</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please Attach Pre LOI draft and Submit for approval</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Please Submit Pre LOI Draft for Approval</subject>
    </tasks>
    <tasks>
        <fullName>Schedule_Site_Visit</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Schedule Site Visit</subject>
    </tasks>
    <tasks>
        <fullName>Send_Needs_List</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Needs List</subject>
    </tasks>
</Workflow>
