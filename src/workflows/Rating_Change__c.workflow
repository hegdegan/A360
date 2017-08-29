<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Rating_Change_Approved</fullName>
        <description>Rating Change Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/RatingUpgrade_Downgrade_Approval</template>
    </alerts>
    <alerts>
        <fullName>Rating_Change_Rejected</fullName>
        <description>Rating Change Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/RatingUpgrade_Downgrade_Rejection</template>
    </alerts>
    <fieldUpdates>
        <fullName>RatingChangeName</fullName>
        <field>Name</field>
        <formula>Consultant_Rating__r.Product__r.Name+ 
IF(AND( !ISBLANK(Consultant_Rating__r.Product__r.Name),!ISBLANK(TEXT(Rating_Change_Type__c ))),&apos; - &apos;,&apos;&apos; )+ 
Text( Rating_Change_Type__c)+IF(AND( !ISBLANK((CreatedDate)),!ISBLANK(TEXT(Rating_Change_Type__c))),&apos; - &apos;,&apos;&apos; )+ 
IF(AND( !ISBLANK((CreatedDate)),!ISBLANK(Consultant_Rating__r.Product__r.Name ),ISBLANK(TEXT(Rating_Change_Type__c))),&apos; - &apos;,&apos;&apos; )+ 
TEXT(Datevalue(CreatedDate))</formula>
        <name>RatingChangeName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdatedApprovalDate</fullName>
        <field>Date_Changed__c</field>
        <formula>TODAY()</formula>
        <name>UpdatedApprovalDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>isApprovedUpdte</fullName>
        <field>isApproved__c</field>
        <literalValue>1</literalValue>
        <name>isApprovedUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>RatingChangeName</fullName>
        <actions>
            <name>RatingChangeName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Checks if there is a change in Name</description>
        <formula>ISNEW() ||  ISCHANGED(Name)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
