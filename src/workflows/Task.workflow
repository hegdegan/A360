<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateStandardTaskName</fullName>
        <field>Subject</field>
        <formula>&quot;Call -  &quot;+ TEXT(ActivityDate)</formula>
        <name>UpdateStandardTaskName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UpdateStandardTaskName</fullName>
        <actions>
            <name>UpdateStandardTaskName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.DeveloperName = &quot;Standard_Task&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
