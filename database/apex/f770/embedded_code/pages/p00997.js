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
// Page 997: #fa-users-chat Chat with Support
// Page: #fa-users-chat Chat with Support
// Execute when Page Loads

(function loop(i) {
    setTimeout(function() {
        apex.region('MESSAGES').refresh();
        loop(i);
    }, 10000);  // 10sec forever
})();


// ----------------------------------------
// Page 997: #fa-users-chat Chat with Support
// Action: NATIVE_JAVASCRIPT_CODE
// Code

apex.server.process (
    'AJAX_SEND_MESSAGE',
    {
        x01: apex.item('P997_MESSAGE').getValue()
    },
    {
        async       : true,
        dataType    : 'text',
        success     : function(data) {
            apex.item('P997_MESSAGE').setValue('');
            apex.region('MESSAGES').refresh();
            $('#P997_MESSAGE').focus();
        }
    }
);


// ----------------------------------------
// Page 997: #fa-users-chat Chat with Support
// Action: NATIVE_JAVASCRIPT_CODE
// Code

apex.server.process (
    'AJAX_SEND_RESPONSE',
    {
        x01: apex.item('P997_RESPONSE').getValue(),
        x02: apex.item('P997_APP_ID').getValue(),
        x03: apex.item('P997_USER_ID').getValue(),
        x04: apex.item('P997_SESSION_ID').getValue()
    },
    {
        async       : true,
        dataType    : 'text',
        success     : function(data) {
console.log('SENT:', apex.item('P997_RESPONSE').getValue());
            apex.item('P997_RESPONSE').setValue('');
            apex.region('MESSAGES').refresh();
            $('#P997_RESPONSE').focus();
        }
    }
);


// ----------------------------------------
// Page 997: #fa-users-chat Chat with Support
// Action: NATIVE_JAVASCRIPT_CODE
// Code

apex.server.process (
    'AJAX_SEND_MESSAGE',
    {
        x01: apex.item('P997_MESSAGE').getValue()
    },
    {
        async       : true,
        dataType    : 'text',
        success     : function(data) {
            apex.item('P997_MESSAGE').setValue('');
            apex.region('MESSAGES').refresh();
            $('#P997_MESSAGE').focus();
        }
    }
);


// ----------------------------------------
// Page 997: #fa-users-chat Chat with Support
// Action: NATIVE_JAVASCRIPT_CODE
// Code

apex.server.process (
    'AJAX_SEND_MESSAGE',
    {
        x01: apex.item('P997_RESPONSE').getValue(),
        x02: apex.item('P997_APP_ID').getValue(),
        x03: apex.item('P997_USER_ID').getValue(),
        x04: apex.item('P997_SESSION_ID').getValue()
    },
    {
        async       : true,
        dataType    : 'text',
        success     : function(data) {
            apex.item('P997_RESPONSE').setValue('');
            apex.region('MESSAGES').refresh();
            $('#P997_RESPONSE').focus();
        }
    }
);


