<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CRT_Update</fullName>
        <description>If the Contact changes from one account to another one or the account status is updated to &apos;Inactive&apos;, CRT flag will be updated to false.</description>
        <field>CRT__c</field>
        <literalValue>0</literalValue>
        <name>CRT Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>consultantContactOrg</fullName>
        <field>Historical_Org_Name__c</field>
        <formula>Contact__r.Account.Name</formula>
        <name>consultantContactOrg</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>consultantContactOrg</fullName>
        <actions>
            <name>consultantContactOrg</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Plan_Association__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Checks if the record is a Consultant</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
