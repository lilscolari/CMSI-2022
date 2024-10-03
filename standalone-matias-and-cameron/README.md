[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/lt1PfALg)
**CMSI 2022** Mobile Application Development, Spring 2024

# Assignment 0131
We start our practicum with a standalone mobile app—one that does not need to communicate with other servers or services in order to do what it seeks to do. For this assignment, we’d like you to demonstrate:
* The ability to compose and lay out views
* Knowledge of the Swift programming language
* Proper separation of views, models, and resources
* Basic event handling and business logic
* Successful use of version control for your code

## Background Reading
The [official SwiftUI tutorials](https://developer.apple.com/tutorials/swiftui) will likely comprise your primary resource for getting started with this assignment. Do and re-do them in order to get used to the core ideas and techniques behind this framework. Swift language specifics can be found on the [Swift resources page](https://developer.apple.com/swift/resources/). Once you are familiar with SwiftUI basics and are ready to go deeper or more specific, the broader [SwiftUI documentation site](https://developer.apple.com/documentation/swiftui/) should have what you need, in addition to the various help content that can be found in Xcode.

Finally, you can get help with design decisions by perusing the [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios/) for best practices on how to use and arrange SwiftUI’s many views and controls.

For version control assistance or review, [this GitHub Classroom link](https://classroom.github.com/a/gefKmZ6l) will give you your own copy of a repository with notes and documentation about _git_ and GitHub, authored by GitHub. You can also use that repository to practice _git_ commands. The official [Git Book](https://git-scm.com/book/en/v2) is also completely available online. Chapters 1 and 2 are fundamental, with Chapter 3 becoming useful if you want to experiment safely without disrupting established code.

## For Submission
Create a mobile app for displaying a (preloaded) “list of stuff”—movies, outfits, parks, musicians, anime, games, countries, teams—take your pick! Allow the user to:
* Browse through what’s available
* Apply a filter or search
* Look at items in detail, and
* Make an in-memory change or edit to the data (e.g., set a rating, like/dislike, comment/note, etc.). “In-memory” change means that it’s OK for that edit to go away if the user restarts your app.

The [official SwiftUI tutorials](https://developer.apple.com/tutorials/swiftui) already have aspects of these features…so additionally, your version must _differ noticeably_ from the tutorial. Views may retain their overall structure but must have different layouts/designs. The detail data must include something more than or different from the details displayed in the tutorial. The in-memory change must be different from any in-memory changes that are already implemented in the tutorial. If something is too close—thus indicating that the tutorial code was insufficiently modified or added to—your score won’t be as high as it could be.

Pick something for which information is easily available so that you don’t spend too much time collating or gathering the data. The list also doesn’t have to be that big—we want to focus on programming, not data entry.

In addition to the app working correctly and distinctly from the tutorial, its layout and design must demonstrate these characteristics:
* Effective layout via proper composition of stacks, spacers, padding, and other SwiftUI features
* Appealing color choices and visuals—demonstrate your mastery of views and their properties (without violating any iOS Human Interface Guidelines 😅)
* Proper choice of input views and controls—sufficiently distinct from what’s in the tutorial

To ensure that this app is built according to best/recommended practices as well as show the knowledge you have gained about building an app, make sure to show the following—_all_ of them, or no credit will be awarded (as one goal of this assignment is to get you to actually use a wide range of foundational SwiftUI techniques). The good news is that all of these items have concrete examples in the tutorial app; you just have to use them in the same way, but customized to the specific “stuff” that you are displaying:
* Use of model objects to separate data from presentation
* Storage of list in a JSON file to be loaded into model objects
* Use of environment objects to connect the model to the app’s views
* Use of images—duly credited of course
* At least one animation or transition
* Custom app icon—again duly credited

As mentioned, the SwiftUI tutorial reflects these practices in many respects already. Thus, for your own list of stuff, make sure to put your distinct stamp on them. Don’t just regurgitate code from the tutorial:
* A sufficiently distinct set of “stuff” should take care of the baseline functionalities and layout/design characteristics
* The all-or-nothing items should be tailored to that “stuff”—be sure to rework the tutorial code to reflect your chosen items well
* Deductions will be applied if we don’t perceive sufficient customization of the tutorial code

Supply a simple _about.md_ Markdown file that describes your “list of stuff” app briefly. Highlight anything about the app that you think is particularly interesting or that you’re particularly proud of.

## Operational Tips/Suggestions
* So as not to let data entry compromise your programming time, plan on two phases of JSON file prep: first, load up “just enough” data from whatever source you pick to have enough information to play with while programming. Then, when the app is largely done, use the remaining time to populate your data file further, perhaps cherry-picking items that will highlight the range of your app most effectively
* Remember that there isn’t enough class time to cover absolutely everything that you might want to do! We hope that our class time so far has served to give you a good foundation for getting started, but definitely don’t let “this wasn’t mentioned in class” be a barrier when it comes to figuring things out

### Initial setup: Unifying your GitHub and Xcode repositories
The repository for this assignment comes _only_ with this _README.md_ by design, so that you can go through the motions of creating the app project in Xcode yourself. Checking _Create Git repository on my Mac_ will set things up properly but as a _separate_ repository from the one that you get with the assignment, and it takes some specialized _git_ commands to “cross the streams” successfully 👻

Note also that **if you are working in a group**, _only one of you_ needs to do this to the group assignment repository. Once it has been set up, everyone can then clone that repository and should be good to go.

Depending on how much _git_ you have done, you may encounter some “wrinkles” that will feel unfamiliar. Make sure to look at the “`pull` wrinkle” subsections for instructions on how to handle them.

So when setting up for the first time, instead of the usual `git clone` command, do the following:
1. Create your initial Xcode project on your machine with the _Create Git repository on my Mac_ option checked
2. Acquire the URL of your assignment repository from the green `Code` button on GitHub—let’s call this `YOUR_REMOTE_URL` (this is also what you would do before doing an initial `git clone`, but in this case we will do something different with it—read on)
3. Make sure that you don’t have any pending changes on your Xcode project—if so, commit them
4. From the command line, `cd` into your Xcode project’s folder and type the following three commands:

```
git remote add origin YOUR_REMOTE_URL
git pull origin main --allow-unrelated-histories
git branch --set-upstream-to=origin/main main
```

(don’t forget to substitute `YOUR_REMOTE_URL` above for the specific URL of your GitHub repository)

That should do it! The repository created by Xcode and the assignment repository that GitHub Classroom gave you should now be “as one.” You should now be able to use _git_ on this folder as if you had `git clone`-d it normally.

#### `pull` Wrinkle 1: “You have divergent branches…” message
If you have not done a lot of push/pull so far, upon attempting the second command (`git pull origin main --allow-unrelated-histories`) you may encounter a message that starts like this:

```
hint: You have divergent branches and need to specify how to reconcile them.
hint: You can do so by running one of the following commands sometime before
hint: your next pull:
```

If you see this, choose the first command option shown, `git config pull.rebase false`. (as you learn more about _git_, you might prefer one of the other options in the future, but for now go with that first one)

After running that command, doing `git pull origin main --allow-unrelated-histories` a second time should proceed without incident.

#### `pull` Wrinkle 2: Lots of `~`s down the left of your screen
Something you might encounter on a more regular basis when doing a `pull` is a full terminal screen display with an auto-generated commit message at the top and a column of `~`s down the left. This is the venerable _**vi**_ editor. Again, there is more to learn about this in the future, but for now just accept the message by typing <kbd>:</kbd><kbd>w</kbd><kbd>q</kbd><kbd>⏎</kbd> (you should see these appear at the bottom of the terminal window as you type)

This saves the commit message and concludes the `pull` operation.

## How to Turn it In
Commit the following to your repository:
- Complete Xcode project with all code, raw data, and assets
- _about.md_ file describing your app

## Specific Point Allocations
For this particular assignment, graded categories are as follows:

| Category | Points |
| -------- | -----: |
| Baseline functionality | 20 points total |
| • Top-level list of information | 3 points|
| • Detail view of individual item | 5 points |
| • At least one filter/search | 7 points |
| • At least one user-modifiable property | 5 points |
| Baseline design/layout | 15 points total |
| • Layout and composition | 5 points |
| • Colors and other visuals | 5 points |
| • Proper choice of input views and controls | 5 points |
| Implementation specifications | 10 points—all or nothing |
| • Model objects<br/>• JSON data<br/>• Environment wrapper and binding<br/>• Use of images, properly credited<br/>• At least one animation or transition<br/>• Custom app icon, properly credited | |
| App description in _about.md_ | 5 points |
| Hard-to-maintain or error-prone code | deduction only |
| Hard-to-read code | deduction only |
| Version control | deduction only |
| Punctuality | deduction only |
| **Total** | **50** |

Any line item may incur additional deductions if there is insufficient differentiation from tutorial code.

Note that inability to compile and run any code to begin with will negatively affect other criteria, because if we can’t run your code, we can’t evaluate related remaining items completely.
