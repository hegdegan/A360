<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SendToCompetTeamQueue</fullName>
        <description>Sets owner to Competitive Analysis Team Queue when report is requested</description>
        <field>OwnerId</field>
        <lookupValue>Competitive_Analysis_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SendToCompetTeamQueue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Competitive_Analysis_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>Competitive_Analysis_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Competitive Analysis Owner</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_Initiate</fullName>
        <field>Status__c</field>
        <literalValue>Initiate</literalValue>
        <name>Set Status to Initiate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>StatusInitiated</fullName>
        <field>Status__c</field>
        <literalValue>Initiate</literalValue>
        <name>StatusInitiated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Completed_Date</fullName>
        <field>Completed_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>noReportUpdate</fullName>
        <description>report is not requested updates status to Track</description>
        <field>Status__c</field>
        <literalValue>Track</literalValue>
        <name>noReportUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Assign Created Person as Owner When Report Not Requested</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Competitive_Analysis_Request__c.Request_Report__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Assign Created Person as Owner for Competitive Analysis Request When Report Not Requested</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ReportRequested</fullName>
        <actions>
            <name>SendToCompetTeamQueue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>StatusInitiated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Competitive_Analysis_Request__c.Request_Report__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Competitive Analysis Owner</fullName>
        <actions>
            <name>Set_Competitive_Analysis_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Competitive_Analysis_Request__c.Request_Report__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>New Competitive Analysis record owner is set to Competitive Analysis queue when the record is created the &quot;Report Requested&quot; checkbox is set to true</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Status to Initiate</fullName>
        <actions>
            <name>Set_Status_to_Initiate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets Status to Initiate when Competitive Analysis Request is submitted</description>
        <formula>1=1</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>StatusUpdateTrack</fullName>
        <actions>
            <name>noReportUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Competitive_Analysis_Request__c.Request_Report__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Completed Date on CAR When Request is finalized</fullName>
        <actions>
            <name>Update_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Status__c , &quot;Track&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
