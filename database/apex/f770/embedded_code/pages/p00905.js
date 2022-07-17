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
// Page 905: #fa-server-play &PAGE_NAME.
// Action: NATIVE_JAVASCRIPT_CODE
// Code

/*
var curr = apex.item('P905_LOG_ID').getValue();
if (curr) {
    var grid = apex.region('HISTORY').widget().interactiveGrid('getViews', 'grid');
    var rec = grid.model.getRecord(curr);
    grid.setSelectedRecords([rec], true);
}
*/

// ----------------------------------------
// Page 905: #fa-server-play &PAGE_NAME.
// Action: NATIVE_JAVASCRIPT_CODE
// Code

// get selection
var curr  = '';
var model = this.data.model;
for (var i = 0; i < this.data.selectedRecords.length; i++) {
    curr = model.getValue(this.data.selectedRecords[i], 'LOG_ID');
}

if (curr) {
    // get arguments for selected row
    apex.server.process(
        'GET_OUTPUT', { x01: curr },
        {
        success: function (pData) {
            apex.item('P905_RESULT_OUTPUT').setValue(pData);
        },
        dataType: 'text'
        }
    );

    // get payload for selected row
    apex.server.process(
        'GET_ADDITIONAL_INFO', { x01: curr },
        {
        success: function (pData) {
            apex.item('P905_RESULT_INFO').setValue(pData);
        },
        dataType: 'text'
        }
    );
}


