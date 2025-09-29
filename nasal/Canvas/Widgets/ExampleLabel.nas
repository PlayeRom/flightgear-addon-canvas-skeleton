#
# This is an Open Source project and it is licensed
# under the GNU Public License v3 (GPLv3)
#

#
# ExampleLabel widget Model.
#
gui.widgets.ExampleLabel = {
    #
    # Constructor.
    #
    # @param  ghost  parent
    # @param  hash|nil  style
    # @param  hash|nil  cfg
    # @return ghost
    #
    new: func(parent, style = nil, cfg = nil) {
        style = style or canvas.style;
        cfg = Config.new(cfg);
        var me = gui.Widget.new(gui.widgets.ExampleLabel, cfg);
        me._focus_policy = me.NoFocus;
        me._setView(style.createWidget(parent, "example-label-view", me._cfg));

        me._text = "Dummy text";

        return me;
    },

    #
    # @param  string  text
    # @return ghost
    #
    setText: func(text) {
        me._text = text;
        return me;
    },

    #
    # Redraw view
    #
    # @return void
    #
    updateView: func() {
        me._view.reDrawContent(me);
    },
};
