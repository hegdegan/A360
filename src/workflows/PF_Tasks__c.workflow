<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Send Task email</fullName>
        <active>false</active>
        <criteriaItems>
            <field>PF_Tasks__c.Name</field>
            <operation>equals</operation>
            <value>new</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
