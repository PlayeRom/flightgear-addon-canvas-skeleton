#
# This is an Open Source project and it is licensed
# under the GNU Public License v3 (GPLv3)
#

# This is the main addon Nasal hook. It MUST contain a function
# called "main". The main function will be called upon init with
# the addons.Addon instance corresponding to the addon being loaded.
#
# This script will live in its own Nasal namespace that gets
# dynamically created from the global addon init script.
# It will be something like "__addon[ADDON_ID]__" where ADDON_ID is
# the addon identifier, such as "org.flightgear.addons.CanvasSkeleton".
#
# See $FG_ROOT/Docs/README.add-ons for info about the addons.Addon
# object that is passed to main(), and much more. The latest version
# of this README.add-ons document is at:
#
#   https://sourceforge.net/p/flightgear/fgdata/ci/next/tree/Docs/README.add-ons
#

#
# Main add-on function.
#
# @param  ghost  addon  The addons.Addon object.
# @return void
#
var main = func(addon) {
    logprint(LOG_ALERT, addon.name, " Add-on initialized from path ", addon.basePath);

    loadNasalFiles(addon.basePath, "canvasSkeleton");

    canvasSkeleton.Bootstrap.init(addon);
};

#
# Search for ".nas" files recursively and load them.
#
# @param  string  path  Starts as base path of add-on.
# @param  string  namespace  Namespace of add-on.
# @param  int  level  Starts from 0, each subsequent subdirectory gets level + 1.
# @param  bool  isWidget  If true then we are in Widgets folder which means that we need add file to separate namespace.
# @return void
#
var loadNasalFiles = func(path, namespace, level = 0, isWidget = false) {
    var files = globals.directory(path);

    foreach (var file; files) {
        if (file == "." or file == ".." or (level == 0 and file == "addon-main.nas")) {
            continue;
        }

        var fullPath = path ~ "/" ~ file;
        var fileUc = string.uc(file);

        if (io.is_regular_file(fullPath) and substr(fileUc, size(file) - 4) == ".NAS") {
            io.load_nasal(fullPath, isWidget ? "canvas" : namespace);
            continue;
        }

        if (level == 0 and fileUc != "NASAL") {
            # At level 0 we are only interested in the "nasal" directory.
            continue;
        }

        if (!io.is_directory(fullPath)) {
            continue;
        }

        if (!isWidget) {
            # Mark that we are entering the "Widgets" directory ("canvas" namespace).
            isWidget = fileUc == "WIDGETS";
        }

        loadNasalFiles(fullPath, namespace, level + 1, isWidget);
    }
};

# This function is for addon development only. It is called on addon
# reload. The addons system will replace setlistener() and maketimer() to
# track this resources automatically for you.
#
# Listeners created with setlistener() will be removed automatically for you.
# Timers created with maketimer() will have their stop() method called
# automatically for you. You should NOT use settimer anymore, see wiki at
# http://wiki.flightgear.org/Nasal_library#maketimer.28.29
#
# Other resources should be freed by adding the corresponding code here,
# e.g. myCanvas.del();
#
# @param  ghost  addon  The addons.Addon object.
# @return void
#
var unload = func(addon) {
    canvasSkeleton.Log.print("unload");
    canvasSkeleton.Bootstrap.uninit();
};
