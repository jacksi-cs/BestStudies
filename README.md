# BestStudies: Group and self study helper
 **Dependencies**: XCode 14.1, Swift 4, Firebase Auth 9.0.0, Firestore 9.0.0
   
   
 BestStudies is a collaborative iOS app targeted towards students and any other individual that is looking to be more focused during work. It allows for study rooms up to 8 people and keeps track when individuals are off the app (and thus distracted) and when they are on (and thus working).
 The main premise is either treating the study room as a team and rewarding/punishing the team whenever someone is off the app (and thus distracted). It can also be used as a competitive system, where a leaderboard contains the most
 productive study members.
 
 ## Progress Table
 | Feature  | Description | Release Planned | Actual Release | Deviations |
| ------------- | ------------- | --- | --- | --- |
| UI | How everything looks. Fonts, logos, backgrounds, buttons, colors, etc. | Alpha | Alpha | UI wasn’t finished until final |
| Login/ Registration | User has account using firebase Auth. | Alpha | Alpha | None |
| Timer/Stopwatch Functions | Timer running when the app is running, and record your slack time when you are away from the app. Able to see everyone’s study and slack time as well as your own | Alpha | Alpha | None | 
| Connectivity | Getting multiple phones to establish a network connection with each other, updates rooms upon entries/exits | Beta | Beta | Did not use room code, instead use Multipeer connectivity |
| Settings | User can change email, username, password, notifications, sound enabled, sound volume, logout and deactivate account | Beta | Beta | No Dark mode |
| Stats | User stats are stored in a database and displayed on stats view | Final | Final | None |
| Achievements | Players can get achievements that will light up upon completion when goals met | Final | Final | Used simplistic achievements settings so the app would be easier to test |
| Sound | Buttons make sounds when clicked | Beta | Beta | Some buttons are missing sounds |
| Help Button | User can get useful insight on what to do, button shown on home | Beta | Final | None |

## Deviations

- Need a more intuitive solution for updating other group members timers. Currently the other member's timers are updated through simple data transfers of Booleans to signify when on and off the app. As delays occur in transfers this leads to time drifts and inaccuracies. However, the functionality of the app works (we need to still address improving consistency across devices)
- Change email/password does not use a real password input. Need to work in reauth from firebase
- One of the key functions of our app is that it tracks different users time spent idle from the app, however we are currently experiencing a bug where when a user is off the app for longer than 15 seconds Multipeer connections are automatically disconnected; attempting to add background processes/tasks to keep connections from timing out
- Leaving midway through a session leads to issues with sessions afterwards. Currently hid the leave button on SessionViewController to prevent such bugs from occurring. We suspect it is due to not handling instance variables properly upon leaving/closing connections or potential issues with shared variables being thread-safe (will have to add semaphores to shared variables or alter structure of ConnectionManager and SessionViewController/WaitingRoomViewController's relationship)

## Future Plans
Rudimentary achievements and stats have been added, but we would like to add more informative achievements and statistics. We think that a valuable feature would be including information on which study buddies are the users most productive with and which ones cause
the most distraction. Additionally, MPC is a rather dated networking system and though serves its purpose, we would be better off homebrewing our own custom library that is more tailored to background processes.
