#
# This is an Open Source project and it is licensed
# under the GNU Public License v3 (GPLv3)
#

#
# AboutDialog class to display about info.
#
var AboutDialog = {
    #
    # Constructor.
    #
    # @return hash
    #
    new: func() {
        var me = { parents: [
            AboutDialog,
            Dialog.new(width: 300, height: 400, title: "About Canvas Skeleton", resize: true),
        ] };

        # Let the parent know who their child is.
        me.setChild(me, AboutDialog);

        me.setPositionOnCenter();

        me._vbox.addSpacing(10);

        me._vbox.addItem(me._getLabel(g_Addon.name));
        me._vbox.addItem(me._getLabel(sprintf("version %s", g_Addon.version.str())));
        me._vbox.addStretch(1);
        me._vbox.addItem(me._getLabel("Written by:"));

        foreach (var author; g_Addon.authors) {
            me._vbox.addItem(me._getLabel(author.name));
        }

        var fancyLabel = canvas.gui.widgets.ExampleLabel.new(me._group, canvas.style, {})
            .setText("Some text for this dialog");

        me._vbox.addStretch(1);

        # Center widget horizontally
        var hBox = canvas.HBoxLayout.new();
        hBox.addStretch(1);
        hBox.addItem(fancyLabel);
        hBox.addStretch(1);

        me._vbox.addItem(hBox);

        me._vbox.addStretch(1);

        me._vbox.addItem(me._getButton("Open GitHub Website", func {
            Utils.openBrowser({ url: g_Addon.codeRepositoryUrl });
        }));

        me._vbox.addStretch(1);

        var buttonBoxClose = me._drawBottomBar("Close", func { me._window.hide(); });
        me._vbox.addSpacing(10);
        me._vbox.addItem(buttonBoxClose);
        me._vbox.addSpacing(10);

        return me;
    },

    #
    # Destructor.
    #
    # @return void
    # @override Dialog
    #
    del: func() {
        call(Dialog.del, [], me);
    },

    #
    # Show the dialog.
    #
    # @return void
    # @override Dialog
    #
    show: func() {
        # TODO: add mode stuff here on show the window...

        call(Dialog.show, [], me);
    },

    #
    # Hide the dialog.
    #
    # @return void
    # @override Dialog
    #
    hide: func() {
        # TODO: add mode stuff here on hide the window, like stop timer, etc...

        call(Dialog.hide, [], me);
    },

    #
    # @param  string  text  Label text.
    # @param  bool  wordWrap  If true then text will be wrapped.
    # @return ghost  Label widget.
    #
    _getLabel: func(text, wordWrap = false) {
        var label = canvas.gui.widgets.Label.new(me._group, canvas.style, {wordWrap: wordWrap})
            .setText(text);

        label.setTextAlign("center");

        return label;
    },

    #
    # @param  string  text  Label of button.
    # @param  func  callback  Function which will be executed after click the button.
    # @return ghost  Button widget.
    #
    _getButton: func(text, callback) {
        return canvas.gui.widgets.Button.new(me._group, canvas.style, {})
            .setText(text)
            .setFixedSize(200, 26)
            .listen("clicked", callback);
    },

    #
    # @param  string  label  Label of button.
    # @param  func  callback  function which will be executed after click the button.
    # @return ghost  HBoxLayout object with button.
    #
    _drawBottomBar: func(label, callback) {
        var buttonBox = canvas.HBoxLayout.new();

        var btnClose = canvas.gui.widgets.Button.new(me._group, canvas.style, {})
            .setText(label)
            .setFixedSize(75, 26)
            .listen("clicked", callback);

        buttonBox.addStretch(1);
        buttonBox.addItem(btnClose);
        buttonBox.addStretch(1);

        return buttonBox;
    },
};
