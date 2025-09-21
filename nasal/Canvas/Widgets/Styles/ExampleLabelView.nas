#
# This is an Open Source project and it is licensed
# under the GNU Public License v3 (GPLv3)
#

#
# ExampleLabelView widget View.
#
DefaultStyle.widgets["fancy-label-view"] = {
    #
    # Constructor.
    #
    # @param  ghost  parent
    # @param  hash  cfg
    # @return void
    #
    new: func(parent, cfg) {
        # The main canvas group must be called `_root`.
        me._root = parent.createChild("group", "fancy-label-view");

        me._text = me._root.createChild("text")
            .setColor([1, 0, 0])
            .setFontSize(20)
            .setAlignment("center-baseline")
            .setFont("LiberationFonts/LiberationSans-Bold.ttf");
    },

    #
    # Callback called when user resized the window.
    #
    # @param  ghost  model  ExampleLabelView model.
    # @param  int  w, h  Width and height of widget.
    # @return ghost
    #
    setSize: func(model, w, h) {
        me.reDrawContent(model);

        return me;
    },

    #
    # @param  ghost  model  ExampleLabelView model.
    # @return void
    #
    update: func(model) {
        # nothing here
    },

    #
    # @param  ghost  model  ExampleLabelView model.
    # @return void
    #
    reDrawContent: func(model) {
        me._text.setText(model._text)
            .setTranslation(model._size[0] / 2, 0);

        var width = me._text.getSize()[0];
        var height = me._text.getSize()[1];

        model.setLayoutMinimumSize([width, height]);
        model.setLayoutSizeHint([width, height]);
    },
};
