<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Gift_Card_Request_Approved</fullName>
        <description>Gift Card Request Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>SF_Gift_Card_Approval_Notification</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ALL/Gift_Card_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>Gift_Card_Request_Denied</fullName>
        <description>Gift Card Request Denied</description>
        <protected>false</protected>
        <recipients>
            <recipient>SF_Gift_Card_Approval_Notification</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ALL/Gift_Card_Request_Denied</template>
    </alerts>
</Workflow>
