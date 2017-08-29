<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Client_service_Manager_on_Case</fullName>
        <field>Client_Service_Manager__c</field>
        <formula>IF(AND( 
ISBLANK(Case__r.Client_Service_Manager__c), 
INCLUDES(Role__c , &quot;Relationship Manager&quot;), 
NOT(ISBLANK( Contact_Name__c ))) , 
Contact__r.Contact_Name__c , Case__r.Client_Service_Manager__c )</formula>
        <name>Update Client service Manager on Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Relation_Manager_on_Case</fullName>
        <field>Relationship_Manager__c</field>
        <formula>IF(AND(
ISBLANK(Case__r.Relationship_Manager__c),  
INCLUDES(Role__c , &quot;Relationship Manager&quot;),
NOT(ISBLANK( Contact_Name__c ))) ,
  Contact__r.Contact_Name__c  , Case__r.Relationship_Manager__c  )</formula>
        <name>Update Relation Manager on Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sales_Person_on_Case</fullName>
        <field>SalesPerson__c</field>
        <formula>IF(AND( 
ISBLANK(Case__r.SalesPerson__c), 
INCLUDES(Role__c , &quot;Relationship Manager&quot;), 
NOT(ISBLANK( Contact_Name__c ))) , 
Contact__r.Contact_Name__c , Case__r.SalesPerson__c )</formula>
        <name>Update Sales Person on Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Populate Case Contact Names</fullName>
        <actions>
            <name>Update_Client_service_Manager_on_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Relation_Manager_on_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sales_Person_on_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Case</fullName>
        <active>false</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
