# Mutually Assured Destruction
## Report, Ayanna J. Colden

Mutually assured destruction (M.A.D.) is a social media app, which focuses on the sharing of embarrassing photos between friends. The idea is to have a safe platform for friends to enjoy embarrassing photos they’ve made of one another without it being displayed on bigger social media platforms such as facebook/twitter/instagram etc. M.A.D.’s newsfeed therefore only contains images that users have sent themselves or images that they’ve personally received. 

![ScreenShot](https://raw.github.com/ayanna92/ayannacolden-programmeerproject/master/doc/Screen Shot 2017-02-02 at 16.13.05.png)

## Firebase data structure
![ScreenShot](https://raw.github.com/ayanna92/ayannacolden-programmeerproject/master/doc/Screen Shot 2017-02-02 at 15.51.27.png) ![ScreenShot](https://raw.github.com/ayanna92/ayannacolden-programmeerproject/master/doc/Screen Shot 2017-02-02 at 15.52.06.png) ![ScreenShot](https://raw.github.com/ayanna92/ayannacolden-programmeerproject/master/doc/Screen Shot 2017-02-02 at 15.53.36.png) ![ScreenShot](https://raw.github.com/ayanna92/ayannacolden-programmeerproject/master/doc/Screen Shot 2017-02-02 at 15.54.10.png)

* message_images: has an auto ID dictionary containing this ID itself under postID, followed by the author and ID of the image (sender), link to image in firebase storage, the ID of the receiving party.
* messages: has an auto ID dictionary with the sending/receiving ID, imageURL or text depending on message type, and a timestamp
* user_messages: senderID is dictionary, containing the receiving ID as dictionary, and then displays a 1 for every message sent (so you can see how many messages have been sent between two users
* users: auto ID for every user, containing followers and following user dictionaries with corresponding userID of who you follow/follows you. User’s aid and url to profile image selected during signup

## Design
![ScreenShot](https://raw.github.com/ayanna92/ayannacolden-programmeerproject/master/doc/EndDesign3.png)

#### Design Decisions

Changes since design.md document week 1
* I decided to not give users a profile page (ProfileVC), this appeared to be unnecessary next the newsfeed which displays all photos and the chat in which users can communicate with others. A profile page wouldn’t have much added value.
* I also removed the UploadVC, because users can share images with one another in the chatlog, and view their received and sent photos directly. Having a separate upload page would overcomplicate things. By this I mean that if a user uploads a photo, they’d then still have to select which user they’d like to share this photo with. Making it a round-a-bout way of getting the same information. 
* I changed the ViewPhotoVC into the FeedVC, where users can see all photos they’ve sent and received in their chat messages
* MakeContractVC and ContractVC ended being quite complicated, as I had to save two images simultaneously in Firebase storage and also connect these images to the 2 users involved, moreover to then retrieve this information and put it neatly in a tableview showing all contracts ended up being a lot more complicated than I was expecting. And understanding what was going wrong started to take too long, so I decided to make the executive decision of scrapping both and replacing this with a combination of images sent/received in the chat log and displaying them on the newsfeed. 
* ChatVC ended up being called MessagesVC and PersonalChatVC became ChatVC, aside from these I also added a NewMessagesVC which contains a list of all the users you have selected to follow, so you can start a conversation with them. 

## Process
* One of my first big challenges while making this app was when I tried to create a user chat for one on one conversations. Most tutorials I could find on the matter were for chatroom apps, meaning all users would see the same chat. Eventually I found a tutorial that did what I wanted, however this person wasn’t using storyboard. My first attempt at following the tutorial was by trying to translate his programmed code into storyboard views with code. After about two days this still wasn’t functional, so I decided to turn it around and also create programmatic view controllers for my chat. After a lot of hassle this turned out to be a beautiful chat, however later I bumped into some issues based on the fact that I had some view controllers in my storyboard and some not. 
* This lead to my second largest hiccup during the process, being the contract view controller that I wanted to create. I was trying to retrieve the names of users from the chat log that a user was currently in when pressing the “make contract” button I had in the navigation bar at the time. The idea was that this would then segue information to the contract view about which user the current user had been chatting with and display both names. It turned out to be more than a hassle to connect my programmatically made view (which was also connected to a container view) and my contractVC. I tried many things, such as putting an empty view in my storyboard, and linking this to my programmed VC, but nothing appeared to be working. Aside from this it was very hard to find information on internet regarding combined (programmed/storyboard) apps. Making me come to the realisation that I may have overcomplicated things for myself. 
* My third large problem was also due to my storyboard/programmed combination of VC’s, I used the SWReveal library, to make my swipe menu. But SWReveal only gave examples on how to implement their library with storyboard segues. You can’t implement segues in programmed VC”s. However eventually I found a way around this. Which was to not give the swipemenu option in new messages and chat log (because doing so unlinked it from their containerview, and I ended up with a chat log that was not connected to any user). So the swipe menu brings users to messages, and from there on they can continue to chats/newmessages and must click the back button to get to messages and back to the swipe menu. In the end this implementation still seems pretty logical when using the app, and not bothersome at all to the user friendliness. 

## My Decisions
The main reason I stand behind the changes that I’ve implemented, are because I realised that my plan was too large for the amount of time that we had for this project. The end product has 8 interactive view controllers, my original idea had 11. Moreover the features I left out weren’t simple ones. Therefore my original plan really just wasn’t realistic. However I feel that my end product is one that I can be proud of, and still contains new and interesting features such as the chat log and swipe menu. Both of which I’m pleased with the visual end results. Even so I must say that in an ideal world, I would have a contract page, in which users select photos and make a contract and then send an invite to other users to accept. And that if this contract gets broken according to the rules the users have both agreed upon, the embarrassing photo of the contract breaker gets posted to other social media platforms. Just because this is something that really hasn’t been seen before. 

## Visual Ideas
* Swipe menu was very much an aesthetic add as it was a practical one for me. When I saw it during one of the presentations I was so impressed by how professional it looked, that I had to figure out how to make one myself. 
* My chat menu was is also exactly what I wanted visually, cause it reminds me of chats that I already use such as WhatsApp and Facebook Messenger. I feel like users will be pleased with this format, because it’s what they’re used to working with. 
* I created the logo for M.A.D. myself in paint with use of a google camera image, because I felt like the camera represented clearly the pictures displayed and shared in the app. 

![ScreenShot](https://raw.github.com/ayanna92/ayannacolden-programmeerproject/master/doc/Screen Shot 2017-02-02 at 11.17.47.png)
![ScreenShot](https://raw.github.com/ayanna92/ayannacolden-programmeerproject/master/doc/Screen Shot 2017-02-02 at 11.19.24.png)
