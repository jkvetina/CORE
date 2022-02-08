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

var hide_success_message = function(search, start) {
    var $start = $('#' + start);
    //
    setTimeout(function() {
        apex.message.hidePageSuccess();  // hide message
        var content = $start.text().trim();
        if (content.length) {
            console.log('MESSAGE CLOSED:', content);
        }
        $start.html('').removeClass('u-visible');  // clean APEX mess
    }, 4000);
};



//
// WHEN PAGE LOADS
//
var apex_page_loaded = function() {
    //
    // WAIT FOR SUCCESS MESSAGE
    //
    const search    = '#APEX_SUCCESS_MESSAGE.u-visible > .t-Body-alert > #t_Alert_Success';
    const start     = 'APEX_SUCCESS_MESSAGE';
    //
    wait_for_element(search, start, hide_success_message);
    hide_success_message(search.replace('.u-visible', ''), start);  // hide existing messages

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
// just put following code in Region - Attributes - JavaScript Initialization Code
// and assign Static ID to region
/*
function(config) {
    return unified_ig_toolbar(config);
}
*/
var unified_ig_toolbar = function(config) {
    var $ = apex.jQuery;
    var toolbarData = $.apex.interactiveGrid.copyDefaultToolbar();
    var toolbarGroup = toolbarData.toolbarFind('actions4');

    // only for developers
    if ($('#apexDevToolbar.a-DevToolbar')) {
        // add a filter button after the actions menu
        toolbarGroup.controls.push({
            type            : 'BUTTON',
            action          : 'save-report',
            label           : 'Save as Default',
            icon            : ''  // no icon
        });

        // add row button as a plus sign without text
        addrowAction                    = toolbarData.toolbarFind('selection-add-row'),
        addrowAction.icon               = 'fa fa-plus';
        addrowAction.iconBeforeLabel    = true;
        addrowAction.label              = ' ';
        addrowAction.hot                = false;
        //
        config.toolbarData = toolbarData;
    }
    //
    return config;
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

