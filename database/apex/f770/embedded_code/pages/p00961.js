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
// Page 961: #fa-file-code-o &PAGE_NAME.
// Action: NATIVE_JAVASCRIPT_CODE
// Code

parent.apex.region('PACKAGES').refresh();
parent.apex.region('MODULES').refresh();


// ----------------------------------------
// Page 961: #fa-file-code-o &PAGE_NAME.
// Action: NATIVE_JAVASCRIPT_CODE
// Code

var item = $('#P961_CLOB_HANDLER');
var parent = item.closest('.HIDDEN');
parent.removeClass('HIDDEN');
item.focus().select();
apex.clipboard.copy();
parent.addClass('HIDDEN');
apex.message.showPageSuccess('View handler copied to clipboard');


// ----------------------------------------
// Page 961: #fa-file-code-o &PAGE_NAME.
// Action: NATIVE_JAVASCRIPT_CODE
// Code

var item = $('#P961_CLOB_CALLER');
var parent = item.closest('.HIDDEN');
parent.removeClass('HIDDEN');
item.focus().select();
apex.clipboard.copy();
parent.addClass('HIDDEN');
apex.message.showPageSuccess('Procedure caller copied to clipboard');


// ----------------------------------------
// Page 961: #fa-file-code-o &PAGE_NAME.
// Action: NATIVE_JAVASCRIPT_CODE
// Code

var item = $('#P961_CLOB_SOURCE');
var parent = item.closest('.HIDDEN');
parent.removeClass('HIDDEN');
item.focus().select();
apex.clipboard.copy();
parent.addClass('HIDDEN');
apex.message.showPageSuccess('Source code copied to clipboard');


