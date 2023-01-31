// --------------------
// IMPORTS
// --------------------
import { LightningElement, track, wire } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import TASK_OBJECT from '@salesforce/schema/Task';
import getTasks from '@salesforce/apex/todoListController.getTasks';
import createTask from '@salesforce/apex/todoListController.createTask';
// --------------------
// SETUP
// --------------------
export default class CreateTask extends LightningElement {
    @track taskName;
    @track textValue;
    @wire(getTasks) tasks;
// --------------------
// METHODS
// --------------------
    async createTask() {
        try {
            await createTask({ taskName: this.taskName });
            this.taskName = '';
            await refreshApex(this.tasks);
        } catch (error) {
            console.error(error);
        }
    } // uses taskName to create a new task before refreshing the task list

    handleInputChange(event) {
        this.textValue = event.detail.value;
        this.taskName = event.target.value;
    } // handles text input - changes the card title live and on-add
}
// --------------------