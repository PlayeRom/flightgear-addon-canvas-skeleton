#
# This is an Open Source project and it is licensed
# under the GNU Public License v3 (GPLv3)
#

#
# AboutPersistentDialog class to display about info.
#
var AboutPersistentDialog = {
    #
    # Constructor.
    #
    # @return hash
    #
    new: func() {
        var me = {
            parents: [
                AboutPersistentDialog,
                PersistentDialog.new(
                    width: 300,
                    height: 400,
                    title: "About Canvas Skeleton",
                    resize: true,
                ),
            ],
        };

        var dialogParent = me.parents[1];
        dialogParent.setChild(me, AboutPersistentDialog); # Let the parent know who their child is.
        dialogParent.setPositionOnCenter();

        me._vbox.addSpacing(10);

        me._vbox.addItem(me._getLabel(g_Addon.name));
        me._vbox.addItem(me._getLabel(sprintf("version %s", g_Addon.version.str())));
        me._vbox.addStretch(1);
        me._vbox.addItem(me._getLabel("Written by:"));

        foreach (var author; g_Addon.authors) {
            me._vbox.addItem(me._getLabel(author.name));
        }

        var exampleLabel = canvas.gui.widgets.ExampleLabel.new(me._group)
            .setText("Some text for this dialog");

        me._vbox.addStretch(1);

        # Center widget horizontally
        var hBox = canvas.HBoxLayout.new();
        hBox.addStretch(1);
        hBox.addItem(exampleLabel);
        hBox.addStretch(1);

        me._vbox.addItem(hBox);

        me._vbox.addStretch(1);

        me._vbox.addItem(me._getButton("Open GitHub Website", func {
            Utils.openBrowser({ url: g_Addon.codeRepositoryUrl });
        }));

        me._vbox.addStretch(1);

        var buttonBoxClose = me._drawBottomBar("Close", func { me.hide(); });
        me._vbox.addSpacing(10);
        me._vbox.addItem(buttonBoxClose);
        me._vbox.addSpacing(10);

        return me;
    },

    #
    # Destructor.
    #
    # @return void
    # @override PersistentDialog
    #
    del: func() {
        # TODO: add more stuff here on delete the window if needed...

        me.parents[1].del();
    },

    #
    # Show the dialog.
    #
    # @return void
    # @override PersistentDialog
    #
    show: func() {
        # TODO: add more stuff here on show the window if needed...

        me.parents[1].show();
    },

    #
    # Hide the dialog.
    #
    # @return void
    # @override PersistentDialog
    #
    hide: func() {
        # TODO: add more stuff here on hide the window if needed, like stop timer, etc...

        me.parents[1].hide();
    },

    #
    # @param  string  text  Label text.
    # @param  bool  wordWrap  If true then text will be wrapped.
    # @return ghost  Label widget.
    #
    _getLabel: func(text, wordWrap = false) {
        var label = canvas.gui.widgets.Label.new(parent: me._group, cfg: { wordWrap: wordWrap })
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
        return canvas.gui.widgets.Button.new(me._group)
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

        var btnClose = canvas.gui.widgets.Button.new(me._group)
            .setText(label)
            .setFixedSize(75, 26)
            .listen("clicked", callback);

        buttonBox.addStretch(1);
        buttonBox.addItem(btnClose);
        buttonBox.addStretch(1);

        return buttonBox;
    },
};
