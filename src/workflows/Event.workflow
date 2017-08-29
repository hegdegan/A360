<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateStandardEventName</fullName>
        <field>Subject</field>
        <formula>TEXT(Internal_Type__c)+ &quot; - &quot; + Location</formula>
        <name>UpdateStandardEventName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateSubject</fullName>
        <description>Sets subject for internal events to set zones</description>
        <field>Subject</field>
        <formula>CreatedBy.FirstName+&quot; &quot;+ CreatedBy.LastName + &quot; - &quot;+ TEXT(Internal_Type__c)+&quot; - &quot;+Location</formula>
        <name>UpdateSubject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SetInternalSubject</fullName>
        <actions>
            <name>UpdateSubject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISNEW() || ISCHANGED(Subject)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateStandardEventName</fullName>
        <actions>
            <name>UpdateStandardEventName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Used to update the standard event name field.</description>
        <formula>RecordType.DeveloperName = &quot;Standard_Event&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
