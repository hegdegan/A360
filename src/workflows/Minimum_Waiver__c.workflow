<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ARG_Notification</fullName>
        <description>ARG Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>ARG_Notifications_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Minimum_Waiver_Created</template>
    </alerts>
    <alerts>
        <fullName>Asia_ex_Japan_Notification</fullName>
        <description>​Asia ex-Japan Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Asia_ex_Japan_Notification_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Minimum_Waiver_Created</template>
    </alerts>
    <alerts>
        <fullName>Australia_New_Zealand_Notification</fullName>
        <description>Australia / New Zealand Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Australia_NZ_Notification_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Minimum_Waiver_Created</template>
    </alerts>
    <alerts>
        <fullName>Consultant_Relations_Notification</fullName>
        <description>Consultant Relations Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Consultant_Relations_Notification_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Minimum_Waiver_Created</template>
    </alerts>
    <alerts>
        <fullName>EMEA_Notification</fullName>
        <description>EMEA Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>EMEA_Notification_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Minimum_Waiver_Created</template>
    </alerts>
    <alerts>
        <fullName>Japan_Notification</fullName>
        <description>Japan Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Japan_Notification_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Minimum_Waiver_Created</template>
    </alerts>
    <alerts>
        <fullName>MFD_KAM_Notification</fullName>
        <description>MFD (KAM) Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>MFD_KAM_Notification_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Minimum_Waiver_Created</template>
    </alerts>
    <alerts>
        <fullName>Non_US_Retail_Notification</fullName>
        <description>Non-US Retail Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Non_US_Retail_Notification_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Minimum_Waiver_Created</template>
    </alerts>
    <alerts>
        <fullName>North_America_Notification</fullName>
        <description>North America Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>North_America_Notification_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Minimum_Waiver_Created</template>
    </alerts>
    <alerts>
        <fullName>PPM_ISG_Notification</fullName>
        <description>PPM/ISG Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>PPM_ISG_Notification_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Minimum_Waiver_Created</template>
    </alerts>
    <alerts>
        <fullName>Rel_Mgrs_ex_Asia_Pac_Hybrids_Notification</fullName>
        <description>Rel Mgrs (ex Asia Pac Hybrids) Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Rel_Mgrs_Notification_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Minimum_Waiver_Created</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_status_to_Not_Started</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Not Started</literalValue>
        <name>Change status to Not Started</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>StatusApproved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>StatusApproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>StatusPending</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>StatusPending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>StatusRejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>StatusRejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>%E2%80%8BAsia ex-Japan Notification</fullName>
        <actions>
            <name>Asia_ex_Japan_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>OR($User.Country_3_Work__c = &apos;BHR&apos;,
$User.Country_3_Work__c = &apos;HKG&apos;,
$User.Country_3_Work__c = &apos;IND&apos;,
$User.Country_3_Work__c = &apos;PHL&apos;,
$User.Country_3_Work__c = &apos;SGP&apos;,
$User.Country_3_Work__c = &apos;TWN&apos;
)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ARG Notification</fullName>
        <actions>
            <name>ARG_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>ARG LS</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>ARG</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Australia %2F New Zealand Notification</fullName>
        <actions>
            <name>Australia_New_Zealand_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>User.Country_3_Work__c</field>
            <operation>equals</operation>
            <value>AUS</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Country_3_Work__c</field>
            <operation>equals</operation>
            <value>NZ</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Change the Status After Clone</fullName>
        <actions>
            <name>Change_status_to_Not_Started</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Minimum_Waiver__c.Approval_Status__c</field>
            <operation>notEqual</operation>
            <value>Not Started</value>
        </criteriaItems>
        <description>Change the status to &quot;Not Started&quot; after clone</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Consultant Relations Notification</fullName>
        <actions>
            <name>Consultant_Relations_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>Consultant Relations LS</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>Consultant Relations</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EMEA Notification</fullName>
        <actions>
            <name>EMEA_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>OR($UserRole.Name = &apos;Sales LS&apos;, $UserRole.Name = &apos;Sales&apos;)

&amp;&amp;

OR($User.Country_3_Work__c = &apos;GBR&apos;,
$User.Country_3_Work__c = &apos;PRT&apos;,
$User.Country_3_Work__c = &apos;DEU&apos;,
$User.Country_3_Work__c = &apos;ESP&apos;,
$User.Country_3_Work__c = &apos;CHE&apos;,
$User.Country_3_Work__c = &apos;FRA&apos;,
$User.Country_3_Work__c = &apos;ITA&apos;,
$User.Country_3_Work__c = &apos;NLD&apos;
)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Japan Notification</fullName>
        <actions>
            <name>Japan_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>Japan LS</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>Japan</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>MFD %28KAM%29 Notification</fullName>
        <actions>
            <name>MFD_KAM_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>Key Accounts</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>Key Accounts LS</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Non-US Retail Notification</fullName>
        <actions>
            <name>Non_US_Retail_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>Non-US LS</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>Non-US KA</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>Non-US Retail</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>North America Notification</fullName>
        <actions>
            <name>North_America_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>Sales LS</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>Sales</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PPM%2FISG Notification</fullName>
        <actions>
            <name>PPM_ISG_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>DC LS</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>DC</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>RIA</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Rel Mgrs %28ex Asia Pac Hybrids%29 Notification</fullName>
        <actions>
            <name>Rel_Mgrs_ex_Asia_Pac_Hybrids_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>Client Service LS</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>CSM</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>Coordinator</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
