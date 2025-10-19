#
# This is an Open Source project and it is licensed
# under the GNU Public License v3 (GPLv3)
#

#
# AboutTransientDialog class to display about info.
#
var AboutTransientDialog = {
    #
    # Constructor.
    #
    # @return hash
    #
    new: func() {
        var obj = {
            parents: [
                AboutTransientDialog,
                TransientDialog.new(
                    width: 300,
                    height: 400,
                    title: "About Canvas Skeleton",
                    resize: true,
                ),
            ],
        };

        obj._createLayout();

        return obj;
    },

    #
    # Destructor.
    #
    # @return void
    # @override TransientDialog
    #
    del: func() {
        # TODO: add more stuff here on delete the window if needed...

        call(TransientDialog.del, [], me);
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
    # Create layout for new version info.
    #
    # @return void
    #
    _createLayoutNewVersionInfo: func {
        var label = g_VersionChecker.isNewVersion()
            ? sprintf("New version %s is available", g_VersionChecker.getNewVersion())
            : "New version is not available";

        var newVersionAvailLabel = me._getLabel(label)
            .setVisible(g_VersionChecker.isNewVersion());

        newVersionAvailLabel.setColor([0.9, 0.0, 0.0]);

        var newVersionAvailBtn = me._getButton("Download new version", func {
            Utils.openBrowser({ url: g_Addon.downloadUrl });
        }).setVisible(g_VersionChecker.isNewVersion());

        me._vbox.addItem(newVersionAvailLabel);
        me._vbox.addItem(newVersionAvailBtn);
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
};
