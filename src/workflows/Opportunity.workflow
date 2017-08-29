<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>RES_Notification</fullName>
        <description>RES Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Templates/RES_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_an_email_if_the_amount_is_greater_than_50_million</fullName>
        <description>Send an email if the amount is greater than 50 million</description>
        <protected>false</protected>
        <recipients>
            <recipient>mbarth@mfs.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Large_Transaction</template>
    </alerts>
    <fieldUpdates>
        <fullName>Completed_Status_date_update</fullName>
        <field>Completed_Status_Date__c</field>
        <formula>NOW()</formula>
        <name>Completed Status date update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Email_Update</fullName>
        <field>Manager_Email__c</field>
        <formula>Owner.Manager.Email</formula>
        <name>Email Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>InProgressUpdate</fullName>
        <field>Onboarding_Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>InProgressUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MergerFieldsForName</fullName>
        <description>Created Date is added to the Opportunity Name</description>
        <field>Name</field>
        <formula>Account.Name +&apos; - &apos;+ Text(DateValue(CreatedDate))</formula>
        <name>MergerFieldsForName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Status_Date_Update</fullName>
        <field>New_Status_Date__c</field>
        <formula>NOW()</formula>
        <name>New Status Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetOppConfidentiality</fullName>
        <field>Conf__c</field>
        <literalValue>1</literalValue>
        <name>SetOppConfidentiality</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Inprogress_status_date</fullName>
        <field>In_Progress_Status_Date__c</field>
        <formula>NOW()</formula>
        <name>Set Inprogress status date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateConsultantDriven</fullName>
        <description>Auto Update Picklist if someone enters a Consultant Organization</description>
        <field>Is_Consultant__c</field>
        <literalValue>Yes</literalValue>
        <name>UpdateConsultantDriven</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_ARG_Oppty_Name</fullName>
        <field>Name</field>
        <formula>IF( ISCHANGED(First_Strategy_Name__c),Name +&apos; - &apos;+First_Strategy_Name__c, Name)</formula>
        <name>Update ARG Oppty Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_ActualClosedDate_to_Todays_Date</fullName>
        <description>When the Opportunity stage is changed to &apos;Funded&apos; change Actual Closed Date (custom field) to Today&apos;s Date</description>
        <field>Actual_Closed_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update ActualClosedDate to Todays Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_StartOnboarding_Process</fullName>
        <field>Start_Onboarding_Process__c</field>
        <literalValue>1</literalValue>
        <name>Update StartOnboarding Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>BuildOpportunityName</fullName>
        <actions>
            <name>MergerFieldsForName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Institutional New Business,Retail/Professional Buyer,Retail External Sales</value>
        </criteriaItems>
        <description>Opportunity Name is updated to Org Name + Created Date</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BuildOpportunityName - ARG</fullName>
        <actions>
            <name>Update_ARG_Oppty_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>ARG/DC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.First_Strategy_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Opportunity Name contains the Strategy Name</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IsClosed</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won,Closed Lost</value>
        </criteriaItems>
        <description>If the Opportunity is closed, check this box</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IsNotClosed</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>Closed Won,Closed Lost</value>
        </criteriaItems>
        <description>If the Opportunity changes from closed to not closed, uncheck the box</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Stage Update</fullName>
        <actions>
            <name>Update_StartOnboarding_Process</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Pending Flow</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Orgisconf</fullName>
        <actions>
            <name>SetOppConfidentiality</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OrgisConf__c = TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RES Email Notification</fullName>
        <actions>
            <name>RES_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(RecordType.Name == &apos;Retail External Sales&apos; &amp;&amp;  Notify_Management__c == true) &amp;&amp; (ISCHANGED( Notify_Management__c) || ISNEW())</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TransactionsOver50M</fullName>
        <actions>
            <name>Send_an_email_if_the_amount_is_greater_than_50_million</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;JPY 50,000,000&quot;</value>
        </criteriaItems>
        <description>Notification sent if the transactions is over 50 million</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UpdateConsultantStatusField</fullName>
        <actions>
            <name>UpdateConsultantDriven</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates &quot;Consultant Driven&quot; to &quot;Yes&quot; if a Consultant Organization is added.</description>
        <formula>NOT(ISBLANK(Consultant__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
