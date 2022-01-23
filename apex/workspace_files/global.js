// INTERACTIVE GRIDS - look for css change on Edit button and apply it to Save button
var apex_page_loaded = function() {
    var observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            var $target = $(mutation.target);
            if ($target.hasClass('is-active')) {
                var $save = $target.parent().parent().find('button.a-Button.a-Toolbar-item.js-actionButton[data-action="save"]');
                $save.addClass('is-active');
                // remove observer when fired ?
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



// common toolbar for all grids
// just put following code in Region - Attributes - JavaScript Initialization Code
// and assign Static ID to region
/**
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

        config.toolbarData = toolbarData;
    }

    return config;
};

