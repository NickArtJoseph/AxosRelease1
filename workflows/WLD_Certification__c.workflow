<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>WLD_QC_Cert_items_outstanding_1_week</fullName>
        <ccEmails>SellerApprovals@bofi.com</ccEmails>
        <description>WLD: QC - Cert items outstanding - 1 week</description>
        <protected>false</protected>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Warehouse_Lending/WLD_Certification_Items_Outstanding_1_Week</template>
    </alerts>
    <alerts>
        <fullName>WLD_QC_Cert_items_outstanding_2_weeks</fullName>
        <ccEmails>SellerApprovals@bofi.com</ccEmails>
        <description>WLD: QC - Cert items outstanding - 2 weeks</description>
        <protected>false</protected>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Warehouse_Lending/WLD_Certification_Items_Outstanding_2_Weeks</template>
    </alerts>
    <alerts>
        <fullName>WLD_QC_Send_email_when_new_QC_created</fullName>
        <description>WLD: QC - Send email when new QC created</description>
        <protected>false</protected>
        <recipients>
            <field>Contact_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>wld@bofi.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Warehouse_Lending/WLD_QC_Request_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>AC_Name_Format</fullName>
        <description>Updates Account Certification Name field to be Account Name + AC + Year</description>
        <field>Name</field>
        <formula>IF(LEN(Account__r.Name) &gt; 72, LEFT(Account__r.Name, 72), Account__r.Name) &amp; &quot; AC &quot; &amp; TEXT(QLR_Year__c)</formula>
        <name>AC: Name Format</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ARC_Name_Format</fullName>
        <description>Updates Account Recertification Name field to be Account Name + ARC + Year</description>
        <field>Name</field>
        <formula>IF(LEN(Account__r.Name) &gt; 71, LEFT(Account__r.Name, 71), Account__r.Name) + &quot; ARC&quot; + &quot; &quot; + TEXT(QLR_Year__c)</formula>
        <name>ARC: Name Format</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QC_Name_Format</fullName>
        <description>Updates Quarterly Certification Name field to be Account Name + QLR Year + QLR Quarter</description>
        <field>Name</field>
        <formula>IF(LEN(Account__r.Name) &gt; (80 - LEN( TEXT(QLR_Year__c) )+1 - LEN( TEXT(QLR_Quarter__c) )+1), LEFT(Account__r.Name,(80 - LEN( TEXT(QLR_Year__c) )+1 - LEN( TEXT(QLR_Quarter__c) )+1)), Account__r.Name) + &quot; &quot; + TEXT(QLR_Year__c) + &quot; &quot; + TEXT(QLR_Quarter__c)</formula>
        <name>QC: Name Format</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WLD_AC_User_Time_Stamp_Update</fullName>
        <field>User_Stamp_Comments__c</field>
        <formula>$User.LastName &amp; &quot; &quot; &amp; TEXT(TODAY())</formula>
        <name>WLD: AC - User Time Stamp Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WLD%3A AC - Name Format</fullName>
        <actions>
            <name>AC_Name_Format</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Ensures that the Account Certification Name follows the agreed upon format [Account Name + AC + Year]</description>
        <formula>AND(   RecordType.DeveloperName = &quot;Account_Certification&quot;,   (IF(LEN(Account__r.Name) &gt; 72, LEFT(Account__r.Name,72), Account__r.Name) &amp; &quot; AC &quot; &amp; TEXT(QLR_Year__c)) &lt;&gt; Name )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WLD%3A AC - User Time Stamp</fullName>
        <actions>
            <name>WLD_AC_User_Time_Stamp_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WLD_Certification__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Quarterly Certification</value>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.Comments__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Updates User Time Stamp field with user&apos;s last name [rewrite of legacy workflow rule]</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WLD%3A ARC - Name Format</fullName>
        <actions>
            <name>ARC_Name_Format</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Ensures that the Account Recertification Name follows the agreed upon format [Account Name + ARC + Year]</description>
        <formula>AND(   RecordType.DeveloperName = &quot;Account_Recertification&quot;,   (IF(LEN(Account__r.Name) &gt; 71, LEFT(Account__r.Name,71), Account__r.Name) + &quot; ARC&quot; + &quot; &quot; + TEXT(QLR_Year__c)) &lt;&gt; Name )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WLD%3A QC - Cert Items Outstanding - 14 days</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND (4 OR 5 OR 6 OR 7 OR 8 OR 9 OR 10 OR 11)</booleanFilter>
        <criteriaItems>
            <field>WLD_Certification__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Quarterly Certification</value>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.Due_Date__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.MRA_Exhibit_B_and_All_Schedules__c</field>
            <operation>notEqual</operation>
            <value>Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.MRA_Schedule_1_Financial_Covenants__c</field>
            <operation>notEqual</operation>
            <value>Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.Unaudited_P_L_for_the_Quarter__c</field>
            <operation>notEqual</operation>
            <value>Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.Unaudited_P_L_YTD__c</field>
            <operation>notEqual</operation>
            <value>Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.Unaudited_Balance_Sheet_YTD__c</field>
            <operation>notEqual</operation>
            <value>Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.Investor_Scorecards__c</field>
            <operation>notEqual</operation>
            <value>Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.Hedging_Reports__c</field>
            <operation>notEqual</operation>
            <value>Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.Quality_Control_Reports__c</field>
            <operation>notEqual</operation>
            <value>Received</value>
        </criteriaItems>
        <description>There are certification items outstanding with only 2 weeks until due date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>WLD_QC_Cert_items_outstanding_2_weeks</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>WLD_Certification__c.Due_Date__c</offsetFromField>
            <timeLength>-14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>WLD%3A QC - Cert Items Outstanding - 7 days</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND (4 OR 5 OR 6 OR 7 OR 8 OR 9 OR 10 OR 11)</booleanFilter>
        <criteriaItems>
            <field>WLD_Certification__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Quarterly Certification</value>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.Due_Date__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.MRA_Exhibit_B_and_All_Schedules__c</field>
            <operation>notEqual</operation>
            <value>Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.MRA_Schedule_1_Financial_Covenants__c</field>
            <operation>notEqual</operation>
            <value>Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.Unaudited_P_L_for_the_Quarter__c</field>
            <operation>notEqual</operation>
            <value>Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.Unaudited_P_L_YTD__c</field>
            <operation>notEqual</operation>
            <value>Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.Unaudited_Balance_Sheet_YTD__c</field>
            <operation>notEqual</operation>
            <value>Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.Investor_Scorecards__c</field>
            <operation>notEqual</operation>
            <value>Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.Hedging_Reports__c</field>
            <operation>notEqual</operation>
            <value>Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.Quality_Control_Reports__c</field>
            <operation>notEqual</operation>
            <value>Received</value>
        </criteriaItems>
        <description>There are certification items outstanding with only 1 weeks until due date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>WLD_QC_Cert_items_outstanding_1_week</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>WLD_Certification__c.Due_Date__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>WLD%3A QC - Name Format</fullName>
        <actions>
            <name>QC_Name_Format</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Ensures that the Quarterly Certification Name follows the agreed upon format [Account Name + QLR Year + QLR Quarter]</description>
        <formula>AND(    RecordType.DeveloperName = &quot;Quarterly_Certification&quot;,   (IF(LEN(Account__r.Name) &gt; (80 - LEN( TEXT(QLR_Year__c) )+1 - LEN( TEXT(QLR_Quarter__c) )+1), LEFT(Account__r.Name,(80 - LEN( TEXT(QLR_Year__c) )+1 - LEN( TEXT(QLR_Quarter__c) )+1)), Account__r.Name) + &quot; &quot; + TEXT(QLR_Year__c) + &quot; &quot; + TEXT(QLR_Quarter__c)) &lt;&gt; Name)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WLD%3A QC - New Email to Client</fullName>
        <actions>
            <name>WLD_QC_Send_email_when_new_QC_created</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>WLD_Certification__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Quarterly Certification</value>
        </criteriaItems>
        <criteriaItems>
            <field>WLD_Certification__c.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Email WLD customer informing them of new QC</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
