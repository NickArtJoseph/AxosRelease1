(function(){

	LifeCycle.Topics.GlobalActionButtonHandler = {
		SAVE: 'GlobalActionButtonHandler.save',
		EDIT: 'GlobalActionButtonHandler.edit',
		CANCEL: 'GlobalActionButtonHandler.cancel',
		CONTINUE: 'GlobalActionButtonHandler.continue',
		SHOW_EDIT: 'GlobalActionButtonHandler.showEdit',
		HIDE_EDIT: 'GlobalActionButtonHandler.hideEdit',
		SHOW_CANCEL: 'GlobalActionButtonHandler.showCancel',
		HIDE_CANCEL: 'GlobalActionButtonHandler.hideCancel',
		SHOW_SAVE: 'GlobalActionButtonHandler.showSave',
		HIDE_SAVE: 'GlobalActionButtonHandler.hideSave',
		SHOW_CONTINUE: 'GlobalActionButtonHandler.showContinue',
		HIDE_CONTINUE: 'GlobalActionButtonHandler.hideContinue',
		FIRE_SAVE_WITH_CONTINUE: 'GlobalActionButtonHandler.fireSaveWithContinue',
		RESET: 'GlobalActionButtonHandler.reset',
		RESET_DIRTY_DATA_ON_CONTINUE: 'GlobalActionButtonHandler.resetDirtyDataOnContinue'
	};

	LifeCycle.Topics.SectionBuilder = {
		UPDATE_CONFIG: 'SectionBuilder.updateConfig',
		REFRESH_CONFIG: 'SectionBuilder.refreshConfig',
		RESET_UNIQUE: 'SectionBuilder.resetUnique',
		SHOW_SORT: 'SectionBuilder.showSort',
		FIELDSET_CHANGED: 'SectionBuilder.fieldsetChanged',
		SECTION_MODIFIED: 'SectionBuilder.sectionModified',
		SHOW_LAYOUT_MODIFIED: 'SectionBuilder.showLayoutModified',
		SHOW_HEADER_MODIFIED: 'SectionBuilder.showHeaderModified',
		SHOW_UNIQUE_MODIFIED: 'SectionBuilder.showUniqueModified',
		SHOW_FILTER_MODIFIED: 'SectionBuilder.showFilterModified',
		SHOW_SORT_MODIFIED: 'SectionBuilder.showSortModified'
	};

	LifeCycle.Topics.ScreenSectionFormBuilder = {
		EDITABLE_FIELD_CHANGED: 'ScreenSectionFormBuilder.editableFieldChanged',
		LOOKUP_MODIFIED: 'ScreenSectionFormBuilder.lookupModified'
	};

})();
