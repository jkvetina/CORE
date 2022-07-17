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
// Page 902: &PAGE_NAME. &P902_LOG_ID.
// Action: NATIVE_JAVASCRIPT_CODE
// Code

var curr = apex.item('P902_LOG_ID').getValue();
if (curr) {
    var grid = apex.region('LOGS_TREE').widget().interactiveGrid('getViews', 'grid');
    var rec = grid.model.getRecord(curr);
    if (rec) {
        grid.setSelectedRecords([rec], true);
    }
}


// ----------------------------------------
// Page 902: &PAGE_NAME. &P902_LOG_ID.
// Action: NATIVE_JAVASCRIPT_CODE
// Code

// get selection
var curr  = '';
var model = this.data.model;
for (var i = 0; i < this.data.selectedRecords.length; i++) {
    curr = model.getValue(this.data.selectedRecords[i], 'LOG_ID');
}

if (curr) {
    // get action name for selected row
    apex.server.process(
        'GET_ACTION_NAME', { x01: curr },
        {
        success: function (pData) {
            apex.item('P902_ACTION_NAME').setValue(pData);
        },
        dataType: 'text'
        }
    );

    // get arguments for selected row
    apex.server.process(
        'GET_ARGUMENTS', { x01: curr },
        {
        success: function (pData) {
            apex.item('P902_ARGUMENTS').setValue(pData);
        },
        dataType: 'text'
        }
    );

    // get payload for selected row
    apex.server.process(
        'GET_PAYLOAD', { x01: curr },
        {
        success: function (pData) {
            apex.item('P902_PAYLOAD').setValue(pData);
        },
        dataType: 'text'
        }
    );
}

