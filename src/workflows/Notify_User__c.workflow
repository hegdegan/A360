<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_when_User_added_to_ER_Template</fullName>
        <description>Notify when User added to ER Template</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Speaker_Request/Notify_when_User_added_to_ER</template>
    </alerts>
    <rules>
        <fullName>Notify when User added to ER</fullName>
        <actions>
            <name>Notify_when_User_added_to_ER_Template</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Notify_User__c.User__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
