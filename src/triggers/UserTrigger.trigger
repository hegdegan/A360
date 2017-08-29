trigger UserTrigger on User (before insert, before update) {

	if(trigger.isUpdate)
		UserTriggerHandler.processUserEmailRecords(trigger.new);
}