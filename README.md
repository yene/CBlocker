# Content Blocker for iOS
This app lets you use your own filter list (called blockerList.json) in Safari. You can fork and extend [https://github.com/yene/blockerList](https://github.com/yene/blockerList). Don't forget to enable the Content Blocker inside Safaris settings.

![screenshot](screenshots/v2.png)![settings](screenshots/settings.png)

## blockerList
An updated version of the blockerList folder can be found under [github.com/yene/blockerList](https://github.com/yene/blockerList).

## HARDCORE block all the scripts
You can use this JSON file as source and it will block all external scripts. [blockThirdParty.json](blockThirdParty.json)

## Todo
- [X] on first run copy example blockerList from bundle to temporary
- [X] grab data from github repo
- [ ] check when updated last time
- [X] get all json files recursive
- [X] combine all json files
- [X] send json file to conten blocker 
- [ ] inform user that he has to toggle content blocker in settings
- [X] Write the data to shared folder
- [ ] remove duplicates in blockList
- [X] add icons and artwork
- [ ] add blockerList as submodule
- [ ] Rename content blocker to something better
- [ ] show a spinner

## Maybe Later
- [ ] inform user that there is an update in the github repo (notification?)
- [X] add support for direct download of json and zip

## Questions
* Do i have to toggle the settings or is reload enough? calling reload is enough
* How do i find out if user enabled my content blocker?

## Links
* https://www.hackingwithswift.com/safari-content-blocking-ios9
* https://easylist.adblockplus.org/de/
* https://www.webkit.org/blog/3476/content-blockers-first-look/
* https://developer.apple.com/library/prerelease/ios/releasenotes/General/WhatsNewInSafari/Articles/Safari_9.html
* https://developer.apple.com/videos/wwdc/2015/?id=511
* https://gist.github.com/CraftyDeano/777579c628b3d8d50f25

## Example Sites with many Ads
* macrumors.com
* imore.com

## Original Repository
https://github.com/yene/Content-Blocker