<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Inflow_Outflow_greater_than_5m</fullName>
        <description>Inflow Outflow greater than 5m</description>
        <protected>false</protected>
        <recipients>
            <recipient>Onboarding_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Templates/Inflow_Outflow_greater_than_5m_ET</template>
    </alerts>
    <alerts>
        <fullName>Notify_when_User_Support_Case_is_Resolved</fullName>
        <description>Notify when User Support Case is Resolved</description>
        <protected>false</protected>
        <recipients>
            <field>Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Templates/Notify_when_User_Support_Case_is_Resolved</template>
    </alerts>
    <alerts>
        <fullName>Onboarding_Review_Email_To_Owner</fullName>
        <description>Onboarding Review Email to Case Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Email_Templates/Onboarding_Case_Review</template>
    </alerts>
    <alerts>
        <fullName>Portfolio_Management_Email_Alert</fullName>
        <description>Portfolio Management Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Portfolio_Management</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Email_Templates/Onboarding_Case_Request</template>
    </alerts>
    <fieldUpdates>
        <fullName>Additional_Info_Update</fullName>
        <field>Additional_Information_on_Opportunity__c</field>
        <formula>URF_Fee__r.Additional_Info_on_this_Opportunity__c</formula>
        <name>Additional Info Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Additional_Info_update1</fullName>
        <field>Additional_Information_on_Opportunity__c</field>
        <name>Additional Info update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Authorized_Signer_checkbox</fullName>
        <field>Authorized_Signer__c</field>
        <literalValue>1</literalValue>
        <name>Authorized Signer checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CaseOwnerUpdate</fullName>
        <field>OwnerId</field>
        <lookupValue>User_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CaseOwnerUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ChangeCaseOwner</fullName>
        <field>OwnerId</field>
        <lookupValue>Onboarding_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>ChangeCaseOwner</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Case_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>mfsowner@mfs.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Change Case Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Service_Request</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Close Service Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Co_Heads_of_Global_Distribution</fullName>
        <field>Co_Heads_of_Global_Distribution__c</field>
        <lookupValue>jim@jesse.test</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Co-Heads of Global Distribution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Data_Management_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Data_Management_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Data Management Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DueDateUpdate</fullName>
        <field>Due_Date__c</field>
        <formula>IF( TEXT(Excludes_Weekends__c) == &apos;Business Days&apos; , CASE(
MOD(Start_Date__c - DATE(1900, 1, 7), 7),
0, (Start_Date__c) + Value(TEXT(Due_In__c)) + FLOOR((Value(TEXT(Due_In__c)))/5)*2,
1, (Start_Date__c) + Value(TEXT(Due_In__c)) + FLOOR((Value(TEXT(Due_In__c)))/5)*2,
2, (Start_Date__c) + Value(TEXT(Due_In__c)) + FLOOR((Value(TEXT(Due_In__c))+1)/5)*2,
3, (Start_Date__c) + Value(TEXT(Due_In__c)) + FLOOR((Value(TEXT(Due_In__c))+2)/5)*2,
4, (Start_Date__c) + Value(TEXT(Due_In__c)) + FLOOR((Value(TEXT(Due_In__c))+3)/5)*2,
5, (Start_Date__c) + Value(TEXT(Due_In__c)) + CEILING((Value(TEXT(Due_In__c)))/5)*2,
6, (Start_Date__c) - IF(Value(TEXT(Due_In__c))&gt;0,1,0) + Value(TEXT(Due_In__c)) + CEILING((Value(TEXT(Due_In__c)))/5)*2,
null), (Start_Date__c) + Value(TEXT(Due_In__c)))</formula>
        <name>DueDateUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Expected_Funding_Amount</fullName>
        <field>Expected_Funding_Amount__c</field>
        <formula>Related_To_Opportunity__r.Amount_Cal__c</formula>
        <name>Expected Funding Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fee_Schedule_Update</fullName>
        <field>Fee_Schedule_Assessment__c</field>
        <formula>URF_Fee__r.Fee_Schedule_Assessment__c</formula>
        <name>Fee Schedule Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fee_Schedule_update1</fullName>
        <field>Fee_Schedule_Assessment__c</field>
        <name>Fee Schedule update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GDS_Acknowledgement_update</fullName>
        <field>GDS_Acknowledgement__c</field>
        <lookupValue>patriciabarnard@test.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>GDS Acknowledgement update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>General_Comment_Update</fullName>
        <field>Resolution_Details__c</field>
        <formula>URF_Fee__r.General_Comments__c</formula>
        <name>General Comment Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>General_comment_update1</fullName>
        <field>Resolution_Details__c</field>
        <name>General comment update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OwnerUpdate</fullName>
        <field>OwnerId</field>
        <lookupValue>Incoming_Request</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>OwnerUpdate</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Recordkeeper_Postal_Code</fullName>
        <field>Primary_Contact_for_MFS_Postal_Code__c</field>
        <formula>IF(ISBLANK(Recordkeeper_or_Administrator__c),&apos;&apos;,Recordkeeper_or_Administrator__r.ShippingPostalCode)</formula>
        <name>Recordkeeper Postal Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reporting_Request_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Reporting_Request</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Reporting Request Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Approval_Received</fullName>
        <field>Number_of_Approvals_Received__c</field>
        <name>Reset Approval Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Provider_Email_Update</fullName>
        <field>Service_Provider_Email__c</field>
        <formula>Service_Provider_Name__r.Email</formula>
        <name>Service Provider Email Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Provider_Phone_Update</fullName>
        <field>Service_Provider_Phone__c</field>
        <formula>Service_Provider_Name__r.Phone</formula>
        <name>Service Provider Phone Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Provider_Phone_Update1</fullName>
        <field>Service_Provider_Phone__c</field>
        <formula>Service_Provider_Name__r.Phone</formula>
        <name>Service Provider Phone Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SubjectUpdate</fullName>
        <field>Subject</field>
        <formula>IF(Text(Service_Request_Type__c) = null, Requester__r.FirstName +&apos; &apos;+ Requester__r.LastName,Requester__r.FirstName+&apos; &apos;+ Requester__r.LastName +&apos; - &apos;+ Text(Service_Request_Type__c) )</formula>
        <name>SubjectUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Summarize_MFS_update</fullName>
        <field>Summary_of_Existing_Relationship_wit_MFS__c</field>
        <formula>URF_Fee__r.Summarise_existing_relationship_with_MFS__c</formula>
        <name>Summarize MFS update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Summarize_MFS_update1</fullName>
        <field>Summary_of_Existing_Relationship_wit_MFS__c</field>
        <name>Summarize MFS update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateSubject</fullName>
        <field>Subject</field>
        <formula>Account.Name  + &apos;-&apos; + TEXT(Type)</formula>
        <name>UpdateSubject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Acknowledged_Status_Start_Date</fullName>
        <field>Acknowledge_Status_Start__c</field>
        <formula>NOW()</formula>
        <name>Update Acknowledged Status Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Amendment_Subject</fullName>
        <field>Subject</field>
        <formula>IF( Account.Name!= null &amp;&amp; !ISBLANK( Type_Amendment__c ), Account.Name +&apos; - &apos;+IF(INCLUDES( Type_Amendment__c,&apos;Fee Rebate&apos;),&apos;Fee Rebate,&apos;,null) +&apos;&apos;+ IF(INCLUDES( Type_Amendment__c,&apos;Marketing Support&apos;),&apos;Marketing Support,&apos;,null) +&apos;&apos;+ IF(INCLUDES( Type_Amendment__c,&apos;Program Support&apos;),&apos;Program Support,&apos;,null), IF(Account.Name == null, IF(INCLUDES( Type_Amendment__c,&apos;Fee Rebate&apos;),&apos;Fee Rebate,&apos;,null) +&apos;&apos;+ IF(INCLUDES( Type_Amendment__c,&apos;Marketing Support&apos;),&apos;Marketing Support,&apos;,null) +&apos;&apos;+ IF(INCLUDES( Type_Amendment__c,&apos;Program Support&apos;),&apos;Program Support,&apos;,null), Account.Name) )</formula>
        <name>Update Amendment Subject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Not Started</literalValue>
        <name>Update Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CFO_Acknowledgement</fullName>
        <field>CFO_Onboarding_Retail_Lookup__c</field>
        <lookupValue>am.kanwal@mfs.com.test</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update CFO Acknowledgement</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Approved_Field</fullName>
        <field>Date_Case_Approved__c</field>
        <formula>TODAY()</formula>
        <name>Update Case Approved Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>Territory_Management</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Case Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Subject</fullName>
        <field>Subject</field>
        <formula>IF(ISBLANK(Service_Provider_Org_Name__r.Name),IF(ISBLANK(Account.Name),TEXT(Type), Account.Name + &apos; - &apos; +   TEXT(Type)), Service_Provider_Org_Name__r.Name+&apos; - &apos;+TEXT(Type) )</formula>
        <name>Update Case Subject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Closed_Status_Start_Date</fullName>
        <field>Closed_Status_Start__c</field>
        <formula>NOW()</formula>
        <name>Update Closed Status Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Compliance_AML_KYC</fullName>
        <field>Compliance_AML_KYC_Approver__c</field>
        <lookupValue>johngarrett@test.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Compliance - AML/KYC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Funding_Date</fullName>
        <field>Funding_Date__c</field>
        <formula>IF(ISBLANK(Client_Investment__c),NULL,Client_Investment__r.Account_Start_Date__c)</formula>
        <name>Update Funding Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_In_Progress_Status_Start_Date</fullName>
        <field>In_Progress_Status_Start__c</field>
        <formula>NOW()</formula>
        <name>Update In Progress Status Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_New_Status_Start_Date</fullName>
        <field>New_Status_Start__c</field>
        <formula>NOW()</formula>
        <name>Update New Status Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Of_PM_Approvals</fullName>
        <field>Number_of_PM_Approvals_Required__c</field>
        <literalValue>3</literalValue>
        <name>Update # Of PM Approvals</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Original_Owner_For_User_Support</fullName>
        <field>Original_Owner__c</field>
        <formula>Owner:Queue.QueueName</formula>
        <name>Update Original Owner For User Support</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pending_Status_Start_Date</fullName>
        <field>Pending_Status_Start__c</field>
        <formula>NOW()</formula>
        <name>Update Pending Status Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status</fullName>
        <field>Status</field>
        <literalValue>Transition Account</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Subject</fullName>
        <field>Subject</field>
        <formula>Account.Name +  IF( Account.Name==&apos;&apos;, &apos; &apos;, IF(Text(Type__c)==&apos;&apos;, &apos;  &apos;, &apos; - &apos;) ) + IF(Text(Type__c)==&apos;&apos;, &apos;  &apos;, Text(Type__c) )</formula>
        <name>Update Subject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Subject_On_User_Support</fullName>
        <field>Subject</field>
        <formula>Requester__r.LastName+&apos; &apos;+Requester__r.FirstName +&apos; - &apos;+Text(Service_Request_Type__c) + IF(Text(Service_Request_Type__c)  ==&apos;&apos;, &apos; &apos;, IF(Text(CreatedDate)==&apos;&apos;, &apos; &apos;, &apos; - &apos;) ) + IF(Text(CreatedDate)==&apos;&apos;, &apos; &apos;, TEXT(DATEVALUE(CreatedDate)))</formula>
        <name>Update Subject On User Support</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Subject_Onboarding</fullName>
        <field>Subject</field>
        <formula>Account.Name+IF(OR(Account.Name==&apos;&apos;,TEXT(Type)==&apos;&apos;),&apos;&apos;,&apos; - &apos;)+TEXT(Type)</formula>
        <name>Update Subject - Onboarding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Subject_for_Termination_Case</fullName>
        <field>Subject</field>
        <formula>IF(ISBLANK( Closing_Termination_Date__c ) , &apos;Termination&apos; , &apos;Termination - &apos; + Text (Closing_Termination_Date__c))</formula>
        <name>Update Subject for Termination Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Subject_to_Default_for_Inflow_Out</fullName>
        <field>Subject</field>
        <formula>&apos;Inflow/Outflow - &apos; + TEXT( Type )</formula>
        <name>Update Subject to Default for Inflow/Out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Subject_to_Default_for_Inst_Amndt</fullName>
        <field>Subject</field>
        <formula>&apos;Institutional Amendment - &apos; + TEXT( Type )</formula>
        <name>Update Subject to Default for Inst Amndt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_To_Closed</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Update To Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Type</fullName>
        <field>Client_Service_Approver__c</field>
        <lookupValue>patriciabarnard@test.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status_on_approval</fullName>
        <field>Status</field>
        <literalValue>Tracking Records</literalValue>
        <name>Update status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_to_Service</fullName>
        <field>Status</field>
        <literalValue>Service</literalValue>
        <name>Update to Service</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>User_Support_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>User_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>User Support Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updateDueDate</fullName>
        <field>Due_Date__c</field>
        <formula>CASE(MOD(  DATEVALUE(CreatedDate)  - DATE(1900, 1, 7),7),
0, DATEVALUE(CreatedDate)+1,
5,DATEVALUE(CreatedDate)+3,
6,DATEVALUE(CreatedDate)+2,
DATEVALUE(CreatedDate)+1)</formula>
        <name>updateDueDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Auto populate case subject</fullName>
        <actions>
            <name>Update_Case_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Case subject is auto populated based Org Name and Type</description>
        <formula>$RecordType.DeveloperName = &apos;Service_Request&apos; || $RecordType.DeveloperName = &apos;Service Request&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Auto populate case subject - General Onboarding</fullName>
        <actions>
            <name>Update_Subject_Onboarding</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Case subject is auto populated based Org Name and Type</description>
        <formula>$RecordType.DeveloperName = &apos;Onboarding&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Billing Contact Name</fullName>
        <active>false</active>
        <formula>ISNEW() || ISCHANGED( Billing_Contact_Name__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Blank Fee Approval data</fullName>
        <actions>
            <name>Additional_Info_update1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Fee_Schedule_update1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>General_comment_update1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Summarize_MFS_update1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(URF_Fee__c == null,RecordType.DeveloperName == &apos;Amendment_URF&apos;,ISCHANGED(URF_Fee__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CalculateDueDate</fullName>
        <actions>
            <name>updateDueDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.Recurring_Case__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Parent_Case_Number__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Due Date is auto populated for recurring cases</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CalculateDueDateOnRecurring</fullName>
        <actions>
            <name>DueDateUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Case.Recurring_Case__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Due Date calculation is based on Parent/original case, plus the number of days before due</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Inflow Outflow Email Trigger</fullName>
        <actions>
            <name>Inflow_Outflow_greater_than_5m</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>(ISCHANGED( Amount__c ) || ISNEW()) &amp;&amp; ( RecordType__c  = &apos;Amendment&apos;  ||  RecordType__c  = &apos;Inflow/Outflow&apos;) &amp;&amp; (Amount__c &gt; 5000000)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ChangeCaseOwner</fullName>
        <actions>
            <name>ChangeCaseOwner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Internal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>High</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>New Account/Transition</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Close Service Request</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Reminder that the Due Date is approaching</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Service_Request_Due_Date_is_Approaching</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Case.Due_Date__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Service_Request_Past</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Case.Due_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Co-Heads of Global Distribution On Amendment URF</fullName>
        <actions>
            <name>Co_Heads_of_Global_Distribution</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Amendment (URF)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Co_Heads_of_Global_Distribution__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Compliance - AML%2FKYC On Amendment URF</fullName>
        <actions>
            <name>Update_Compliance_AML_KYC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Compliance_AML_KYC_Approver__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Amendment (URF)</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Consultant Name</fullName>
        <active>false</active>
        <formula>ISNEW() || ISCHANGED(  Consultant_Contact__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ContactAutoPopulate</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy Fee Approval data to Amendment Case</fullName>
        <actions>
            <name>Additional_Info_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Fee_Schedule_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>General_Comment_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Summarize_MFS_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(URF_Fee__c != null,RecordType.DeveloperName == &apos;Amendment_URF&apos;, ISCHANGED(URF_Fee__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Default CFO Acknowledgement For Amendment Case</fullName>
        <actions>
            <name>Update_CFO_Acknowledgement</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Amendment (URF)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Outside_Guidelines__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Default GDS Acknowledgement for Domestic%2FNon-US Retail Case</fullName>
        <actions>
            <name>GDS_Acknowledgement_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Global Retail Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GDS_Acknowledgement__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Default Subject for Amendment%28URF%29 Case</fullName>
        <actions>
            <name>Update_Amendment_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Amendment (URF)</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FollowUp Task</fullName>
        <actions>
            <name>Service_Request_Closed_Notify_Client</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Follow up task is required whenever the Status = Closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Initial Case Owner</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>User Support</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify When User Support case is Resolved</fullName>
        <actions>
            <name>Notify_when_User_Support_Case_is_Resolved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordType__c</field>
            <operation>equals</operation>
            <value>User Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Amount</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Amendment (URF)</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Populate Service Provider Email and Phone</fullName>
        <actions>
            <name>Service_Provider_Phone_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Recordkeeper or Administrator</fullName>
        <actions>
            <name>Recordkeeper_Postal_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() || ISCHANGED(   Recordkeeper_or_Administrator__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RelatedToOpportunityAmount</fullName>
        <actions>
            <name>Expected_Funding_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() || ISCHANGED(  Related_To_Opportunity__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Reset Approval Info on Creation</fullName>
        <actions>
            <name>Reset_Approval_Received</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Approval_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Onboarding Review Request</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Onboarding_Review_Email_To_Owner</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.IMA_Finalization_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Service Provider Phone Email Update</fullName>
        <actions>
            <name>Service_Provider_Email_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Service_Provider_Phone_Update1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Service Provider phone and email updates are pushed</description>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set %23 Of PM Approvals</fullName>
        <actions>
            <name>Update_Of_PM_Approvals</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(RecordType.DeveloperName =&apos;Onboarding&apos;, !ISBLANK(Client_Asset_Type__c),ISBLANK( TEXT(Number_of_PM_Approvals_Required__c )) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SetTerritoryCase Owner to Territory Management Queue</fullName>
        <actions>
            <name>Update_Case_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Territory Management Case</value>
        </criteriaItems>
        <description>Sets Territory Management Case Owner to the Territory Queue on creation</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Acknowledged Status Start Date</fullName>
        <actions>
            <name>Update_Acknowledged_Status_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Acknowledged</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Closed Status Start Date</fullName>
        <actions>
            <name>Update_Closed_Status_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update In Progress Status Start Date</fullName>
        <actions>
            <name>Update_In_Progress_Status_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update New Status Start Date</fullName>
        <actions>
            <name>Update_New_Status_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update On Actual Funding Date</fullName>
        <actions>
            <name>Update_To_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Actual_Funding_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update On Approval Received</fullName>
        <actions>
            <name>Update_status_on_approval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType__c == &apos;Onboarding&apos; &amp;&amp; 
  ISPICKVAL(Approval_Status__c  , &apos;Submitted&apos;) &amp;&amp;
 ISCHANGED (Number_of_Approvals_Received__c) &amp;&amp; 
Number_of_Approvals_Received__c == Number_of_Approvals_Sent__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Pending Status Start Date</fullName>
        <actions>
            <name>Update_Pending_Status_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Status Onboarding to Review Documentation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordType__c</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CaseNumber</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Subject Domestic%2FNonUs-Retail</fullName>
        <actions>
            <name>Update_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Global Retail Onboarding</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Subject On User Support</fullName>
        <actions>
            <name>Update_Subject_On_User_Support</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>User Support</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Subject for Inflow%2FOutflow</fullName>
        <actions>
            <name>Update_Subject_to_Default_for_Inflow_Out</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordType__c</field>
            <operation>equals</operation>
            <value>Inflow/Outflow</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Subject for Institutional Amendment</fullName>
        <actions>
            <name>Update_Subject_to_Default_for_Inst_Amndt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordType__c</field>
            <operation>equals</operation>
            <value>Institutional Amendment</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Subject for Termination Cases</fullName>
        <actions>
            <name>Update_Subject_for_Termination_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Termination</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Termination Case when Client Investment Changes</fullName>
        <actions>
            <name>Update_Funding_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>RecordType__c == &apos;Termination&apos; &amp;&amp;  (ISNEW() ||  ISCHANGED( Client_Investment__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Type On Domestic%2FNon-US Retail</fullName>
        <actions>
            <name>Update_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Global Retail Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type__c</field>
            <operation>equals</operation>
            <value>New Domestic Retail Onboarding</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update status On Termination</fullName>
        <actions>
            <name>Update_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Termination</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update status to service</fullName>
        <actions>
            <name>Update_to_Service</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.All_Documents_Received__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UpdateOrgInfo</fullName>
        <active>false</active>
        <description>The Org info needs to match what&apos;s on the Org record (and updated on the Org)</description>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>User Support - Data Management Queue</fullName>
        <actions>
            <name>Data_Management_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Used for user support</description>
        <formula>AND( NOT(ISNEW()),(RecordType.DeveloperName == &apos;User_Support&apos; ), ISPICKVAL(Service_Request_Type__c,&apos;Data Request&apos;),  NOT(BEGINS(OwnerId,&apos;005&apos;)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>User Support - Reporting Request Queue</fullName>
        <actions>
            <name>Reporting_Request_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Used in user support</description>
        <formula>AND( NOT(ISNEW()),(RecordType.DeveloperName == &apos;User_Support&apos; ), ISPICKVAL(Service_Request_Type__c,&apos;Reporting Request&apos;),  NOT(BEGINS(OwnerId,&apos;005&apos;)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>User Support - Transaction Request Queue</fullName>
        <active>false</active>
        <description>Used in user support</description>
        <formula>AND( NOT(ISNEW()),(RecordType.DeveloperName == &apos;User_Support&apos; ), ISPICKVAL(Service_Request_Type__c,&apos;Transaction Request&apos;),  NOT(BEGINS(OwnerId,&apos;005&apos;)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>User Support - User Support Queue</fullName>
        <actions>
            <name>User_Support_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Used in user support</description>
        <formula>AND( NOT(ISNEW()),(RecordType.DeveloperName == &apos;User_Support&apos; ), ISPICKVAL(Service_Request_Type__c,&apos;User Support&apos;),  NOT(BEGINS(OwnerId,&apos;005&apos;)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UserSupportCaseOwnerToQueue</fullName>
        <actions>
            <name>OwnerUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>User Support</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>UserSupportCaseOwnerToUserSupportQueue</fullName>
        <actions>
            <name>CaseOwnerUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>User Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Service_Request_Type__c</field>
            <operation>equals</operation>
            <value>Access,Group/List Access,Group Request,Question,System Enhancement Request,System Error,Training Request</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>UserSupportCaseSubjectUpdate</fullName>
        <actions>
            <name>SubjectUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>User Support</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>orginal case owner</fullName>
        <actions>
            <name>Update_Original_Owner_For_User_Support</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>User Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Original_Owner__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Contact_Client</fullName>
        <assignedTo>mfsowner@mfs.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Contact Client in reference to redemption and close change request</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>User.CreatedDate</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Contact Client</subject>
    </tasks>
    <tasks>
        <fullName>Notify_Client</fullName>
        <assignedToType>owner</assignedToType>
        <description>Notify Client that Service Request has been completed</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.ClosedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Notify Client</subject>
    </tasks>
    <tasks>
        <fullName>Please_Close_Service_Request</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please Resolve Service Request, due date is tomorrow</description>
        <dueDateOffset>-1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.Due_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Please Close Service Request</subject>
    </tasks>
    <tasks>
        <fullName>Service_Request_Closed_Notify_Client</fullName>
        <assignedToType>owner</assignedToType>
        <description>Notify Client, Service Request has been completed</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.ClosedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Service Request Closed Notify Client</subject>
    </tasks>
    <tasks>
        <fullName>Service_Request_Due_Date_is_Approaching</fullName>
        <assignedToType>owner</assignedToType>
        <description>Service Request Due Date is approaching please work to close out</description>
        <dueDateOffset>-1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.Due_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Service Request Due Date is Approaching</subject>
    </tasks>
    <tasks>
        <fullName>Service_Request_Past</fullName>
        <assignedToType>owner</assignedToType>
        <description>Service Request is Past Due Date please close out request</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.Due_Date__c</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Service Request Past Due</subject>
    </tasks>
    <tasks>
        <fullName>Service_Request_Past_Due</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.Due_Date__c</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Service Request Past Due</subject>
    </tasks>
</Workflow>
