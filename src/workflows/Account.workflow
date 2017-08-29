<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Change_RT</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Global_Retail</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change RT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_RT_to_Consultant</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Investment_Consultant</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change RT to Consultant</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_RT_to_Custodian_Service_Provider</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Service_Provider</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change RT to Custodian, Service Provider</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_RT_to_Global_Inst_Client</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Global_Institutional_Client</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change RT to Global Inst Client</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_RT_to_Global_Inst_Prospect</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Global_Institutional_Prospect</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change RT to Global Inst Prospect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_RT_to_Global_Retail</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Global_Retail</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change RT to Global Retail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ChannelUpdate</fullName>
        <field>Channel__c</field>
        <formula>IF(INCLUDES(Distribution_Level__c , &apos;Global Institutional&apos;), &apos;Global Institutional;&apos;,null) +
IF(INCLUDES(Distribution_Level__c, &apos;Non-US Retail&apos;), &apos;Non-US Retail;&apos;,null) +
IF(INCLUDES(Distribution_Level__c, &apos;US Retail&apos;), &apos;US Retail;&apos;,null)</formula>
        <name>ChannelUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IsAConsultant</fullName>
        <field>IsConsultant__c</field>
        <literalValue>1</literalValue>
        <name>IsAConsultant</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IsCompetitor</fullName>
        <field>IsCompetitor__c</field>
        <literalValue>1</literalValue>
        <name>IsCompetitor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IsNotCompetitor</fullName>
        <field>IsCompetitor__c</field>
        <literalValue>0</literalValue>
        <name>IsNotCompetitor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IsNotConsultant</fullName>
        <field>IsConsultant__c</field>
        <literalValue>0</literalValue>
        <name>IsNotConsultant</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Global_Institutional_Client</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateAlternateName</fullName>
        <field>Alternate_Name__c</field>
        <formula>Name</formula>
        <name>UpdateAlternateName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateOrgOwner</fullName>
        <description>Updates Organization Owner to MFS Owner</description>
        <field>OwnerId</field>
        <lookupValue>mfsowner@mfs.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>UpdateOrgOwner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Billing_Country</fullName>
        <description>This field update action updates the Billing Country to blank if there is no Billing street information for an organization.</description>
        <field>BillingCountry</field>
        <name>Update Billing Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Shipping_Country</fullName>
        <field>ShippingCountry</field>
        <name>Update Shipping Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>AlternateNameBlank</fullName>
        <actions>
            <name>UpdateAlternateName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Alternate_Name__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Alternate Name Blank</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Org Record Type</fullName>
        <actions>
            <name>Change_RT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>(TEXT(Type__c) = &apos;Competitor&apos; &amp;&amp; !INCLUDES(Distribution_Level__c,&apos;Global Institutional&apos;)) || (ISNEW() &amp;&amp; TEXT(Type__c) = &apos;Competitor&apos; &amp;&amp; !INCLUDES(Distribution_Level__c,&apos;Global Institutional&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Org Record Type based on Distribution</fullName>
        <actions>
            <name>Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>(INCLUDES(Distribution_Level__c,&apos;Global Institutional&apos;) &amp;&amp; TEXT(Type__c) = &apos;Competitor&apos; ) || (ISNEW() &amp;&amp; TEXT(Type__c) = &apos;Competitor&apos; &amp;&amp; INCLUDES(Distribution_Level__c,&apos;Global Institutional&apos;) &amp;&amp; TEXT(Type__c) = &apos;Competitor&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Clear Billing Country if Street is Null</fullName>
        <actions>
            <name>Update_Billing_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.BillingStreet</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.BillingState</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.BillingCity</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>This workflow rule will clear out the Billing country if there is no other billing address information available for the organization.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Clear Shipping Country if Street is Null</fullName>
        <actions>
            <name>Update_Shipping_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.ShippingStreet</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.ShippingState</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.ShippingCity</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>This workflow rule will clear out the Shipping country if there is no other Shipping address information available for the organization.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CopyDistributionChannel</fullName>
        <actions>
            <name>ChannelUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NewInsOrgFlag</fullName>
        <active>false</active>
        <formula>AND(RecordType.Name =&quot;Institutional Client&quot;, ( TODAY()-Datevalue(CreatedDate)&lt;30))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SetOwnertoMFSOwner</fullName>
        <actions>
            <name>UpdateOrgOwner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>notEqual</operation>
            <value>MFS Owner</value>
        </criteriaItems>
        <description>Sets Organization Ownership to MFS Owner</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Unknown RT - Type is Client%2FProspect and Distribution Channel is Global Inst AND %28US Retail%2C Non US Retail%2C or Both%29</fullName>
        <actions>
            <name>Change_RT_to_Global_Inst_Client</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>if Type = Client/Prospect then 
If Distribution Channel = Global Institutional AND (US Retail, Non US Retail, or Both) then Org Type = Global Institutional</description>
        <formula>(TEXT(Type__c) = &apos;Client/Prospect&apos; &amp;&amp; INCLUDES(Distribution_Level__c,&apos;Global Institutional&apos;) &amp;&amp; ( INCLUDES(Distribution_Level__c,&apos;Non-US Retail&apos;) || INCLUDES(Distribution_Level__c,&apos;US Retail&apos;)) &amp;&amp; RecordType.DeveloperName = &apos;UNKNOWN&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Unknown Record Type - Type is Client%2FProspect and  Distribution Channel is US Retail or Non Us Retail</fullName>
        <actions>
            <name>Change_RT_to_Global_Retail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>if Type = Client/Prospect then
 If Distribution Channel in (US Retail, Non US Retail, or Both) then Org Record Type = Global Retail</description>
        <formula>(TEXT(Type__c) = &apos;Client/Prospect&apos; &amp;&amp; INCLUDES(Distribution_Level__c,&apos;US Retail&apos;) &amp;&amp; RecordType.DeveloperName = &apos;UNKNOWN&apos; &amp;&amp; !INCLUDES(Distribution_Level__c,&apos;Global Institutional&apos;)) || (TEXT(Type__c) = &apos;Client/Prospect&apos; &amp;&amp; INCLUDES(Distribution_Level__c,&apos;Non-US Retail&apos;) &amp;&amp; RecordType.DeveloperName = &apos;UNKNOWN&apos; &amp;&amp;  !INCLUDES(Distribution_Level__c,&apos;Global Institutional&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Unknown Record Type - Type is Client%2FProspect and Distribution Channel is Global Inst and Sales Status is Prospect</fullName>
        <actions>
            <name>Change_RT_to_Global_Inst_Prospect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>if Type = Client/Prospect then
 If Distribution Channel = Global Institutional and Sales Status = Prospect then Org Record Type = Global Institutional Prospect</description>
        <formula>(TEXT(Type__c) = &apos;Client/Prospect&apos; &amp;&amp; INCLUDES(Distribution_Level__c,&apos;Global Institutional&apos;) &amp;&amp; ISPICKVAL ( Sales_Status__c ,&apos;Prospect&apos;) &amp;&amp; RecordType.DeveloperName = &apos;UNKNOWN&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Unknown Record Type - Type is Competitor</fullName>
        <actions>
            <name>Change_RT_to_Global_Retail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Type__c</field>
            <operation>equals</operation>
            <value>Competitor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>UNKNOWN</value>
        </criteriaItems>
        <description>If Type = Competitor then Org Record Type = Global Retail</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Unknown Record Type - Type is Custodian or Service Provider</fullName>
        <actions>
            <name>Change_RT_to_Custodian_Service_Provider</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 3) AND 2</booleanFilter>
        <criteriaItems>
            <field>Account.Type__c</field>
            <operation>equals</operation>
            <value>Service Provider</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>UNKNOWN</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Type__c</field>
            <operation>equals</operation>
            <value>Special Dealer</value>
        </criteriaItems>
        <description>If Type in (Custodian, Service Provider) then Org Record Type = Service Provider</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Unknown Record Type - Type is Investment Consultant</fullName>
        <actions>
            <name>Change_RT_to_Consultant</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Type__c</field>
            <operation>equals</operation>
            <value>Investment_Consultant</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>UNKNOWN</value>
        </criteriaItems>
        <description>If Type = Investment Consultant then Org Record Type = Consultant</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Unknown Record Type -Type is Client%2FProspect and Distribution Channel is Global Institutional and Sales Status is Client</fullName>
        <actions>
            <name>Change_RT_to_Global_Inst_Client</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>if Type = Client/Prospect then 
 If Distribution Channel = Global Institutional and Sales Status = Client then Org Record Type = Global Institutional Client</description>
        <formula>(TEXT(Type__c) = &apos;Client/Prospect&apos; &amp;&amp; INCLUDES(Distribution_Level__c,&apos;Global Institutional&apos;) &amp;&amp; ISPICKVAL ( Sales_Status__c ,&apos;Client&apos;) &amp;&amp; RecordType.DeveloperName = &apos;UNKNOWN&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
