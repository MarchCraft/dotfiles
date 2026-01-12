{ lib, ... }:
{

  programs.nixcord = {
    enable = true;
    discord.enable = false;
    vesktop.enable = false;

    #   config =
    #     let
    #       enabledPlugins = [
    #         "accountPanelServerProfile"
    #         "accountPanelServerProfile"
    #         "alwaysExpandRoles"
    #         "anonymiseFileNames"
    #         "betterGifAltText"
    #         "betterSessions"
    #         "betterUploadButton"
    #         "biggerStreamPreview"
    #         "callTimer"
    #         "copyFileContents"
    #         "disableCallIdle"
    #         "fakeNitro"
    #         "favoriteEmojiFirst"
    #         "fixCodeblockGap"
    #         "fixSpotifyEmbeds"
    #         "forceOwnerCrown"
    #         "friendsSince"
    #         "gameActivityToggle"
    #         "imageLink"
    #         "imageZoom"
    #         "loadingQuotes"
    #         "memberCount"
    #         "mentionAvatars"
    #         "messageClickActions"
    #         "noF1"
    #         "noUnblockToJump"
    #         "openInApp"
    #         "pictureInPicture"
    #         "previewMessage"
    #         "roleColorEverywhere"
    #         "shikiCodeblocks"
    #         "shikiCodeblocks"
    #         "sortFriendRequests"
    #         "typingTweaks"
    #         "validReply"
    #         "validUser"
    #         "voiceChatDoubleClick"
    #         "whoReacted"
    #       ];
    #     in
    #     {
    #       plugins =
    #         lib.recursiveUpdate
    #           {
    #             accountPanelServerProfile.prioritizeServerProfile = true;
    #             shikiCodeblocks.useDevIcon = "COLOR";
    #           }
    #           (
    #             lib.genAttrs enabledPlugins (_: {
    #               enable = true;
    #             })
    #           );
    #     };
  };
}
