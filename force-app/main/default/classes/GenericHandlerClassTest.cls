@isTest
public class GenericHandlerClassTest {
    static testMethod void createTasksTest() {
        Account acc = new Account(name = 'Test', AccountNumber = '123456');
        insert acc;
        acc.Active__c = true;
        update acc;
    }
    static testMethod void activateAccountstest() {
        Account acc = new Account(name = 'Test', AccountNumber = '123456');
        insert acc;
        Task objtask = [SELECT Id FROM Task WHERE WhatId =: acc.Id LIMIT 1];
        objTask.Status = 'Completed';
        update objTask;
    }
}