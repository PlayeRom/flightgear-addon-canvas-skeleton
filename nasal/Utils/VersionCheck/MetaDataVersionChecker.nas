#
# This is an Open Source project and it is licensed
# under the GNU Public License v3 (GPLv3)
#

#
# This class will execute an HTTP request to download the addon-metadata.xml
# file from the repository. This way, you can read the version entered there and
# compare it with the local addon's version.
#
var MetaDataVersionChecker = {
    #
    # Constructor.
    #
    # @return hash
    #
    new: func() {
        var me = {
            parents: [
                MetaDataVersionChecker,
                XmlVersionChecker.new(),
            ],
        };

        me.setUrl(me._getUrl());
        me.setDownloadCallback(Callback.new(me._downloadCallback, me));

        return me;
    },

    #
    # Get URL to addon-metadata.xml file in your repository.
    #
    # @return string
    #
    _getUrl: func() {
        # TODO: adjust this variables to your repository:
        var (user, repo) = me.getUserAndRepoNames();
        var branch = "main";
        return "https://raw.githubusercontent.com/" ~ user ~ "/" ~ repo ~ "/" ~ branch ~ "/addon-metadata.xml";
    },

    #
    # @param  ghost  downloadedResource  Downloaded props.Node for HTTP request.
    # @return void
    #
    _downloadCallback: func(downloadedResource) {
        var addonNode = downloadedResource.getChild("addon");
        if (addonNode == nil) {
            return;
        }

        var versionNode = addonNode.getChild("version");
        if (versionNode == nil) {
            return;
        }

        var strLatestVersion = versionNode.getValue();
        if (strLatestVersion == nil) {
            return;
        }

        me.checkVersion(strLatestVersion);
    },
};
