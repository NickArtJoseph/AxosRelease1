<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>LLC_BI__Set_Contact_Business_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Business_Contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Contact Business Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Contact_Individual_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Individual_Contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Contact Individual Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC2_Phone_field_update_after_LC</fullName>
        <description>Business Phone field update after LC</description>
        <field>Business_Phone_SFDC2__c</field>
        <formula>Phone</formula>
        <name>SFDC2: Phone field update after LC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>LLC_BI__Contact Set Business Record Type</fullName>
        <actions>
            <name>LLC_BI__Set_Contact_Business_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.LLC_BI__Primary_Contact__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>sets Record Type to Business if Contact is not marked as primary</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Contact Set Individual Record Type</fullName>
        <actions>
            <name>LLC_BI__Set_Contact_Individual_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.LLC_BI__Primary_Contact__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>sets Record Type to Individual if Contact is marked as primary</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2%3A Contact Phone field update</fullName>
        <actions>
            <name>SFDC2_Phone_field_update_after_LC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Phone</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>Business SFDC2</value>
        </criteriaItems>
        <description>Coresponding Business phone field update after lead conversion</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
