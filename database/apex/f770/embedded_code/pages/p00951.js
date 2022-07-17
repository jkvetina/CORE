// --------------------------------------------------------------------------------
// 
// Oracle APEX source export file
// 
// The contents of this file are intended for review and analysis purposes only.
// Developers must use the Application Builder to make modifications to an
// application. Changes to this file will not be reflected in the application.
// 
// --------------------------------------------------------------------------------

// ----------------------------------------
// Page 951: #fa-table-check &PAGE_NAME.
// Action: NATIVE_JAVASCRIPT_CODE
// Code

var selected = '';
for (var i = 0; i < this.data.selectedRecords.length; i++) {
    selected += this.data.model.getValue(this.data.selectedRecords[i], 'COLUMN_NAME_OLD') + ':';
}
//
apex.item('P951_SELECTED_COLUMNS').setValue(selected);


// ----------------------------------------
// Page 951: #fa-table-check &PAGE_NAME.
// Action: NATIVE_JAVASCRIPT_CODE
// Code

show_search_fields();


// ----------------------------------------
// Page 951: #fa-table-check &PAGE_NAME.
// Action: NATIVE_JAVASCRIPT_CODE
// Code

show_search_fields();


// ----------------------------------------
// Page 951: #fa-table-check &PAGE_NAME.
// Action: NATIVE_JAVASCRIPT_CODE
// Code

var view = apex.region('COLUMNS').widget().interactiveGrid('getViews', 'grid');
view.setSelectedRecords($());


// ----------------------------------------
// Page 951: #fa-table-check &PAGE_NAME.
// Action: NATIVE_JAVASCRIPT_CODE
// Code

hide_search_fields();


