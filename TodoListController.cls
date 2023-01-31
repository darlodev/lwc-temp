public with sharing class TodoListController {
    // READ
    @AuraEnabled(cacheable=true)
    public static List<Task> getTasks(){
            return [SELECT Id, Subject FROM Task WHERE OwnerId = :UserInfo.getUserId() WITH SECURITY_ENFORCED];
    }
    // UPDATE
    @AuraEnabled
    public static void updateTask(Id taskId, String newTaskName){
        try {
            Task t = [SELECT Id, Subject FROM Task WHERE Id = :taskId AND OwnerId = :UserInfo.getUserId()];
            t.Subject = newTaskName;
            update t;
        } catch (Exception e) {
            throw new AuraHandledException('An error occurred whilst updating tasks: ' + e.getMessage());
        }
    }
    // CREATE
    @AuraEnabled
    public static void createTask(String taskName){
        try {
            Task t = new Task(Subject = taskName, OwnerId = UserInfo.getUserId());
            insert t;
        } catch (Exception e) {
            throw new AuraHandledException('An error occurred whilst creating tasks: ' + e.getMessage());
        }
    }
    // DELETE
    @AuraEnabled
    public static void deleteTask(Id taskId){
        try {
            Task t = [SELECT Id FROM Task WHERE Id = :taskId AND OwnerId = :UserInfo.getUserId()];
            delete t;
        } catch (Exception e) {
            throw new AuraHandledException('An error occurred whilst deleting tasks: ' + e.getMessage());
        }
    }
}