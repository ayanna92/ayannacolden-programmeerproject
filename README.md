# ayannacolden-finalproject

# Project Proposal
### Ayanna J. Colden

## M.A.D. 
Imagine having an embarrassing photo being taken of you on a night out, or during a vacation by one of your friends. You’re dreading the idea of the possibility that they’ll post this picture on the internet, so you’ll try to convince them to delete it. However, realistically in most friendships people have embarrassing information or photos of each other. So what if instead of freaking out about the embarrassing photo, you could counter this photo with information or an embarrassing image you yourself own of this friend.

* what features will be available to solve the problem
  * Mutually assured destruction (M.A.D.), makes a contract between two friends who have embarrassing information or images of each other. The idea is that friend A uploads an embarrassing photo of friend B, and that friend B can counter this with an embarrassing photo of friend A (photos can only be viewed by these two users). Assuring that neither will ever upload the pictures to other forms of social media, knowing the consequence that will follow is an embarrassing photo of themselves being uploaded in retaliation. 

      M.A.D. is a fun way for friends to assure between one another that neither will embarrass the other with photos or information. It is also a fun place where friends can laugh about embarrassing moments they’ve spent together, cause they’ll have a medium to view images between themselves in a safe environment.  

* what separate parts of the application can be defined (decomposing the problem) and how these should work together
  * Login screen
  * Registration screen
  * User home page (with tableview of photos friends)
  * A chat where users can interact with each other (for laughing about image purposes)
  * A zoom in screen of both images next to one another (and usernames of both parties)
  * Friendlist page, where you can also invite friends through email to download application

* what external components (APIs) you probably need to make certain features possible
  * Firebase for user login functionality (minimum viable product)
  * User Image uploading from device and saving image in application (minimum viable product)
  * User interaction should be possible (need to invite one another through email to check out image, and they need to be able to speak to one another in app) (minimum viable product, some form of user interaction may be low level depending on difficulty)
  * Extra: automatically delete photo from device once uploaded to application
  * Extra: upload to other social media mediums (instagram, FB, twitter) for if contract between friends is broken by one, the other’s photo gets uploaded to one of these mediums

* technical problems or limitations that could arise during development and what possibilities you have to overcome these
  * Image uploading is still new to me, so will have to research how this is done
  * User interaction is also new to me, so will need research the limitations and possibilities of this and what base will be used to save this interaction
  * Firebase user login, needs to be fully functional and protected. Also needs to be able to not only login gmail formatted emails (which was a problem I’ve had before). Should make sure to ask about this during process.

* a review of similar applications or visualizations in terms of features and technical aspects (what do they offer? how have they implemented it?)
  * Tutorial to set up chatroom with Firebase: https://www.raywenderlich.com/140836/firebase-tutorial-real-time-chat-2
  * Tutorial video on how to make instagram like app with Firebase (but in Swift 2.3, nothing for 3 to be found), but could still show important basics. There are 5 parts making it a tutorial of around 2 hours: https://www.youtube.com/watch?v=HRLats_SCho
  * Instagram-like video Firebase swift 3, Xcode 8!: https://www.youtube.com/watch?v=AsSZulMc7sk
  * Tutorial on how to build social media features and links into your own app: https://www.andrewcbancroft.com/2015/11/23/get-social-with-swift-posting-to-facebook-and-twitter/


### Visualization idea examples
![ScreenShot](https://raw.github.com/ayanna92/ayannacolden-finalproject/master/doc/Login:Register.png)
![ScreenShot](https://raw.github.com/ayanna92/ayannacolden-finalproject/master/doc/homepage:chatroom.png)
