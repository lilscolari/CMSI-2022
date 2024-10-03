# Known Issues Document
This is a document where we document all the known issues/bugs with our app.

### List of Issues:
 - SongList view not loading the list of songs from Firebase. Likely something wrong with the implementation of the function that fetches the songs from Firebase.
 - App crashing when user tries to create a playlist. Sometimes it works? Could be an issue with the way the project was set up.
- Adding to playlists doesn’t work. When trying to change the “playlist” field of a song in Firebase, a new “song” gets created with only the playlist field.
- We were unable to find the data for queryId and resultId fields in order to ask for audio from the bot. So no audio gets sent by the bot.
- Even when sent, audio doesn’t load. (It’s supposed to load the last audio in chat, which might be within range for loading if I use my Telegram app to get it sent.)
