<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SFDC2_Email_notification_to_opportunity_owner_when_account_is_funded</fullName>
        <description>SFDC2:Email notification to opportunity owner when account is funded</description>
        <protected>false</protected>
        <recipients>
            <field>Opportunity_Owner_Email_SFDC2__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC2_Enterprise_Templates/SFDC2_Email_to_Opportunity_Owner</template>
    </alerts>
    <fieldUpdates>
        <fullName>SFDC2_Tick_CampaignAutomationTrigger</fullName>
        <field>CampaignAutomationTriggerSFDC2__c</field>
        <literalValue>1</literalValue>
        <name>SFDC2: Tick CampaignAutomationTrigger</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Update_Opportunity_Owner_Email</fullName>
        <field>Opportunity_Owner_Email_SFDC2__c</field>
        <formula>Opportunity__r.Owner.Email</formula>
        <name>SFDC2:Update Opportunity Owner  Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SFDC2%3A Campaign Automation - CD Maturity</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Maturity_Date__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Product_Class__c</field>
            <operation>equals</operation>
            <value>CD</value>
        </criteriaItems>
        <description>Time-based workflow that triggers based on Maturity Date for Campaign automation</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Tick_CampaignAutomationTrigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Financial_Account_SFDC2__c.Maturity_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Tick_CampaignAutomationTrigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Financial_Account_SFDC2__c.Maturity_Date__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SFDC2%3A Campaign Automation - No Sig</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Open_Date__c</field>
            <operation>greaterOrEqual</operation>
            <value>LAST 60 DAYS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Open_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>LAST 30 DAYS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Department__c</field>
            <operation>equals</operation>
            <value>Consumer Deposits</value>
        </criteriaItems>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Signature_Card_Received__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Time-based workflow that triggers based on Open Date/No Signature for Campaign automation</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Tick_CampaignAutomationTrigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Financial_Account_SFDC2__c.Open_Date__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Tick_CampaignAutomationTrigger</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>61</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Tick_CampaignAutomationTrigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Financial_Account_SFDC2__c.Open_Date__c</offsetFromField>
            <timeLength>46</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Tick_CampaignAutomationTrigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Financial_Account_SFDC2__c.Open_Date__c</offsetFromField>
            <timeLength>45</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SFDC2%3A Campaign Automation - Unfunded</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Open_Date__c</field>
            <operation>greaterOrEqual</operation>
            <value>LAST 60 DAYS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Open_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>LAST 10 DAYS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Department__c</field>
            <operation>equals</operation>
            <value>Consumer Deposits</value>
        </criteriaItems>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Funding_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Time-based workflow that triggers based on Open Date/Funding Date for Campaign automation</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Tick_CampaignAutomationTrigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Financial_Account_SFDC2__c.Open_Date__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Tick_CampaignAutomationTrigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Financial_Account_SFDC2__c.Open_Date__c</offsetFromField>
            <timeLength>31</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Tick_CampaignAutomationTrigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Financial_Account_SFDC2__c.Open_Date__c</offsetFromField>
            <timeLength>46</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Tick_CampaignAutomationTrigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Financial_Account_SFDC2__c.Open_Date__c</offsetFromField>
            <timeLength>45</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Tick_CampaignAutomationTrigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Financial_Account_SFDC2__c.Open_Date__c</offsetFromField>
            <timeLength>61</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Tick_CampaignAutomationTrigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Financial_Account_SFDC2__c.Open_Date__c</offsetFromField>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SFDC2%3A Campaign Automation - Welcome</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Open_Date__c</field>
            <operation>greaterOrEqual</operation>
            <value>LAST 10 DAYS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Open_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Department__c</field>
            <operation>equals</operation>
            <value>Consumer Deposits</value>
        </criteriaItems>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <description>Time-based workflow that triggers based on Open Date for Campaign automation</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Tick_CampaignAutomationTrigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Financial_Account_SFDC2__c.Open_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Tick_CampaignAutomationTrigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Financial_Account_SFDC2__c.Open_Date__c</offsetFromField>
            <timeLength>11</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SFDC2%3A Campaign Automation - Zero Balance</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Zero_Balance_Date__c</field>
            <operation>greaterOrEqual</operation>
            <value>LAST 60 DAYS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Zero_Balance_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>LAST 10 DAYS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Department__c</field>
            <operation>equals</operation>
            <value>Consumer Deposits</value>
        </criteriaItems>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Zero_Balance_Flag__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Time-based workflow that triggers based on Zero Balance Date/Zero Balance Flag for Campaign automation</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Tick_CampaignAutomationTrigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Financial_Account_SFDC2__c.Zero_Balance_Date__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Tick_CampaignAutomationTrigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Financial_Account_SFDC2__c.Zero_Balance_Date__c</offsetFromField>
            <timeLength>45</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Tick_CampaignAutomationTrigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Financial_Account_SFDC2__c.Zero_Balance_Date__c</offsetFromField>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Tick_CampaignAutomationTrigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Financial_Account_SFDC2__c.Zero_Balance_Date__c</offsetFromField>
            <timeLength>46</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Tick_CampaignAutomationTrigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Financial_Account_SFDC2__c.Zero_Balance_Date__c</offsetFromField>
            <timeLength>61</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFDC2_Tick_CampaignAutomationTrigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Financial_Account_SFDC2__c.Zero_Balance_Date__c</offsetFromField>
            <timeLength>31</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SFDC2%3AEmail to Opportunity</fullName>
        <actions>
            <name>SFDC2_Email_notification_to_opportunity_owner_when_account_is_funded</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SFDC2_Update_Opportunity_Owner_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Financial_Account_SFDC2__c.Funding_Amount__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Email notifications to opportunity owner when account is funded</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
