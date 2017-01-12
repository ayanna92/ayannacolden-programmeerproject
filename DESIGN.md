# Ayanna Colden, Design Document

a list of APIs and frameworks or plugins that you will be using to provide functionality in your app
  * Firebase

List of Viewcontrollers
  * SignupVC
      Let’s users sign up to Firebase database through authorisation
  * LoginVC
      Let’s users log in to Firebase database through authorisation
  * UsersVC
      Shows list of users in database and let’s you follow/unfollow the different users. 
      * User class
  * FriendListVC
      List of followed users (friends), should link to their profile when didselectrow
  * UploadVC
      Upload embarrassing photos of friends to your collection, should be able to send uploaded photos to involved users (for contract purposes)
  * ViewPhotoVC
      Place for users to see own uploaded photos so they can link these to users later
  * MakeContractVC [EXTRA FEATURE]
      Page where you can invite users to make contracts (select photo, they answer by also selecting a photo) this is then shown in contractVC
  * ContractVC [EXTRA FEATURE]
      shows user photos, that make up the contract between two users
  * ChatVC
      Lets users interact with one another, chatroom where they can communicate, show list of open chats
  *PersonalChatVC
      one on one conversation (when selected through profile or chat tableview)
  * ProfileVC
      Users profile, showing name and profile picture, links to chatroom with button
  
  ![ScreenShot](https://raw.github.com/ayanna92/ayannacolden-programmeerproject/master/doc/IMG_6375.JPG)
