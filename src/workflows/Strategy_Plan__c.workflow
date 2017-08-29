<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ConsultantStrategyPlanNameUpdate</fullName>
        <description>Updates Strategy Plan Name for Consultant Plans</description>
        <field>Name</field>
        <formula>Organization__r.Name  +&quot; - &quot;+(TEXT(YEAR(DATEVALUE((CreatedDate)))))</formula>
        <name>ConsultantStrategyPlanNameUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ConsultantStrategyPlanNameUpdates</fullName>
        <actions>
            <name>ConsultantStrategyPlanNameUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Strategy_Plan__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Consultant Strategy Plan</value>
        </criteriaItems>
        <description>Sets Consultant Name to &quot;Organization + Created Year&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
