trigger TaskTrigger on Task (after insert, after update) {
	GenericHandlerClass.activateAccounts(Trigger.New, Trigger.oldMap, Trigger.newMap);
}