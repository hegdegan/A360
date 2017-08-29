<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>update_Portfolio_Name</fullName>
        <field>Name</field>
        <formula>Portfolio__r.Name</formula>
        <name>update Portfolio Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>update Portfolio Junction Object Name</fullName>
        <actions>
            <name>update_Portfolio_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISCHANGED(Portfolio__c), ISNEW() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
