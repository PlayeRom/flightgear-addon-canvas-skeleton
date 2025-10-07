#
# This is an Open Source project and it is licensed
# under the GNU Public License v3 (GPLv3)
#

#
# A class to check if there is a new version of an add-on based on releases and
# tags when the add-on is hosted on GitLab.
# See description of VersionChecker class.
#
var GitLabVersionChecker = {
    #
    # Constructor.
    #
    # @return hash
    #
    new: func() {
        var me = {
            parents: [
                GitLabVersionChecker,
                JsonVersionChecker.new(),
            ],
        };

        me.setUrl(me._getUrl());
        me.setDownloadCallback(Callback.new(me._downloadCallback, me));

        return me;
    },

    #
    # @return string
    #
    _getUrl: func() {
        var (user, repo) = me.getUserAndRepoNames();
        return "https://gitlab.com/api/v4/projects/" ~ user ~ "%2F" ~ repo ~ "/releases";
    },

    #
    # @param  string  downloadedResource  Downloaded text from HTTP request.
    # @return void
    #
    _downloadCallback: func(downloadedResource) {
        var json = me.parseJson(downloadedResource);
        if (json == nil) {
            return;
        }

        # GitLab returns arrays of objects with releases, where the first object is the latest release.
        # Each object contains a `tag_name` field.
        if (!globals.isvec(json) or !globals.size(json)) {
            return;
        }

        var item = json[0];
        if (!globals.ishash(item) or !globals.contains(item, "tag_name")) {
            Log.print("GitLabVersionChecker failed, the JSON doesn't contain `tag_name` key.");
            return;
        }

        var strLatestVersion = item["tag_name"];
        if (strLatestVersion == nil) {
            return;
        }

        me.checkVersion(strLatestVersion);
    },
};
