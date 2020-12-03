import { LightningElement, api } from 'lwc';
import deleteAllRelatedHistories from '@salesforce/apex/TestAccountNameHistoryHandler.deleteAllRelatedHistories'

export default class TestAccountNameContainer extends LightningElement {

        @api recordId;

        isQuestionModalOpened = false;
        isResultsModalOpened = false;
        isLoading = false;
        message = '';
        
        openModal() {
            this.isQuestionModalOpened = true;
        }

        closeModal() {
            this.isQuestionModalOpened = false;
            this.isResultsModalOpened = false;
        }

        handleDeleteClick() {
            this.isLoading = true;

            deleteAllRelatedHistories({ recordId: this.recordId })
            .then(size => {
                this.message = (size === 0) ? 'No records to delete.' :  size + ' record were deleted.';
                this.isLoading = false;
                this.isResultsModalOpened = true;
            })
            .catch(err => {
                this.message = 'Error: code: ' + err.errorCode + ' ' + ', message: ' + err.body.message;
                this.isLoading = false;
                this.isResultsModalOpened = true;
            });
        }
}