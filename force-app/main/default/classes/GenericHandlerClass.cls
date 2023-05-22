public class GenericHandlerClass {
    public static void activateAccounts(List<Task> newTasks, Map<Id, Task> oldTaskMap, Map<Id, Task> newTaskMap) {
        Boolean hasPermissionSet = FeatureManagement.checkPermission('CQ_Account_Admin');
        List<Account> accListToUpdate = new List<Account>();
        Set<Id> accountIds = new Set<Id>();
        Set<Id> accIdsToMakeActive = new Set<Id>();
        Set<Id> accsWithTasks = new Set<Id>();
        Map<Id, List<Task>> accTaskListMap = new Map<Id, List<Task>>();
        Map<Id, String> taskDescMap = new Map<Id, String>();
        for (Task objTask : newtasks) {
            if (objTask.Status == 'Completed' && objTask.Status != oldTaskMap.get(objTask.Id).Status && objTask.WhatId != null && String.valueOf(objTask.WhatId).startsWith('001')) {
                if (!hasPermissionSet) {
                    objTask.addError('You dont have permission set to complete tasks and add accounts');
                    continue;
                } else {
                    accountIds.add(objTask.WhatId);
                    taskDescMap.put(objTask.WhatId, objTask.Description);
                }
            }
        }
        for (Task objTask : [SELECT Id,Description, WhatId FROM Task WHERE Status != 'Completed' AND WhatId IN: accountIds]) {
            List<Task> taskList = accTaskListMap.containsKey(objTask.WhatId) ?accTaskListMap.get(objTask.WhatId): new List<Task>();
            taskList.add(objTask);
            accTaskListMap.put(objTask.WhatId, taskList);
        }
        for (Id accId : accountIds) {
            if (!accTaskListMap.containsKey(accId)) {
                accListToUpdate.add(new Account(Id = accId, Active__c = true, Description = taskDescMap.get(accId)));
            }
        }
        update accListToUpdate;
    }
    
    public static void completeTasks(List<Account> newAccs, Map<Id, Account> oldAccMap) {
        Set<Id> accountIds = new Set<Id>();
        List<Task> taskToComplete = new List<Task>();
        List<Account> accsToUpdate = new List<Account>();
        Map<Id, String> taskDescMap = new Map<Id, String>();
        for (Account acc : newAccs) {
            if (acc.Active__c && oldAccMap.get(acc.Id).Active__c != acc.Active__c) {
                accountIds.add(acc.Id);
            }
        }
        for (Task objTask : [SELECT Id,Description, WhatId FROM Task WHERE Status != 'Completed' AND WhatId IN: accountIds]) {
            taskDescMap.put(objTask.WhatId, objTask.Description);
            taskToComplete.add(new Task(Id = objTask.Id, Status = 'Completed'));
        }
        update taskToComplete;
        for (Id accId : taskDescMap.keySet()) {
            accsToUpdate.add(new Account(Id = accId, Description = taskDescMap.get(accId)));
        }
        update accsToUpdate;
    }
    public static void createTasks(List<Account> accList) {
        List<Task> taskList = new List<Task>();
        for (Account acc : accList) {
            Task objTask = new Task();
            objTask.Subject = 'Review Account - ' + (String.isNotBlank(acc.AccountNumber) ? acc.AccountNumber : '');
            objTask.ActivityDate = Date.today().addDays(7);
            objTask.WhatId = acc.Id;
            objtask.OwnerId = acc.OwnerId;
            objTask.Status = 'Not Started';
            taskList.add(objTask);
        }
        insert taskList;
    }
}