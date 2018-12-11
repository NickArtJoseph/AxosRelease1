<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>LLC_BI__AP_Stress_Index_Actual</fullName>
        <field>LLC_BI__AP_Stress_Index_actual__c</field>
        <formula>LLC_BI__Account__r.LLC_BI__AP_Stress_Index__c</formula>
        <name>AP Stress Index - Actual</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__AP_Stress_Index_RG</fullName>
        <field>LLC_BI__AP_Stress_Index_RG__c</field>
        <formula>IF(AND( LLC_BI__AP_Stress_Index_actual__c &lt;= 8, LLC_BI__AP_Stress_Index_actual__c &gt;=0),1, 
IF(AND( LLC_BI__AP_Stress_Index_actual__c &lt;= 10, LLC_BI__AP_Stress_Index_actual__c &gt;=8.01),2, 
IF(AND( LLC_BI__AP_Stress_Index_actual__c &lt;= 13, LLC_BI__AP_Stress_Index_actual__c &gt;=10.01),3, 
IF(AND( LLC_BI__AP_Stress_Index_actual__c &lt;= 15, LLC_BI__AP_Stress_Index_actual__c &gt;=13.01),5, 
IF(AND( LLC_BI__AP_Stress_Index_actual__c &lt;= 17, LLC_BI__AP_Stress_Index_actual__c &gt;=15.01),6, 
IF(LLC_BI__AP_Stress_Index_actual__c &gt;=17.01,7,0))))))</formula>
        <name>AP Stress Index RG</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
