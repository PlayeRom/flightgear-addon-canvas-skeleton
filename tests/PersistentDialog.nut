#
# CanvasSkeleton Add-on for FlightGear
#
# Written and developer by Roman Ludwicki (PlayeRom, SP-ROM)
#
# Copyright (C) 2025 Roman Ludwicki
#
# This is an Open Source project and it is licensed
# under the GNU Public License v3 (GPLv3)
#

# Unit tests for `/nasal/Canvas/BaseDialogs/PersistentDialog.nas`

var setUp = func {
    # Get add-on namespace:
    var namespace = globals['__addon[org.flightgear.addons.CanvasSkeleton]__'];
};

var tearDown = func {
};

var test_callChildMethodByParent = func {
    var TestDialog = {
        new: func() {
            var obj = {
                parents: [
                    TestDialog,
                    namespace.PersistentDialog.new(50, 50, "Test Dialog"),
                ],
            };

            # Let the parent know who their child is.
            call(namespace.PersistentDialog.setChild, [obj, TestDialog], obj.parents[1]);

            obj._hideCalled = false;

            return obj;
        },

        hide: func() {
            me._hideCalled = true;

            call(namespace.PersistentDialog.hide, [], me);
        },
    };

    var testDialog = TestDialog.new();

    # Simulate click [X] button on the window bar:
    testDialog._window.del();

    # TestDialog.hide() has been called:
    unitTest.assert_equal(testDialog._hideCalled, true);
};
