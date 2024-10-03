# Pink Posts

A mobile development project by Taylor Musso and Cameron Scolari integrating Google Firebase for database management and user sign-in. This application allows users to sign-in and post blogs under their display name. Users can edit/delete blogs after posting them. Users can favorite blogs to show support of a post. The app provides basic functions like sorting and searching so users can easily navigate around the app and view articles that interest them most.

### Extra Features:
 - Google login.
 - Editing articles.
 - Deleting articles.
 - Sorting articles by: date, score (ascending and descending), default (uid).
 - Pagination (20 articles per page, works with sort as well).
 - Search bar (debounced text so firebase is not spammed).
 - User profile metadata. Edit profile.
 - Photo upload for articles.
 - Comments for articles.

### Known Bugs:
 - Profile photo updating properly in user metadata after updating profile but not being displayed properly in ArticleList. In the top right of the screen, the old user profile picture is displayed.
 - Not necessarily a bug: searching only searches for articles displayed on current page.
 - When searching on a page other than the first, bugs occur after deleting search query. Either crashes, displays no articles, or random articles are displayed but not all.

### Fun Fact:
 - Our graphic is displayed when there are no articles to be displayed.

### Coding references:
 - [Debounce](https://www.youtube.com/watch?v=gb4iE8Sbny4)
 - [Custom App Icon](https://www.craiyon.com/image/GRmxkqNGQMKPIk3iHKpmEA)
 - [Image Picker](https://www.hackingwithswift.com/books/ios-swiftui/importing-an-image-into-swiftui-using-phpickerviewcontroller)

### Here is a copy of the Firestore production security policy:
<pre>
rules_version = '2';

service cloud.firestore
  match /databases/{database}/documents {
    match /{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
</pre>
