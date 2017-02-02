# Ayanna Colden Process Book

# Week 1
## Day 1 (Mon):
* Wrote proposal for M.A.D. app
* Watched Instagram like app tutorials and followed for firebase login/signup functionality and following users

## Day 2 (Tue): 
* Did research on chat functionality and started implementation

## Day 3 (Wed):
* Continuance chat functionality (watching tutorials, trying to find right one for swift 3 and my need for one on one chats)
* Design documentation made and handed in

## Day 4 (Thu):
* Continuance chat functionality and views
* Preparing for presentation on prototypes

## Day 5 (Fri):
* First presentation, feedback on needing to decide on contract method (if it will be in user chat, or have seperate vc)
* continuance chat functionality, having trouble with implementing this according to tutorial cause of differences (tutorial is using no storyboard code, which makes a lot of it confusing)
* having hard time figuring out how to read followers from firebase, so I can have a page where only followed users are listed to chat with

## Day 6 (Sat):
* Stuck on trying to get only followed users displayed in tableview, trying different things

## Day 7 (Sun):
* Took a break from apps for the day

# Week 2
## Day 8 (Mon):
* Fixed following user display problem, thanks to groupmate suggesting dispatch main async! SO HAPPY
* continued trying to make chat work, implementing different method that I found on firebase website themselves. Having a hard time figuring out how to make the chat one on one, rather than all users seeing the same chat. Also having problems retrieving information from segue, which I appear to be send properly so I have no clue why.

## Day 9 (Tue):
* WORKING CHAT, still suuper buggy and I have a lot of file cleaning up to do, and rid of viewcontrollers I'm not using. BUT my chat is functioning, and I'm very happy with this development. 

## Day 10 (Wed):
* Made chat less buggy, can now see profile images in navigation bar and profile images/names of users you're chatting with and can send images to each other
* Having a hard time saving images within chat itself, have tried using imagepicked variable, and placing it when user zooms in on message. But I need to figure out a way to fill variable with the url/img of the selected cell. Should ask about this tomorrow at SP, once this is done I can make the contracts, or at least the first contract view. 

## Day 11 (Thu):
* I can now save images from within chat between users! Still buggy in the sense that it's too tap sensitive and therefore saves images way too often
* debugged saving and zooming images in chat
* started on contract making viewcontroller: users can now upload two different images to make a contract. Still need to add images to firebase and save contract --> to contract tableview (needs to be made still)

## Day 12 (Fri):
* During presentations I saw one of classmates made a swipe menu in his app. Decided with the amount of viewcontrollers I have, a menu like that would make a lot of sense for me so plan on attempting to implement it this weekend. 
* Found useful tutorial on swipe menu and started following it

# Week 3
## Day 15 (Mon):
* Attempt finishing menu, bumped into problem with programmatically made controllers, couldn't segue connect

## Day 16 (Tue):
* Help from classmate, can now connect programmatically made controllers, but not new messages because this is in a containerview meaning it needs to be reached through a certain route otherwise chatlog users always comes back empty and I get taken back to login screen.
* Can't figure out how to segue information from chatlog/messages to my contract, making the next steps near impossible
* Trying to maybe think of changing these last parts of app drastically (making it a more social media forum for example), I could maybe create a news feed that can only be seen by two users? In a way displaying a contract...
* Only have two more days and I'm freaking out.

## Day 17 (Wed):
* Working on newsfeed between two users, using instagram like app ep 4. Trying to retrieve from firebase, but seems to be problem with collectionview.reloaddata saying the link is ambiguous. So I need to figure out if this is because of storyboard link problems, or due to something else. 
* Created working newsfeed! Decided on a newsfeed with all photos sent by your friends (maybe I'll do photos sent by yourself as well) since otherwise you're only looking at embarassing photos of yourself that are sent by your friends
* Need to edit proposal, as now my app implementation has been changed quite a bit
* And need to get on finally making app prettier

## Day 18 (Thu):
* Worked on layout of app
* Added alert messages to login and signup in case of errors
* fixed loading list not showing completely sometimes
* added profile photo and username to newsfeed pictures, still need to add name receiving user and count

## Day 19 (Fri): 
* Fixed an animation bug when going from login to signup view controller, it would show the previous controller in the background. 
* Added keyboard Swipe away to controllers
* Need to show add sent messages count between users to news feed, been working on it
* And want to find a way to retrieve username of receiving user of photo from firebase

# Week 4
## Day 22 (Mon): 
* Finally worked out how to retrieve who photos are sent to from firebase and put it in my newsfeed
* Now going to make newsfeed look pretty, because it is very plain atm.
* By resizing images and adding a seperator

## Day 23 (Tue):
* Trying to implement searchbar into usersviewcontroller, so you can search users
* However this if giving me problems with follow/unfollowing of users, and an index out of range issue!
* Making last attempts of fixing this problem by asking for assistence tonight and tomorrow morning. If not I'll have to sadly scrap it and get back to code cleanup and writing of report/editing proposal etc. Enough left to do. 

## Day 24 (Wed):
* Had a colleague of a friend help me figure out the follow/unfollowing problem, we found that the tableview reloaded too quickly and then would grab an empty array, so added: "if array.count > indexPath.row" which is a bit of a workaround for this problem, that ensures the right array is selected.
* Followers could only be selected by using a left swipe, due to an overlay problem. Managed to fix this by adding a didselectcell function with taprecognizer. And now users can be followed/unfollowed with just one tap.
* App is now fully functioning, all that is left is report/readme/code cleaning
