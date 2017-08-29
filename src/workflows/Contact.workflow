<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>BuildContactName</fullName>
        <field>Contact_Name__c</field>
        <formula>FirstName+&apos; &apos;+LastName</formula>
        <name>BuildContactName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>City_Custom_Field_Update</fullName>
        <field>Street_City__c</field>
        <formula>MailingCity</formula>
        <name>City Custom Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Contact_name_for_attendee_search</fullName>
        <field>Contact_Name_for_Attendee_Search__c</field>
        <formula>IF(
AND(
NOT(ISBLANK(FirstName ) ),
NOT(ISBLANK( MiddleName ) ),
NOT(ISBLANK( LastName ) )
),
FirstName + &apos; &apos; + MiddleName + &apos; &apos; +LastName,

IF(
AND(
NOT(ISBLANK(FirstName ) ),
NOT(ISBLANK( LastName ) )
),
FirstName + &apos; &apos; + LastName,

IF(
AND(
NOT(ISBLANK( MiddleName ) ),
NOT(ISBLANK( LastName ) )
),
MiddleName + &apos; &apos; +LastName,
LastName
)
)
)</formula>
        <name>Copy Contact name for attendee search</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Country_Update</fullName>
        <field>Street_Country__c</field>
        <formula>MailingCountry</formula>
        <name>Country Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OptOut</fullName>
        <field>optout__c</field>
        <formula>&quot;Out&quot;</formula>
        <name>OptOut</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Postal_Code_Update</fullName>
        <field>Street_Zip_Postal_Code__c</field>
        <formula>MailingPostalCode</formula>
        <name>Postal Code Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>State_Update</fullName>
        <field>Street_State_Province__c</field>
        <formula>MailingState</formula>
        <name>State Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Street_Update</fullName>
        <field>Street_Street__c</field>
        <formula>MailingStreet</formula>
        <name>Street Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateContactOrg</fullName>
        <field>Date_Joined_Current_Firm__c</field>
        <formula>TODAY()</formula>
        <name>UpdateContactOrg</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateContactOwner</fullName>
        <description>Update Contact Owner</description>
        <field>OwnerId</field>
        <lookupValue>mfsowner@mfs.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>UpdateContactOwner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateContactRecordTypetoInst</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Institutional</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>UpdateContactRecordTypetoInst</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateContactRecordTypetoRetail</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Retail</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>UpdateContactRecordTypetoRetail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateLinkedInwithMMDLinked</fullName>
        <field>LinkedIn__c</field>
        <formula>MMD_LINKEDIN__c</formula>
        <name>UpdateLinkedInwithMMDLinked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMailingCountrytoNull</fullName>
        <field>MailingCountry</field>
        <name>UpdateMailingCountrytoNull</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateOtherCountrytoNull</fullName>
        <field>OtherCountry</field>
        <name>UpdateOtherCountrytoNull</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdatetoContactConsultantRecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Consultant</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>UpdatetoContactConsultantRecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Automating street address updation when Contact switches Organization</fullName>
        <active>true</active>
        <description>Street address updates when the Org changes</description>
        <formula>ISCHANGED( AccountId )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BuildCustomContactName</fullName>
        <actions>
            <name>BuildContactName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Contact Name is automatically updaeted</description>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact change from one account to another account</fullName>
        <active>true</active>
        <description>Contact change from one account to another account, CRT flag in Association table will be updated to false.</description>
        <formula>Or(ISCHANGED(AccountId),ISPICKVAL(Account.Entity_Status__c,&quot;Inactive&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy Contact name to custom contact name field for attendee search</fullName>
        <actions>
            <name>Copy_Contact_name_for_attendee_search</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MFS Copy Street Address to Custom Fields</fullName>
        <actions>
            <name>City_Custom_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Country_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Postal_Code_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>State_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Street_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>The standard, MFS, Street Address is applied to all address fields</description>
        <formula>ISCHANGED( MailingCity )  ||  ISCHANGED(MailingState)  ||  ISCHANGED( MailingCountry )  ||  ISCHANGED( MailingPostalCode )  ||  ISCHANGED( MailingStreet ) || ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PopulateLinkedInwithMMD</fullName>
        <actions>
            <name>UpdateLinkedInwithMMDLinked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populates LinkedInfield with MMD LinkedIn Data when field is blank.</description>
        <formula>ISBLANK( LinkedIn__c )&amp;&amp; NOT(ISBLANK( MMD_LINKEDIN__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Mailing Address to Blank</fullName>
        <actions>
            <name>UpdateMailingCountrytoNull</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.MailingCity</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MailingState</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MailingStreet</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Other Address to Blank</fullName>
        <actions>
            <name>UpdateOtherCountrytoNull</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.OtherCity</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.OtherState</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.OtherStreet</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SetContactOwnertoMFSOwner</fullName>
        <actions>
            <name>UpdateContactOwner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.OwnerId</field>
            <operation>notEqual</operation>
            <value>MFS Owner</value>
        </criteriaItems>
        <description>Sets Contact Ownership to MFS Owner</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SetDateJoinedCurrentFirm</fullName>
        <actions>
            <name>UpdateContactOrg</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>((ISCHANGED( AccountId))
||
( ISNEW()))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TestUpdateType</fullName>
        <active>false</active>
        <formula>1=1</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Unknown Record Type - Update to Account</fullName>
        <actions>
            <name>UpdateContactRecordTypetoInst</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>UNKNOWN</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Service Provider,Service Provider - Verified,Global Institutional Prospect,Global Institutional Prospect - Verified,Global Institutional Client,Global Institutional Client - Verified</value>
        </criteriaItems>
        <description>Updates to match account record type if the record type for contact = unknown</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Unknown Record Type - Update to Consultant</fullName>
        <actions>
            <name>UpdatetoContactConsultantRecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>UNKNOWN</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Investment Consultant,Investment Consultant - Verified</value>
        </criteriaItems>
        <description>Updates to match account record type if the record type for contact = unknown</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Unknown Record Type - Update to Retail</fullName>
        <actions>
            <name>UpdateContactRecordTypetoRetail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>UNKNOWN</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Global Retail,Global Retail - Verified</value>
        </criteriaItems>
        <description>Updates to match account record type if the record type for contact = unknown</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateOptOut</fullName>
        <actions>
            <name>OptOut</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Opt Out is evaluated on creation and edit</description>
        <formula>ISCHANGED( HasOptedOutOfEmail ) &amp;&amp; HasOptedOutOfEmail = TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
