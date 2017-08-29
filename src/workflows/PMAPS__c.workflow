<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Autofill_Sales_person_email</fullName>
        <field>Sales_RM_Email__c</field>
        <formula>Sales_Person_Relationship_Manager__r.Email</formula>
        <name>Autofill Sales person email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Autofill_Sales_person_phone</fullName>
        <field>Sales_RM_Phone__c</field>
        <formula>Sales_Person_Relationship_Manager__r.Phone</formula>
        <name>Autofill Sales person phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OpportunityAmountUpdate</fullName>
        <field>Opportunity_Amount__c</field>
        <formula>TEXT(Opportunity__r.Amount__c)</formula>
        <name>OpportunityAmountUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Secondary_MFS_Contact_Email</fullName>
        <field>Secondary_Contact_Email__c</field>
        <formula>Secondary_MFS_Contact__r.Email</formula>
        <name>Populate Secondary MFS Contact Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Secondary_MFS_Contact_Phone</fullName>
        <field>Secondary_Contact_Phone__c</field>
        <formula>Secondary_MFS_Contact__r.Phone</formula>
        <name>Populate Secondary MFS Contact Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_RM_Email</fullName>
        <field>Sales_RM_Email__c</field>
        <formula>Sales_Person_Relationship_Manager__r.Email</formula>
        <name>Sales/RM Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Pmaps Contact Update</fullName>
        <active>false</active>
        <description>RFP Contact is automatically updated</description>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PmapsOpportunityAmount</fullName>
        <actions>
            <name>OpportunityAmountUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Relationship Manager</fullName>
        <actions>
            <name>Autofill_Sales_person_email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Autofill_Sales_person_phone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Relationship Manager and related fields are automatically updated</description>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Secondary MFS Contact</fullName>
        <actions>
            <name>Populate_Secondary_MFS_Contact_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Secondary_MFS_Contact_Phone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Secondary MFS Contact is updated</description>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Strategy Details</fullName>
        <active>true</active>
        <description>Strategy information is updated</description>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>StrategyRollUp</fullName>
        <active>false</active>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
