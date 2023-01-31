// --------------------
// IMPORTS
// --------------------
import { LightningElement, track, wire } from 'lwc';
import { updateRecord, deleteRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';
import TASK_OBJECT from '@salesforce/schema/Task';
import getTasks from '@salesforce/apex/todoListController.getTasks';
import updateTask from '@salesforce/apex/TodoListController.updateTask';
import deleteTask from '@salesforce/apex/todoListController.deleteTask';
// --------------------
// SETUP
// --------------------
export default class TaskList extends NavigationMixin(LightningElement) {
    @track modalOpen = false;
    @track selectedTaskId;
    @track newTaskName;
    @wire(getTasks) tasks;
// --------------------
// METHODS
// --------------------
    async deleteTask(event) {
        try {
            const taskId = event.target.dataset.id;
            await deleteTask({ taskId });
            await refreshApex(this.tasks);
        } catch (error) {
            console.error(error);
        }
    } // uses taskId to delete the selected task before refreshing the task list.

    navigateToTaskRecord(event) {
        const taskId = event.target.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: taskId,
                objectApiName: 'Task',
                actionName: 'view'
            }
        });
    } // takes task id to navigate to task record page

    // UPDATE
    handleUpdateClick(event) {
        this.selectedTaskId = event.target.dataset.id;
        this.modalOpen = true;
    } // select task and open modal
    handleModalClose() {
        this.modalOpen = false;
    } // close modal
    handleModalSubmit() {
        try {
            updateTask({ taskId: this.selectedTaskId, newTaskName: this.newTaskName });
            refreshApex(this.tasks);
            this.modalOpen = false
        } catch (error) {
            console.error(error);
        }
    }
}
// --------------------