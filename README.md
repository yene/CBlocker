# Content Blocker for iOS
It grabs all the JSON files from Github repo and combines them into a filter list.


## Todo
- [X] on first run copy example blockerList from bundle to temporary
- [X] grab data from github repo
- [ ] check when updated last time
- [X] get all json files recursive
- [X] combine all json files
- [X] send json file to conten blocker 
- [ ] inform user that he has to toggle content blocker in settings
- [X] Write the data to shared folder
- [ ] remove duplicates in blockList

## Maybe Later
- [ ] inform user that there is an update in the github repo (notification?)
- [ ] add support for direct download of json and zip

## Questions
* Do i have to toggle the settings or is reload enough? calling reload is enough
* How do i find out if user enabled my content blocker?

## Links
* https://www.hackingwithswift.com/safari-content-blocking-ios9