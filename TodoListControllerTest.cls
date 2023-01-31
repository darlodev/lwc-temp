@isTest
private with sharing class TodoListControllerTest {

    static User u;

    // Create Test User
    @testSetup
    static void TestUser(){
        Profile p = [SELECT Id FROM Profile WHERE Name ='Chatter Free User' LIMIT 1];
        u = new User(Username='lwcbronzetestjordan@revolent.com', Email='lwcbronzetestjordan@revolent.com', EmailEncodingKey='UTF-8', ProfileId=p.Id, LastName='Test', Alias='lwcbjd', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', LanguageLocaleKey='en_US');
        insert u;
    }


    // Valid Get
    @isTest
    static void TestGetTask() {
        Task testTask = new Task(
            Subject = 'Test Task',
            OwnerId = UserInfo.getUserId()
        );
        insert testTask;

        Test.startTest();{
            List<Task> tasks = TodoListController.getTasks();
            System.assertEquals(1, tasks.size());
            System.assertEquals(testTask.Id, tasks[0].Id);
        Test.stopTest();
        }
    }


    // Valid Create
    @isTest
    static void TestCreateTaskValid() {
        Test.startTest();
            TodoListController.createTask('Test Task');
            List<Task> tasks = [SELECT Id, Subject FROM Task WHERE OwnerId = :UserInfo.getUserId()];
            System.assertEquals(1, tasks.size());
            System.assertEquals('Test Task', tasks[0].Subject);
        Test.stopTest();
    }
    // Invalid Create
    @isTest
    static void TestCreateTaskInvalid() {
        user u = [SELECT Id FROM User WHERE Username='lwcbronzetestjordan@revolent.com'];
        System.runAs(u) {
            Test.startTest();
            try {
                TodoListController.createTask('Test Task');
            } catch (AuraHandledException e) {
                String msg = e.getMessage();
                System.assertEquals(false, msg.contains('An error occurred whilst creating tasks: '));
            }
            Test.stopTest();
        }
    }

    // Valid Delete
    @isTest
    static void TestDeleteTaskValid() {
        Task testTask = new Task(
            Subject = 'Test Task',
            OwnerId = UserInfo.getUserId()
        );
        insert testTask;

        Test.startTest();
            TodoListController.deleteTask(testTask.Id);
            List<Task> tasks = [SELECT Id FROM Task WHERE OwnerId = :UserInfo.getUserId()];
            System.assertEquals(0, tasks.size());
        Test.stopTest();
    }

    // Invalid Delete
    @isTest
    static void TestDeleteTaskInvalid() {
        Task testTask = new Task(
            Subject = 'Test Task',
            OwnerId = UserInfo.getUserId()
        );
        insert testTask;

        user u = [SELECT Id FROM User WHERE Username='lwcbronzetestjordan@revolent.com'];
        System.runAs(u) {
            Test.startTest();
            try {
                TodoListController.deleteTask(testTask.Id);
            } catch (AuraHandledException e) {
                String msg = e.getMessage();
                System.assertEquals(false, msg.contains('An error occurred whilst deleting tasks: '));
            }
            Test.stopTest();
        }
    }
}