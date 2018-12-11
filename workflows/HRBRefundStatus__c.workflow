<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>HRBCommRetryTimestamp</fullName>
        <description>Put &quot;COMMRETRY&quot; +Timestamp in  Middle_Name__c</description>
        <field>Middle_Name__c</field>
        <formula>&quot;COMMRETRY &quot; +   TEXT(DATETIMEVALUE(NOW())) + &quot; &quot; +   LEFT( HRB_Refund_Advance__r.Middle_Name__c,60)</formula>
        <name>HRBCommRetryTimestamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>HRB_Refund_Advance__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HRBUncomplete</fullName>
        <description>mark uncomplete in HRB Refund Advance object</description>
        <field>isCompleted__c</field>
        <literalValue>0</literalValue>
        <name>HRBUncomplete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>HRB_Refund_Advance__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HRBUndecide</fullName>
        <description>Set HRBDecision to Null in HRB Refund Advance</description>
        <field>HRBDecision__c</field>
        <name>HRBUndecide</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <targetObject>HRB_Refund_Advance__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>HRBStatusCommRetryEvery1hr</fullName>
        <active>true</active>
        <criteriaItems>
            <field>HRBRefundStatus__c.HTTPResponseCode__c</field>
            <operation>notEqual</operation>
            <value>200</value>
        </criteriaItems>
        <criteriaItems>
            <field>HRBRefundStatus__c.SLAMinutes__c</field>
            <operation>lessThan</operation>
            <value>1380</value>
        </criteriaItems>
        <criteriaItems>
            <field>HRBRefundStatus__c.HTTPResponseCode__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>retry on not 200, aftr 1hr</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>HRBCommRetryTimestamp</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>HRBUncomplete</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>HRBUndecide</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>HRBRefundStatus__c.LastModifiedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
