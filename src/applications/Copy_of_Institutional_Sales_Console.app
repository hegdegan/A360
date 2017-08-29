<?xml version="1.0" encoding="UTF-8"?>
<CustomApplication xmlns="http://soap.sforce.com/2006/04/metadata">
    <customApplicationComponents>
        <alignment>right</alignment>
        <customApplicationComponent>Console.BuiltInComponent.mostRecentlyUsed</customApplicationComponent>
        <customApplicationComponent>My_Organizations</customApplicationComponent>
    </customApplicationComponents>
    <defaultLandingTab>standard-home</defaultLandingTab>
    <description>Institutional Sales Console</description>
    <detailPageRefreshMethod>autoRefresh</detailPageRefreshMethod>
    <enableCustomizeMyTabs>false</enableCustomizeMyTabs>
    <enableKeyboardShortcuts>true</enableKeyboardShortcuts>
    <enableListViewReskin>true</enableListViewReskin>
    <enableMultiMonitorComponents>true</enableMultiMonitorComponents>
    <enablePinTabs>true</enablePinTabs>
    <footerColor>#8CB4D8</footerColor>
    <headerColor>#D0D0D1</headerColor>
    <isServiceCloudConsole>true</isServiceCloudConsole>
    <keyboardShortcuts>
        <defaultShortcut>
            <action>FOCUS_CONSOLE</action>
            <active>true</active>
            <keyCommand>ESC</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>FOCUS_NAVIGATOR_TAB</action>
            <active>true</active>
            <keyCommand>V</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>FOCUS_DETAIL_VIEW</action>
            <active>true</active>
            <keyCommand>SHIFT+S</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>FOCUS_PRIMARY_TAB_PANEL</action>
            <active>true</active>
            <keyCommand>P</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>FOCUS_SUBTAB_PANEL</action>
            <active>true</active>
            <keyCommand>S</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>FOCUS_LIST_VIEW</action>
            <active>true</active>
            <keyCommand>N</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>FOCUS_FIRST_LIST_VIEW</action>
            <active>true</active>
            <keyCommand>SHIFT+F</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>FOCUS_SEARCH_INPUT</action>
            <active>true</active>
            <keyCommand>R</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>MOVE_LEFT</action>
            <active>true</active>
            <keyCommand>LEFT ARROW</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>MOVE_RIGHT</action>
            <active>true</active>
            <keyCommand>RIGHT ARROW</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>UP_ARROW</action>
            <active>true</active>
            <keyCommand>UP ARROW</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>DOWN_ARROW</action>
            <active>true</active>
            <keyCommand>DOWN ARROW</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>OPEN_TAB_SCROLLER_MENU</action>
            <active>true</active>
            <keyCommand>D</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>OPEN_TAB</action>
            <active>true</active>
            <keyCommand>T</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>CLOSE_TAB</action>
            <active>true</active>
            <keyCommand>C</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>REFRESH_TAB</action>
            <active>false</active>
            <keyCommand>SHIFT+R</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>ENTER</action>
            <active>true</active>
            <keyCommand>ENTER</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>EDIT</action>
            <active>true</active>
            <keyCommand>CTRL+E</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>SAVE</action>
            <active>true</active>
            <keyCommand>CTRL+S</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>CONSOLE_LINK_DIALOG</action>
            <active>false</active>
            <keyCommand>U</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>HOTKEYS_PANEL</action>
            <active>false</active>
            <keyCommand>SHIFT+K</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>FOCUS_MACRO</action>
            <active>false</active>
            <keyCommand>M</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>FOCUS_FOOTER_PANEL</action>
            <active>false</active>
            <keyCommand>F</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>TOGGLE_LIST_VIEW</action>
            <active>false</active>
            <keyCommand>SHIFT+N</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>TOGGLE_LEFT_SIDEBAR</action>
            <active>false</active>
            <keyCommand>SHIFT+LEFT ARROW</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>TOGGLE_RIGHT_SIDEBAR</action>
            <active>false</active>
            <keyCommand>SHIFT+RIGHT ARROW</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>TOGGLE_TOP_SIDEBAR</action>
            <active>false</active>
            <keyCommand>SHIFT+UP ARROW</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>TOGGLE_BOTTOM_SIDEBAR</action>
            <active>false</active>
            <keyCommand>SHIFT+DOWN ARROW</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>TOGGLE_APP_LEVEL_COMPONENTS</action>
            <active>false</active>
            <keyCommand>Z</keyCommand>
        </defaultShortcut>
        <defaultShortcut>
            <action>REOPEN_LAST_TAB</action>
            <active>false</active>
            <keyCommand>SHIFT+C</keyCommand>
        </defaultShortcut>
    </keyboardShortcuts>
    <label>Console</label>
    <listPlacement>
        <location>full</location>
    </listPlacement>
    <listRefreshMethod>refreshList</listRefreshMethod>
    <primaryTabColor>#8CB4D8</primaryTabColor>
    <pushNotifications>
        <pushNotification>
            <fieldNames>LastActivityDate</fieldNames>
            <objectName>Account</objectName>
        </pushNotification>
        <pushNotification>
            <fieldNames>IsClosed</fieldNames>
            <objectName>Case</objectName>
        </pushNotification>
        <pushNotification>
            <fieldNames>LastActivityDate</fieldNames>
            <objectName>Contact</objectName>
        </pushNotification>
        <pushNotification>
            <fieldNames>LastActivityDate</fieldNames>
            <objectName>Opportunity</objectName>
        </pushNotification>
    </pushNotifications>
    <saveUserSessions>false</saveUserSessions>
    <tab>standard-Chatter</tab>
    <tab>standard-Account</tab>
    <tab>standard-Contact</tab>
    <tab>standard-Case</tab>
    <tab>standard-Opportunity</tab>
    <tab>Approval_Request__c</tab>
    <tab>standard-report</tab>
    <tab>pca__Setting__c</tab>
    <tab>BI_Dashboard</tab>
    <tab>State_and_Country_Picklist</tab>
    <workspaceMappings>
        <mapping>
            <tab>Approval_Request__c</tab>
        </mapping>
        <mapping>
            <tab>BI_Dashboard</tab>
        </mapping>
        <mapping>
            <tab>State_and_Country_Picklist</tab>
        </mapping>
        <mapping>
            <tab>pca__Setting__c</tab>
        </mapping>
        <mapping>
            <tab>standard-Account</tab>
        </mapping>
        <mapping>
            <tab>standard-Case</tab>
        </mapping>
        <mapping>
            <tab>standard-Chatter</tab>
        </mapping>
        <mapping>
            <fieldName>AccountId</fieldName>
            <tab>standard-Contact</tab>
        </mapping>
        <mapping>
            <fieldName>AccountId</fieldName>
            <tab>standard-Opportunity</tab>
        </mapping>
        <mapping>
            <tab>standard-report</tab>
        </mapping>
    </workspaceMappings>
</CustomApplication>