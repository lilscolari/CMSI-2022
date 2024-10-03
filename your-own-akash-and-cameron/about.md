# Music Mixer
By Akash and Cameron

### Akash:
Akash dedicated his time to integrating the Telegram API into the app as well as creating some of the Views needed for the API to work. He was responsible for a majority of the Telegram work and wrote some functions for interacting with Firebase.

### Cameron:
Cameron initially set up the app and helped prepare the project for API integration including Firebase management and designing the app. Cameron was reponsible for some of the functions that interactd with Firebase.

## About the Project:
### Audience:
Our original chosen audience was people who were 13+ because we wanted to create a social-media app where users could connect over common interests in music. The typical age requirement for social media apps is 13+ so that is why we chose this audience. Since we pivoted from the social media direction and made the app more focused on user experience, the audience for the app can be changed. Our audience can now be classified as people who enjoy music. A lot of times, people who enjoy music cannot listen to songs they enjoy because they are not accessible on various platforms. For that reason, we made an app that compiled music from different sources so people could enjoy songs from various platforms all in one place.

### Custom App Icon:
[Custom App Icon](https://www.google.com/url?sa=i&url=https%3A%2F%2Fmasterbundles.com%2Ffreebies%2Fmusic-notes-clipart-free%2F&psig=AOvVaw386rAWrWa3HP_FtbTsvxsf&ust=1714613267952000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCKCZkaim64UDFQAAAAAdAAAAABAZ)

### App Demo:
To use the application, you must log in to Telegram so that you can interact with the Bot. From there, you should click the 'Sign In' button so you can save songs in Firebase. Once those initial steps are out of the way, you can start searching for songs. When on a song's detail page, click the star to save the song to Firebase.

### App Screenshots:

<img width="339" alt="Screenshot 2024-05-03 at 12 52 42 AM" src="https://github.com/lmu-cmsi2022-spring2024/your-own-akash-and-cameron/assets/112520099/ff76cb6d-8461-4484-8665-21018102349f">

<img width="349" alt="Screenshot 2024-05-03 at 12 52 53 AM" src="https://github.com/lmu-cmsi2022-spring2024/your-own-akash-and-cameron/assets/112520099/77d32c62-92e6-406f-a1a4-d6a1c3953d21">

<img width="347" alt="Screenshot 2024-05-03 at 12 53 19 AM" src="https://github.com/lmu-cmsi2022-spring2024/your-own-akash-and-cameron/assets/112520099/4bd607f0-5e18-4efa-9434-7e388beba32b">

<img width="346" alt="Screenshot 2024-05-03 at 12 54 24 AM" src="https://github.com/lmu-cmsi2022-spring2024/your-own-akash-and-cameron/assets/112520099/f88d4727-e8b6-4178-ae87-3c77c31ccbb6">


### Chosen API:
We looked at many APIs and could not find any that worked with what we wanted to do until we found the one we ended up choosing. The API we chose was called TDLib. [Here](https://github.com/tdlib/td) is the link for the documentation for this API. It is a library for building Telegram clients. We used Telegram to interact with a bot that returned songs based off of user input. The songs were returned in a very foreign format and it was difficult retrieving the information we needed. (Shout out to Akash for finding the API and handling a majority of the integration).

### Firebase Management:
We used Firebase to supervise user authentication. Unfortunately, the only way a user can log in is via email. We planned on adding more ways for users to log in but encountered issues when trying to download packages. In particular, the second method we wanted to use was Google Authentication. We had to ditch this idea when the Google packages continuously crashed our project and we could not find an adequate workaround. Because of this experience, we were hesitent to add any more sign-in methods because we did not want our entire app to break. With more time, we would have looked into adding more sign-in options so that a wider variety of people could have enjoyed the app.

### Cool Features:
The app has really awesome graphics that make the user want to use it due to its visually appealing nature. These graphics and aesthetic were something new to us so it was fun to experiment with the RGB colors, the gradient, graphics, animations, and ZStacks. We customized the app so that it could provide the best user experience which is one of the original needs we identified for our audience during ideation. With this thought in mind, we added different Views so that the user did not get bored of the same screen. On top of proper views, we handled errors and feedback in progress through proper feedback and ProgressViews. When users click on their 'Profile', they can view all of their favorites songs and all of their playlists with those songs. We also have animations in some places! See if you can find them!

### Challenges:
This project was very difficult because of the integration of the music downloading APIs into Swift. The initial idea was to use the youtube-dl command-line API which allows users to download music through Terminal. We realized that this required various packages such as Python installed on a computer, which would not transfer via Github. We searched for and tested other APIs, but none of them allowed music downloading until Telegram. The Telegram API was helpful at first because, unlike Youtube or Spotify, it had open source code and its basic features were very developer-friendly. However, installation again required external packages. Finally we found TDLibKit, the Swift package. 

Next, our music downloader bot stopped working, and we had to switch to another one. This returned a different type of message, which we were eventually able to unwrap. However, we were unable to send data back to the bot because we could not find the query id to send (ChatGPT had no solutions, and the only recorded person with the same problem was unanswered on Stack Exchange). Akash tried searching through code in Objective-C (.h), C++ (.cpp), Teal (Lua) (.tl), and java files, for the original TDLib API, to find the query id. Akash then tried to run a Telegram desktop app (tdesktop) to print the query id, but we ultimately gave up because it had already taken hours.

What we did accomplish was also complex to code. Most structs contained about five wrappers attached to various other information. The Telegram API client class had to be initialized with an update handler that had to be synchronous, yet other API functions were asynchronous. Because of the large quantity of updates coming to the Telegram app, we took a long time to figure out what type of message contained the data we were looking for (And we never found out for the query id data).

Another challenge we were never able to conquer was the issue with Firebase. Our app had so many nested views it made it impossible to try and retrieve stuff from Firebase to display. We should have set our app up better so that we could follow along better and get the information we needed.

We have functionality for deleting songs but this does not seem to be working. We were not able to figure out why becuase we checked the documentation and followed it.

Another issue we have is the way we have set up favorites. When users favorite songs, the song gets added into Firebase but they can continuously favorite songs and continuously add songs to Firebase. This goes hand and hand with the issue of the songs not deleting. Additionally, when users reload the app, the app forgets that the user has the song favorited because of the way the favoriting is stored in Firebase. In fact, favoriting is not stored in Firebase at all. We debated about ways on how to implement favoriting and decided on keeping it local to the current build of the app due to time constraints. With more time, we would have fixed the way the favoriting system worked so that a user ID was saved to a "favorites" field of each song so that whenever user loaded the app, the songs were favorited in memory.

We also tried changing the background of the NavigationView that displayed on the Home screen so that the gradient was visible throughout the screen but nothing worked. We changed the background of pretty much every view possible to Color.clear but could not get it working.

We were getting some errors with some views causing errors because the compiler was failing to run in time because of complex operations in the views. Somehow, we got those errors to stop.

The Keck Lab laptops were not supporting many of the previews so a lot of the files are missing previews.

### Acknowledgements:
 - A massive thank you to Dondi for allowing us to work on the project another day. This was very beneficial because we were working nonstop and did not get much sleep so this extra day allowed us to catch up on rest and finalize some things we were working on. Additionally, we ran into many hurdles in terms of buggy APIs and packages so this extra day made up for the time lost fixing those issues. We also would like to acknowledge Dondi for doing an amazing job teaching the class and responding to student feedback/questions. We know it was difficult with the whole Macbook situation but Dondi handled it very well and we feel well compensated.
 - Thank you to the fellow students in the Keck Lab who gave feedback to us about our app and helped us resolve some minor bugs.
 - Thank you to the students who listened to our pitch and gave us feedback on the direction we should take our app as well as what we should reconsider.
 - ChatGPT 3.5 was used for a few lines of code and to answer questions.
 - Thanks to creator of TDLibKit for making the TDLib API into a Swift package.
 - Thanks to the Russian bot creators who are providing this music to us. All the American bots failed us, but thanks to Russia for being a haven of free music.
 - Thanks to the creators of Firebase.
