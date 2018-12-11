<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Campaign_Code</fullName>
        <description>Update Campaign_Code_SFDC2__c field from Medium Code, Category Code and RND to make a unique external id</description>
        <field>Campaign_Code_SFDC2__c</field>
        <formula>IF(ISBLANK(Legacy_Campaign_Code_SFDC2__c) , Type_Code_SFDC2__c + Category_Code_SFDC2__c + RND_SFDC2__c, Legacy_Campaign_Code_SFDC2__c)</formula>
        <name>Update Campaign Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Campaign_Tagged_URL</fullName>
        <description>Updates the URL for Campaign Tagged URL</description>
        <field>Campaign_Tagged_URL_SFDC2__c</field>
        <formula>IF((CONTAINS(Destination_URL_SFDC2__c,&quot;?&quot;)),Destination_URL_SFDC2__c, Destination_URL_SFDC2__c+&quot;?&quot;)+&quot;utm_campaign={&quot;+ Campaign_Code_SFDC2__c +&quot;}&amp;utm_source=LOWER({&quot; +TEXT(Publisher_Source_SFDC2__c)+ &quot;})&amp;utm_medium=LOWER({&quot;+ TEXT(Type) +&quot;})&quot;</formula>
        <name>Update Campaign Tagged URL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SFDC2 Campaign Code Update</fullName>
        <actions>
            <name>Update_Campaign_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Type_Code_SFDC2__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Category_Code_SFDC2__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SFDC2 Campaign URL Update</fullName>
        <actions>
            <name>Update_Campaign_Tagged_URL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Destination_URL_SFDC2__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Campaign_Code_SFDC2__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Type</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Custom_Campaign_URL_SFDC2__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Publisher_Source_SFDC2__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Automatically updates Campaign Tagged URL</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
