<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
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
        <fullName>Pending</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pending_For_Approval</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Pending For Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Record Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Record Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateStepCarolGeremia</fullName>
        <description>Updates Step owner to Carol Geremia Group</description>
        <field>Approval_Step_Owner__c</field>
        <formula>&quot;Carol Geremia Queue&quot;</formula>
        <name>UpdateStepCarolGeremia</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Equity_Step</fullName>
        <description>updates the equity step for speaker request.</description>
        <field>Approval_Step_Owner__c</field>
        <formula>IF((((ISPICKVAL(Speaker_Request__r.Requester__r.Business__c , &apos;Retail&apos;) &amp;&amp; ISPICKVAL( Speaker_Request__r.Requester__r.Speaker_Request_Approval__c , &apos;US Equity Analyst&apos;)) || (ISPICKVAL(Speaker_Request__r.Requester__r.Business__c , &apos;Retail&apos;) &amp;&amp; ISPICKVAL( Speaker_Request__r.Requester__r.Speaker_Request_Approval__c , &apos;Fixed Income&apos;)) || (ISPICKVAL(Speaker_Request__r.Requester__r.Business__c , &apos;Retail&apos;) &amp;&amp; ISPICKVAL( Speaker_Request__r.Requester__r.Speaker_Request_Approval__c , &apos;Non-US Retail&apos;)))&amp;&amp; !ISPICKVAL(Approval_Status__c , &apos;Rejected&apos;)),&quot;&quot;,&quot;Retail Equity Queue&quot;)</formula>
        <name>Update Equity Step</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_IPM_Step2</fullName>
        <field>Approval_Step_Owner__c</field>
        <formula>IF((ISPICKVAL(Speaker_Request__r.Requester__r.Business__c , &apos;Retail&apos;) &amp;&amp; ISPICKVAL(Speaker_Request__r.Requester__r.Speaker_Request_Approval__c , &apos;PM&apos;) &amp;&amp; !ISPICKVAL(Approval_Status__c,&apos;Rejected&apos;)),&quot;&quot;,&quot;Speaker Coordinator Queue&quot;)</formula>
        <name>Update IPM Step2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PM_Step</fullName>
        <field>Approval_Step_Owner__c</field>
        <formula>IF((!ISPICKVAL(Speaker_Request__r.Requester__r.Speaker_Request_Approval__c,&apos;IPS&apos;) &amp;&amp; !ISPICKVAL(Approval_Status__c,&apos;Rejected&apos;)) || (ISPICKVAL(Speaker_Request__r.Requester__r.Business__c,&apos;Retail&apos;) &amp;&amp; Speaker_Request__r.RecordType.Name = &apos;Trading Floor Tour&apos;),&quot;&quot;,&quot;IPM Queue&quot;)</formula>
        <name>Update PM Step</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Step_IPM</fullName>
        <field>Approval_Step_Owner__c</field>
        <formula>&quot;IPM&quot;</formula>
        <name>Update Step IPM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Step_IPS</fullName>
        <field>Approval_Step_Owner__c</field>
        <formula>IF((!ISPICKVAL(Speaker_Request__r.Requester__r.Speaker_Request_Approval__c,&apos;IPS&apos;)),&quot;&quot;,&quot;Speaker Coordinator Queue&quot;)</formula>
        <name>Update Step IPS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Step_Jim_Jessee</fullName>
        <field>Approval_Step_Owner__c</field>
        <formula>&quot;Jim Jessee Queue&quot;</formula>
        <name>Update Step Jim Jessee</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Step_Speaker_Coordinator</fullName>
        <field>Approval_Step_Owner__c</field>
        <formula>&quot;Speaker Coordinator Queue&quot;</formula>
        <name>Update Step Speaker Coordinator</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
