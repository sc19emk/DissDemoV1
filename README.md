# DissDemoV1

# Safely

Safely is a personal safety app designed to help users feel more secure in various situations. The app includes features like account management, friend connections, notifications, safety advice articles, location sharing, voice box with pre-recorded conversations, countdown timer, loud alarm, and quick dial for emergency contacts or the police.

## Features

1. **Account**: Allows users to view, edit, and delete their account details.
2. **Friends**: Lets users add and manage connections with other users of the app.
3. **Notifications**: Displays a list of sent and received messages and alerts between users and their friends.
4. **Advice**: Provides articles with advice on keeping safe in different situations.
5. **Map**: Enables location sharing between users and their friends.
6. **Voice Box**: Offers pre-recorded audio conversations and transcripts for users to pretend to be calling a loved one.
7. **Countdown**: Allows users to enable a countdown timer that will disable if they reach their destination safely; otherwise, the alarm goes off and alerts their friends.
8. **Alarm**: Activates a loud, piercing alarm to attract attention.
9. **Quick Dial**: Pre-dials the police or the user's set emergency contact.

## Firebase Structure

Safely uses Firebase as its backend, and it has the following database structure:

- `users`: Stores user account details, including username, phone number, and emergency contact number.
- `auth`: Handles user authentication using email/password login.
- `friends`: Manages friendships between users, including friend requests, approvals, and removals.
- `notifications`: Holds notification data, including sender and receiver IDs, message content, timestamp, and opened status.

## DataManager

The `DataManager` class handles all interactions with Firebase. It fetches the account data, friend list, and unopened notifications count for the logged-in user. It also updates the notification count in real-time when a notification is marked as opened.

## Views

- **HomeView**: The main screen of the app, presenting a list of features with their respective icons. Users can navigate to different features by tapping on the corresponding list item.
- **AccountView**: Allows users to view, edit, and delete their account details.
- **FriendsView**: Lets users add, view, and remove current friends.
- **NotificationsView**: Displays all sent and received notifications.
- **AdviceView**: Contains articles with advice on women's safety.
- **MapView**: Shows the user's current location and allows them to share it with friends.
- **VoiceBoxView**: Provides fake phone call functionality with pre-recorded conversations.
- **CountdownView**: Allows users to set durations for expected journey times and notifies friends if the user does not arrive on time.
- **AlarmView**: Includes the SOS alarm functionality that alerts friends when activated.
- **HelpButton**: Displays an info button that shows a help alert with instructions on how to use the app when tapped.


## Usage

- Clone the repository and open the project in Xcode.
- Set up a Firebase project and enable authentication and Firestore database.
- Add the Firebase configuration file (GoogleService-Info.plist) to your project.
- Install the required Firebase dependencies via Swift Package Manager or CocoaPods.
- Build and run the app on a simulator or physical device.
