BETA:
Contributions
Jason: 25%
-user profiles
    -wrote authmanager for ease of access to Auth commands
    -wrote change username, change password, change email functions
    -added settings specifically for profiles

-sound design/ implementation
    -recorded and produced button noises
    -wrote SoundManager for ease of access to playSound function
    -implemented sound enable/disable switch in settings
    -implemented volume control in settings

-notifications
    -prompt user for notification access on first app launch
    -added setting to change user notification 
    -If user sets the app setting to notify but the system settings are not the user will see a prompt saing they must enable in system settings to see push notifications

-UI Elements:
    -Set UI notebook background and built constraints to make text fit between lines
    
-Settings Elements:
    -Aside from previously mentioned settings also made the custom table with various programatically generated settings depending on specific setting. 
    
Jack Si: 25%
- Connectivity:
    - Implemented multipeer connectivity
        - Created host/joiner relationships through multipeer connections and passed relevant information of sessions to joiners
        - Created waiting rooms allowing hosts to start sessions and all members to see everyone who connected (with the capability of leaving waiting room)
        - Expanded previous timer implementation to support multiple users in a session through data messages and interpretations that allow for proper actions to occur

Joseph: 25%
- Connectivity
    - Research on room codes and the best framework to use for connecting users together
    - Understand and implement multipeer connectivity
    - Mainly worked with Jack Si and Jack G on the different types of possible implementation
    - Focused on sending data to other peer connected through multipeer connectivity
    - Looked into sending message when a peer takes their app into the background and 
      return to the app
    - Looked and tested several different ways to try to find a loophole to have the device stay connected while its in the background 
      (Need more work)
      
Jack G: 25%
- Connectivity
    - Spent a bunch of time studying social connectivity/peer connectivity
    - Had many trials and errors of setting up a basic peer-to-peer connection
    - Worked on messaging capabilities and passing peer data and connection info
    - Spent a bunch of time researching and creating state with Observable Objects, trying to show current room members/update upon member changes
    - Worked on objectWillChange (even though we had to ditch it, unsure where to connect it and when to call it)
- UI
    - Worked on background for theme
    - Worked on getting font that matched theme

Deviations:
- Need a more intuitive solution for updating other group members timers. Currently the other member's timers are updated through simple data transfers of Booleans to signify when on and off the app. As delays occur in transfers this leads to time drifts and inaccuracies. However, the functionality of the app works (we need to still address improving consistency across devices)
- Change email/password does not use a real password input. Need to work in reauth from firebase
- One of the key functions of our app is that it tracks different users time spent idle from the app, however we are currently experiencing a bug where when a user is off the app for longer than 15 seconds Multipeer connections are automatically disconnected; attempting to add background processes/tasks to keep connections from timing out
- Leaving midway through a session leads to issues with sessions afterwards. Currently hid the leave button on SessionViewController to prevent such bugs from occurring. We suspect it is due to not handling instance variables properly upon leaving/closing connections or potential issues with shared variables being thread-safe (will have to add semaphores to shared variables or alter structure of ConnectionManager and SessionViewController/WaitingRoomViewController's relationship)


Alpha:
Contributions
Jason: 25%  
-Loading Screen  
-Login Screen  
-Registration Screen  
-README  
  
Joseph Yeh: 25%  
-Timer functionality  
-Timer screens  
  
Jack Greer: 25%  
-Settings Screens  
-Home Screen  
-Timer Screen  
  
Jack Si: 25%  
-Merging project  
  
Deviations:  
  
-Got more done on login than we expected but still have more to do like creating Facebook and Google linking  
-Pushed Sound Detection down to stretch goals because even if added, would be an experimental/optional feature  
-For the sessions, our current session view is without swiping capabilities. We were having issues getting UIPageViewController working in container, and have pushed it to be resolved ASAP in Beta  
-Settings for Account, Linking, Sounds, and Notifications were not fully implemented as some of them required implementation of features that were slated for Beta or were not mentioned at all  
-Some ViewControllers are unused, in part due to experimentation and preplanning for future features or VCs  
