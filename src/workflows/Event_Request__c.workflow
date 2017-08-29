<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EventRequestNotification</fullName>
        <description>EventRequestNotification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Speaker_Request/EventRequestEmailNotificationBeforeTwoDays</template>
    </alerts>
    <alerts>
        <fullName>RequestedSpeakerApproved</fullName>
        <description>RequestedSpeakerApproved</description>
        <protected>false</protected>
        <recipients>
            <recipient>Speaker_Coordinator_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Speaker_Request/All_Requested_Speakers_Approved</template>
    </alerts>
    <alerts>
        <fullName>Requested_Speakers_Approved</fullName>
        <description>Requested Speakers Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>Speaker_Coordinator_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Speaker_Request/All_Requested_Speakers_Approved</template>
    </alerts>
    <alerts>
        <fullName>SpeakerRequestNotificationCreator</fullName>
        <description>SpeakerRequestNotificationCreator</description>
        <protected>false</protected>
        <recipients>
            <recipient>Speaker_Coordinator_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Speaker_Request/Speaker_Request_Changes_Notify_Creator</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_End_Date</fullName>
        <field>Approval_Process_End_Date__c</field>
        <formula>Today()</formula>
        <name>Approval End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Process_Start_Date</fullName>
        <field>Approval_Process_Start_Date__c</field>
        <formula>Today()</formula>
        <name>Approval Process Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_MFSI</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Status MFSI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EventTitleUpdate</fullName>
        <field>Event_Title__c</field>
        <formula>Organization__r.Name</formula>
        <name>EventTitleUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_Approval_Status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>IPM Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_Pending</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>IPM-Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_Pending_Status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>IPM Pending Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_Rejected_Status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>IPM Rejected Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Institutional_Approval_Status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Institutional Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Institutional_Pending_Status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Institutional Pending Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Institutional_Rejected_Status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Institutional Rejected Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PopulateNotificationDate</fullName>
        <field>Notification_Date__c</field>
        <formula>CASE(
MOD(DateValue(Start_Date__c) - DATE(1900, 1, 7), 7),
0, (DateValue(Start_Date__c)) - 2 - 1,
1, (DateValue(Start_Date__c)) - 2 - 2,
2, (DateValue(Start_Date__c)) - 2 - 2,
3, (DateValue(Start_Date__c)) - 2,
4, (DateValue(Start_Date__c)) - 2,
5, (DateValue(Start_Date__c)) - 2,
6, (DateValue(Start_Date__c)) - 2,
null)</formula>
        <name>PopulateNotificationDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RejectionStatus</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>RejectionStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejection_Status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Rejection Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejection_Status_MFSI</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Rejection Status MFSI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Retail_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Retail-Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Retail_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Retail-Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update</fullName>
        <description>Updates the owner field on the event request.</description>
        <field>OwnerId</field>
        <lookupValue>Speaker_Coordinator_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Approval Step Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner</fullName>
        <description>Updates the owner of the event request to the speaker coordinator group/queue.</description>
        <field>OwnerId</field>
        <lookupValue>Speaker_Coordinator_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>EventRequestPopulateNotificationDate</fullName>
        <actions>
            <name>PopulateNotificationDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>DATEVALUE(Start_Date__c) &gt;= Today() + 2</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EventRequestSendNotificationBeforeTwoDays</fullName>
        <active>true</active>
        <description>Sent Email Notification to Record Creator and Requested For user before two day&apos;s of Event Start Date</description>
        <formula>1=1</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>EventRequestNotification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Event_Request__c.Notification_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>EventRequestTitleUpdate</fullName>
        <actions>
            <name>EventTitleUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Event_Request__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Approval End Date</fullName>
        <actions>
            <name>Approval_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(PRIORVALUE(Overall_Approval_Status__c),&apos;Pending&apos;) &amp;&amp; ISPICKVAL(Overall_Approval_Status__c,&apos;Confirmed&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Approval Start Date</fullName>
        <actions>
            <name>Approval_Process_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(PRIORVALUE(Overall_Approval_Status__c),&apos;New&apos;) &amp;&amp; ISPICKVAL(Overall_Approval_Status__c,&apos;Pending&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SpeakerRequestNotifyChanges</fullName>
        <actions>
            <name>SpeakerRequestNotificationCreator</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>OR((ISCHANGED( Start_Date__c )), (ISCHANGED(End_Date__c )),  (ISCHANGED(Location__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Owner to Speaker Coordinator Group</fullName>
        <actions>
            <name>Update_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Event_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Event Request,Trading Floor Tour</value>
        </criteriaItems>
        <description>Workflow rule to update owner of a new Event Request to the Speaker Coordinator Group</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
