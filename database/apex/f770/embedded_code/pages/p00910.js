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
// Page 910: #fa-map-signs &PAGE_NAME.
// Action: NATIVE_JAVASCRIPT_CODE
// Code

apex.message.showPageSuccess(apex.item('P910_MESSAGE_MVW').getValue());


// ----------------------------------------
// Page 910: #fa-map-signs &PAGE_NAME.
// Action: NATIVE_JAVASCRIPT_CODE
// Code

fold_grid_group('PAGE_REGIONS', 'Page Group', '0 Global Page');


// ----------------------------------------
// Page 910: #fa-map-signs &PAGE_NAME.
// Action: NATIVE_JAVASCRIPT_CODE
// Code

apex.region('NAVIGATION').widget().interactiveGrid('getActions').invoke('save');


// ----------------------------------------
// Page 910: #fa-map-signs &PAGE_NAME.
// Action: NATIVE_JAVASCRIPT_CODE
// Code

fold_grid_group('PAGE_REGIONS', 'Page Group', '0 Global Page');


