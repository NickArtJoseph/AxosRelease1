<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>C_I_AC_Name_Format</fullName>
        <description>Formats the C&amp;I Annual Certification Name to [Account Name] + [Year]</description>
        <field>Name</field>
        <formula>IF(LEN(Opportunity__r.Account.Name) &gt; 75, LEFT(Opportunity__r.Account.Name, 75), Opportunity__r.Account.Name) &amp; &quot; &quot; &amp; TEXT(Year_of_Certification__c)</formula>
        <name>C&amp;I: AC Name Format</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Certification_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>C&amp;I Certification: Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Certification_Date_Completed</fullName>
        <field>Date_Completed__c</field>
        <formula>TODAY()</formula>
        <name>C&amp;I Certification: Date Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Certification_In_Credit_Review</fullName>
        <field>Status__c</field>
        <literalValue>In Credit Review</literalValue>
        <name>C&amp;I Certification: In Credit Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Certification_In_Progress</fullName>
        <field>Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>C&amp;I Certification: In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Certification_Incomplete</fullName>
        <field>Status__c</field>
        <literalValue>Incomplete</literalValue>
        <name>C&amp;I Certification: Incomplete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_MC_Name_Format</fullName>
        <description>Formats the C&amp;I Monthly Certification Name to [Account Name] + [Year] + [Month]</description>
        <field>Name</field>
        <formula>IF(LEN(Opportunity__r.Account.Name) &gt; 72, LEFT(Opportunity__r.Account.Name, 72), Opportunity__r.Account.Name) &amp; &quot; &quot; &amp; TEXT(Year_of_Certification__c) &amp; &quot; &quot; &amp; TEXT(Month_of_Certification__c)</formula>
        <name>C&amp;I: MC Name Format</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_QC_Name_Format</fullName>
        <description>Formats the C&amp;I Quarterly Certification Name to [Account Name] + [Year] + [Quarter]</description>
        <field>Name</field>
        <formula>IF(LEN(Opportunity__r.Account.Name) &gt; 69, LEFT(Opportunity__r.Account.Name, 69), Opportunity__r.Account.Name) &amp; &quot; &quot; &amp; TEXT(Year_of_Certification__c) &amp; &quot; &quot; &amp; Quarter_of_Certification__c</formula>
        <name>C&amp;I: QC Name Format</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>C%26I%3A MC Name Format</fullName>
        <actions>
            <name>C_I_MC_Name_Format</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Provides proper format for C&amp;I Monthly Certification records</description>
        <formula>AND(  RecordType.DeveloperName = &quot;Monthly_Certification&quot;,   Name !=  IF(LEN(Opportunity__r.Account.Name) &gt; 72, LEFT(Opportunity__r.Account.Name, 72), Opportunity__r.Account.Name) &amp; &quot; &quot; &amp;  TEXT(Year_of_Certification__c) &amp; &quot; &quot; &amp; TEXT(Month_of_Certification__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A QC Name Format</fullName>
        <actions>
            <name>C_I_QC_Name_Format</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Provides proper format for C&amp;I Quarterly Certification records</description>
        <formula>AND(  RecordType.DeveloperName = &quot;Quarterly_Certification&quot;,  Name !=  IF(LEN(Opportunity__r.Account.Name) &gt; 69, LEFT(Opportunity__r.Account.Name, 69), Opportunity__r.Account.Name) &amp; &quot; &quot; &amp;  TEXT(Year_of_Certification__c) &amp; &quot; &quot; &amp;  Quarter_of_Certification__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Record Type is Annual Certification and Name does not equal proper format</fullName>
        <actions>
            <name>C_I_AC_Name_Format</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I - Provides proper format for C&amp;I Annual Certification records</description>
        <formula>AND(  RecordType.DeveloperName = &quot;Annual_Certification&quot;,   Name !=  IF(LEN(Opportunity__r.Account.Name) &gt; 75, LEFT(Opportunity__r.Account.Name, 75), Opportunity__r.Account.Name) &amp; &quot; &quot; &amp;  TEXT(Year_of_Certification__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Certification_In_Credit_Review</fullName>
        <assignedTo>jbutensky@bofifederalbank.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>The associated Certification has been submitted for approval and is ready for review.</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Certification Ready for Credit Review</subject>
    </tasks>
    <tasks>
        <fullName>Certification_is_Incomplete</fullName>
        <assignedToType>owner</assignedToType>
        <description>The associated Certification has been marked as Incomplete as a result of the credit review.</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Certification is Incomplete</subject>
    </tasks>
</Workflow>
