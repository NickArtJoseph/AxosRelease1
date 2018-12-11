<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_RMI_Virtus_Lead</fullName>
        <ccEmails>customerservice@virtusbank.com</ccEmails>
        <description>New RMI Virtus Lead</description>
        <protected>false</protected>
        <senderAddress>noreply@bankofinternet.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Auto_Responses/New_RMI_Virtus_Lead</template>
    </alerts>
    <alerts>
        <fullName>SFDC2_Lead_No_Activity_Notification</fullName>
        <description>SFDC2: Lead No Activity Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC2_Enterprise_Templates/SFDC2_Lead_Record_No_Activity</template>
    </alerts>
    <fieldUpdates>
        <fullName>Assignment_Business_Banking_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Business_Banking_Lead_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assignment: Business Banking Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assignment_Consumer_Deposit_Queue</fullName>
        <description>Consumer Deposits - RMI - Queue</description>
        <field>OwnerId</field>
        <lookupValue>Consumer_Deposits_Lead_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assignment: Consumer Deposit Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assignment_Virtus_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Virtus_Lead_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assignment: Virtus Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Association_NULL</fullName>
        <field>Association__c</field>
        <name>Association: NULL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CD_Lead_Incr_Number_Calls</fullName>
        <field>Leads_Number_of_Calls__c</field>
        <formula>Leads_Number_of_Calls__c + 1</formula>
        <name>CD - Lead - Incr Number Calls</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cap_IQ_Lead_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CI_Bridge</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Cap IQ - Lead Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Consumer_Deposits_Clear_Company_Field</fullName>
        <field>Company</field>
        <name>Consumer Deposits - Clear Company Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Consumer_Deposits_Set_Campaign_Field</fullName>
        <field>CD_Campaign__c</field>
        <formula>Company</formula>
        <name>Consumer Deposits - Set Campaign Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deposits_Lead_Status_Update</fullName>
        <description>This will trigger the lead status to change from New Unassigned to New Assigned</description>
        <field>Status</field>
        <literalValue>New Assigned</literalValue>
        <name>Deposits Lead Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Advisors_Tick_Checkbox</fullName>
        <description>Ticks the Financial Advisor checkbox for Leads</description>
        <field>Financial_Advisor__c</field>
        <literalValue>1</literalValue>
        <name>Financial Advisors - Tick Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Five9_Add_List_ID_a2i0H000001xuib</fullName>
        <field>Add_to_f9list_id__c</field>
        <formula>&quot;a2i0H000001xuib&quot;</formula>
        <name>Five9: Add List ID a2i0H000001xuib</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Five9_Remove_List_ID_a2i0H000001xuib</fullName>
        <field>Delete_from_f9list_id__c</field>
        <formula>&quot;a2i0H000001xuib&quot;</formula>
        <name>Five9: Remove List ID a2i0H000001xuib</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPL_2_0_Populate_Broker_Email</fullName>
        <field>Broker_Email__c</field>
        <formula>Broker_Name_SFDC2__r.Email</formula>
        <name>IPL 2.0: Populate Broker Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPL_2_0_Populate_Broker_Phone</fullName>
        <field>Broker_Phone__c</field>
        <formula>IF(ISBLANK(Broker_Name_SFDC2__r.MobilePhone), 
IF(ISBLANK( Broker_Name_SFDC2__r.HomePhone),Broker_Company_SFDC2__r.Phone, Broker_Name_SFDC2__r.HomePhone)
, Broker_Name_SFDC2__r.MobilePhone)</formula>
        <name>IPL 2.0: Populate Broker Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPL_2_0_Pre_fill_the_company_Field</fullName>
        <field>Company</field>
        <formula>Broker_Company_SFDC2__r.Name</formula>
        <name>IPL 2.0: Pre-fill the company Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Company_Name_Fname_Lname</fullName>
        <description>Populate the Company with the Leads Full Name</description>
        <field>Company</field>
        <formula>FirstName &amp; &quot; &quot; &amp; LastName</formula>
        <name>Lead: Company Name = Fname &amp; Lname</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Source_Web_RMI</fullName>
        <field>LeadSource</field>
        <literalValue>Web RMI</literalValue>
        <name>Lead Source: Web RMI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Status_New</fullName>
        <description>Change Lead Status to &quot;New&quot;</description>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>Lead Status: New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Type_BB_Lead</fullName>
        <field>Lead_Type__c</field>
        <literalValue>Business Banking</literalValue>
        <name>Lead Type = BB Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Type_FA</fullName>
        <field>Lead_Type__c</field>
        <literalValue>Advisor Firm</literalValue>
        <name>Lead Type = FA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Type_SFR_TPO_IPL</fullName>
        <field>Lead_Type__c</field>
        <literalValue>SFR, TPO, IPL</literalValue>
        <name>Lead Type = SFR,TPO,IPL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_update_description_container</fullName>
        <description>Updates the description container field for field conversion mapping</description>
        <field>Description_container__c</field>
        <formula>Description</formula>
        <name>Lead update description container</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Other_Lead_Source_Original_Lead_Source</fullName>
        <field>Other_Lead_Source__c</field>
        <formula>IF(CONTAINS( Web_Source__c , &quot;www.bankofinternet.com&quot;), &quot;RMI-BankOfInternetUSA&quot;,
IF(CONTAINS( Web_Source__c , &quot;60-month-cd&quot;),&quot;RMI-BankOfInternetUSA-60MonthCD&quot;,
IF(CONTAINS( Web_Source__c , &quot;first-checking&quot;),&quot;RMI-BankOfInternetUSA-FirstChecking&quot;,
IF(CONTAINS( Web_Source__c , &quot;rewards-&quot;),&quot;RMI-BankOfInternetUSA-RewardsChecking&quot;,
IF(CONTAINS( Web_Source__c , &quot;essential-checking&quot;),&quot;RMI-BankOfInternetUSA-EssentialChecking&quot;,
IF(CONTAINS( Web_Source__c , &quot;www.bankx.com&quot;),&quot;RMI-Bankx&quot;,
IF(CONTAINS( Web_Source__c , &quot;ufbdirect.com&quot;),&quot;RMI-UFBDirect&quot;,
IF(CONTAINS( Web_Source__c , &quot;personal-banking&quot;),&quot;RMI-HRB&quot;
,&quot;&quot;))))))))</formula>
        <name>Other Lead Source: Original Lead Source</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Other_Lead_Source_Virtus_formula</fullName>
        <field>Other_Lead_Source__c</field>
        <formula>IF( CONTAINS( Web_Source__c , &quot;fb&quot;), &quot;Virtus Bank Landing Page - Facebook&quot;, &quot;RMI-Virtus&quot;)</formula>
        <name>Other Lead Source: Virtus formula</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Lead_BU_Owner_Change_Count_to_0</fullName>
        <description>SFDC2 - resets counter to 0</description>
        <field>BU_Owner_Change_Count_SFDC2__c</field>
        <formula>0</formula>
        <name>SFDC2: Lead BU Owner Change Count to 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Lead_Incr_BU_Owner_Change_Count</fullName>
        <description>SFDC2: Increments counter when lead ownership changes to queue</description>
        <field>BU_Owner_Change_Count_SFDC2__c</field>
        <formula>BU_Owner_Change_Count_SFDC2__c + 1</formula>
        <name>SFDC2: Lead Incr BU Owner Change Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Lead_Reassign_to_Queue</fullName>
        <description>Ticks checkbox to indicate Lead needs to be reassigned to business lead queue</description>
        <field>Reassign_To_Queue_SFDC2__c</field>
        <literalValue>1</literalValue>
        <name>SFDC2: Lead Reassign to Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Lead_Status_to_Inactive</fullName>
        <description>SFDC2 - Sets Lead Status to Inactive</description>
        <field>Status</field>
        <literalValue>Inactive</literalValue>
        <name>SFDC2: Lead Status to Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Set_Last_Activity_SFDC2_Lead</fullName>
        <description>Sets the Lead Last Activity SFDC2 field to the current date</description>
        <field>Last_Activity_SFDC2__c</field>
        <formula>TODAY()</formula>
        <name>SFDC2: Set Last Activity SFDC2 Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Set_Lead_RT</fullName>
        <description>Sets the Lead RT field when the record type changes</description>
        <field>Lead_RT_SFDC2__c</field>
        <formula>RecordType.Name</formula>
        <name>SFDC2: Set Lead RT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Transform_Consumer_Deposit_Lead</fullName>
        <description>Consumer Deposit -&gt; Consumer Deposit 2.0</description>
        <field>RecordTypeId</field>
        <lookupValue>Consumer_Deposits_SFDC2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SFDC2: Transform Consumer Deposit Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Transform_Vitrus_Consumer</fullName>
        <description>Virtus Customer Lead -&gt; Virtus 2.0</description>
        <field>RecordTypeId</field>
        <lookupValue>Virtus_SFDC2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SFDC2: Transform Vitrus Consumer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_WebToLead_default_Status</fullName>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>SF: WebToLead default Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Records_Type_BB2</fullName>
        <description>Update Record type to Business Banking 2.0</description>
        <field>RecordTypeId</field>
        <lookupValue>Business_Banking_SFDC2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Records Type: BB2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Actual_Funding</fullName>
        <apiVersion>30.0</apiVersion>
        <description>Funds guaranteed
(Using Total Contract Value KPI field in Inside Sales)</description>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/bookings</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>api@bofi.com</integrationUser>
        <name>Actual Funding</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>IPL_REOS_Integration</fullName>
        <apiVersion>30.0</apiVersion>
        <endpointUrl>https://dev.bofi.com/iplreosintegration</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>api@bofi.com</integrationUser>
        <name>IPL REOS Integration</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
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
        <fullName>Potential_Funding</fullName>
        <apiVersion>30.0</apiVersion>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/annual_con_val</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>api@bofi.com</integrationUser>
        <name>Potential Funding</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>BB%3A Actual Funding not 0</fullName>
        <actions>
            <name>Actual_Funding</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Actual_Funding__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Business Banking,Advisor Firm,Virtus Business Lead,Virtus Customer Lead</value>
        </criteriaItems>
        <description>Business Banking - Tracks the actual funding of Business Banking within InsideSales; based on Lead Record Type being one of Business Banking, Advisor, or Virtus Business/Customer</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BB%3A Potential Funding not 0</fullName>
        <actions>
            <name>Potential_Funding</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Potential_Funding__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Business Banking,Advisor Firm,Virtus Business Lead,Virtus Customer Lead</value>
        </criteriaItems>
        <description>Business Banking - Tracks the potential funding of Business Banking within Inside Sales; based on Lead Record Type being one of Business Banking, Advisor, or Virtus Business/Customer</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BB%3A Record Type is Advisor Firm</fullName>
        <actions>
            <name>Financial_Advisors_Tick_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Advisor Firm</value>
        </criteriaItems>
        <description>BB - When a new Financial Advisors Lead is created, autopopulate the &quot;Financial Advisor&quot; checkbox with a tick</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>BB%3A Record Type is Advisor Firm and Created Date is not empty</fullName>
        <actions>
            <name>Lead_Type_FA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Advisor Firm</value>
        </criteriaItems>
        <description>BB - Populate Lead Type from the Record Type</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BB%3A Record Type is Business Banking and Created Date is not empty</fullName>
        <actions>
            <name>Lead_Type_BB_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Business Banking</value>
        </criteriaItems>
        <description>BB - Populate Lead Type from the Record Type</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A S%26P Capital IQ Person ID is not empty</fullName>
        <actions>
            <name>Cap_IQ_Lead_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.SNPCAPIQ__CapitalIQPersonID_txt__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>C&amp;I - For Leads created by Capital IQ app, set the record type to C&amp;I - General [Support Ticket #]</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CD%3A Company is not empty</fullName>
        <actions>
            <name>Consumer_Deposits_Clear_Company_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Consumer_Deposits_Set_Campaign_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Consumer Deposits</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Company</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>CD - When a new Consumer Deposits Lead is created that contains a value in the Company field, move that value to the Campaign field and then clear out the Company field</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CD%3A Increment Call Count</fullName>
        <actions>
            <name>CD_Lead_Incr_Number_Calls</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CD - Increments the &quot;Lead - Number of Calls&quot; field if criteria is met</description>
        <formula>AND(
   ISCHANGED(Status),
   DATEVALUE(CreatedDate) &gt;= DATE(2016,4,7),   NOT(ISNEW()),   RecordType.DeveloperName = &quot;Consumer_Deposits&quot;,   OR(     AND(ISPICKVAL(PRIORVALUE(Status),&quot;New Assigned&quot;),         NOT(ISPICKVAL(Status,&quot;Attempt 2&quot;)),         NOT(ISPICKVAL(Status,&quot;Attempt 3-Voicemail&quot;)),         NOT(ISPICKVAL(Status,&quot;Attempt 4-Not Contacted&quot;)),         NOT(ISPICKVAL(Status,&quot;Not Contacted&quot;))     ),     AND(ISPICKVAL(PRIORVALUE(Status), &quot;Attempt 1&quot;),         NOT(ISPICKVAL(Status,&quot;New Assigned&quot;)),         NOT(ISPICKVAL(Status,&quot;Attempt 3-Voicemail&quot;)),         NOT(ISPICKVAL(Status,&quot;Attempt 4-Not Contacted&quot;)),         NOT(ISPICKVAL(Status,&quot;Not Contacted&quot;))     ),     AND(ISPICKVAL(PRIORVALUE(Status), &quot;Attempt 2&quot;),         NOT(ISPICKVAL(Status,&quot;New Assigned&quot;)),         NOT(ISPICKVAL(Status,&quot;Attempt 1&quot;)),         NOT(ISPICKVAL(Status,&quot;Attempt 4-Not Contacted&quot;)),         NOT(ISPICKVAL(Status,&quot;Not Contacted&quot;))     ),     AND(ISPICKVAL(PRIORVALUE(Status), &quot;Attempt 3-Voicemail&quot;),         NOT(ISPICKVAL(Status,&quot;New Assigned&quot;)),         NOT(ISPICKVAL(Status,&quot;Attempt 1&quot;)),         NOT(ISPICKVAL(Status,&quot;Attempt 2&quot;)),         NOT(ISPICKVAL(Status,&quot;Not Contacted&quot;))     ),     AND(ISPICKVAL(PRIORVALUE(Status), &quot;Contacted- Call Back&quot;),         OR(           ISPICKVAL(Status,&quot;Contacted-Not Interested&quot;),           ISPICKVAL(Status,&quot;Sale Won&quot;),           ISPICKVAL(Status,&quot;Sale Lost&quot;)         )     )   ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CD%3A Lead Status is New Unassigned and Lead Owner Role is not CD Manager</fullName>
        <actions>
            <name>Deposits_Lead_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CD - Reassigning Lead Status from New Unassigned to New Assigned upon these conditions.</description>
        <formula>AND(
  RecordType.DeveloperName = &quot;Consumer_Deposits&quot;,
  ISPICKVAL(Status, &quot;New Unassigned&quot;),
  NOT(Owner:User.UserRole.DeveloperName = &quot;Consumer_Deposits_Manager&quot;)
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CD%3A Lead Status is Sale Won</fullName>
        <actions>
            <name>InsideSales_OppWon_KPI</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Consumer Deposits</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Sale Won</value>
        </criteriaItems>
        <description>CD - This workflow is based on the Consumer Deposits Lead record type and sets the KPI when the Lead Status = Sale Won</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Enterprise%3A Description is changed</fullName>
        <actions>
            <name>Lead_update_description_container</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Enterprise - Description needs to be mapped to Account Description for ticket 60721; update the container field so it can be mapped to a container field on Account. These are needed because the normal fields are standard and unchangeable</description>
        <formula>OR(
  ISNEW(),
  ISCHANGED(Description)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Five9%3A Add to Web RMI list</fullName>
        <actions>
            <name>Five9_Add_List_ID_a2i0H000001xuib</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Five9: Add to Web RMI list</description>
        <formula>AND(OR( ISPICKVAL(Status,&quot;New&quot;), ISPICKVAL(Status,&quot;Attempting to Contact&quot;)),  ISPICKVAL(LeadSource,&quot;Web RMI&quot;), RecordType.Name = &quot;Consumer Deposits SFDC2&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Five9%3A Remove from Web RMI list</fullName>
        <actions>
            <name>Five9_Remove_List_ID_a2i0H000001xuib</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Five9: Remove from Web RMI list
https://bofi.my.salesforce.com/a2i0H000001xuibQAA</description>
        <formula>AND(NOT(OR( ISPICKVAL(Status,&quot;New&quot;), ISPICKVAL(Status,&quot;Attempting to Contact&quot;))), ISPICKVAL(LeadSource,&quot;Web RMI&quot;), RecordType.Name = &quot;Consumer Deposits SFDC2&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IPL 2%2E0%3A Pre-fill the Broker Company Fields</fullName>
        <actions>
            <name>IPL_2_0_Pre_fill_the_company_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Takes the Broker Company and fills in the company field</description>
        <formula>AND( NOT(ISBLANK(Broker_Company_SFDC2__c )), NOT(BrokerLead__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IPL 2%2E0%3A Pre-fill the Broker Data fields</fullName>
        <actions>
            <name>IPL_2_0_Populate_Broker_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>IPL_2_0_Populate_Broker_Phone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>IPL 2.0: Pre-fill the Broker Data fields</description>
        <formula>AND( NOT( ISBLANK(Broker_Name_SFDC2__c )), NOT(BrokerLead__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead_IPL_Populate Company when Direct%2FBroker</fullName>
        <actions>
            <name>Lead_Company_Name_Fname_Lname</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.IPL_Channel_SFDC2__c</field>
            <operation>equals</operation>
            <value>Direct,Broker is Customer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Company</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Will populate the company name when the IPL Channel is Direct or Broker is customer
AND Company is Blank</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SF%3A Is Web2Lead is true</fullName>
        <actions>
            <name>SF_WebToLead_default_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>contains</operation>
            <value>Specialty Finance</value>
        </criteriaItems>
        <description>SF - Sets the Lead Status to &quot;New&quot; when a lead record is created for Specialty Finance through web-to-lead functionality</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2%3A BU Owner Change Count is 3</fullName>
        <actions>
            <name>SFDC2_Lead_BU_Owner_Change_Count_to_0</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SFDC2_Lead_Status_to_Inactive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.SFDC2__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.BU_Owner_Change_Count_SFDC2__c</field>
            <operation>greaterOrEqual</operation>
            <value>3</value>
        </criteriaItems>
        <description>SFDC2 - When the owner change count hits 3, reset to 0 and change Lead Status to Inactive</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2%3A Lead No Activity Notification</fullName>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>Lead.SFDC2__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
            <value>API Service Account</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.IsConverted</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>notEqual</operation>
            <value>Contacted/Converted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Last_Activity_SFDC2__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedDate</field>
            <operation>greaterOrEqual</operation>
            <value>8/25/2017 3:00 AM</value>
        </criteriaItems>
        <description>Send email to user about inactive lead record when not converted, when the last activity date and last modified date has not changed in 10 or 15 days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Lead_No_Activity_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Lead.Last_Activity_SFDC2__c</offsetFromField>
            <timeLength>15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Lead_Reassign_to_Queue</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Lead.Last_Activity_SFDC2__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Lead_No_Activity_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Lead.Last_Activity_SFDC2__c</offsetFromField>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SFDC2%3A Lead Set Last Activity</fullName>
        <actions>
            <name>SFDC2_Set_Last_Activity_SFDC2_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.SFDC2__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notContain</operation>
            <value>Marketing,System Administrator,Salesforce</value>
        </criteriaItems>
        <description>Every time the Lead record is updated, set the Last Activity SFDC2 field to the current date</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2%3A Lead Set RT</fullName>
        <actions>
            <name>SFDC2_Set_Lead_RT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Every time the Lead record type is updated, set the Lead RT field</description>
        <formula>AND(   SFDC2__c,   ISCHANGED(RecordTypeId) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2%3A Owner changes to Queue</fullName>
        <actions>
            <name>SFDC2_Lead_Incr_BU_Owner_Change_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Increments counter field when ownership changes to lead queue</description>
        <formula>AND( SFDC2__c,  !ISBLANK(Owner:Queue.Id), ISCHANGED(OwnerId) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2%3A Transform Business Banking Lead</fullName>
        <actions>
            <name>Assignment_Business_Banking_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Association_NULL</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Source_Web_RMI</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Status_New</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Other_Lead_Source_Original_Lead_Source</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Records_Type_BB2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(RecordType.DeveloperName = &quot;Business_Banking&quot;, CreatedById = &quot;005i0000001wnZb&quot;, OR(CONTAINS(TEXT( LeadSource ),&quot;Web&quot;),CONTAINS(TEXT( LeadSource ),&quot;RMI&quot;)) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2%3A Transform Consumer Deposit Lead</fullName>
        <actions>
            <name>Assignment_Consumer_Deposit_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Association_NULL</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Five9_Add_List_ID_a2i0H000001xuib</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Source_Web_RMI</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Status_New</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Other_Lead_Source_Original_Lead_Source</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SFDC2_Transform_Consumer_Deposit_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(RecordType.DeveloperName = &quot;Consumer_Deposits&quot;, CreatedById = &quot;005i0000001wnZb&quot;,OR(CONTAINS(TEXT( LeadSource ),&quot;Web&quot;),CONTAINS(TEXT( LeadSource ),&quot;RMI&quot;)))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2%3A Transform Vitrus Consumer</fullName>
        <actions>
            <name>Assignment_Virtus_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Association_NULL</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Source_Web_RMI</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Status_New</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Other_Lead_Source_Virtus_formula</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SFDC2_Transform_Vitrus_Consumer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(RecordType.DeveloperName = &quot;Virtus_Customer_Lead&quot;, CreatedById = &quot;005i0000001wnZb&quot;, OR(CONTAINS(TEXT( LeadSource ),&quot;Web&quot;),CONTAINS(TEXT( LeadSource ),&quot;Facebook&quot;),CONTAINS(TEXT( LeadSource ),&quot;RMI&quot;)))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFR%3A Created Date is not empty</fullName>
        <actions>
            <name>Contact_Lead</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>&quot;SFR, TPO, IPL&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>SFR - Reminder to contact Lead within 2 days.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SFR%3A Record Type is SFR%2C TPO%2C IPL and Created Date is not empty</fullName>
        <actions>
            <name>Lead_Type_SFR_TPO_IPL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>&quot;SFR, TPO, IPL&quot;</value>
        </criteriaItems>
        <description>SFR - Populate Lead Type from the Record Type</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Virtus Lead Creation Notification</fullName>
        <actions>
            <name>New_RMI_Virtus_Lead</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Virtus Lead Queue</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Contact_Lead</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Contact Lead</subject>
    </tasks>
</Workflow>
