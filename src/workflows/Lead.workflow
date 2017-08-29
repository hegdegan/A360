<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>email_notification_to_a_member_of_salesteam_on_lead_conversion</fullName>
        <description>Email notification to a member of salesteam on lead conversion</description>
        <protected>false</protected>
        <recipients>
            <recipient>msuresh@mfs.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Contact_Converted</template>
    </alerts>
    <alerts>
        <fullName>sends_email_to_member_of_salesteam</fullName>
        <description>sends email to member of salesteam</description>
        <protected>false</protected>
        <recipients>
            <recipient>Retail Sales</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Contact_Converted</template>
    </alerts>
    <fieldUpdates>
        <fullName>Lead_Company_Update</fullName>
        <description>Updates Lead Company Names</description>
        <field>Company</field>
        <formula>Organization__r.Name</formula>
        <name>Lead Company Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCompany</fullName>
        <field>Company</field>
        <formula>Organization__r.Name</formula>
        <name>UpdateCompany</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Company Name Equals Organization</fullName>
        <actions>
            <name>UpdateCompany</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Company</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EmailOnConversion</fullName>
        <actions>
            <name>email_notification_to_a_member_of_salesteam_on_lead_conversion</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.IsConverted</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Email sent to member of salesteam on lead conversion</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Company Name Equal to Org Name</fullName>
        <actions>
            <name>Lead_Company_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Company</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Set the company name equal to the organization name anytime the org name is changed or updated.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
