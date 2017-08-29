<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Defect_Email</fullName>
        <description>Defect Email</description>
        <protected>false</protected>
        <recipients>
            <field>PF_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Defect_Email_Template</template>
    </alerts>
    <rules>
        <fullName>Trigger Defect Email</fullName>
        <actions>
            <name>Defect_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PF_Defects__c.PF_Status__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Defect email is sent</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
