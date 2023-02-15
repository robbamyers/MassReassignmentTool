import { LightningElement, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import fetchMatterTeamMembers from '@salesforce/apex/MassReassignmentToolController.fetchMatterTeamMembers';
import fetchMetadataRecord from '@salesforce/apex/MassReassignmentToolController.fetchMetadataRecord';
import fetchTasks from '@salesforce/apex/MassReassignmentToolController.fetchTasks';
import updateMatterTeamMembersAndLookupsBatch from '@salesforce/apex/MassReassignmentToolController.updateMatterTeamMembersAndLookupsBatch';
import updateMatterTeamMembersBatch from '@salesforce/apex/MassReassignmentToolController.updateMatterTeamMembersBatch';
import updateMatterTeamMembersAndTasksBatch from '@salesforce/apex/MassReassignmentToolController.updateMatterTeamMembersAndTasksBatch';
import fetchProgressData from '@salesforce/apex/MassReassignmentToolController.fetchProgressData';
import updateMatterTeamMemberAndLookupsAndTasksBatch from '@salesforce/apex/MassReassignmentToolController.updateMatterTeamMemberAndLookupsAndTasksBatch';
import UserPreferencesShowFaxToExternalUsers from '@salesforce/schema/User.UserPreferencesShowFaxToExternalUsers';

export default class MassRassignmentTool extends LightningElement {

    options = [ { label: 'Reassign Matter Team Members', value: '1'},
                { label: 'Reassign Matter Team Members and update lookups', value: '2'},
                { label: 'Reassign Matter Team Members and reassign open tasks', value: '3'},
                { label: 'Reassign Matter Team Members and update lookups and reassign open tasks', value: '4'}
              ];

    selectedCurrentUser = "";
    selectedNewUser = "";
    updateTypeValue = '1';
    matterTeamMembers;
    tasks;
    displayText = "";
    showButton = false;
    showProgressBar = false; 
    showReset = false;
    jobIds = [];
    progressBarValue = 0;

    @wire(fetchMetadataRecord)
    metaData;



    handleAccountSelection(event){
        if(event.currentTarget.dataset.id === 'current-user'){
            this.selectedCurrentUser = event.target.value;

            fetchMatterTeamMembers({ userId: this.selectedCurrentUser}).then((result) => {
                this.matterTeamMembers = result;
            }).catch((err)=>{
                console.error(err);
            }).finally(() => {
                fetchTasks({userId: this.selectedCurrentUser}).then((result) => {
                    this.tasks = result;
                }).catch((err)=>{
                    console.error(err);
                }).finally(() => {
                    this.handleDisplayText();
                });
            });
            this.handleShowButton();
        }
        if(event.currentTarget.dataset.id === 'new-user'){
            this.selectedNewUser = event.target.value;
            this.handleShowButton();
        }
    }

    handleRadioSelection(event){
        this.updateTypeValue = event.detail.value;
        if(this.selectedCurrentUser != ""){
            this.handleDisplayText();
        }
    }


    handleDisplayText(){
        if(this.selectedCurrentUser != null){
            switch (this.updateTypeValue) {
                case '1':
                    this.displayText = `You are about to reassign ${this.matterTeamMembers.length} Matter Team Member records`;
                    break;
                case '2':
                    this.displayText = `You are about to reassign ${this.matterTeamMembers.length} Matter Team Member records and the following lookup fields: ${this.getLookupFieldNames()}`;
                    break;
                case '3':
                    this.displayText = `You are about to reassign ${this.matterTeamMembers.length} Matter Team Member records and update ${this.tasks.length} tasks`;
                    break;
                case '4':
                    this.displayText = `You are about to reassign ${this.matterTeamMembers.length} Matter Team Member records and the following lookup fields: ${this.getLookupFieldNames()} and update ${this.tasks.length} tasks`;
                default:
                    break;
            }
        }
    }

    handleShowButton(){
        if(this.selectedCurrentUser != "" && this.selectedNewUser != "" && this.selectedCurrentUser != this.selectedNewUser){
            this.showButton = true;
        }
        else{
            this.showButton = false;
        }
    }

    handleUpdate(){
        switch (this.updateTypeValue) {
            case '1':
                updateMatterTeamMembersBatch({matterTeamMembers: this.matterTeamMembers, newUserId: this.selectedNewUser, currentUserId: this.selectedCurrentUser}).then((result) => {
                    this.jobIds = result;
                }).catch((err)=>{
                    console.error(err)
                });
                break;
            case '2':
                updateMatterTeamMembersAndLookupsBatch({matterTeamMembers: this.matterTeamMembers, newUserId: this.selectedNewUser, currentUserId: this.selectedCurrentUser}).then((result) => {
                    this.jobIds = result;
                });
                break;
            case '3':
                updateMatterTeamMembersAndTasksBatch({matterTeamMembers: this.matterTeamMembers, newUserId: this.selectedNewUser, currentUserId: this.selectedCurrentUser}).then((result) => {
                    this.jobIds = result;
                });
                break;
            case '4':
                updateMatterTeamMemberAndLookupsAndTasksBatch({matterTeamMembers: this.matterTeamMembers, newUserId: this.selectedNewUser, currentUserId: this.selectedCurrentUser}).then((result) => {
                    this.jobIds = result;
                });
                break;
            default:
                break;
        }
    }



    getLookupFieldNames(){
        var lookupFields = "";
        for(const [key, value] of Object.entries(this.metaData.data)){
            lookupFields += value.Field_Name__c;
            lookupFields += ", ";
        }
        lookupFields = lookupFields.slice(0, lookupFields.length - 2);
        return lookupFields;
    }


    renderedCallback() {
        setInterval(() => {
            if(this.jobIds.length != 0){
                this.showButton = false;
                fetchProgressData({jobIds: this.jobIds}).then((result) => {
                    this.progressBarValue = result;
                    if(result == 100){
                        this.jobIds = [];
                        this.showReset = true;
                    }
                })
            }
        }, 5000);
    }

    handleReset(){
        window.location.reload();
    }

}