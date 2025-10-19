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
        var obj = {
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

        # Let the parent know who their child is.
        call(PersistentDialog.setChild, [obj, AboutPersistentDialog], obj.parents[1]);

        # Enable correct handling of window positioning in the center of the screen.
        call(PersistentDialog.setPositionOnCenter, [], obj.parents[1]);

        obj._createLayout();

        g_VersionChecker.registerCallback(Callback.new(obj.newVersionAvailable, obj));

        return obj;
    },

    #
    # Destructor.
    #
    # @return void
    # @override PersistentDialog
    #
    del: func() {
        # TODO: add more stuff here on delete the window if needed...

        call(PersistentDialog.del, [], me);
    },

    #
    # Show the dialog.
    #
    # @return void
    # @override PersistentDialog
    #
    show: func() {
        # TODO: add more stuff here on show the window if needed...

        call(PersistentDialog.show, [], me);
    },

    #
    # Hide the dialog.
    #
    # @return void
    # @override PersistentDialog
    #
    hide: func() {
        # TODO: add more stuff here on hide the window if needed, like stop timer, etc...

        call(PersistentDialog.hide, [], me);
    },

    #
    # Create layout.
    #
    # @return void
    #
    _createLayout: func {
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

        me._createLayoutNewVersionInfo();

        me._vbox.addStretch(1);

        me._vbox.addSpacing(10);
        me._vbox.addItem(me._drawBottomBar());
        me._vbox.addSpacing(10);
    },

    #
    # Create hidden layout for new version info.
    #
    # @return void
    #
    _createLayoutNewVersionInfo: func {
        me._newVersionAvailLabel = me._getLabel("New version is available").setVisible(false);
        me._newVersionAvailLabel.setColor([0.9, 0.0, 0.0]);

        me._newVersionAvailBtn = me._getButton("Download new version", func {
            Utils.openBrowser({ url: g_Addon.downloadUrl });
        }).setVisible(false);

        me._vbox.addItem(me._newVersionAvailLabel);
        me._vbox.addItem(me._newVersionAvailBtn);
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
    # @param  int  width
    # @return ghost  Button widget.
    #
    _getButton: func(text, callback, width = 200) {
        return canvas.gui.widgets.Button.new(me._group)
            .setText(text)
            .setFixedSize(width, 26)
            .listen("clicked", callback);
    },

    #
    # @return ghost  HBoxLayout object with button.
    #
    _drawBottomBar: func() {
        var btnClose = me._getButton("Close", func me.hide(), 75);

        var hBox = canvas.HBoxLayout.new();
        hBox.addStretch(1);
        hBox.addItem(btnClose);
        hBox.addStretch(1);

        return hBox;
    },

    #
    # Callback called when a new version of add-on is detected.
    #
    # @param  string  newVersion
    # @return void
    #
    newVersionAvailable: func(newVersion) {
        me._newVersionAvailLabel
            .setText(sprintf("New version %s is available", newVersion))
            .setVisible(true);

        me._newVersionAvailBtn
            .setVisible(true);
    },
};
