//
// WAIT FOR ELEMENT TO EXIST
//
var wait_for_element = function(search, start, fn, disconnect) {
    var ob  = new MutationObserver(function(mutations) {
        if ($(search).length) {
            fn(search, start);
            if (disconnect) {
                observer.disconnect();  // keep observing
            }
        }
    });
    //
    ob.observe(document.getElementById(start), {
        childList: true,
        subtree: true
    });
};



//
// WHEN PAGE LOADS
//
var apex_page_loaded = function() {
    //
    // SHOW NOTIFICATIONS
    //
    var item_success        = 'P0_MESSAGE_SUCCESS';
    var item_error          = 'P0_MESSAGE_ERROR';
    var item_alert          = 'P0_MESSAGE_ALERT';
    var item_callback       = 'P0_MESSAGE_CALLBACK';  // contains function name
    //
    var item_success_value  = apex.item(item_success).getValue();
    var item_error_value    = apex.item(item_error).getValue();
    var item_alert_value    = apex.item(item_alert).getValue();
    var item_callback_value = apex.item(item_callback).getValue();

    // catch error close event
    apex.message.setThemeHooks({
        beforeShow: function(pMsgType, pElement$) {  // beforeShow, beforeHide
            //console.log('MESSAGE:', pMsgType, pElement$);

            // unescape HTML in error message
            var $err = $('#APEX_ERROR_MESSAGE');
            $err.html($('<textarea />').html($err.html()).text());

            // translate message ?
            //

            //if (pMsgType === apex.message.TYPE.ERROR) {  // SUCCESS, ERROR
            if (pMsgType === apex.message.TYPE.SUCCESS) {
                setTimeout(() => {
                    apex.message.hidePageSuccess();  // hide message
                }, 3000);
            }
        },
        beforeHide: function(pMsgType, pElement$) {  // beforeShow, beforeHide
            //if (pMsgType === apex.message.TYPE.ERROR) {  // SUCCESS, ERROR
            //}
        }
    });

    // hide message already created on page
    setTimeout(() => {
        apex.message.hidePageSuccess();  // hide message
    }, 3000);

    // show notifications based on page zero items
    if (item_error_value.length) {
        // show error/warning
        apex.message.showErrors([{
            type:       apex.message.TYPE.ERROR,
            location:   ['page'],
            message:    item_error_value,
            unsafe:     false
        }]);
    }
    else if (item_success_value.length) {
        // show success
        apex.message.showPageSuccess(item_success_value);
    }

    // show alert
    if (item_alert_value.length) {
        apex.message.alert(item_alert_value, function() {
            console.log('ALERT CLOSED');
            //
            if (item_callback_value.length) {
                console.log('CALLBACK INITIATED:', item_callback_value);
                new Function(item_callback_value)();
            }
        });
    }

    //
    // FIX GRID TOOLBARS
    //
    fix_toolbars();

    //
    // INTERACTIVE GRIDS - look for css change on Edit button and apply it to Save button
    //
    var observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            var $target = $(mutation.target);
            if ($target.hasClass('is-active')) {
                var $save = $target.parent().parent().find('button.a-Button.a-Toolbar-item.js-actionButton[data-action="save"]');
                $save.addClass('is-active');
                //observer.disconnect();  // remove observer when fired
            }
        });
    });
    //
    $.each($('div.a-Toolbar-toggleButton.js-actionCheckbox.a-Toolbar-item[data-action="edit"] > label'), function(i, el) {
        // assign unique ID + apply tracker/observer
        $el = $(el);
        $el.attr('id', 'OBSERVE_' + $el.attr('for'));
        observer.observe($el[0], {
            attributes: true
        });
    });
};



//
// INTERACTIVE GRIDS - fold (hide) requested group (Control Break)
//
var fold_grid_group = function(grid_id, group_name, group_value) {
    (function loop(i) {
        setTimeout(function() {
            var $x = $('#' + grid_id + ' table tbody tr:first button');
            if ($x) {
                var $b = $x.parent().find('.a-GV-controlBreakLabel');
                if ($b.find('.a-GV-breakLabel').text().includes(group_name) && $b.find('.a-GV-breakValue').text().includes(group_value)) {
                    $x.click();
                    $x.blur();
                    $(window).scrollTop(0);
                    return;
                }
            }
            if (--i) loop(i);
        }, 1000)
    })(10);
};



//
// COMMON TOOLBAR FOR ALL GRIDS
//
var fix_toolbars = function () {
    $('.a-IG').each(function() {
        var $parent = $(this).parent();
        var id      = $parent.attr('id');
        //
        if (!$parent.hasClass('ORIGINAL')) {
            //console.log('GRID MODIFIED', id);
            fix_toolbar(id);
        }
    })
};
//
var fix_toolbar = function (region_id) {
    console.group('FIX_TOOLBAR', region_id);
    //
    var $region     = $('#' + region_id);
    var widget      = apex.region(region_id).widget();
    var actions     = widget.interactiveGrid('getActions');
    var toolbar     = widget.interactiveGrid('getToolbar');
    var config      = $.apex.interactiveGrid.copyDefaultToolbar();
    var action1     = config.toolbarFind('actions1');
    var action2     = config.toolbarFind('actions2');
    var action3     = config.toolbarFind('actions3');
    var action4     = config.toolbarFind('actions4');
    //
    //console.log('TOOLBAR DATA - ORIGINAL', config_bak.data);
    //console.log('ACTIONS', widget.interactiveGrid('getActions').list());

    // manipulate buttons
    // https://docs.oracle.com/en/database/oracle/application-express/20.1/aexjs/interactiveGrid.html#actions-section
    //
    // grid actions
    // widget.interactiveGrid('getActions').list()
    //console.log('ACTIONS', widget.interactiveGrid('getActions').list());
    //
    // row actions
    // widget.interactiveGrid('getViews').grid.rowActionMenu$.menu('option')
    //

    // hide some buttons
    actions.hide('reset-report');
    actions.show('change-rows-per-page');

    // modify add row button as a plus sign without text
    for (var i = 0; i < action3.controls.length; i++) {
        var button = action3.controls[i];
        if (button.action == 'selection-add-row') {
            button.icon         = 'fa fa-plus';
            button.iconOnly     = true;
            button.label        = ' ';
            break;
        }
    }

    // add action to save all rows in grid
    if ($region.hasClass('SAVE_ALL')) {
        actions.add({
            name    : 'SAVE_ALL',
            action  : function(event, element) {
                var region_id   = event.delegateTarget.id.replace('_ig', '');
                var grid        = apex.region(region_id).widget();
                var model       = grid.interactiveGrid('getViews', 'grid').model;
                //
                model.forEach(function(r) {
                    try {
                        if (!model.getValue(r, 'ITEM_NAME').endsWith('?')) {
                            model.setValue(r, 'ITEM_TYPE', model.getValue(r, 'ITEM_TYPE') + ' ');  // fake change
                        }
                    }
                    catch(err) {  // deleted rows cant be changed
                    }
                });
                grid.interactiveGrid('getActions').invoke('save');
                grid.interactiveGrid('getCurrentView').model.fetch();
            }
        });
        //
        action2.controls.push({
            type        : 'BUTTON',
            label       : 'Save All Rows',
            id          : 'save_all_rows',
            icon        : '',
            action      : 'SAVE_ALL'
        });
    }

    // add action to save all selected and changed rows
    if ($region.hasClass('SAVE_SELECTED')) {
        actions.add({
            name    : 'SAVE_SELECTED',
            action  : function(event, element) {
                var region_id   = event.delegateTarget.id.replace('_ig', '');
                var grid        = apex.region(region_id).widget();
                var model       = grid.interactiveGrid('getViews', 'grid').model;
                var gridview    = grid.interactiveGrid('getViews').grid;
                var selected    = grid.interactiveGrid('getViews').grid.getSelectedRecords();
                var id;
                var changed = [];
                //
                for (var i = 0; i < selected.length; i++ ) {
                    id = gridview.model.getRecordId(selected[i]);
                    changed.push(id);
                };
                //
                model.forEach(function(r) {
                    for (var i = 0; i < changed.length; i++ ) {
                        if (changed[i] == gridview.model.getRecordId(r)) {
                            try {
                                model.setValue(r, 'ITEM_TYPE', model.getValue(r, 'ITEM_TYPE') + ' ');  // fake change
                            }
                            catch(err) {  // deleted rows cant be changed
                            }
                        }
                    }
                });
                //
                grid.interactiveGrid('getActions').invoke('save');

                // refresh grid after save
                //grid.interactiveGrid('getViews', 'grid').model.clearChanges();
                //grid.interactiveGrid('getActions').invoke('refresh');
                grid.interactiveGrid('getCurrentView').model.fetch();
            }
        });
        //
        action2.controls.push({
            type        : 'BUTTON',
            label       : 'Save Selected',
            id          : 'save_all_rows',
            icon        : '',
            action      : 'SAVE_SELECTED',
        });
    }

    action4.controls.unshift({
        type    : 'SELECT',
        action  : 'change-rows-per-page'
    });

    // show refresh button before save button
    action4.controls.push({
        type            : 'BUTTON',
        action          : 'refresh',
        label           : 'Refresh Data',
        icon            : '',
        iconBeforeLabel : true
    });

    // only for developers
    if ($('#apexDevToolbar.a-DevToolbar')) {
        // add a filter button after the actions menu
        action4.controls.push({
            type        : 'BUTTON',
            action      : 'save-report',
            label       : 'Save as Default',
            icon        : ''  // no icon
        });
    }

    // update toolbar
    //actions.set('edit', true);
    toolbar.toolbar('option', 'data', config);
    toolbar.toolbar('refresh');
    console.groupEnd();
};



//
// SHOW/HIDE SEARCH FIELDS
//
var show_search_fields = function() {
    $('.t-HeroRegion-col.t-HeroRegion-col--content .HIDDEN').removeClass('HIDDEN');
    //
    $('.SEARCH_FIELDS').show();
    $('#BUTTON_SHOW_SEARCH').hide();
    $('#BUTTON_CLOSE_SEARCH').show();
    $('.SEARCH_FIELDS').find('input')[0].focus();
};
//
var hide_search_fields = function() {
    $('.SEARCH_FIELDS').hide();
    $('#BUTTON_CLOSE_SEARCH').hide();
    $('#BUTTON_SHOW_SEARCH').show().focus();
};

