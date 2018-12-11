<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_Moved_TPO_House</fullName>
        <ccEmails>clientrelations@bofi.com</ccEmails>
        <description>Inform seller approval coordinator of account move to TPO House so IHM gets updated</description>
        <protected>false</protected>
        <recipients>
            <recipient>jsingh@bofifederalbank.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ALL/IHM_Update_Needed_Account_Moved_to_TPO_House</template>
    </alerts>
    <alerts>
        <fullName>Account_Moved_to_TPO_House</fullName>
        <description>Account Moved to TPO House</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TPO_Templates/Account_Moved_to_TPO_House</template>
    </alerts>
    <alerts>
        <fullName>Account_in_suspension_for_a_year</fullName>
        <ccEmails>clientrelations@bofi.com</ccEmails>
        <description>Account in suspension for a year</description>
        <protected>false</protected>
        <recipients>
            <recipient>bhines@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jsingh@bofifederalbank.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ALL/X1_Year_in_Suspension</template>
    </alerts>
    <alerts>
        <fullName>Approval_TPO_Account_Change</fullName>
        <description>Approved TPO Account Change</description>
        <protected>false</protected>
        <recipients>
            <field>TPO_House_Account_Approval_Submitter__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TPO_Templates/TPO_Account_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>Approved_TPO_Account_Change_Joleen</fullName>
        <description>Approved TPO Account Change - Joleen</description>
        <protected>false</protected>
        <recipients>
            <recipient>jsingh@bofifederalbank.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TPO_Templates/TPO_Account_Change</template>
    </alerts>
    <alerts>
        <fullName>Client_Re_Certification_Email_New</fullName>
        <ccEmails>clientrelations@bofifederalbank.com</ccEmails>
        <description>Client Re-Certification Email</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <field>Email_Address_TPO_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Email_Address_TPO_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SFR_TPO_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>ALL/Recertification_Email</template>
    </alerts>
    <alerts>
        <fullName>Email_when_TPO_account_needs_approval</fullName>
        <description>Email when TPO account needs approval</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TPO_Templates/TPO_Account_Needs_Approval</template>
    </alerts>
    <alerts>
        <fullName>Lead_Account_Moved_to_TPO_House</fullName>
        <description>Lead Account Moved to TPO House</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TPO_Templates/TPO_Lead_Account_Moved_to_TPO_House</template>
    </alerts>
    <alerts>
        <fullName>Notify_WLD_of_Account_Status_change_from_Active</fullName>
        <description>Notify WLD of Account Status change from Active</description>
        <protected>false</protected>
        <recipients>
            <recipient>csilvius@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>dsullivan@bofifederalbank.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nicole@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rmartini@bofifederalbank.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Warehouse_Lending/Account_Status_Changed_from_Active</template>
    </alerts>
    <alerts>
        <fullName>Reassign_to_TPO_House_Account</fullName>
        <description>Reassignment to TPO House Account</description>
        <protected>false</protected>
        <recipients>
            <recipient>bhines@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>TPO_Templates/Reassign_to_TPO_House_Account</template>
    </alerts>
    <alerts>
        <fullName>Seller_Agreement_Sent_Email</fullName>
        <description>Seller Agreement Sent Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>jsingh@bofifederalbank.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>ALL/SFO_TPO_Approval_Process</template>
    </alerts>
    <alerts>
        <fullName>Seller_Agreement_Sent_Email_to_Client</fullName>
        <description>Seller Agreement Sent Email to Client</description>
        <protected>false</protected>
        <recipients>
            <field>SFR_TPO_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>ALL/Seller_Agreement_Email</template>
    </alerts>
    <alerts>
        <fullName>Send_recertification_email</fullName>
        <ccEmails>clientrelations@bofifederalbank.com</ccEmails>
        <ccEmails>bhines@bofi.com</ccEmails>
        <description>Send recertification email for TPO accounts</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <field>Email_Address_TPO_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Email_Address_TPO_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SFR_TPO_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>TPO_Templates/Second_Notice_TPO_Recertification_Letter</template>
    </alerts>
    <alerts>
        <fullName>TPO_Account_Nearing_Expiration</fullName>
        <description>TPO Account Nearing Expiration</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ALL/Account_Expiration_Notice</template>
    </alerts>
    <alerts>
        <fullName>TPO_Account_Nearing_Suspended_Expiration</fullName>
        <description>TPO Account Nearing Suspended Expiration</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TPO_Templates/TPO_Suspended_Account_Notification</template>
    </alerts>
    <alerts>
        <fullName>TPO_Outside_Sales_Notification_for_CA_FL_NY_NJ</fullName>
        <description>TPO Outside Sales Notification for CA, FL, NY, NJ</description>
        <protected>false</protected>
        <recipients>
            <recipient>TPO_Outside_Sales</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TPO_Templates/TPO_Outside_Sales_Account_Notification</template>
    </alerts>
    <alerts>
        <fullName>TPO_Recertification_First_Notice</fullName>
        <ccEmails>clientrelations@bofi.com</ccEmails>
        <description>TPO Recertification: First Notice</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <field>Email_Address_TPO_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Email_Address_TPO_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SFR_TPO_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>clientrelations@bofi.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>TPO_Templates/TPO_Recertification_Letter</template>
    </alerts>
    <alerts>
        <fullName>TPO_Recertification_Second_Notice</fullName>
        <ccEmails>clientrelations@bofi.com</ccEmails>
        <description>TPO Recertification: Second Notice</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <field>Email_Address_TPO_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Email_Address_TPO_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SFR_TPO_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>clientrelations@bofi.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>TPO_Templates/Second_Notice_TPO_Recertification_Letter</template>
    </alerts>
    <alerts>
        <fullName>TPO_account_needs_to_return_application_to_us</fullName>
        <description>TPO account needs to return application to us</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TPO_Templates/TPO_New_Account_App_Received</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Five9Bypass_is_FALSE</fullName>
        <field>Five9ByPass__c</field>
        <literalValue>0</literalValue>
        <name>Account: Five9Bypass is FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Outbound</fullName>
        <field>OwnerId</field>
        <lookupValue>outboundaccountpool@bofi.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Outbound Account Pool</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Account_Status</fullName>
        <description>Used for Time Dependent workflow. sfr/tpo</description>
        <field>SFR_TPO_IPL_Client_Status__c</field>
        <literalValue>Suspend</literalValue>
        <name>Change Account Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Document_Status_update</fullName>
        <description>Document Status to &quot;Seller Application Received&quot;</description>
        <field>Document_Status__c</field>
        <literalValue>Seller Application Received</literalValue>
        <name>Document Status update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FinAdvStatus</fullName>
        <field>Financial_Advisor_Status__c</field>
        <literalValue>In Pursuit</literalValue>
        <name>FinAdvStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Account_Business_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Business</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Account Business Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Account_Household_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Household</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Account Household Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Account_Individual_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Individual</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Account Individual Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Default_App_to_Counterparty_Report</fullName>
        <description>Update default app to Counterparty Report</description>
        <field>LLC_BI__Default_App__c</field>
        <literalValue>counterparty-report.counterparty-report</literalValue>
        <name>Set Default App to Counterparty Report</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Update_Record_Type_to_Lender</fullName>
        <description>If Account type is &quot;Institutional Investor&quot; or &quot;Financial Institution&quot; update record type to Lender.</description>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Lender</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Lender</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Move_Account_to_TPO_House</fullName>
        <description>Automatically update account to TPO House Account when days until expiration hits 0</description>
        <field>OwnerId</field>
        <lookupValue>tpo@bofiusa.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Move Account to TPO House</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>No_Payment_Remaining_Account_Assignment</fullName>
        <description>Assign to Francisco (formerly Bradley Greer)</description>
        <field>OwnerId</field>
        <lookupValue>fvillasana@bofi.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>No Payment Remaining Account Assignment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OwnerID_Distribution_Date</fullName>
        <description>Field updates the value today for when a new account is reassigned or distributed</description>
        <field>TransDate__c</field>
        <formula>Today()</formula>
        <name>OwnerID_Distribution_Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Person_Last_Researched_Field_Update</fullName>
        <description>Updates Last_Researched_Person__c with LastModifiedDate value</description>
        <field>Last_Researched_Person__c</field>
        <formula>LastModifiedDate</formula>
        <name>Person Last Researched Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Current_Rep_Dials</fullName>
        <description>Sets Current Rep Dials to 0</description>
        <field>Current_Rep_Dials__c</field>
        <formula>0</formula>
        <name>Reset Current Rep Dials</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reviewed_Date_Updated</fullName>
        <description>Used in Approval Process</description>
        <field>Reviewed_Date__c</field>
        <formula>Today()</formula>
        <name>Reviewed Date Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_PA_Phone_field_update_after_LC</fullName>
        <description>PA Phone field update after LC</description>
        <field>PersonHomePhone</field>
        <formula>Phone</formula>
        <name>SFDC2:PA Phone field update after LC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_FVR_Last_Update</fullName>
        <field>FVR_Last_Update__c</field>
        <formula>TODAY()</formula>
        <name>SF FVR Last Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_Last_Researched</fullName>
        <field>Last_Researched_Person__c</field>
        <formula>NOW()</formula>
        <name>SF Last Researched</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_Outbound_Pool</fullName>
        <field>OwnerId</field>
        <lookupValue>outboundaccountpool@bofi.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>SF Outbound Pool</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_Research_Status_Date</fullName>
        <field>Researched_Status_Date_and_Time__c</field>
        <formula>NOW()</formula>
        <name>SF Research Status Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_Research_Status_Set_By</fullName>
        <field>Research_Status_Set_By__c</field>
        <formula>TRIM($User.FirstName + &quot; &quot; + $User.LastName)</formula>
        <name>SF Research Status Set By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_Reset_Email_Bounced</fullName>
        <field>Email_Bounced_Specialty_Finance__c</field>
        <literalValue>0</literalValue>
        <name>SF - Reset Email Bounced</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_Sales_Status_to_Deceased</fullName>
        <description>SF: Sets Sales Status to Deceased</description>
        <field>Sales_Status_Person__c</field>
        <literalValue>Deceased</literalValue>
        <name>SF: Sales Status to Deceased</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_Sales_Status_to_No_Pymts_Remain</fullName>
        <description>SF: Sets Sales Status to No Payments Remaining</description>
        <field>Sales_Status_Person__c</field>
        <literalValue>No Payments Remaining</literalValue>
        <name>SF: Sales Status to No Pymts Remain</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Research_Status_Date_and_Time</fullName>
        <field>Researched_Status_Date_and_Time__c</field>
        <formula>LastModifiedDate</formula>
        <name>Set Research Status Date and Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Research_Status_Set_By</fullName>
        <field>Research_Status_Set_By__c</field>
        <formula>LastModifiedBy.FirstName + &quot; &quot; + LastModifiedBy.LastName</formula>
        <name>Set Research Status Set By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TPO_Account_Recert_Reqd</fullName>
        <field>Document_Status__c</field>
        <literalValue>Recertification Required</literalValue>
        <name>TPO Account Recert Reqd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TPO_BrokerID</fullName>
        <description>Updates the TPO Broker ID with Approval from Seller Coordinator Flow</description>
        <field>TPO_Account_ID__c</field>
        <name>TPO_BrokerID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TPO_House_Account_Approval_Submitter</fullName>
        <description>Sets the email address of the approval submitter</description>
        <field>TPO_House_Account_Approval_Submitter__c</field>
        <formula>$User.Email</formula>
        <name>TPO House Account Approval Submitter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Owner_to_Bradley_Greer</fullName>
        <field>OwnerId</field>
        <lookupValue>dammeraal@bofi.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Account Owner to Bradley Greer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_description</fullName>
        <description>Updates Account description from description container</description>
        <field>Description</field>
        <formula>Description_container__c</formula>
        <name>Update Account description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Documents_Status</fullName>
        <field>Document_Status__c</field>
        <literalValue>Seller Agreement Received</literalValue>
        <name>Update Documents Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Last_Status_Update</fullName>
        <description>Update Last Status Update field</description>
        <field>Last_Status_Update__c</field>
        <formula>Today()</formula>
        <name>Update Last Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Last_Suspension_Date</fullName>
        <description>Change date when account is suspended</description>
        <field>Last_Suspension_Date__c</field>
        <formula>Today()</formula>
        <name>Update Last Suspension Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SFR_TPO_Client_Status</fullName>
        <description>Used in Approval Process</description>
        <field>SFR_TPO_IPL_Client_Status__c</field>
        <literalValue>Denied</literalValue>
        <name>Update SFR/TPO Client Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SFR_TPO_Status</fullName>
        <field>SFR_TPO_IPL_Client_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update SFR/TPO Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>no_contact</fullName>
        <description>change sales status to no contact</description>
        <field>Sales_Status_Person__c</field>
        <literalValue>No Contact</literalValue>
        <name>no_contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account%3A Revert Five9Bypass</fullName>
        <actions>
            <name>Account_Five9Bypass_is_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Five9ByPass__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Enterprise%3A Account update description on creation</fullName>
        <actions>
            <name>Update_Account_description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Description_container__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Enterprise: If a description was mapped over from the Lead Description container field, this will update the account description from the description container field.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Account Set Business Record Type</fullName>
        <actions>
            <name>LLC_BI__Set_Account_Business_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>notEqual</operation>
            <value>Household,Individual,Sole Proprietorship,Financial Institution,Institutional Investor</value>
        </criteriaItems>
        <description>sets Record Type to Business if Account Type is not &quot;Household&quot;, &quot;Sole Proprietorship&quot;, &quot;Institutional Investor&quot;, &quot;Financial Institution&quot; or &quot;Individual&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Account Set Household Record Type</fullName>
        <actions>
            <name>LLC_BI__Set_Account_Household_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Household</value>
        </criteriaItems>
        <description>sets Record Type to Household if Account Type is &quot;Household&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Account Set Individual Record Type</fullName>
        <actions>
            <name>LLC_BI__Set_Account_Individual_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Individual,Sole Proprietorship</value>
        </criteriaItems>
        <description>sets Record Type to Individual if Account Type is &quot;Sole Proprietorship&quot; or &quot;Individual&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Account Set Lender Record Type</fullName>
        <actions>
            <name>LLC_BI__Update_Record_Type_to_Lender</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Financial Institution,Institutional Investor</value>
        </criteriaItems>
        <description>sets Record Type to Lender if Account Type is &quot;Financial Institution&quot; or &quot;Institutional Investor&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Set Default App for Lenders</fullName>
        <actions>
            <name>LLC_BI__Set_Default_App_to_Counterparty_Report</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Lender</value>
        </criteriaItems>
        <description>When Record Type is Lender, set default app to be counterparty report.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Date of Death is populated</fullName>
        <actions>
            <name>SF_Sales_Status_to_Deceased</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>startsWith</operation>
            <value>Specialty Finance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Date_of_Death__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>SF - Triggered when a Date of Death value is populated, sets Sales Status to Deceased</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Face Value Remaining is changed and is not empty</fullName>
        <actions>
            <name>SF_FVR_Last_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SF - Handles when Specialty Finance account has an update to Face Value Remaining</description>
        <formula>AND(  BEGINS(RecordType.DeveloperName, &quot;Specialty&quot;),  OR(    AND(NOT(ISNEW()),ISCHANGED(Face_Value_Remaining__c)),    AND(ISNEW(),NOT(ISBLANK(Face_Value_Remaining__c)))  ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A No Payments Remaining is true</fullName>
        <actions>
            <name>No_Payment_Remaining_Account_Assignment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.No_Payments_Remaining__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>startsWith</operation>
            <value>Specialty Finance</value>
        </criteriaItems>
        <description>SF - No Payments Remaining Account Assignment to Bradley</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A No Payments Remaining set to true</fullName>
        <actions>
            <name>No_Payment_Remaining_Account_Assignment</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_Sales_Status_to_No_Pymts_Remain</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.No_Payments_Remaining__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>startsWith</operation>
            <value>Specialty Finance</value>
        </criteriaItems>
        <description>SF: Triggered when the No Payments Remaining checkbox is ticked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Person Email is changed and Email Bounced Specialty Finance is true</fullName>
        <actions>
            <name>SF_Reset_Email_Bounced</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SF - Person Accounts - when Email field is updated, set the Email Bounced field to False</description>
        <formula>AND(   BEGINS(RecordType.DeveloperName, &quot;Specialty_Finance&quot;),   ISCHANGED(PersonEmail),   Email_Bounced_Specialty_Finance__c = true )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Research Status is Hard to Find and Owner is not Bradley Greer</fullName>
        <actions>
            <name>Update_Account_Owner_to_Bradley_Greer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Research_Status_Person__c</field>
            <operation>equals</operation>
            <value>Hard to Find</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>contains</operation>
            <value>Specialty Finance -</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>notEqual</operation>
            <value>Bradley Greer</value>
        </criteriaItems>
        <description>SF - When field research status is changed to &quot; Hard to Find&quot;, assign account to bradley greer.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Research Status is Needs Research%2C Owner is not Bradley Greer%2C Record Type is not Lottery Winners%2C SS Ann%2C IGT Win</fullName>
        <actions>
            <name>Update_Account_Owner_to_Bradley_Greer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Research_Status_Person__c</field>
            <operation>equals</operation>
            <value>Needs Research</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>contains</operation>
            <value>Specialty Finance -</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Specialty Finance - Lottery Winners,Specialty Finance - SS Annuitants,Specialty Finance - IGT Winners</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>notEqual</operation>
            <value>Bradley Greer</value>
        </criteriaItems>
        <description>SF - When field research status is changed to &quot; needs research&quot;, assign account to bradley greer.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Research Status is New Researched</fullName>
        <actions>
            <name>SF_Last_Researched</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_Research_Status_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SF_Research_Status_Set_By</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Research_Status_Person__c</field>
            <operation>equals</operation>
            <value>New Researched</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>startsWith</operation>
            <value>Specialty Finance</value>
        </criteriaItems>
        <description>SF - Handles when Specialty Finance account Research Status is set to New Researched</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Research Status is New Researched and Total Number of Phone Numbers is greater than 0</fullName>
        <actions>
            <name>SF_Outbound_Pool</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Research_Status_Person__c</field>
            <operation>equals</operation>
            <value>New Researched</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>startsWith</operation>
            <value>Specialty Finance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Total_Number_of_Phone_Number__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>SF - Handles when Specialty Finance account Research Status is set to New Researched and has phone numbers</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Research Status is New Researched and Total Number of Phone Numbers is not 0</fullName>
        <actions>
            <name>Assign_to_Outbound</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Research_Status_Person__c</field>
            <operation>equals</operation>
            <value>New Researched</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>contains</operation>
            <value>Specialty Finance -</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Total_Number_of_Phone_Number__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <description>SF - Account Assignment to Outbound Acct Pool for New Researched Status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Research Status is Wrong Person</fullName>
        <actions>
            <name>Update_Account_Owner_to_Bradley_Greer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Research_Status_Person__c</field>
            <operation>equals</operation>
            <value>Wrong Person</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - IGT Winners,Specialty Finance - Lottery Winners,Specialty Finance - SS Annuitants</value>
        </criteriaItems>
        <description>SF - Reassigns account is &quot;Wrong Person&quot; is selected for Research Status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Sales Status is empty and Last Call Time is not empty</fullName>
        <actions>
            <name>no_contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Specialty Finance - Lottery Winners,Specialty Finance - SS Annuitants,Specialty Finance - IGT Winners</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Sales_Status_Person__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.qbdialer__LastCallTime__pc</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>change sales status from null to no contact when a call attempt did not result in a correct contact</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2%3A Account Phone field update after Lead conversion</fullName>
        <actions>
            <name>SFDC2_PA_Phone_field_update_after_LC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Phone</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Consumer Person Account SFDC2</value>
        </criteriaItems>
        <description>Person Account home Phone field update after Lead conversion</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TPO%3A Branch Expiration Trigger is greater than today</fullName>
        <active>true</active>
        <description>TPO - Move account to TPO House when pending (branch) account timer expires</description>
        <formula>AND(
RecordType.DeveloperName = &quot;TPO_Account&quot;,  Branch_Expiration_Trigger__c &gt;= TODAY())</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Move_Account_to_TPO_House</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.Branch_Expiration_Trigger__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Account_Moved_to_TPO_House</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.Branch_Expiration_Trigger__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TPO%3A Owner is changed</fullName>
        <actions>
            <name>OwnerID_Distribution_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>TPO - Anytime a TPO OwnerID changes; document the change with a timestamp.</description>
        <formula>AND(   ISCHANGED( OwnerId ),   RecordType.DeveloperName = &apos;TPO_Account&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TPO%3A Owner is changed to TPO House Account and Billing State in CA%2C FL%2C NY%2C NJ</fullName>
        <actions>
            <name>TPO_Outside_Sales_Notification_for_CA_FL_NY_NJ</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>TPO - When an Account is created or updated so that the owner is TPO House Account and the Billing State is in CA, FL, NY, or NJ, send an email notification to the TPO Outside Sales role members</description>
        <formula>AND(ISCHANGED(OwnerId), OwnerId = &apos;005i0000003922D&apos;, OR(   BillingState = &apos;CA&apos;,   BillingState = &apos;FL&apos;,   BillingState = &apos;NY&apos;,   BillingState = &apos;NJ&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TPO%3A Recertification Email Reminder is today</fullName>
        <actions>
            <name>Send_recertification_email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Recertification_Email_Reminder__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>TPO - Deliver Recertification Emails for TPO accounts (Deactivated between uses)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TPO%3A SFR%2C TPO%2C IPL Client Status is Application Received</fullName>
        <actions>
            <name>Document_Status_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.SFR_TPO_IPL_Client_Status__c</field>
            <operation>equals</operation>
            <value>Application Received</value>
        </criteriaItems>
        <description>TPO - Update Document Status to &quot;Seller Application Received&quot; when the SFR, TPO, IPL Client Status field is changed at any point to &apos;Application Received&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TPO%3A SFR%2C TPO%2C IPL Client Status is Approved and Reviewed Date is greater than 300 days ago</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.Reviewed_Date__c</field>
            <operation>greaterOrEqual</operation>
            <value>300 DAYS AGO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>TPO Account</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.SFR_TPO_IPL_Client_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>TPO - Recertification Email: First Notification; Sends email notification 10 months after Reviewed Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>TPO_Recertification_First_Notice</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.Reviewed_Date__c</offsetFromField>
            <timeLength>300</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TPO%3A SFR%2C TPO%2C IPL Client Status is Approved and Reviewed Date is greater than 330 days ago</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.Reviewed_Date__c</field>
            <operation>greaterOrEqual</operation>
            <value>330 DAYS AGO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>TPO Account</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.SFR_TPO_IPL_Client_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>TPO - Recertification Email: Second Notification; Sends email notification 11 months after Reviewed Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>TPO_Recertification_Second_Notice</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.Reviewed_Date__c</offsetFromField>
            <timeLength>330</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TPO%3A SFR%2C TPO%2C IPL Client Status is Denied and NMLSID is not empty</fullName>
        <actions>
            <name>Move_Account_to_TPO_House</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>TPO - Move an account to TPO House when it is marked as Denied status</description>
        <formula>ISPICKVAL(SFR_TPO_IPL_Client_Status__c,&quot;Denied&quot;)
&amp;&amp; NOT(ISBLANK(NMLSID__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TPO%3A SFR%2C TPO%2C IPL Client Status is Pending%2FSeller App Sent%2C NMLSID is not empty%2C Branch Expiration Trigger %3E toda</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.SFR_TPO_IPL_Client_Status__c</field>
            <operation>equals</operation>
            <value>Pending/Seller App Sent</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.NMLSID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Branch_Expiration_Trigger__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>TPO Account</value>
        </criteriaItems>
        <description>TPO - Need TPO seller application returned to us</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>TPO_account_needs_to_return_application_to_us</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.Branch_Expiration_Trigger__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TPO%3A SFR%2C TPO%2C IPL Client Status is Suspended</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.SFR_TPO_IPL_Client_Status__c</field>
            <operation>equals</operation>
            <value>Suspended</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>TPO Account</value>
        </criteriaItems>
        <description>TPO - Move 1 year suspended account to denied</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Account_in_suspension_for_a_year</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.Last_Suspension_Date__c</offsetFromField>
            <timeLength>365</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TPO%3A SFR%2C TPO%2C IPL Client Status is changed to Suspended</fullName>
        <actions>
            <name>Update_Last_Suspension_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>TPO - Update Last Suspension Date when status changed to Suspended</description>
        <formula>AND(IsChanged(SFR_TPO_IPL_Client_Status__c),IsPickVal(SFR_TPO_IPL_Client_Status__c,&quot;Suspended&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TPO%3A SFR%2C TPO%2C IPL Client Status is changed to Suspended and Reviewed Date is not empty</fullName>
        <actions>
            <name>TPO_Account_Recert_Reqd</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>TPO - When the TPO account&apos;s Reviewed Date field is not NULL AND The SFR, TPO, IPL Client Status changes to &apos;Suspended&apos; THEN Update the Document Status to &apos;Recertification Required&apos;</description>
        <formula>AND(    RecordType.DeveloperName = &quot;TPO_Account&quot;,    NOT(ISBLANK(Reviewed_Date__c)),    ISCHANGED(SFR_TPO_IPL_Client_Status__c),    TEXT(SFR_TPO_IPL_Client_Status__c) = &quot;Suspended&quot; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TPO%3A Suspended Expiration Trigger is great than today</fullName>
        <active>true</active>
        <description>TPO - Send email to AE when account hits the day of suspended expiration</description>
        <formula>AND( RecordType.DeveloperName = &quot;TPO_Account&quot;,  Suspended_Expiration_Trigger__c &gt;= TODAY())</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>TPO_Account_Nearing_Suspended_Expiration</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Move_Account_to_TPO_House</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.Suspended_Expiration_Trigger__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TPO%3A Suspended Expiration Trigger is great than today %2B 15 days</fullName>
        <active>true</active>
        <description>TPO - Send email to AE when account hits 15 days until suspended expiration</description>
        <formula>AND( RecordType.DeveloperName = &quot;TPO_Account&quot;,  Suspended_Expiration_Trigger__c &gt;= (TODAY() + 15))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>TPO_Account_Nearing_Suspended_Expiration</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.Suspended_Expiration_Trigger__c</offsetFromField>
            <timeLength>-15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TPO%3A Suspended Expiration Trigger is great than today %2B 7 days</fullName>
        <active>true</active>
        <description>TPO - Send email to AE when account hits 7 days until suspended expiration</description>
        <formula>AND( RecordType.DeveloperName = &quot;TPO_Account&quot;,  Suspended_Expiration_Trigger__c &gt;= (TODAY() + 7))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>TPO_Account_Nearing_Suspended_Expiration</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.Suspended_Expiration_Trigger__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TPO%3A TPO Account ID is not empty and SFR%2C TPO%2C IPL Client Status is Application Received</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.SFR_TPO_IPL_Client_Status__c</field>
            <operation>equals</operation>
            <value>Application Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.TPO_Account_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>TPO Account</value>
        </criteriaItems>
        <description>TPO - account has 30 days to get approval</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_when_TPO_account_needs_approval</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.Branch_Expiration_Trigger__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TPO%3A TPO Account ID is not empty and SFR%2C TPO%2C IPL Client Status is changed</fullName>
        <actions>
            <name>Update_Last_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>TPO - Update last status update field when status is changed</description>
        <formula>AND( 
RecordType.DeveloperName = &quot;TPO_Account&quot;, 
OR(IsChanged(SFR_TPO_IPL_Client_Status__c),IsNew()) 
,NOT(IsBlank(TPO_Account_ID__c)) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TPO%3A TPO Account Id is not empty and Account Expiration Trigger is great than today</fullName>
        <active>true</active>
        <description>TPO - Send email to seller approval coordinator when account expires</description>
        <formula>AND(
RecordType.DeveloperName = &quot;TPO_Account&quot;, 
NOT(ISBLANK(TPO_Account_ID__c)), Account_Expiration_Trigger__c &gt;= TODAY())</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Account_Moved_TPO_House</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Move_Account_to_TPO_House</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.Account_Expiration_Trigger__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TPO%3A TPO Account Id is not empty and Account Expiration Trigger is great than today %2B 1 day</fullName>
        <active>true</active>
        <description>TPO - Send email to AE when account hits 1 day until expiration</description>
        <formula>AND(
RecordType.DeveloperName = &quot;TPO_Account&quot;,
NOT(ISBLANK(TPO_Account_ID__c)), Account_Expiration_Trigger__c &gt;= (TODAY() + 1))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Account_Moved_to_TPO_House</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.Account_Expiration_Trigger__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TPO%3A TPO Account Id is not empty and Account Expiration Trigger is great than today %2B 30 days</fullName>
        <active>true</active>
        <description>TPO - Send email to AE when account hits 30 days until expiration</description>
        <formula>AND(
RecordType.DeveloperName = &quot;TPO_Account&quot;, 
NOT(ISBLANK(TPO_Account_ID__c)), Account_Expiration_Trigger__c &gt;= (TODAY() + 30))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>TPO_Account_Nearing_Expiration</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.Account_Expiration_Trigger__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TPO%3A TPO Account Id is not empty and Account Expiration Trigger is great than today %2B 60 days</fullName>
        <active>true</active>
        <description>TPO - Send email to AE when account hits 60 days until expiration</description>
        <formula>AND(
RecordType.DeveloperName = &quot;TPO_Account&quot;, 
NOT(ISBLANK(TPO_Account_ID__c)), Account_Expiration_Trigger__c &gt;= (TODAY() + 60))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>TPO_Account_Nearing_Expiration</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.Account_Expiration_Trigger__c</offsetFromField>
            <timeLength>-60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TPO%3A TPO Account Id is not empty and Account Expiration Trigger is great than today %2B 90 days</fullName>
        <active>true</active>
        <description>TPO - Send email to AE when account hits 90 days until expiration</description>
        <formula>AND(
RecordType.DeveloperName = &quot;TPO_Account&quot;, 
NOT(ISBLANK(TPO_Account_ID__c)), Account_Expiration_Trigger__c &gt;= (TODAY() + 90))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>TPO_Account_Nearing_Expiration</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.Account_Expiration_Trigger__c</offsetFromField>
            <timeLength>-90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>WLD%3A Account Status changes from Active</fullName>
        <actions>
            <name>Notify_WLD_of_Account_Status_change_from_Active</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Triggers when the Account Status for a WLD account changes from &quot;Active&quot; to a different status.</description>
        <formula>AND(
  RecordType.DeveloperName = &quot;WLD&quot;,
  ISCHANGED( Account_Status__c ),
  PRIORVALUE( Account_Status__c) = &quot;Active&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Approval_Due</fullName>
        <assignedTo>jsingh@bofifederalbank.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Approval Due</subject>
    </tasks>
    <tasks>
        <fullName>Re_Certification_Sent_New</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please Follow up on Re-certification</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Re-Certification Sent</subject>
    </tasks>
    <tasks>
        <fullName>X30_days_until_certification_expires</fullName>
        <assignedToType>owner</assignedToType>
        <description>Only 30 days until account certification expires.  Please follow up immediately</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>30 days until certification expires</subject>
    </tasks>
    <tasks>
        <fullName>X60_Days_until_Certification_Expiration</fullName>
        <assignedToType>owner</assignedToType>
        <description>60 Days until account Certification expires.  Please follow up immediately.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>60 Days until Certification Expiration</subject>
    </tasks>
</Workflow>
