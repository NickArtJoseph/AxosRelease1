<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>C_I_CAM_Approval_Notification</fullName>
        <description>C&amp;I - CAM Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>jfairchild@bofi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/C_I_CAM_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>C_I_CAM_Approval_Request_Approved</fullName>
        <description>C&amp;I - CAM Approval Request Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>C&amp;I - Collateral Analyst</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>C&amp;I - Collateral Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>C&amp;I - Credit</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>C&amp;I - Jr. Relationship Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>C&amp;I - Loan Ops</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>C&amp;I - Loan Ops Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>C&amp;I - Relationship Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>C&amp;I - Sr. Relationship Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/CAM_Approval_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>C_I_CAM_Approval_Request_Rejected</fullName>
        <description>C&amp;I - CAM Approval Request Rejected</description>
        <protected>false</protected>
        <recipients>
            <recipient>C&amp;I - Collateral Analyst</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>C&amp;I - Collateral Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>C&amp;I - Credit</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>C&amp;I - Jr. Relationship Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>C&amp;I - Loan Ops</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>C&amp;I - Loan Ops Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>C&amp;I - Relationship Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>C&amp;I - Sr. Relationship Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/CAM_Approval_Request_Rejected</template>
    </alerts>
    <alerts>
        <fullName>C_I_PIC_Approval_Request_Approved</fullName>
        <description>C&amp;I - PIC Approval Request Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/PIC_Approval_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>C_I_PIC_Approval_Request_Rejected</fullName>
        <description>C&amp;I - PIC Approval Request Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C_I_Email_Templates/PIC_Approval_Request_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>AB_Advance_Rates_Standard_Language</fullName>
        <field>Advance_Rate_s_Standard_Language__c</field>
        <formula>&quot;Collateral value requires an appraisal performed by a Lender approved appraiser.&quot;</formula>
        <name>AB - Advance Rates, Standard Language</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AB_Borrower_Standard_Language</fullName>
        <field>Borrower_Standard_Language__c</field>
        <formula>&quot;, a bankruptcy remote special purpose entity.&quot;</formula>
        <name>AB - Borrower, Standard Language</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AB_Cash_Flow_Waterfall</fullName>
        <field>Cash_Flow_Waterfall__c</field>
        <formula>&quot;Absent an Event of Default, all proceeds received, net of customary servicing expenses, will be applied as follows:&lt;BR&gt;&lt;BR&gt;(a) to the Senior Participant, to reimburse it for all costs and/or advances made or incurred by it together with any interest thereon;&lt;BR&gt;(b) to the accrued and unpaid interest on the Senior Participation Principal Balance then due and payable to the extent that the amounts in the Interest Reserve are insufficient to pay such interest;&lt;BR&gt;(c) to the Senior Participant, an amount equal to Senior Participant’s pro-rata portion of any fee paid by the Borrower in connection with exercising any extension option (as defined in the Note);&lt;BR&gt;(d) to the Senior Participant, in reduction of the then outstanding Senior Participation Principal Balance until such Senior Participation Principal Balance is reduced to zero ($0.00), an amount equal to any principal payment or prepayment made on the Loan;&lt;BR&gt;(e) to the Senior Participant, Senior Participant’s pro-rata portion of any Prepayment Premium owed under the Note;&lt;BR&gt;(f) to Senior Participant, any other amounts due to Senior Participant including, any amounts owed to the Senior Participant on account of any default by Junior Participant or Parent hereunder; and&lt;BR&gt;(g) any excess to Junior Participant on account of Junior Participation Interest including any costs or advances made by it; provided, however, net operating income from REO Property and all other proceeds from REO Property or from the direct or indirect sale, refinancing or letting thereof shall belong to, and be remitted and/or retained by, the Senior Participant or its designee.&quot;</formula>
        <name>AB - Cash Flow Waterfall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AB_Due_Diligence</fullName>
        <field>Due_Diligence__c</field>
        <formula>&quot;Lender shall conduct all diligence deemed necessary and prudent in its sole and absolute discretion. The cost of all due diligence items shall be paid by the Junior Participant, or Parent on Junior Participant’s behalf.&quot;</formula>
        <name>AB - Due Diligence</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AB_Events_of_Default</fullName>
        <field>Events_of_Default__c</field>
        <formula>&quot;As defined in the underlying Borrower Loan documents.&quot;</formula>
        <name>AB - Events of Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AB_Interest_Rate_Standard_Language</fullName>
        <field>Interest_Rate_Standard_Language__c</field>
        <formula>&quot;Interest on the Participation shall be payable monthly in arrears, calculated on the basis of actual number of days elapsed in a 360 day year.&quot;+BR()+BR()+&quot;Interest shall accrue at an annual rate equal to the Base Rate plus 10.00% (the “Default Rate”) upon the occurrence of the following:&quot;+BR()+BR()+&quot;(a) any time an amount owed to the Senior Participant is not paid on or before the earlier of (i) the maturity date and (ii) ten (10) days after the same is due and payable;&quot;+BR()+&quot;(b) a Junior Participant Release Event (as hereinafter defined) has occurred; or&quot;+BR()+&quot;(c) an Event of Default (as hereinafter defined) has occurred.&quot;</formula>
        <name>AB - Interest Rate, Standard Language</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AB_Junior_Participant_Release_Event</fullName>
        <field>Junior_Participant_Release_Event__c</field>
        <formula>&quot;May include, but not be limited to, any of the following events:&lt;BR&gt;&lt;BR&gt;(a) any failure by Junior Participant to deliver to Senior Participant additional contributions to the Interest Reserve as and when required;&lt;BR&gt;(b)	 any failure by Junior Participant or Parent to pay any other sum payable under the Participation Documents within three (3) business days of when due;&lt;BR&gt;(c) any representation or warranty made by Junior Participant or Parent in or pursuant to the Participation Documents shall prove to have been false or incorrect in any material respect as of the date when made;&lt;BR&gt;(d) any dissolution, termination, partial or complete liquidation, merger or consolidation of Junior Participant, or any sale, transfer or other disposition of all or substantially all of the assets of Junior Participant;&lt;BR&gt;(e) any Junior Participant or Borrower insolvency event;&lt;BR&gt;(f) the failure of Junior Participant to be a single purpose entity;&lt;BR&gt;(g) the failure of Junior Participant to inform Lender of an Event of Default within three (3) business days of Junior Participant’s knowledge thereof;&lt;BR&gt;(h) the failure of Junior Participant to obtain any required Lender consent under the Participation Documents;&lt;BR&gt;(i) Junior Participant’s transfer of all or any portion of its interest, other than as permitted by the Participation Documents; or&lt;BR&gt;(j) any failure by Junior Participant to duly observe or perform any other term, covenant, condition or agreement under the Participation Agreement and continuance of such failure for a period of thirty (30) days after Junior Participant first had knowledge of such failure.&quot;</formula>
        <name>AB - Junior Participant Release Event</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AB_Loan_Purpose_Standard_Language</fullName>
        <field>Loan_Purpose_Standard_Language__c</field>
        <formula>&quot;The Participation shall be documented through a Participation Agreement and such ancillary documents as may be requested by Lender in light of the final structure of the transaction (the “Participation Documents”).&quot;</formula>
        <name>AB - Loan Purpose, Standard Language</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AB_Other_Terms_Conditions_Standard</fullName>
        <field>Other_Terms_Conditions_Standard_Language__c</field>
        <formula>&quot;Shall consist of, but not be limited to, the following:&lt;BR&gt;&lt;BR&gt;a) Satisfactory review of the Borrower Loan documents and other ancillary documents.&lt;BR&gt;b) No material change in Parent’s, Junior Participant’s, Borrower(s), or Guarantor(s) business or general financial condition.&lt;BR&gt;c) Complete loan application, including all due diligence documentation required by Lender.&lt;BR&gt;d) Acceptable appraisal report assigned to Lender and an appraisal review engaged by Lender.&lt;BR&gt;e) Lender’s legal counsel to review all entity documents and all legal/title documents pertaining to the underlying project.&lt;BR&gt;f) Lender’s legal counsel to prepare all Participation Documents, which Participation Documents will contain usual and customary representations and warranties for transactions of this type.&lt;BR&gt;g) ALTA Lenders Policy from an acceptable title company, including endorsements.&lt;BR&gt;h)	Title and escrow expenses paid by Borrower or Junior Participant.&lt;BR&gt;i) Any other financial and/or documentation which may be required by Lender in its sole and absolute discretion.&quot;</formula>
        <name>AB - Other Terms &amp; Conditions, Standard</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AB_Participating_Lender_Standard_Lang</fullName>
        <field>Participating_Lender_Standard_Language__c</field>
        <formula>&quot;, a bankruptcy remote special purpose entity.&quot;</formula>
        <name>AB - Participating Lender, Standard Lang</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AB_Participations_and_Assignments</fullName>
        <field>Participations_and_Assignments__c</field>
        <formula>&quot;Lender may, in its sole discretion, sell, assign, pledge, transfer, grant a security interest in, syndicate, contribute, or otherwise dispose of (collectively, “Transfer”) all or any portion of the Participation.&quot;+BR()+BR()+&quot;Junior Participant shall not Transfer all or any portion of its interest in the Loan, other than to Lender.&quot;</formula>
        <name>AB - Participations and Assignments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AB_Repurchase_Price</fullName>
        <field>Repurchase_Price__c</field>
        <formula>&quot;An amount equal to the sum of the following as of the repurchase date:&lt;BR&gt;&lt;BR&gt;(a) all unreimbursed costs and/or advances made or incurred by the Senior Participant together with any interest thereon at the Default Rate from the date incurred until the date paid;&lt;BR&gt;(b) all accrued and unpaid interest on the Senior Participation Principal Balance;&lt;BR&gt;(c) the Senior Participation Principal Balance;&lt;BR&gt;(d) an amount equal to Senior Participant’s actual third party costs and expenses incurred in connection with the preparation, negotiation, execution and delivery hereof including attorneys’ fees not previously reimbursed by Junior Participant; and&lt;BR&gt;(e) all other amounts due to Senior Participant hereunder including, any amounts owed to the Senior Participant on account of any default by Junior Participant.&quot;</formula>
        <name>AB - Repurchase Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AB_Repurchase_Requirement</fullName>
        <field>Repurchase_Requirement__c</field>
        <formula>&quot;Upon the occurrence of a Borrower or Junior Participant insolvency event, Parent shall immediately be obligated to purchase all of the Senior Participant Interest for the Repurchase Price (as hereinafter defined).&quot;</formula>
        <name>AB - Repurchase Requirement</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AB_Servicing_Servicer</fullName>
        <field>Servicing_Servicer__c</field>
        <formula>&quot;Servicing of Collateral shall be provided by Parent or a third party servicer subject to Lender approval.  Servicing shall include payment reconciliation, collection payments, compilation of information related to tax reporting (to the extent required) and providing a monthly file which lists such information as requested by Lender. In the Event of Default by Borrower, Junior Participant, or Parent, Lender shall have the right to replace the Parent as servicer with a third party servicer acceptable to Lender in its sole discretion.  Any costs incurred by such replacement servicer shall be the responsibility of the Parent.&quot;</formula>
        <name>AB - Servicing/Servicer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Bridge_Advance_Rate_Standard_Language</fullName>
        <field>Advance_Rate_s_Standard_Language__c</field>
        <formula>&quot;Collateral value requires an appraisal performed by a Lender approved appraiser.&quot;</formula>
        <name>Bridge - Advance Rate, Standard Language</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Bridge_Borrower_Standard_Lanaguage</fullName>
        <field>Borrower_Standard_Language__c</field>
        <formula>&quot;, a newly formed single-purpose entity.&quot;</formula>
        <name>Bridge - Borrower, Standard Lanaguage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Bridge_Cash_Flow_Waterfall</fullName>
        <field>Cash_Flow_Waterfall__c</field>
        <formula>&quot;All proceeds from Borrower will be applied as follows:&lt;BR&gt;&lt;BR&gt;a. To pay any fees/expenses owed to Lender&lt;BR&gt;b. To pay interest owed to Lender&lt;BR&gt;c. To pay down the outstanding principal balance owed to Lender, until the principal balance equals $0&lt;BR&gt;d. To Borrower provided that no Default or Event of Default has occurred and is continuing&quot;</formula>
        <name>Bridge - Cash Flow Waterfall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Bridge_Due_Diligence</fullName>
        <field>Due_Diligence__c</field>
        <formula>&quot;Lender shall conduct all diligence deemed necessary and prudent in its sole and absolute discretion. The cost of all due diligence items shall be paid by the Borrower.&quot;</formula>
        <name>Bridge - Due Diligence</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Bridge_Events_of_Default</fullName>
        <field>Events_of_Default__c</field>
        <formula>&quot;Customary events of default, including, but not limited to, without limitation: (i) nonpayment of obligations under the Loan; (ii) breaches of representations, warranties, or covenants; (iii) bankruptcy; (iv) material judgments; (v) ERISA violations; (vi) changes of control; and (vii) occurrence of a default (whether or not resulting in acceleration) under any other agreement governing material indebtedness of the Borrower or any of its subsidiaries.&quot;</formula>
        <name>Bridge - Events of Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Bridge_Interest_Rate_Standard_Lang</fullName>
        <field>Interest_Rate_Standard_Language__c</field>
        <formula>&quot;Interest on the Loan shall be payable monthly in arrears, calculated on the basis of actual number of days elapsed in a 360 day year.&quot;+BR()+BR()+&quot;If an Event of Default (as hereinafter defined) has occurred interest shall accrue at an annual rate equal to the Base Rate plus 10.00% (the “Default Rate”).&quot;</formula>
        <name>Bridge - Interest Rate, Standard Lang</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Bridge_Other_Terms_Conditions_Standard</fullName>
        <field>Other_Terms_Conditions_Standard_Language__c</field>
        <formula>&quot;Shall consist of, but not be limited to, the following:&lt;BR&gt;&lt;BR&gt;a) Satisfactory review of Loan documents and other ancillary documents by Lender and Lender counsel.&lt;BR&gt;b) No material change in Borrower(s) or Guarantor(s) business or general financial condition.&lt;BR&gt;c) Complete loan application, including all due diligence documentation required by Lender.&lt;BR&gt;d) Acceptable appraisal report and an appraisal review engaged by Lender.&lt;BR&gt;e) Lender’s legal counsel to review all entity documents and all legal/title documents pertaining to the underlying project.&lt;BR&gt;f) Lender’s legal counsel to prepare all Loan Documents, which Loan Documents will contain usual and customary representations and warranties for transactions of this type.&lt;BR&gt;g) Proof of acceptable insurance coverage, with Lender named as additional insured and loss payee.&lt;BR&gt;h) ALTA Lenders Policy from an acceptable title company, including endorsements.&lt;BR&gt;i) Title and escrow expenses paid by Borrower&lt;BR&gt;j) Any other financial and/or documentation which may be required by Lender in its sole and absolute discretion. &quot;</formula>
        <name>Bridge - Other Terms/Conditions,Standard</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Bridge_Participations_and_Assignments</fullName>
        <field>Participations_and_Assignments__c</field>
        <formula>&quot;BofI may, in its sole discretion, sell participations in the Loan and in its commitment thereunder.&quot;</formula>
        <name>Bridge - Participations and Assignments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_CAM_Approval_Closing</fullName>
        <field>CAM_Approval__c</field>
        <formula>3</formula>
        <name>C&amp;I - CAM Approval - Closing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_CAM_Approval_Revision</fullName>
        <field>CAM_Approval__c</field>
        <formula>2</formula>
        <name>C&amp;I - CAM Approval - Revision</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_CAM_Approval_Submitted</fullName>
        <field>CAM_Approval__c</field>
        <formula>1</formula>
        <name>C&amp;I - CAM Approval - Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_PIC_Approval_LOI</fullName>
        <field>PIC_Approval__c</field>
        <formula>3</formula>
        <name>C&amp;I - PIC Approval - LOI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_PIC_Approval_Revision</fullName>
        <field>PIC_Approval__c</field>
        <formula>2</formula>
        <name>C&amp;I - PIC Approval - Revision</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_PIC_Approval_Submitted</fullName>
        <field>PIC_Approval__c</field>
        <formula>1</formula>
        <name>C&amp;I - PIC Approval - Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_CAM_1st_Approval_FALSE</fullName>
        <field>CAM_1st_Approval__c</field>
        <literalValue>0</literalValue>
        <name>C&amp;I - CAM - 1st Approval - FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_CAM_1st_Approval_TRUE</fullName>
        <field>CAM_1st_Approval__c</field>
        <literalValue>1</literalValue>
        <name>C&amp;I - CAM - 1st Approval - TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_CAM_2nd_Approval_FALSE</fullName>
        <field>CAM_2nd_Approval__c</field>
        <literalValue>0</literalValue>
        <name>C&amp;I - CAM - 2nd Approval - FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_CAM_2nd_Approval_TRUE</fullName>
        <field>CAM_2nd_Approval__c</field>
        <literalValue>1</literalValue>
        <name>C&amp;I - CAM - 2nd Approval - TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_CAM_Approved_FALSE</fullName>
        <field>CAM_Approved__c</field>
        <literalValue>0</literalValue>
        <name>C&amp;I - CAM Approved - FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_CAM_Approved_TRUE</fullName>
        <field>CAM_Approved__c</field>
        <literalValue>1</literalValue>
        <name>C&amp;I - CAM Approved - TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_CAM_Fields_Populated_FALSE_AB</fullName>
        <description>Checks to see if any AB Participation CAM fields are not populated. Used as entry criteria for the CAM approval process.</description>
        <field>CAM_Fields_Populated_AB__c</field>
        <literalValue>0</literalValue>
        <name>C&amp;I - CAM Fields Populated - FALSE - AB</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_CAM_Fields_Populated_FALSE_ALL</fullName>
        <description>Checks to see if any CAM fields that are consistent across all record types are not populated. Used as entry criteria for the CAM approval process.</description>
        <field>CAM_Fields_Populated_ALL__c</field>
        <literalValue>0</literalValue>
        <name>C&amp;I - CAM Fields Populated - FALSE - ALL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_CAM_Fields_Populated_FALSE_BRI</fullName>
        <description>Checks to see if any Bridge CAM fields are not populated. Used as entry criteria for the CAM approval process.</description>
        <field>CAM_Fields_Populated_BRI__c</field>
        <literalValue>0</literalValue>
        <name>C&amp;I - CAM Fields Populated - FALSE - BRI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_CAM_Fields_Populated_FALSE_GEN</fullName>
        <description>Checks to see if any General CAM fields are not populated. Used as entry criteria for the CAM approval process.</description>
        <field>CAM_Fields_Populated_GENeral__c</field>
        <literalValue>0</literalValue>
        <name>C&amp;I - CAM Fields Populated - FALSE - GEN</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_CAM_Fields_Populated_FALSE_LF</fullName>
        <description>Checks to see if any Lender Finance CAM fields are not populated. Used as entry criteria for the CAM approval process.</description>
        <field>CAM_Fields_Populated_LF__c</field>
        <literalValue>0</literalValue>
        <name>C&amp;I - CAM Fields Populated - FALSE - LF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_CAM_Fields_Populated_TRUE_AB</fullName>
        <description>Checks to see if all AB Participation CAM fields are populated. Used as entry criteria for the CAM approval process.</description>
        <field>CAM_Fields_Populated_AB__c</field>
        <literalValue>1</literalValue>
        <name>C&amp;I - CAM Fields Populated - TRUE - AB</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_CAM_Fields_Populated_TRUE_ALL</fullName>
        <description>Checks to see if all CAM fields that are consistent across all record types are populated. Used as entry criteria for the CAM approval process.</description>
        <field>CAM_Fields_Populated_ALL__c</field>
        <literalValue>1</literalValue>
        <name>C&amp;I - CAM Fields Populated - TRUE - ALL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_CAM_Fields_Populated_TRUE_BRI</fullName>
        <description>Checks to see if all Bridge CAM fields are populated. Used as entry criteria for the CAM approval process.</description>
        <field>CAM_Fields_Populated_BRI__c</field>
        <literalValue>1</literalValue>
        <name>C&amp;I - CAM Fields Populated - TRUE - BRI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_CAM_Fields_Populated_TRUE_GEN</fullName>
        <description>Checks to see if all General CAM fields are populated. Used as entry criteria for the CAM approval process.</description>
        <field>CAM_Fields_Populated_GENeral__c</field>
        <literalValue>1</literalValue>
        <name>C&amp;I - CAM Fields Populated - TRUE - GEN</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_CAM_Fields_Populated_TRUE_LF</fullName>
        <description>CAM</description>
        <field>CAM_Fields_Populated_LF__c</field>
        <literalValue>1</literalValue>
        <name>C&amp;I - CAM Fields Populated - TRUE - LF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_PIC_1st_Approval_FALSE</fullName>
        <field>PIC_1st_Approval__c</field>
        <literalValue>0</literalValue>
        <name>C&amp;I - PIC - 1st Approval - FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_PIC_1st_Approval_TRUE</fullName>
        <field>PIC_1st_Approval__c</field>
        <literalValue>1</literalValue>
        <name>C&amp;I - PIC - 1st Approval - TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_PIC_2nd_Approval_FALSE</fullName>
        <field>PIC_2nd_Approval__c</field>
        <literalValue>0</literalValue>
        <name>C&amp;I - PIC - 2nd Approval - FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_PIC_2nd_Approval_TRUE</fullName>
        <field>PIC_2nd_Approval__c</field>
        <literalValue>1</literalValue>
        <name>C&amp;I - PIC - 2nd Approval - TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_PIC_Approved_FALSE</fullName>
        <field>PIC_Approved__c</field>
        <literalValue>0</literalValue>
        <name>C&amp;I - PIC Approved - FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_PIC_Approved_TRUE</fullName>
        <field>PIC_Approved__c</field>
        <literalValue>1</literalValue>
        <name>C&amp;I - PIC Approved - TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_PIC_Fields_Populated_FALSE</fullName>
        <field>PIC_Fields_Populated__c</field>
        <literalValue>0</literalValue>
        <name>C&amp;I - PIC Fields Populated - FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_PIC_Fields_Populated_TRUE</fullName>
        <field>PIC_Fields_Populated__c</field>
        <literalValue>1</literalValue>
        <name>C&amp;I - PIC Fields Populated - TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Risk_Rating_1_High_Pass</fullName>
        <description>Updates the Risk Rating value to 1-High Pass on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <field>CI_Risk_Rating__c</field>
        <literalValue>1 – High Pass</literalValue>
        <name>C&amp;I - Risk Rating - 1-High Pass</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Risk_Rating_2_Pass</fullName>
        <description>Updates the Risk Rating value to 2-Pass on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <field>CI_Risk_Rating__c</field>
        <literalValue>2 – Pass</literalValue>
        <name>C&amp;I - Risk Rating - 2-Pass</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Risk_Rating_3_Pass</fullName>
        <description>Updates the Risk Rating value to 3-Pass on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <field>CI_Risk_Rating__c</field>
        <literalValue>3 – Pass</literalValue>
        <name>C&amp;I - Risk Rating - 3-Pass</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Risk_Rating_4_Low_Pass</fullName>
        <description>Updates the Risk Rating value to 4-Low Pass on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <field>CI_Risk_Rating__c</field>
        <literalValue>4 – Low Pass</literalValue>
        <name>C&amp;I - Risk Rating - 4-Low Pass</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Risk_Rating_5_Special_Mention</fullName>
        <description>Updates the Risk Rating value to 5-Special Mention on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <field>CI_Risk_Rating__c</field>
        <literalValue>5 – Special Mention</literalValue>
        <name>C&amp;I - Risk Rating - 5-Special Mention</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Risk_Rating_6_Sub_Standard</fullName>
        <description>Updates the Risk Rating value to 6-Sub Standard on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <field>CI_Risk_Rating__c</field>
        <literalValue>6 – Sub Standard</literalValue>
        <name>C&amp;I - Risk Rating - 6-Sub Standard</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Risk_Rating_7_SubStandard_NonAcc</fullName>
        <description>Updates the Risk Rating value to 7-Sub Standard, Non-Accrual on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <field>CI_Risk_Rating__c</field>
        <literalValue>7 – Sub Standard, Non-Accrual</literalValue>
        <name>C&amp;I - Risk Rating - 7-SubStandard,NonAcc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Risk_Rating_8_Doubtful</fullName>
        <description>Updates the Risk Rating value to 8-Doubtful on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <field>CI_Risk_Rating__c</field>
        <literalValue>8 – Doubtful</literalValue>
        <name>C&amp;I - Risk Rating - 8-Doubtful</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Risk_Rating_9_Loss</fullName>
        <description>Updates the Risk Rating value to 9-Loss on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <field>CI_Risk_Rating__c</field>
        <literalValue>9 – Loss</literalValue>
        <name>C&amp;I - Risk Rating - 9-Loss</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Risk_Rating_Null</fullName>
        <description>Updates the Risk Rating value to null on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <field>CI_Risk_Rating__c</field>
        <name>C&amp;I - Risk Rating - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_Closing_Fee_s</fullName>
        <description>Updates the Closing Fee(s) value on the Opportunity when the same field is updated on an Origination Documentation record.</description>
        <field>CI_Closing_Fee_s__c</field>
        <formula>Closing_Fee_s__c</formula>
        <name>C&amp;I - Update Closing Fee(s)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_Closing_Fee_s_AB</fullName>
        <description>Updates the Closing Fee(s) value on the AB Participation Opportunity when the BofI Closing Fee field is updated on an Origination Documentation record.</description>
        <field>CI_Closing_Fee_s__c</field>
        <formula>BofI_Closing_Fee__c</formula>
        <name>C&amp;I - Update Closing Fee(s) [AB]</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_Collateral</fullName>
        <description>Updates the Collateral value on the Opportunity when the same field is updated on an Origination Documentation record.</description>
        <field>CI_Collateral__c</field>
        <formula>Collateral__c</formula>
        <name>C&amp;I - Update Collateral</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_Collateral_AB</fullName>
        <description>Updates the Collateral value on the AB Participation Opportunity when the Collateral Description field is updated on an Origination Documentation record.</description>
        <field>CI_Collateral__c</field>
        <formula>Collateral_Description__c</formula>
        <name>C&amp;I - Update Collateral [AB]</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_Extension_Option_s</fullName>
        <description>Updates the Extension Option(s) value on the Opportunity when the same field is updated on an Origination Documentation record.</description>
        <field>CI_Extension_Option_s__c</field>
        <formula>Extension_Option_s__c</formula>
        <name>C&amp;I - Update Extension Option(s)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_Extension_Option_s_AB</fullName>
        <description>Updates the Extension Option(s) value on the Opportunity when the BofI Extension Option(s) field is updated on an Origination Documentation record.</description>
        <field>CI_Extension_Option_s__c</field>
        <formula>BofI_Extension_Option_s__c</formula>
        <name>C&amp;I - Update Extension Option(s) [AB]</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_Guarantor_Type_s</fullName>
        <description>Updates the Guarantor Type(s) value on the Opportunity when the same field is updated on an Origination Documentation record.</description>
        <field>CI_Guarantor_Type_s__c</field>
        <formula>Guarantor_Type_s__c</formula>
        <name>C&amp;I - Update Guarantor Type(s)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_Guarantor_s</fullName>
        <description>Updates the Guarantor(s) value on the Opportunity when the same field is updated on an Origination Documentation record.</description>
        <field>CI_Guarantor_s__c</field>
        <formula>Guarantor_s__c</formula>
        <name>C&amp;I - Update Guarantor(s)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_Loan_Amount</fullName>
        <description>Updates the Loan Amount value on the Opportunity when the same field is updated on an Origination Documentation record.</description>
        <field>CI_Loan_Amount__c</field>
        <formula>Loan_Amount__c</formula>
        <name>C&amp;I - Update Loan Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_Loan_Amount_AB</fullName>
        <description>Updates the Loan Amount value on AB Participation Opportunity when the BofI Loan Amount field is updated on an Origination Documentation record.</description>
        <field>CI_Loan_Amount__c</field>
        <formula>BofI_Loan_Amount__c</formula>
        <name>C&amp;I - Update Loan Amount [AB]</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_Loan_Structure_Multi</fullName>
        <description>Updates the Loan Structure value to Multi Draw Term on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <field>CI_Loan_Structure__c</field>
        <literalValue>Multi Draw Term</literalValue>
        <name>C&amp;I - Update Loan Structure - Multi</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_Loan_Structure_Null</fullName>
        <description>Updates the Loan Structure value to null on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <field>CI_Loan_Structure__c</field>
        <name>C&amp;I - Update Loan Structure - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_Loan_Structure_Revolving</fullName>
        <description>Updates the Loan Structure value to Revolving on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <field>CI_Loan_Structure__c</field>
        <literalValue>Revolving</literalValue>
        <name>C&amp;I - Update Loan Structure - Revolving</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_Loan_Structure_Term</fullName>
        <description>Updates the Loan Structure value to Term on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <field>CI_Loan_Structure__c</field>
        <literalValue>Term</literalValue>
        <name>C&amp;I - Update Loan Structure - Term</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_PIC_Loan_Amount</fullName>
        <description>Updates the Loan Amount value on the Opportunity when the same field is updated on an PIC Origination Documentation record.</description>
        <field>CI_PIC_Loan_Amount__c</field>
        <formula>Loan_Amount__c</formula>
        <name>C&amp;I - Update PIC Loan Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_Rate_AB</fullName>
        <description>Updates the Rate value on the AB Participation Opportunity when the BofI Rate field is updated on an Origination Documentation record.</description>
        <field>CI_Rate__c</field>
        <formula>BofI_Rate__c</formula>
        <name>C&amp;I - Update Rate [AB]</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_Term</fullName>
        <description>Updates the Term value on the Opportunity when the same field is updated on an Origination Documentation record.</description>
        <field>CI_Term__c</field>
        <formula>Term__c</formula>
        <name>C&amp;I - Update Term</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_I_Update_Term_AB</fullName>
        <description>Updates the Term value on the AB Participation Opportunity when the BofI Term field is updated on an Origination Documentation record.</description>
        <field>CI_Term__c</field>
        <formula>BofI_Term__c</formula>
        <name>C&amp;I - Update Term [AB]</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>General_Cash_Flow_Waterfall</fullName>
        <field>Cash_Flow_Waterfall__c</field>
        <formula>&quot;All proceeds from Borrower will be applied as follows:&lt;BR&gt;&lt;BR&gt;a. To pay any fees/expenses owed to Lender&lt;BR&gt;b. To cure any Loan deficiency&lt;BR&gt;c. To pay interest owed to Lender&lt;BR&gt;d. To pay down the outstanding principal balance owed to Lender, until the principal balance equals $0&lt;BR&gt;e. To Borrower provided that no Default or Event of Default has occurred and is continuing&quot;</formula>
        <name>General - Cash Flow Waterfall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>General_Collateral_Standard_Language</fullName>
        <field>Collateral_Standard_Language__c</field>
        <formula>&quot;All real estate collateral is subject to an Appraisal acceptable to Bank in its sole discretion.&quot;</formula>
        <name>General - Collateral, Standard Language</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>General_Due_Diligence</fullName>
        <field>Due_Diligence__c</field>
        <formula>&quot;Lender shall conduct all diligence deemed necessary and prudent in its sole and absolute discretion. The cost of all due diligence items shall be paid by the Borrower.&quot;</formula>
        <name>General - Due Diligence</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>General_Events_of_Default</fullName>
        <field>Events_of_Default__c</field>
        <formula>&quot;Customary events of default, including, but not limited to, without limitation: (i) nonpayment of obligations under the Loan; (ii) breaches of representations, warranties, or covenants; (iii) bankruptcy; (iv) material judgments; (v) ERISA violations; (vi) changes of control; and (vii) occurrence of a default (whether or not resulting in acceleration) under any other agreement governing material indebtedness of the Borrower or any of its subsidiaries.&quot;</formula>
        <name>General - Events of Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>General_Interest_Rate_Standard_Lang</fullName>
        <field>Interest_Rate_Standard_Language__c</field>
        <formula>&quot;Interest on the Loan shall be payable monthly in arrears, calculated on the basis of actual number of days elapsed in a 360 day year.&quot;+BR()+BR()+&quot;If an Event of Default (as hereinafter defined) has occurred interest shall accrue at an annual rate equal to the Base Rate plus 5.00% (the “Default Rate”).&quot;</formula>
        <name>General - Interest Rate, Standard Lang</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>General_Other_Terms_Conditions_Standard</fullName>
        <field>Other_Terms_Conditions_Standard_Language__c</field>
        <formula>&quot;Shall consist of, but not be limited to, the following:&lt;BR&gt;&lt;BR&gt;a) Satisfactory review of Loan documents and other ancillary documents by Lender and Lender counsel.&lt;BR&gt;b) No material change in Borrower(s) or Guarantor(s) business or general financial condition.&lt;BR&gt;c) Complete loan application, including all due diligence documentation required by Lender.&lt;BR&gt;d) Lender’s legal counsel to review all entity documents.&lt;BR&gt;e) Lender’s legal counsel to prepare all Loan Documents, which Loan Documents will contain usual and customary representations and warranties for transactions of this type.&lt;BR&gt;f) Any other financial and/or documentation which may be required by Lender in its sole and absolute discretion.&quot;</formula>
        <name>General-Other Terms/Conditions, Standard</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>General_Participations_and_Assignments</fullName>
        <field>Participations_and_Assignments__c</field>
        <formula>&quot;BofI may, in its sole discretion, sell participations in the Loan and in its commitment thereunder.&quot;</formula>
        <name>General - Participations and Assignments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LF_Advance_Rate_Standard_Lang</fullName>
        <field>Advance_Rate_s_Standard_Language__c</field>
        <formula>&quot;Any Eligible Receivable secured by real estate requires a property appraisal performed by a Lender approved appraiser.&quot;</formula>
        <name>LF - Advance Rate, Standard Lang</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LF_Borrower_Standard_Language</fullName>
        <field>Borrower_Standard_Language__c</field>
        <formula>&quot;a to-be-formed, single purpose, bankruptcy remote entity.&quot;</formula>
        <name>LF - Borrower, Standard Language</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LF_Cash_Flow_Waterfall</fullName>
        <field>Cash_Flow_Waterfall__c</field>
        <formula>&quot;All proceeds from mortgage loans, net of customary servicing expenses, will be applied as follows:&lt;BR&gt;a. To pay any fees/expenses owed to Lender&lt;BR&gt;b. To cure a Borrowing Base deficiency&lt;BR&gt;c. To pay interest owed to Lender&lt;BR&gt;d. To pay down the outstanding principal balance owed to Lender, until the principal balance equals $0&lt;BR&gt;e. To Borrower provided that no Default or Event of Default has occurred and is continuing&quot;</formula>
        <name>LF - Cash Flow Waterfall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LF_Collateral_Custodian</fullName>
        <field>Collateral_Custodian__c</field>
        <formula>&quot;US Bank or other custodian acceptable to Lender. The fees of the custodian shall be paid by Borrower.&quot;</formula>
        <name>LF - Collateral Custodian</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LF_Collateral_Diversity</fullName>
        <field>Collateral_Diversity__c</field>
        <formula>&quot;Lender may establish collateral diversity requirements, as determined by Lender in its sole and absolute discretion during due diligence, and set forth in the Loan Documents.&quot;</formula>
        <name>LF - Collateral Diversity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LF_Collection_Account</fullName>
        <field>Collection_Account__c</field>
        <formula>&quot;All proceeds from Collateral shall be collected and deposited directly into a restricted account held at the bank.&quot;</formula>
        <name>LF - Collection Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LF_Draw_Requests</fullName>
        <field>Draw_Requests__c</field>
        <formula>&quot;Unless Lender provides advance consent, Borrower shall not be permitted to request draws for less than $100,000 and no more than once per week. Borrower must submit such request by 10:30 am PST in order to draw on the same day as the request.&quot;</formula>
        <name>LF - Draw Requests</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LF_Due_Diligence</fullName>
        <field>Due_Diligence__c</field>
        <formula>&quot;Lender will conduct due diligence on the Guarantor and Principals of the Borrower. Lender shall conduct all diligence deemed necessary and prudent in its sole and absolute discretion. The cost of all due diligence items shall be paid by the Borrower.&quot;</formula>
        <name>LF - Due Diligence</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LF_Eligibility_Criteria_Standard_Lang</fullName>
        <field>Eligibility_Criteria_Standard_Language__c</field>
        <formula>&quot;Lender can reject any advance under the terms of the Loan.&quot;+BR()+BR()+&quot;Collateral shall automatically be deemed Ineligible based on delinquency and duration criteria, as determined at Lender’s sole discretion during underwriting and set forth in the Loan Documents.&quot;</formula>
        <name>LF - Eligibility Criteria, Standard Lang</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LF_Events_of_Default</fullName>
        <field>Events_of_Default__c</field>
        <formula>&quot;Event of Default shall include, but not be limited to, the following:&quot;+BR()+&quot;1. If greater than 15% of the Collateral pledged to the Credit Facility is greater than 60 days delinquent&quot;+BR()+&quot;2. If Borrower fails to remedy a borrowing base deficiency&quot;+BR()+&quot;3. If Borrower fails to maintain the Interest Reserve&quot;+BR()+&quot;4. If Parent or Guarantor takes actions that (i) affect the Borrower’s SPE structure or (ii) results in the consolidation of the Borrower&quot;</formula>
        <name>LF - Events of Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LF_Financial_Reporting_Requirements</fullName>
        <field>Financial_Reporting_Requirements__c</field>
        <formula>&quot;The Borrower, Guarantor, Parent, and Principals may be required to provide, at minimum but not limited to, the following:&quot;+BR()+&quot;a) Internally prepared financial statements&quot;+BR()+&quot;b) Audited financial statements&quot;+BR()+&quot;c) Month-end borrowing base certificate&quot;+BR()+&quot;d) Tax Returns&quot;</formula>
        <name>LF - Financial Reporting Requirements</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LF_Interest_Rate_Standard_Language</fullName>
        <field>Interest_Rate_Standard_Language__c</field>
        <formula>&quot;Interest on the Loan shall be payable monthly in arrears, calculated on the basis of actual number of days elapsed in a 360 day year.&quot;+BR()+BR()+&quot;From and after the occurrence of a default, a default rate of interest equal to 5.0% per annum over the rate otherwise applicable will be payable on demand.&quot;</formula>
        <name>LF - Interest Rate, Standard Language</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LF_Legal_Opinion</fullName>
        <field>Legal_Opinions__c</field>
        <formula>&quot;Borrower will be required to provide certain legal opinions as defined in the LSA, including Corporate matters, Non contravention, Enforceability, Perfection and priority of security interest, Investment Company Act of 1940, True Sale/True Contribution (if applicable), Non-Consolidation. Legal Documents will be governed by New York law.&quot;</formula>
        <name>LF - Legal Opinion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LF_Loan_Amount_Standard_Language</fullName>
        <field>Loan_Amount_Standard_Language__c</field>
        <formula>&quot;The amount available to Borrower under the Loan at any one time shall be based upon the Advance Rates as generally defined below and finalized in diligence.&quot;</formula>
        <name>LF - Loan Amount, Standard Language</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LF_Other_Fees_Standard_Lang</fullName>
        <field>Other_Fee_s_Standard_Language__c</field>
        <formula>&quot;Borrower shall agree to pay fees incurred by Lender for collateral review, including but not limited to required appraisals if Collateral is real estate secured.&quot;</formula>
        <name>LF - Other Fees, Standard Lang</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LF_Other_LOI_Conditions</fullName>
        <field>Other_LOI_Conditions__c</field>
        <formula>&quot;Shall consist of, but not be limited to:&quot;+BR()+&quot;a) No material change in Parent(s), Guarantor(s) or Borrower(s) business or general financial condition.&quot;+BR()+&quot;b) Proof that the Servicer has and maintains Errors &amp; Omissions insurance and a Fidelity Bond, both representing coverage of at least $1 million.&quot;+BR()+&quot;c) Final documentation acceptable to Lender in its sole discretion.&quot;+BR()+&quot;d) Satisfactory review of the Parent’s loan &amp; legal documents and other ancillary documents.&quot;+BR()+&quot;e) Lender shall have the right to complete up to two (2) field exams with costs of each analyst at $850 per day to be paid by Parent.&quot;</formula>
        <name>LF - Other LOI Conditions</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LF_Prepayment_Penalty_Standard_Lang</fullName>
        <field>Prepayment_Penalty_Standard_Language__c</field>
        <formula>&quot;Repayment of Loan resulting from principal payments of individual loans in the normal course of business shall not be subject to the Prepayment Penalty.&quot;</formula>
        <name>LF - Prepayment Penalty, Standard Lang</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LF_Servicing_Servicer</fullName>
        <field>Servicing_Servicer__c</field>
        <formula>&quot;Servicing of Collateral shall be provided by Parent or a third party servicer subject to Lender approval.  Servicing shall include payment reconciliation, collection of payments, compilation of information related to tax reporting (to the extent required) and providing a monthly file which lists such information as requested by Lender. If an Event of Default occurs by either Borrower or Parent and remains uncured, Lender shall have the right to replace the Borrower as servicer with a third party servicer acceptable to Lender in its sole discretion.  Any costs incurred by such replacement servicer shall be the responsibility of the Borrower.&quot;</formula>
        <name>LF - Servicing/Servicer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LF_Transaction_Summary</fullName>
        <field>Transaction_Summary__c</field>
        <formula>&quot;Transaction will be made to a to-be-formed, single purpose, bankruptcy remote entity established to hold qualifying receivables (“Collateral”). The Loan will be secured by a first priority security interest, in and to all Collateral and related assets of the Borrower (Assets), an assignment of contracts as designated by Lender, guaranties of Guarantor and its principals, and such other collateral as Lender may reasonably request in light of the final structure of the transaction and industry custom. Funds will be advanced through an underwriting and funding management process that allows for disbursement of funds as needed. The Loan shall be documented through a Credit Agreement and such collateral documents as may be reasonably requested by Lender in light of the final structure of the transaction and industry custom (the “Loan Documents”).&quot;</formula>
        <name>LF - Transaction Summary</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LF_Wind_Down_Period</fullName>
        <field>Wind_Down_Period__c</field>
        <formula>&quot;At any point after the one year anniversary of Loan Closing, Borrower has the option to initiate a Wind Down Period during which the Lender will not make an Advance and the Minimum Monthly Interest Expense will be waived.&quot;</formula>
        <name>LF - Wind Down Period</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>C%26I%3A BofI Closing Fee is changed and Opportunity is AB Participation</fullName>
        <actions>
            <name>C_I_Update_Closing_Fee_s_AB</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I - Updates the Closing Fee(s) value on the AB Participation Opportunity when the BofI Closing Fee field is updated on an Origination Documentation record.</description>
        <formula>Opportunity_Name__r.RecordType.DeveloperName = &quot;CI_AB_Participation&quot; &amp;&amp;  (ISNEW () || ISCHANGED (  BofI_Closing_Fee__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A BofI Extension Options is changed and Opportunity is AB Participation</fullName>
        <actions>
            <name>C_I_Update_Extension_Option_s_AB</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I - Updates the Extension Option(s) value on the Opportunity when the BofI Extension Option(s) field is updated on an Origination Documentation record.</description>
        <formula>Opportunity_Name__r.RecordType.DeveloperName = &quot;CI_AB_Participation&quot; &amp;&amp; (ISNEW () ||  ISCHANGED (  BofI_Extension_Option_s__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A BofI Loan Amount is changed and Opportunity is AB Participation</fullName>
        <actions>
            <name>C_I_Update_Loan_Amount_AB</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I - Updates the Loan Amount value on AB Participation Opportunity when the BofI Loan Amount field is updated on an Origination Documentation record.</description>
        <formula>Opportunity_Name__r.RecordType.DeveloperName = &quot;CI_AB_Participation&quot; &amp;&amp; (ISNEW () ||  ISCHANGED (BofI_Loan_Amount__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A BofI Rate is changed and Opportunity is AB Participation</fullName>
        <actions>
            <name>C_I_Update_Rate_AB</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I - Updates the Rate value on the AB Participation Opportunity when the BofI Rate field is updated on an Origination Documentation record.</description>
        <formula>Opportunity_Name__r.RecordType.DeveloperName = &quot;CI_AB_Participation&quot; &amp;&amp; (ISNEW () ||  ISCHANGED ( BofI_Rate__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A BofI Term is changed and Opportunity is AB Participation</fullName>
        <actions>
            <name>C_I_Update_Term_AB</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I - Updates the Term value on the AB Participation Opportunity when the BofI Term field is updated on an Origination Documentation record.</description>
        <formula>Opportunity_Name__r.RecordType.DeveloperName = &quot;CI_AB_Participation&quot; &amp;&amp;  (ISNEW () ||  ISCHANGED ( BofI_Term__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A CAM - Fields Populated - FALSE - AB</fullName>
        <actions>
            <name>C_I_CAM_Fields_Populated_FALSE_AB</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I CAM - Checks to see if any AB Participation CAM fields are not populated. Used as entry criteria for the CAM approval process.</description>
        <formula>RecordType.Name = &quot;CAM - AB Participation&quot; &amp;&amp; ( ISBLANK ( Participating_Lenders__c ) || ISBLANK ( Global_Loan_Amount__c ) || ISBLANK ( Collateral_Address_Street__c ) || ISBLANK ( Collateral_Address_City__c ) || ISBLANK ( Collateral_Address_State__c ) || ISBLANK ( Collateral_Address_Zip_Postal_Code__c ) || LEN ( Description_of_Parties_Involved__c ) = 0 || LEN ( Purpose_of_Underlying_Loan__c ) = 0 || LEN ( Underlying_Loan_Terms__c ) = 0 || LEN ( Property_Summary__c ) = 0 || LEN ( Basic_Collateral_Summary__c ) = 0 || LEN ( BofI_Sources_Uses__c ) = 0 || LEN ( Global_Sources_Uses__c ) = 0 || LEN ( Corporate_Org_Chart__c ) = 0 || LEN ( Loan_Legal_Structure_Org_Chart__c ) = 0 || ISBLANK ( Sources_of_Repayment__c ) || ISBLANK ( Release_Price_Description__c ) || ISBLANK ( Events_of_Default__c ) || ISBLANK ( Loan_Purpose__c ) || ISBLANK ( Prepayment_Penalty_Exit_Fee__c ) || LEN ( Cash_Flow_Waterfall__c ) = 0 || LEN ( Other_Terms_Conditions__c ) = 0 || LEN ( Property_History__c ) = 0 || LEN ( Reason_for_Financing__c ) = 0 || LEN ( Exit_Strategies__c ) = 0 || LEN ( Borrowing_Entity_Background__c ) = 0 || LEN ( Principal_s_Bio_s_Resume_s__c ) = 0 || LEN ( Transaction_Background_General_Other__c ) = 0 || LEN ( Detailed_Collateral_Description__c ) = 0 || LEN ( Requirements_for_Project_Financing_Exit__c ) = 0 || LEN ( Exit_Strategy_Feasibility_Analysis__c ) = 0 || LEN ( Property_Description_General_Other__c ) = 0 || LEN ( Appraisal_Summary_Highlights__c ) = 0 || LEN ( As_Is_Value__c ) = 0 || LEN ( As_Complete_Value__c ) = 0 || LEN ( LTV_LTC__c ) = 0 || LEN ( Background__c ) = 0 || LEN ( Business_Strategy_Portfolio_Overview__c ) = 0 || LEN ( Financial_Portfolio_Analysis__c ) = 0 || LEN ( Junior_Participant_General_Other__c ) = 0 || LEN ( Background_Experience__c ) = 0 || LEN ( Financial_Analysis__c ) = 0 || LEN ( Underlying_Borrower_General_Other__c ) = 0 || LEN ( PFS_Analysis__c ) = 0 || LEN ( Cash_Flow_Analysis__c ) = 0 || LEN ( Credit_Report_Findings__c ) = 0 || LEN ( Background_Check_Findings__c ) = 0 || LEN ( Principals_Guarantors_General_Other__c ) = 0 )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A CAM - Fields Populated - FALSE - ALL</fullName>
        <actions>
            <name>C_I_CAM_Fields_Populated_FALSE_ALL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I CAM - Checks to see if any CAM fields that are consistent across all record types are not populated. Used as entry criteria for the CAM approval process.</description>
        <formula>( RecordType.Name = &quot;CAM - Bridge&quot; || RecordType.Name = &quot;CAM - General&quot; || RecordType.Name = &quot;CAM - AB Participation&quot; || RecordType.Name = &quot;CAM - Lender Finance&quot; ) &amp;&amp; ISBLANK ( Borrower_Legal_Name__c ) || LEN ( Guarantor_s__c ) = 0 || LEN ( Guarantor_Type_s__c ) = 0 || ISBLANK ( Loan_Amount__c ) || ISBLANK ( Term__c ) || TEXT ( Payment__c ) = &quot;&quot; || ISBLANK (CI_Rate__c ) || ISBLANK ( Interest_Reserve__c ) || LEN ( Advance_Rate_s__c ) = 0 || ISBLANK ( Closing_Fee_s__c ) || TEXT ( Loan_Structure__c ) = &quot;&quot; || ISBLANK ( Extension_Option_s__c ) || ISBLANK (CI_Rate_Description__c ) || LEN ( Collateral__c ) = 0 || LEN ( Pictures_Attachments__c ) = 0 || TEXT ( Risk_Rating__c ) = &quot;&quot; || ISBLANK ( Related_Exposure__c ) || ISBLANK ( NAICS_Code__c ) || ISBLANK ( Policy_Exceptions__c ) || ISBLANK ( Guideline_Exceptions__c ) || ISBLANK ( CAM_C_I_Signer_1__c ) || ISBLANK ( CAM_C_I_Signer_2__c ) || ISBLANK ( CAM_C_I_Signer_3__c ) || ISBLANK ( CAM_C_I_Signer_1_Title__c ) || ISBLANK ( CAM_C_I_Signer_2_Title__c ) || ISBLANK ( CAM_C_I_Signer_3_Title__c ) || LEN ( Transaction_Overview_General_Other__c ) = 0 || TEXT ( OFAC_Results_for_All_Entities__c ) = &quot;&quot; || TEXT ( Relevant_Negative_Media_Found__c ) = &quot;&quot; || TEXT ( Foreign_Offshore_Entities_20_Found__c ) = &quot;&quot; || TEXT ( If_Match_cleared_by_BSA_Compliance__c ) = &quot;&quot; || ISBLANK ( Summarize_Negative_Media_Findings__c ) || TEXT ( If_Foreign_Nationals_NRA_approved_by_BS__c ) = &quot;&quot; || ISBLANK ( Conditions_of_Extension__c ) || LEN ( Pre_Close_Conditions__c ) = 0 || LEN ( Post_Close_Conditions__c ) = 0 || ISBLANK ( Financial_Reporting_Requirements__c ) || ISBLANK ( Other_Reporting_Requirements__c ) || LEN ( Deal_Strengths__c ) = 0 || LEN ( Risks_Mitigants__c ) = 0 || LEN ( Collateral_Analysis_General_Other__c ) = 0 || LEN ( Rating_Matrix__c ) = 0 || LEN ( Borrower_Scorecard__c ) = 0 || LEN ( Transaction_Recap__c ) = 0 || LEN ( Recommendation__c ) = 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A CAM - Fields Populated - FALSE - BRI</fullName>
        <actions>
            <name>C_I_CAM_Fields_Populated_FALSE_BRI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I CAM - Checks to see if any Bridge CAM fields are not populated. Used as entry criteria for the CAM approval process.</description>
        <formula>RecordType.Name = &quot;CAM - Bridge&quot; &amp;&amp; ( ISBLANK ( Collateral_Address_Street__c ) || ISBLANK ( Collateral_Address_City__c ) || ISBLANK ( Collateral_Address_State__c ) || ISBLANK ( Collateral_Address_Zip_Postal_Code__c ) || LEN ( Property_Summary__c ) = 0 || LEN ( Borrowing_Entity_Background__c ) = 0 || LEN ( Principal_s_Bio_s_Resume_s__c ) = 0 || LEN ( Transaction_Overview_Loan_Purpose__c ) = 0 || LEN ( Sources_Uses__c ) = 0 || LEN ( Description__c ) = 0 || LEN ( Borrower_Org_Chart_Vesting_Tree__c ) = 0 || LEN ( Other_Fee_s__c ) = 0 || ISBLANK ( Loan_Purpose__c ) || ISBLANK ( Exit_Fee_s__c ) || ISBLANK ( Sources_of_Repayment__c ) || LEN ( Other_Terms_Conditions__c ) = 0 || LEN ( Property_History__c ) = 0 || LEN ( Reason_for_Financing__c ) = 0 || LEN ( Transaction_Background_General_Other__c ) = 0 || LEN ( Detailed_Collateral_Description__c ) = 0 || LEN ( Requirements_for_Project_Financing_Exit__c ) = 0 || LEN ( Exit_Strategy_Feasibility_Analysis__c ) = 0 || LEN ( Property_Description_General_Other__c ) = 0 || LEN ( Appraisal_Summary_Highlights__c ) = 0 || LEN ( As_Is_Value__c ) = 0 || LEN ( As_Complete_Value__c ) = 0 || LEN ( LTV_LTC__c ) = 0 || LEN ( Entity_Structure_and_Other_Assets_Held__c ) = 0 || LEN ( Financial_Analysis__c ) = 0 || LEN ( Borrowing_Entity_General_Other__c ) = 0 || LEN ( PFS_Analysis__c ) = 0 || LEN ( Cash_Flow_Analysis__c ) = 0 || LEN ( Credit_Report_Findings__c ) = 0 || LEN ( Background_Check_Findings__c ) = 0 || LEN ( Principals_Guarantors_General_Other__c ) = 0 )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A CAM - Fields Populated - FALSE - GEN</fullName>
        <actions>
            <name>C_I_CAM_Fields_Populated_FALSE_GEN</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I CAM - Checks to see if any General CAM fields are not populated. Used as entry criteria for the CAM approval process.</description>
        <formula>RecordType.Name = &quot;CAM - General&quot; &amp;&amp; ( ISBLANK ( Location_Address__c ) || LEN ( Background_Experience_General_Other__c ) = 0 || LEN ( Corporate_Legal_Loan_Diagrams__c ) = 0 || LEN ( Organizational_Charts_General_Other__c ) = 0 || ISBLANK ( Loan_Purpose__c ) || ISBLANK ( Prepayment_Penalty_Exit_Fee__c ) || ISBLANK ( Events_of_Default__c ) || LEN ( Other_Fee_s__c ) = 0 || ISBLANK ( Sources_of_Repayment__c ) || LEN ( Other_Terms__c ) = 0 || LEN ( Other_Conditions__c ) = 0 || LEN ( Transaction_Background_General_Other__c ) = 0 || LEN ( Sources_Uses_General_Other__c ) = 0 || LEN ( Financial_Analysis_General_Other__c ) = 0 || LEN ( Guarantors_General_Other__c ) = 0 || LEN ( Misc_General_Other__c ) = 0 )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A CAM - Fields Populated - FALSE - LF</fullName>
        <actions>
            <name>C_I_CAM_Fields_Populated_FALSE_LF</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I CAM - Checks to see if any Lender Finance CAM fields are not populated. Used as entry criteria for the CAM approval process.</description>
        <formula>RecordType.Name = &quot;CAM - Lender Finance&quot; &amp;&amp; ( ISBLANK ( Location_Address__c ) || LEN ( Company_Background__c ) = 0 || LEN ( Purpose_of_Funds_Request_Rationale__c ) = 0 || LEN ( Deal_Thesis__c ) = 0 || LEN ( Opportunity_Overview__c ) = 0 || LEN ( Sources_Uses__c ) = 0 || LEN ( Corporate_Org_Chart__c ) = 0 || LEN ( Legal_Org_Chart__c ) = 0 || ISBLANK ( Product_Type__c ) || LEN ( Uses_of_Funds__c ) = 0 || LEN ( Other_Fee_s__c ) = 0 || LEN ( Wind_Down_Period__c ) = 0 || ISBLANK ( Release_Price_Description__c ) || LEN ( Repayment_Exit_Strategy__c ) = 0 || LEN ( Eligibility_Criteria__c ) = 0 || ISBLANK ( Collateral_Custodian__c ) || ISBLANK ( Draw_Requests__c ) || ISBLANK ( Events_of_Default__c ) || ISBLANK ( Prepayment_Penalty__c ) || ISBLANK ( Collateral_Diversity__c ) || ISBLANK ( Servicing_Servicer__c ) || LEN ( Cash_Flow_Waterfall__c ) = 0 || LEN ( Industry_Market__c ) = 0 || LEN ( Borrower_Business_Strategy__c ) = 0 || LEN ( Borrower_Product_Descriptions_Details__c ) = 0 || LEN ( Management_Background_Experience__c ) = 0 || LEN ( New_Business_Sources__c ) = 0 || LEN ( Underlying_Borrower_Profile__c ) = 0 || LEN ( Origination_Process__c ) = 0 || LEN ( Underwriting_Standards_and_Process__c ) = 0 || LEN ( Licenses_Held_States_of_Operation__c ) = 0 || LEN ( Servicing__c ) = 0 || LEN ( Portfolio_Monitoring__c ) = 0 || LEN ( Renewal_Modification_ReWrite_Policy__c ) = 0 || LEN ( Reserves_Write_offs__c ) = 0 || LEN ( Historic_Volumes_Performance_Metrics__c ) = 0 || LEN ( Current_Volumes_Performance_Metrics__c ) = 0 || LEN ( Portfolio_Overview_General_Other__c ) = 0 || LEN ( Loan_Tape_Analysis__c ) = 0 || LEN ( Base_Case_Static_Wind_Down__c ) = 0 || LEN ( Stress_Case_Static_Wind_Down__c ) = 0 || LEN ( Cash_Flow_Diagram__c ) = 0 || LEN ( Origination_Assignment_Diagram__c ) = 0 || LEN ( Deal_Specific_Operations__c ) = 0 || LEN ( BofI_Borrower_General_Other__c ) = 0 || LEN ( Balance_Sheet_Analysis__c ) = 0 || LEN ( Income_Statement_Analysis__c ) = 0 || LEN ( Trends_Ratios__c ) = 0 || LEN ( Projection_Analysis__c ) = 0 || LEN ( Financial_Analysis_General_Other__c ) = 0 || LEN ( Background_Check_Findings__c ) = 0 || LEN ( Credit_Report_Findings__c ) = 0 || LEN ( Guarantors_General_Other__c ) = 0 )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A CAM - Fields Populated - TRUE - AB</fullName>
        <actions>
            <name>C_I_CAM_Fields_Populated_TRUE_AB</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I CAM - Checks to see if all AB Participation CAM fields are populated. Used as entry criteria for the CAM approval process.</description>
        <formula>RecordType.Name = &quot;CAM - AB Participation&quot; &amp;&amp; NOT ( ISBLANK ( Participating_Lenders__c ) ) &amp;&amp; NOT ( ISBLANK ( Global_Loan_Amount__c ) ) &amp;&amp; NOT ( ISBLANK ( Collateral_Address_Street__c ) ) &amp;&amp; NOT ( ISBLANK ( Collateral_Address_City__c ) ) &amp;&amp; NOT ( ISBLANK ( Collateral_Address_State__c ) ) &amp;&amp; NOT ( ISBLANK ( Collateral_Address_Zip_Postal_Code__c ) ) &amp;&amp; LEN ( Description_of_Parties_Involved__c ) != 0 &amp;&amp; LEN ( Purpose_of_Underlying_Loan__c ) != 0 &amp;&amp; LEN ( Underlying_Loan_Terms__c ) != 0 &amp;&amp; LEN ( Property_Summary__c ) != 0 &amp;&amp; LEN ( Basic_Collateral_Summary__c ) != 0 &amp;&amp; LEN ( BofI_Sources_Uses__c ) != 0 &amp;&amp; LEN ( Global_Sources_Uses__c ) != 0 &amp;&amp; LEN ( Corporate_Org_Chart__c ) != 0 &amp;&amp; LEN ( Loan_Legal_Structure_Org_Chart__c ) != 0 &amp;&amp; NOT ( ISBLANK ( Sources_of_Repayment__c ) ) &amp;&amp; NOT ( ISBLANK ( Release_Price_Description__c ) ) &amp;&amp; NOT ( ISBLANK ( Events_of_Default__c ) ) &amp;&amp; NOT ( ISBLANK ( Loan_Purpose__c ) ) &amp;&amp; NOT ( ISBLANK ( Prepayment_Penalty_Exit_Fee__c ) ) &amp;&amp; LEN ( Cash_Flow_Waterfall__c ) != 0 &amp;&amp; LEN ( Other_Terms_Conditions__c ) != 0 &amp;&amp; LEN ( Property_History__c ) != 0 &amp;&amp; LEN ( Reason_for_Financing__c ) != 0 &amp;&amp; LEN ( Exit_Strategies__c ) != 0 &amp;&amp; LEN ( Borrowing_Entity_Background__c ) != 0 &amp;&amp; LEN ( Principal_s_Bio_s_Resume_s__c ) != 0 &amp;&amp; LEN ( Transaction_Background_General_Other__c ) != 0 &amp;&amp; LEN ( Detailed_Collateral_Description__c ) != 0 &amp;&amp; LEN ( Requirements_for_Project_Financing_Exit__c ) != 0 &amp;&amp; LEN ( Exit_Strategy_Feasibility_Analysis__c ) != 0 &amp;&amp; LEN ( Property_Description_General_Other__c ) != 0 &amp;&amp; LEN ( Appraisal_Summary_Highlights__c ) != 0 &amp;&amp; LEN ( As_Is_Value__c ) != 0 &amp;&amp; LEN ( As_Complete_Value__c ) != 0 &amp;&amp; LEN ( LTV_LTC__c ) != 0 &amp;&amp; LEN ( Background__c ) != 0 &amp;&amp; LEN ( Business_Strategy_Portfolio_Overview__c ) != 0 &amp;&amp; LEN ( Financial_Portfolio_Analysis__c ) != 0 &amp;&amp; LEN ( Junior_Participant_General_Other__c ) != 0 &amp;&amp; LEN ( Background_Experience__c ) != 0 &amp;&amp; LEN ( Financial_Analysis__c ) != 0 &amp;&amp; LEN ( Underlying_Borrower_General_Other__c ) != 0 &amp;&amp; LEN ( PFS_Analysis__c ) != 0 &amp;&amp; LEN ( Cash_Flow_Analysis__c ) != 0 &amp;&amp; LEN ( Credit_Report_Findings__c ) != 0 &amp;&amp; LEN ( Background_Check_Findings__c ) != 0 &amp;&amp; LEN ( Principals_Guarantors_General_Other__c ) != 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A CAM - Fields Populated - TRUE - ALL</fullName>
        <actions>
            <name>C_I_CAM_Fields_Populated_TRUE_ALL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I CAM - Checks to see if all CAM fields that are consistent across all record types are populated. Used as entry criteria for the CAM approval process.</description>
        <formula>( RecordType.Name = &quot;CAM - Bridge&quot; || RecordType.Name = &quot;CAM - General&quot; || RecordType.Name = &quot;CAM - AB Participation&quot; || RecordType.Name = &quot;CAM - Lender Finance&quot; ) &amp;&amp; NOT ( ISBLANK ( Borrower_Legal_Name__c ) ) &amp;&amp; Guarantor_s__c != NULL &amp;&amp; LEN ( Guarantor_Type_s__c ) != 0 &amp;&amp; NOT ( ISBLANK ( Loan_Amount__c ) ) &amp;&amp; NOT ( ISBLANK ( Term__c ) ) &amp;&amp; TEXT ( Payment__c ) != &quot;&quot; &amp;&amp; NOT ( ISBLANK (CI_Rate__c ) ) &amp;&amp; NOT ( ISBLANK ( Interest_Reserve__c ) ) &amp;&amp; LEN ( Advance_Rate_s__c ) != 0 &amp;&amp; NOT ( ISBLANK ( Closing_Fee_s__c ) ) &amp;&amp; TEXT ( Loan_Structure__c ) != &quot;&quot; &amp;&amp; NOT ( ISBLANK ( Extension_Option_s__c ) ) &amp;&amp; NOT ( ISBLANK (CI_Rate_Description__c ) ) &amp;&amp; LEN ( Collateral__c ) != 0 &amp;&amp; LEN ( Pictures_Attachments__c ) != 0 &amp;&amp; TEXT ( Risk_Rating__c ) != &quot;&quot; &amp;&amp; NOT ( ISBLANK ( Related_Exposure__c ) ) &amp;&amp; NOT ( ISBLANK ( NAICS_Code__c ) ) &amp;&amp; NOT ( ISBLANK ( Policy_Exceptions__c ) ) &amp;&amp; NOT ( ISBLANK ( Guideline_Exceptions__c ) ) &amp;&amp; NOT ( ISBLANK ( CAM_C_I_Signer_1__c ) ) &amp;&amp; NOT ( ISBLANK ( CAM_C_I_Signer_2__c ) ) &amp;&amp; NOT ( ISBLANK ( CAM_C_I_Signer_3__c ) ) &amp;&amp; NOT ( ISBLANK ( CAM_C_I_Signer_1_Title__c ) ) &amp;&amp; NOT ( ISBLANK ( CAM_C_I_Signer_2_Title__c ) ) &amp;&amp; NOT ( ISBLANK ( CAM_C_I_Signer_3_Title__c ) ) &amp;&amp; LEN ( Transaction_Overview_General_Other__c ) != 0 &amp;&amp; TEXT ( OFAC_Results_for_All_Entities__c ) != &quot;&quot; &amp;&amp; TEXT ( Relevant_Negative_Media_Found__c ) != &quot;&quot; &amp;&amp; TEXT ( Foreign_Offshore_Entities_20_Found__c ) != &quot;&quot; &amp;&amp; TEXT ( If_Match_cleared_by_BSA_Compliance__c ) != &quot;&quot; &amp;&amp; NOT ( ISBLANK ( Summarize_Negative_Media_Findings__c ) ) &amp;&amp; TEXT ( If_Foreign_Nationals_NRA_approved_by_BS__c ) != &quot;&quot; &amp;&amp; NOT ( ISBLANK ( Conditions_of_Extension__c ) ) &amp;&amp; LEN ( Pre_Close_Conditions__c ) != 0 &amp;&amp; LEN ( Post_Close_Conditions__c ) != 0 &amp;&amp; NOT ( ISBLANK ( Financial_Reporting_Requirements__c ) ) &amp;&amp; NOT ( ISBLANK ( Other_Reporting_Requirements__c ) ) &amp;&amp; LEN ( Deal_Strengths__c ) != 0 &amp;&amp; LEN ( Risks_Mitigants__c ) != 0 &amp;&amp; LEN ( Collateral_Analysis_General_Other__c ) != 0 &amp;&amp; LEN ( Rating_Matrix__c ) != 0 &amp;&amp; LEN ( Borrower_Scorecard__c ) != 0 &amp;&amp; LEN ( Transaction_Recap__c ) != 0 &amp;&amp; LEN ( Recommendation__c ) != 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A CAM - Fields Populated - TRUE - BRI</fullName>
        <actions>
            <name>C_I_CAM_Fields_Populated_TRUE_BRI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I CAM - Checks to see if all Bridge CAM fields are populated. Used as entry criteria for the CAM approval process.</description>
        <formula>RecordType.Name = &quot;CAM - Bridge&quot; &amp;&amp; NOT ( ISBLANK ( Collateral_Address_Street__c ) ) &amp;&amp; NOT ( ISBLANK ( Collateral_Address_City__c ) ) &amp;&amp; NOT ( ISBLANK ( Collateral_Address_State__c ) ) &amp;&amp; NOT ( ISBLANK ( Collateral_Address_Zip_Postal_Code__c ) ) &amp;&amp; LEN ( Property_Summary__c ) != 0 &amp;&amp; LEN ( Borrowing_Entity_Background__c ) != 0 &amp;&amp; LEN ( Principal_s_Bio_s_Resume_s__c ) != 0 &amp;&amp; LEN ( Transaction_Overview_Loan_Purpose__c ) != 0 &amp;&amp; LEN ( Sources_Uses__c ) != 0 &amp;&amp; LEN ( Description__c ) != 0 &amp;&amp; LEN ( Borrower_Org_Chart_Vesting_Tree__c ) != 0 &amp;&amp; LEN ( Other_Fee_s__c ) != 0 &amp;&amp; NOT ( ISBLANK ( Loan_Purpose__c ) ) &amp;&amp; NOT ( ISBLANK ( Exit_Fee_s__c ) ) &amp;&amp; NOT ( ISBLANK ( Sources_of_Repayment__c ) ) &amp;&amp; LEN ( Other_Terms_Conditions__c ) != 0 &amp;&amp; LEN ( Property_History__c ) != 0 &amp;&amp; LEN ( Reason_for_Financing__c ) != 0 &amp;&amp; LEN ( Transaction_Background_General_Other__c ) != 0 &amp;&amp; LEN ( Detailed_Collateral_Description__c ) != 0 &amp;&amp; LEN ( Requirements_for_Project_Financing_Exit__c ) != 0 &amp;&amp; LEN ( Exit_Strategy_Feasibility_Analysis__c ) != 0 &amp;&amp; LEN ( Property_Description_General_Other__c ) != 0 &amp;&amp; LEN ( Appraisal_Summary_Highlights__c ) != 0 &amp;&amp; LEN ( As_Is_Value__c ) != 0 &amp;&amp; LEN ( As_Complete_Value__c ) != 0 &amp;&amp; LEN ( LTV_LTC__c ) != 0 &amp;&amp; LEN ( Entity_Structure_and_Other_Assets_Held__c ) != 0 &amp;&amp; LEN ( Financial_Analysis__c ) != 0 &amp;&amp; LEN ( Borrowing_Entity_General_Other__c ) != 0 &amp;&amp; LEN ( PFS_Analysis__c ) != 0 &amp;&amp; LEN ( Cash_Flow_Analysis__c ) != 0 &amp;&amp; LEN ( Credit_Report_Findings__c ) != 0 &amp;&amp; LEN ( Background_Check_Findings__c ) != 0 &amp;&amp; LEN ( Principals_Guarantors_General_Other__c ) != 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A CAM - Fields Populated - TRUE - GEN</fullName>
        <actions>
            <name>C_I_CAM_Fields_Populated_TRUE_GEN</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I CAM - Checks to see if all General CAM fields are populated. Used as entry criteria for the CAM approval process.</description>
        <formula>RecordType.Name = &quot;CAM - General&quot; &amp;&amp; NOT ( ISBLANK ( Location_Address__c ) ) &amp;&amp; LEN ( Background_Experience_General_Other__c ) != 0 &amp;&amp; LEN ( Corporate_Legal_Loan_Diagrams__c ) != 0 &amp;&amp; LEN ( Organizational_Charts_General_Other__c ) != 0 &amp;&amp; NOT ( ISBLANK ( Loan_Purpose__c ) ) &amp;&amp; NOT ( ISBLANK ( Prepayment_Penalty_Exit_Fee__c ) ) &amp;&amp; NOT ( ISBLANK ( Events_of_Default__c ) ) &amp;&amp; LEN ( Other_Fee_s__c ) != 0 &amp;&amp; NOT ( ISBLANK ( Sources_of_Repayment__c ) ) &amp;&amp; LEN ( Other_Terms__c ) != 0 &amp;&amp; LEN ( Other_Conditions__c ) != 0 &amp;&amp; LEN ( Transaction_Background_General_Other__c ) != 0 &amp;&amp; LEN ( Sources_Uses_General_Other__c ) != 0 &amp;&amp; LEN ( Financial_Analysis_General_Other__c ) != 0 &amp;&amp; LEN ( Guarantors_General_Other__c ) != 0 &amp;&amp; LEN ( Misc_General_Other__c ) != 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A CAM - Fields Populated - TRUE - LF</fullName>
        <actions>
            <name>C_I_CAM_Fields_Populated_TRUE_LF</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I CAM - Checks to see if all Lender Finance CAM fields are populated. Used as entry criteria for the CAM approval process.</description>
        <formula>RecordType.Name = &quot;CAM - Lender Finance&quot; &amp;&amp; NOT ( ISBLANK ( Location_Address__c ) ) &amp;&amp; LEN ( Company_Background__c ) != 0 &amp;&amp; LEN ( Purpose_of_Funds_Request_Rationale__c ) != 0 &amp;&amp; LEN ( Deal_Thesis__c ) != 0 &amp;&amp; LEN ( Opportunity_Overview__c ) != 0 &amp;&amp; LEN ( Sources_Uses__c ) != 0 &amp;&amp; LEN ( Corporate_Org_Chart__c ) != 0 &amp;&amp; LEN ( Legal_Org_Chart__c ) != 0 &amp;&amp; NOT ( ISBLANK ( Product_Type__c ) ) &amp;&amp; LEN ( Uses_of_Funds__c ) != 0 &amp;&amp; LEN ( Other_Fee_s__c ) != 0 &amp;&amp; LEN ( Wind_Down_Period__c ) != 0 &amp;&amp; NOT ( ISBLANK ( Release_Price_Description__c ) ) &amp;&amp; LEN ( Repayment_Exit_Strategy__c ) != 0 &amp;&amp; LEN ( Eligibility_Criteria__c ) != 0 &amp;&amp; NOT ( ISBLANK ( Collateral_Custodian__c ) ) &amp;&amp; NOT ( ISBLANK ( Draw_Requests__c ) ) &amp;&amp; NOT ( ISBLANK ( Events_of_Default__c ) ) &amp;&amp; NOT ( ISBLANK ( Prepayment_Penalty__c ) ) &amp;&amp; NOT ( ISBLANK ( Collateral_Diversity__c ) ) &amp;&amp; NOT ( ISBLANK ( Servicing_Servicer__c ) ) &amp;&amp; LEN ( Cash_Flow_Waterfall__c ) != 0 &amp;&amp; LEN ( Industry_Market__c ) != 0 &amp;&amp; LEN ( Borrower_Business_Strategy__c ) != 0 &amp;&amp; LEN ( Borrower_Product_Descriptions_Details__c ) != 0 &amp;&amp; LEN ( Management_Background_Experience__c ) != 0 &amp;&amp; LEN ( New_Business_Sources__c ) != 0 &amp;&amp; LEN ( Underlying_Borrower_Profile__c ) != 0 &amp;&amp; LEN ( Origination_Process__c ) != 0 &amp;&amp; LEN ( Underwriting_Standards_and_Process__c ) != 0 &amp;&amp; LEN ( Licenses_Held_States_of_Operation__c ) != 0 &amp;&amp; LEN ( Servicing__c ) != 0 &amp;&amp; LEN ( Portfolio_Monitoring__c ) != 0 &amp;&amp; LEN ( Renewal_Modification_ReWrite_Policy__c ) != 0 &amp;&amp; LEN ( Reserves_Write_offs__c ) != 0 &amp;&amp; LEN ( Historic_Volumes_Performance_Metrics__c ) != 0 &amp;&amp; LEN ( Current_Volumes_Performance_Metrics__c ) != 0 &amp;&amp; LEN ( Portfolio_Overview_General_Other__c ) != 0 &amp;&amp; LEN ( Loan_Tape_Analysis__c ) != 0 &amp;&amp; LEN ( Base_Case_Static_Wind_Down__c ) != 0 &amp;&amp; LEN ( Stress_Case_Static_Wind_Down__c ) != 0 &amp;&amp; LEN ( Cash_Flow_Diagram__c ) != 0 &amp;&amp; LEN ( Origination_Assignment_Diagram__c ) != 0 &amp;&amp; LEN ( Deal_Specific_Operations__c ) != 0 &amp;&amp; LEN ( BofI_Borrower_General_Other__c ) != 0 &amp;&amp; LEN ( Balance_Sheet_Analysis__c ) != 0 &amp;&amp; LEN ( Income_Statement_Analysis__c ) != 0 &amp;&amp; LEN ( Trends_Ratios__c ) != 0 &amp;&amp; LEN ( Projection_Analysis__c ) != 0 &amp;&amp; LEN ( Financial_Analysis_General_Other__c ) != 0 &amp;&amp; LEN ( Background_Check_Findings__c ) != 0 &amp;&amp; LEN ( Credit_Report_Findings__c ) != 0 &amp;&amp; LEN ( Guarantors_General_Other__c ) != 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Closing Fees has changed and Opportunity is not AB Participation</fullName>
        <actions>
            <name>C_I_Update_Closing_Fee_s</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I - Updates the Closing Fee(s) value on the Opportunity when the same field is updated on an Origination Documentation record.</description>
        <formula>Opportunity_Name__r.RecordType.DeveloperName != &quot;CI_AB_Participation&quot; &amp;&amp;  (ISNEW () || ISCHANGED ( Closing_Fee_s__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Collateral Description is changed and Opportunity is AB Participation</fullName>
        <actions>
            <name>C_I_Update_Collateral_AB</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I - Updates the Collateral value on the AB Participation Opportunity when the Collateral Description field is updated on an Origination Documentation record.</description>
        <formula>Opportunity_Name__r.RecordType.DeveloperName = &quot;CI_AB_Participation&quot; &amp;&amp;  (ISNEW () ||  ISCHANGED (  Collateral_Description__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Collateral is changed and Opportunity is not AB Participation</fullName>
        <actions>
            <name>C_I_Update_Collateral</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I - Updates the Collateral value on the Opportunity when the same field is updated on an Origination Documentation record.</description>
        <formula>Opportunity_Name__r.RecordType.DeveloperName != &quot;CI_AB_Participation&quot; &amp;&amp;  (ISNEW () ||  ISCHANGED ( Collateral__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Extension Options is changed and Opportunity is not AB Participation</fullName>
        <actions>
            <name>C_I_Update_Extension_Option_s</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I - Updates the Extension Option(s) value on the Opportunity when the same field is updated on an Origination Documentation record.</description>
        <formula>Opportunity_Name__r.RecordType.DeveloperName != &quot;CI_AB_Participation&quot; &amp;&amp; (ISNEW () ||  ISCHANGED ( Extension_Option_s__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Guarantor Types is changed</fullName>
        <actions>
            <name>C_I_Update_Guarantor_Type_s</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I - Updates the Guarantor Type(s) value on the Opportunity when the same field is updated on an Origination Documentation record.</description>
        <formula>ISNEW () ||  ISCHANGED ( Guarantor_Type_s__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Guarantors is changed</fullName>
        <actions>
            <name>C_I_Update_Guarantor_s</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I - Updates the Guarantor(s) value on the Opportunity when the same field is updated on an Origination Documentation record.</description>
        <formula>ISNEW () ||  ISCHANGED ( Guarantor_s__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A LOI - AB Participation Standard Language 1</fullName>
        <actions>
            <name>AB_Advance_Rates_Standard_Language</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AB_Borrower_Standard_Language</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AB_Cash_Flow_Waterfall</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AB_Interest_Rate_Standard_Language</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AB_Junior_Participant_Release_Event</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AB_Loan_Purpose_Standard_Language</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AB_Participating_Lender_Standard_Lang</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AB_Repurchase_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AB_Repurchase_Requirement</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AB_Servicing_Servicer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Documentation__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>LOI - AB Participation</value>
        </criteriaItems>
        <description>C&amp;I LOI - Updates the Standard Language for the LOI - AB Participation (fields 1-10).</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A LOI - AB Participation Standard Language 2</fullName>
        <actions>
            <name>AB_Due_Diligence</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AB_Events_of_Default</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AB_Other_Terms_Conditions_Standard</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AB_Participations_and_Assignments</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Documentation__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>LOI - AB Participation</value>
        </criteriaItems>
        <description>C&amp;I LOI - Updates the Standard Language for the LOI - AB Participation (fields 11-14).</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A LOI - Bridge Standard Language 1</fullName>
        <actions>
            <name>Bridge_Advance_Rate_Standard_Language</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Bridge_Borrower_Standard_Lanaguage</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Bridge_Cash_Flow_Waterfall</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Bridge_Due_Diligence</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Bridge_Events_of_Default</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Bridge_Interest_Rate_Standard_Lang</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Bridge_Other_Terms_Conditions_Standard</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Bridge_Participations_and_Assignments</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Documentation__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>LOI - Bridge</value>
        </criteriaItems>
        <description>C&amp;I LOI - Updates the Standard Language for the LOI - Bridge (fields 1-8).</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A LOI - General Standard Language 1</fullName>
        <actions>
            <name>General_Cash_Flow_Waterfall</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>General_Collateral_Standard_Language</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>General_Due_Diligence</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>General_Events_of_Default</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>General_Interest_Rate_Standard_Lang</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>General_Other_Terms_Conditions_Standard</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>General_Participations_and_Assignments</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Documentation__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>LOI - General</value>
        </criteriaItems>
        <description>C&amp;I LOI - Updates the Standard Language for the LOI - General (fields 1-7).</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A LOI - Lender Finance Standard Language 1</fullName>
        <actions>
            <name>LF_Advance_Rate_Standard_Lang</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LF_Borrower_Standard_Language</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LF_Collateral_Diversity</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LF_Eligibility_Criteria_Standard_Lang</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LF_Interest_Rate_Standard_Language</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LF_Loan_Amount_Standard_Language</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LF_Other_Fees_Standard_Lang</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LF_Prepayment_Penalty_Standard_Lang</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LF_Transaction_Summary</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LF_Wind_Down_Period</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Documentation__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>LOI - Lender Finance</value>
        </criteriaItems>
        <description>C&amp;I LOI - Updates the Standard Language for the LOI - Lender Finance (fields 1-10).</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A LOI - Lender Finance Standard Language 2</fullName>
        <actions>
            <name>LF_Cash_Flow_Waterfall</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LF_Collateral_Custodian</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LF_Collection_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LF_Draw_Requests</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LF_Due_Diligence</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LF_Events_of_Default</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LF_Financial_Reporting_Requirements</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LF_Legal_Opinion</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LF_Other_LOI_Conditions</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LF_Servicing_Servicer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Documentation__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>LOI - Lender Finance</value>
        </criteriaItems>
        <description>C&amp;I LOI - Updates the Standard Language for the LOI - Lender Finance (fields 11-20).</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Loan Amount is changed and Opportunity is not AB Participation</fullName>
        <actions>
            <name>C_I_Update_Loan_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I - Updates the Loan Amount value on the Opportunity when the same field is updated on an Origination Documentation record.</description>
        <formula>Opportunity_Name__r.RecordType.DeveloperName != &quot;CI_AB_Participation&quot; &amp;&amp; (ISNEW () ||  ISCHANGED (  Loan_Amount__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Loan Amount is changed and Record Type is PIC</fullName>
        <actions>
            <name>C_I_Update_PIC_Loan_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I - Updates the Loan Amount value on the Opportunity when the same field is updated on an PIC Origination Documentation record.</description>
        <formula>( ISCHANGED ( Loan_Amount__c ) || ISNEW () ) &amp;&amp; ( RecordType.Name = &quot;PIC - General&quot; || RecordType.Name = &quot;PIC - AB Participation&quot; || RecordType.Name = &quot;PIC - Lender Finance&quot; || RecordType.Name = &quot;PIC - Bridge&quot; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Loan Structure is Multi Draw Term</fullName>
        <actions>
            <name>C_I_Update_Loan_Structure_Multi</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Documentation__c.Loan_Structure__c</field>
            <operation>equals</operation>
            <value>Multi Draw Term</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Loan Structure value to Multi Draw Term on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Loan Structure is Revolving</fullName>
        <actions>
            <name>C_I_Update_Loan_Structure_Revolving</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Documentation__c.Loan_Structure__c</field>
            <operation>equals</operation>
            <value>Revolving</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Loan Structure value to Revolving on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Loan Structure is Term</fullName>
        <actions>
            <name>C_I_Update_Loan_Structure_Term</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Documentation__c.Loan_Structure__c</field>
            <operation>equals</operation>
            <value>Term</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Loan Structure value to Term on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Loan Structure is empty</fullName>
        <actions>
            <name>C_I_Update_Loan_Structure_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Documentation__c.Loan_Structure__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>C&amp;I - Updates the Loan Structure value to null on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A PIC - Fields Populated - FALSE</fullName>
        <actions>
            <name>C_I_PIC_Fields_Populated_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I PIC - Checks to see if any PIC fields are not populated. Used as entry criteria for the PIC approval process.</description>
        <formula>( ( RecordType.Name = &quot;PIC - Bridge&quot; || RecordType.Name = &quot;PIC - General&quot; || RecordType.Name = &quot;PIC - AB Participation&quot; || RecordType.Name = &quot;PIC - Lender Finance&quot; ) &amp;&amp; ISBLANK ( Borrower_Legal_Name__c ) || ISBLANK ( Existing_Client__c ) || LEN ( Guarantor_s__c ) = 0 || ISBLANK ( Projected_Close_Date__c ) || ISBLANK ( Loan_Purpose__c ) || LEN ( Guarantor_Type_s__c ) = 0 || ISBLANK ( Loan_Amount__c ) || ISBLANK ( Term__c ) || TEXT ( Payment__c ) = &quot;&quot; || ISBLANK (CI_Rate__c ) || ISBLANK ( Interest_Reserve__c ) || LEN ( Advance_Rate_s__c ) = 0 || ISBLANK ( Closing_Fee_s__c ) || TEXT ( Loan_Structure__c ) = &quot;&quot; || ISBLANK ( Extension_Option_s__c ) || LEN ( Repayment_Exit_Strategy__c ) = 0 || ISBLANK ( Payment_Description__c ) || ISBLANK (CI_Rate_Description__c ) || LEN ( Collateral__c ) = 0 || LEN ( Other_Fee_s__c ) = 0 || LEN ( Principal_s_Background__c ) = 0 || LEN ( Uses_of_Funds__c ) = 0 || LEN ( Key_Strengths_Risks_Weaknesses__c ) = 0 || LEN ( Summary_Financial_Analysis__c ) = 0 || LEN ( Guarantor_s_Background__c ) = 0 || LEN ( Pictures_Attachments__c ) = 0 ) ||   ( ( RecordType.Name = &quot;PIC - AB Participation&quot; &amp;&amp; ( ISBLANK ( Related_Exposure__c ) || ISBLANK ( Primary_Business_Activity_ies__c ) || ISBLANK ( Participating_Lenders__c ) || ISBLANK ( Conditions_of_Extension__c ) || ISBLANK ( Prepayment_Penalty_Exit_Fee__c ) || LEN ( Eligibility_Criteria__c ) = 0 || ISBLANK ( Release_Price_Description__c ) || LEN ( Other_Terms_Conditions__c ) = 0 || LEN ( Opportunity_Overview__c ) = 0 || LEN ( Underlying_Loan_Terms__c ) = 0 || LEN ( Project_Background__c ) = 0 || LEN ( Participant_s_Background__c ) = 0 ) ) ||   ( RecordType.Name = &quot;PIC - Bridge&quot; &amp;&amp; ( ISBLANK ( Related_Exposure__c ) || ISBLANK ( Exit_Fee_s__c ) || ISBLANK ( Conditions_of_Extension__c ) || LEN ( Other_Terms_Conditions__c ) = 0 || LEN ( Opportunity_Overview_Property_Backgrou__c ) = 0 ) )||   ( RecordType.Name = &quot;PIC - General&quot; &amp;&amp; ( ISBLANK ( Primary_Business_Activity_ies__c ) || LEN ( Eligibility_Criteria__c ) = 0 || LEN ( Other_Terms_Conditions__c ) = 0 || ISBLANK ( Prepayment_Penalty_Exit_Fee__c ) || LEN ( Opportunity_Overview__c ) = 0 || LEN ( Company_Background__c ) = 0 ) ) ||   ( RecordType.Name = &quot;PIC - Lender Finance&quot; &amp;&amp; ( ISBLANK ( Parent_Name__c ) || ISBLANK ( Related_Exposure__c ) || ISBLANK ( Primary_Business_Activity_ies__c ) || ISBLANK ( Deal_Sponsor__c ) || LEN ( Eligibility_Criteria__c ) = 0 || ISBLANK ( Prepayment_Penalty__c ) || LEN ( Release_Price_Description__c ) = 0 || LEN ( Opportunity_Overview__c ) = 0 || LEN ( Company_Background__c ) = 0 || LEN ( Appraisal_Diligence_Requirements__c ) = 0 || LEN ( Sponsor_s_Background__c ) = 0 ) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A PIC - Fields Populated - TRUE</fullName>
        <actions>
            <name>C_I_PIC_Fields_Populated_TRUE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>C&amp;I PIC - Checks to see if all PIC fields are populated. Used as entry criteria for the PIC approval process.</description>
        <formula>( ( RecordType.Name = &quot;PIC - Bridge&quot; || RecordType.Name = &quot;PIC - General&quot; || RecordType.Name = &quot;PIC - AB Participation&quot; || RecordType.Name = &quot;PIC - Lender Finance&quot; ) &amp;&amp; NOT ( ISBLANK ( Borrower_Legal_Name__c ) ) &amp;&amp; NOT ( ISBLANK ( Existing_Client__c ) ) &amp;&amp; LEN ( Guarantor_s__c ) != 0 &amp;&amp; NOT ( ISBLANK ( Projected_Close_Date__c ) ) &amp;&amp; NOT ( ISBLANK ( Loan_Purpose__c ) ) &amp;&amp; LEN ( Guarantor_Type_s__c ) != 0 &amp;&amp; NOT ( ISBLANK ( Loan_Amount__c ) ) &amp;&amp; NOT ( ISBLANK ( Term__c ) ) &amp;&amp; TEXT ( Payment__c ) != &quot;&quot; &amp;&amp; NOT ( ISBLANK (CI_Rate__c ) ) &amp;&amp; NOT ( ISBLANK ( Interest_Reserve__c ) ) &amp;&amp; LEN ( Advance_Rate_s__c ) != 0 &amp;&amp; NOT ( ISBLANK ( Closing_Fee_s__c ) ) &amp;&amp; TEXT ( Loan_Structure__c ) != &quot;&quot; &amp;&amp; NOT ( ISBLANK ( Extension_Option_s__c ) ) &amp;&amp; LEN ( Repayment_Exit_Strategy__c ) != 0 &amp;&amp; NOT ( ISBLANK ( Payment_Description__c ) ) &amp;&amp; NOT ( ISBLANK (CI_Rate_Description__c ) ) &amp;&amp; LEN ( Collateral__c ) != 0 &amp;&amp; LEN ( Other_Fee_s__c ) != 0 &amp;&amp; LEN ( Principal_s_Background__c ) != 0 &amp;&amp; LEN ( Uses_of_Funds__c ) != 0 &amp;&amp; LEN ( Key_Strengths_Risks_Weaknesses__c ) != 0 &amp;&amp; LEN ( Summary_Financial_Analysis__c ) != 0 &amp;&amp; LEN ( Guarantor_s_Background__c ) != 0 &amp;&amp; LEN ( Pictures_Attachments__c ) != 0 ) &amp;&amp; ( ( RecordType.Name = &quot;PIC - AB Participation&quot; &amp;&amp; ( NOT ( ISBLANK ( Related_Exposure__c ) ) &amp;&amp; NOT ( ISBLANK ( Primary_Business_Activity_ies__c ) ) &amp;&amp; NOT ( ISBLANK ( Participating_Lenders__c ) ) &amp;&amp; NOT ( ISBLANK ( Conditions_of_Extension__c ) ) &amp;&amp; NOT ( ISBLANK ( Prepayment_Penalty_Exit_Fee__c ) ) &amp;&amp; LEN ( Eligibility_Criteria__c ) != 0 &amp;&amp; NOT ( ISBLANK ( Release_Price_Description__c ) ) &amp;&amp; LEN ( Other_Terms_Conditions__c ) != 0 &amp;&amp; LEN ( Opportunity_Overview__c ) != 0 &amp;&amp; LEN ( Underlying_Loan_Terms__c ) != 0 &amp;&amp; LEN ( Project_Background__c ) != 0 &amp;&amp; LEN ( Participant_s_Background__c ) != 0 ) ) || ( RecordType.Name = &quot;PIC - Bridge&quot; &amp;&amp; ( NOT ( ISBLANK ( Related_Exposure__c ) ) &amp;&amp; NOT ( ISBLANK ( Exit_Fee_s__c ) ) &amp;&amp; NOT ( ISBLANK ( Conditions_of_Extension__c ) ) &amp;&amp; LEN ( Other_Terms_Conditions__c ) != 0 &amp;&amp; LEN ( Opportunity_Overview_Property_Backgrou__c ) != 0 ) ) || ( RecordType.Name = &quot;PIC - General&quot; &amp;&amp; ( NOT ( ISBLANK ( Primary_Business_Activity_ies__c ) ) &amp;&amp; LEN ( Eligibility_Criteria__c ) != 0 &amp;&amp; LEN ( Other_Terms_Conditions__c ) != 0 &amp;&amp; NOT ( ISBLANK ( Prepayment_Penalty_Exit_Fee__c ) ) &amp;&amp; LEN ( Opportunity_Overview__c ) != 0 &amp;&amp; LEN ( Company_Background__c ) != 0 ) ) || ( RecordType.Name = &quot;PIC - Lender Finance&quot; &amp;&amp; ( NOT ( ISBLANK ( Parent_Name__c ) ) &amp;&amp; NOT ( ISBLANK ( Related_Exposure__c ) ) &amp;&amp; NOT ( ISBLANK ( Deal_Sponsor__c ) ) &amp;&amp; NOT ( ISBLANK ( Primary_Business_Activity_ies__c ) ) &amp;&amp; LEN ( Eligibility_Criteria__c ) != 0 &amp;&amp; NOT ( ISBLANK ( Prepayment_Penalty__c ) ) &amp;&amp; LEN ( Release_Price_Description__c ) != 0 &amp;&amp; LEN ( Opportunity_Overview__c ) != 0 &amp;&amp; LEN ( Company_Background__c ) != 0 &amp;&amp; LEN ( Appraisal_Diligence_Requirements__c ) != 0 &amp;&amp; LEN ( Sponsor_s_Background__c ) != 0 ) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Risk Rating is 1 - High Pass</fullName>
        <actions>
            <name>C_I_Risk_Rating_1_High_Pass</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Documentation__c.Risk_Rating__c</field>
            <operation>equals</operation>
            <value>1 – High Pass</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Risk Rating value to 1-High Pass on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Risk Rating is 2 - Pass</fullName>
        <actions>
            <name>C_I_Risk_Rating_2_Pass</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Documentation__c.Risk_Rating__c</field>
            <operation>equals</operation>
            <value>2 – Pass</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Risk Rating value to 2-Pass on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Risk Rating is 3 - Pass</fullName>
        <actions>
            <name>C_I_Risk_Rating_3_Pass</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Documentation__c.Risk_Rating__c</field>
            <operation>equals</operation>
            <value>3 – Pass</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Risk Rating value to 3-Pass on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Risk Rating is 4 - Low Pass</fullName>
        <actions>
            <name>C_I_Risk_Rating_4_Low_Pass</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Documentation__c.Risk_Rating__c</field>
            <operation>equals</operation>
            <value>4 – Low Pass</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Risk Rating value to 4-Low Pass on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Risk Rating is 5 - Special Mention</fullName>
        <actions>
            <name>C_I_Risk_Rating_5_Special_Mention</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Documentation__c.Risk_Rating__c</field>
            <operation>equals</operation>
            <value>5 – Special Mention</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Risk Rating value to 5-Special Mention on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Risk Rating is 6 - Sub Standard</fullName>
        <actions>
            <name>C_I_Risk_Rating_6_Sub_Standard</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Documentation__c.Risk_Rating__c</field>
            <operation>equals</operation>
            <value>6 – Sub Standard</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Risk Rating value to 6-Sub Standard on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Risk Rating is 7 - SubStandard%2CNonAccrual</fullName>
        <actions>
            <name>C_I_Risk_Rating_7_SubStandard_NonAcc</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Documentation__c.Risk_Rating__c</field>
            <operation>equals</operation>
            <value>&quot;7 – Sub Standard, Non-Accrual&quot;</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Risk Rating value to 7-Sub Standard, Non-Accrual on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Risk Rating is 8 - Doubtful</fullName>
        <actions>
            <name>C_I_Risk_Rating_8_Doubtful</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Documentation__c.Risk_Rating__c</field>
            <operation>equals</operation>
            <value>8 – Doubtful</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Risk Rating value to 8-Doubtful on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Risk Rating is 9 - Loss</fullName>
        <actions>
            <name>C_I_Risk_Rating_9_Loss</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Documentation__c.Risk_Rating__c</field>
            <operation>equals</operation>
            <value>9 – Loss</value>
        </criteriaItems>
        <description>C&amp;I - Updates the Risk Rating value to 9-Loss on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Risk Rating is empty</fullName>
        <actions>
            <name>C_I_Risk_Rating_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Documentation__c.Risk_Rating__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>C&amp;I - Updates the Risk Rating value to null on the Opportunity when the same field value is updated on an Origination Documentation record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>C%26I%3A Term is changed and Opportunity is not AB Participation</fullName>
        <actions>
            <name>C_I_Update_Term</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the Term value on the Opportunity when the same field is updated on an Origination Documentation record.</description>
        <formula>Opportunity_Name__r.RecordType.DeveloperName != &quot;CI_AB_Participation&quot; &amp;&amp;  (ISNEW () ||  ISCHANGED ( Term__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>CI_Update_Opportunity_Stage_to_C_I_LOI</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Update Opportunity Stage to C&amp;I - LOI</subject>
    </tasks>
    <tasks>
        <fullName>CI_Update_Opportunity_Sub_Stage_to_PIC_Revision_or_Opportunity_Stage_to_Closed_L</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Update Opportunity Sub-Stage to PIC Revision or Opportunity Stage to Closed Lost</subject>
    </tasks>
    <tasks>
        <fullName>CI_Update_Opportunity_Sub_Stage_to_PIC_Submitted</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Update Opportunity Sub-Stage to PIC Submitted</subject>
    </tasks>
    <tasks>
        <fullName>Complete_Cash_Management_Setup</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Complete Cash Management Setup</subject>
    </tasks>
    <tasks>
        <fullName>Request_Legal_Deposit</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Request Legal Deposit</subject>
    </tasks>
    <tasks>
        <fullName>Update_Opportunity_Stage_to_C_I_Closing</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Update Opportunity Stage to C&amp;I - Closing</subject>
    </tasks>
    <tasks>
        <fullName>Update_Opportunity_Sub_Stage_to_CAM_Revision_or_Opportunity_Stage_to_Closed_Lost</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Update Opportunity Sub-Stage to CAM Revision or Opportunity Stage to Closed Lost</subject>
    </tasks>
    <tasks>
        <fullName>Update_Opportunity_Sub_Stage_to_CAM_Submitted</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Update Opportunity Sub-Stage to CAM Submitted</subject>
    </tasks>
</Workflow>
