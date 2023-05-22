trigger AccountTrigger on Account (before insert , before update, After Insert, After Update, Before Delete, After Delete) {
    if(Trigger.IsAfter  && Trigger.isInsert )
    {
        GenericHandlerClass.createTasks(Trigger.new);
    }
    if (Trigger.IsAfter  && (Trigger.isUpdate || Trigger.isInsert)) {
        GenericHandlerClass.completeTasks(Trigger.new, Trigger.oldMap);
    }
}