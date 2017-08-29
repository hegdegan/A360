<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Update_status</fullName>
        <description>Update status</description>
        <protected>false</protected>
        <recipients>
            <recipient>BI_List_Creation_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/BI_List_creation_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>Active_Changes</fullName>
        <field>IsActive</field>
        <literalValue>1</literalValue>
        <name>Active Changes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CompletedStatus</fullName>
        <field>Duration__c</field>
        <formula>NOW()- CreatedDate</formula>
        <name>CompletedStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DeactivateActiveCheckbox</fullName>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>DeactivateActiveCheckbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EndDateWithSilverID</fullName>
        <field>EndDate</field>
        <formula>Today()</formula>
        <name>EndDateWithSilverID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateActiveCheckbox</fullName>
        <field>IsActive</field>
        <literalValue>1</literalValue>
        <name>UpdateActiveCheckbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateBusinessCampaignName</fullName>
        <description>Workflow rule used to auto update the Business Driven campaign name.</description>
        <field>Name</field>
        <formula>Text( Content_Type__c ) + &apos; - &apos; +  Description__c</formula>
        <name>UpdateBusinessCampaignName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCampaignName</fullName>
        <description>Workflow rule used to auto update the Marketing Driven campaign name.</description>
        <field>Name</field>
        <formula>Text( Distribution_Channel__c )+
IF(AND( !ISBLANK(TEXT(Distribution_Channel__c )),!ISBLANK(TEXT(Content_Type__c ))),&apos; - &apos;,&apos;&apos; )+
Text( Content_Type__c )+IF(AND( !ISBLANK((Description__c)),!ISBLANK(TEXT(Content_Type__c ))),&apos; - &apos;,&apos;&apos; )+
IF(AND( !ISBLANK((Description__c)),!ISBLANK(TEXT(Distribution_Channel__c )),ISBLANK(TEXT(Content_Type__c ))),&apos; - &apos;,&apos;&apos; )+
Description__c</formula>
        <name>UpdateCampaignName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCampaignStatus</fullName>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>UpdateCampaignStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_End_Date</fullName>
        <field>EndDate</field>
        <formula>SilverPop_Updated_Date__c</formula>
        <name>Update End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SilverPop_Date</fullName>
        <field>SilverPop_Updated_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update SilverPop Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>ActiveCheckBoxCampaign</fullName>
        <actions>
            <name>UpdateActiveCheckbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Active field is automatically checked and unchecked based on Start &amp; End Dates</description>
        <formula>(StartDate &lt;=  TODAY() &amp;&amp;  EndDate  &gt;=  TODAY()) || (StartDate &lt;=  TODAY() &amp;&amp;   ISBLANK(EndDate) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Business Driven Campaign Naming Rule</fullName>
        <actions>
            <name>UpdateBusinessCampaignName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Business Driven</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Content_Type__c</field>
            <operation>notEqual</operation>
            <value>Contact</value>
        </criteriaItems>
        <description>This naming rule is used for business driven campaigns.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Campaign status</fullName>
        <actions>
            <name>Update_status</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(
NOT(ISNEW()),
ISCHANGED( Status),
ISPICKVAL(PRIORVALUE(Status),&quot;Initiated&quot;),
ISPICKVAL(Status,&quot;Planning&quot;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CampaignDeliveryType</fullName>
        <actions>
            <name>UpdateCampaignStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISChanged( Campaign_Delivery__c ), ISPICKVAL(Campaign_Delivery__c , &apos;Email&apos;)) || AND(ISChanged(SilverPop_Updated_Date__c),ISPICKVAL(Campaign_Delivery__c , &apos;Email&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DeactivateCampaignCheckbox</fullName>
        <actions>
            <name>DeactivateActiveCheckbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(StartDate &lt;=  TODAY() &amp;&amp;  EndDate &lt;  TODAY())  || (StartDate &gt;  TODAY() &amp;&amp;  EndDate &gt;  TODAY()) || (StartDate &gt; TODAY() &amp;&amp; ISBLANK(EndDate))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Duration</fullName>
        <actions>
            <name>CompletedStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Marketing Driven Campaign Naming Rule</fullName>
        <actions>
            <name>UpdateCampaignName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Marketing Driven</value>
        </criteriaItems>
        <description>This naming rule is used for marketing driven campaigns.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SilverPop Date</fullName>
        <actions>
            <name>Update_SilverPop_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(!ISBLANK(silverpop__Silverpop_ID__c), ISCHANGED( silverpop__Silverpop_ID__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
