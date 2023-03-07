# Overview

This project consists of 3 parts.

One part is a wiki app downloaded from the https://github.com/wikimedia/wikipedia-ios.

Another part is `LocationsManagerCore` that contains business and presentation logic of this assignment.

The third part is `LocationsManagerHostApp` that contains an Xcode project that is connected to `LocationsManagerCore` and serves a purpose of a host App.

## Wiki app

I tried to make my impact on the wiki app minimal and my changes as small as possible.
The motivation behind this is simple: it is a large codebase with lots of unknowns. And given the limited time and lack of knowledge of wiki app internals and historical reasoning behind their decisions I decided to keep it simple.
1) I ran tests before my changes.
2) I changed 3 places to satisfy the requirements.
3) I ran tests again. All reds remained red, all greens remained green.
4) I did manual shallow testing. (without edge cases like no internet).

## LocationsManagerCore

I tried to build the project in a modular way using Swift package manager. For that I defined a few targets and set up their hierarchy.

I've chosen MVVM+C to separate different layers from each other and define navigation.
I've made this choice because it's something I've been working with for the last 2 years. Before that I used to work with VIPER, MVC, MVVM(without coordinators) and custom versions of Clean arch.
In this MVVM+C I used Combine framework for bindings. Even though using reactive frameworks can be a controversial topic and should be approved by a team (considering many factors) I decided to give it a shot. 
Even though at Polarsteps we don't usually do reactive bindings and use simple closures most times because it was discussed and agreed upon.

To communicate with the network I used async-await in a very simple way. It's important to draw the line between Combine and Swift concurrency, because async-await may seem like a killer of Combine, they serve different purposes.
All of it could have been reproduced solely in either async-await or Combine. Though some of the things (like debouncing) is simpler with the Combine.

The Core contains both business logic and presentation logic. But built in a way that everything except views is platform-agnostic and independent from UIKit. So, in theory we can reuse it to build a desktop app with AppKit. But that's in theory :) 

The whole project is done in vanilla swift. All layouts, api calls are programmatic.

The only 3d party is apple-docc-plugin to generate documentation from the package. You can find the compiled docs next to this Readme file.

The deployment targets are iOS 15 and macOS 13. These could have easily been 13 and 12 respectively, but I wanted to save time and use `keyboardLayoutGuide` to not deal with keyboard management on a LocationSearch screen.
 
## LocationsManagerHostApp

This is a project that serves one purpose: be a host app.
It has the Core connected to it.

**To start using the app, open LocationsManagerHostApp/LocationsManager.xcodeproj and let the Xcode resolve packages.**
The signing is not handled. Should run fine on a simulator though.

## What's done

An app that shows a list of locations fetched from the github-stored json file.
If a user taps a location in the list, the app will try to open a wiki app with the specified coordinates and name of the picked location. Though it's not guaranteed that Wiki will have an article for that exact location. It has it's own algorithms.
If a user wants to explore other locations, the user can tap a magnifying glass icon in the top right corner.
The user will be given a modal screen with a map and a search bar. User can either drag the map to search for location (the center of the map highlighted by a pin icon will be passed to Apple geocoder and will produce a reverse geocoding result based on the response).
Or the user can start typing something in the search bar. Once user presses `search`, the string will be passed to Apple geocoder and the view will be updated with the forward geocoding result.
If the user taps a bottom panel view with the location the app will try to open Wiki app with the specified location.
User can also save locations from this screen. (The saved locations will be shown in the list on top of remote locations).

From engineering perspective, there are a few tests that cover some business logic. Though the coverage is minimal (intentionally, just to introduce the unit tests into this project).
There's also compilable and scalable documentation solution. You can update/regenerate the docs by doing `cd LocationsManagerCore && swift package generate-documentation`

## What's not done

* Offline mode. If there's no network connection the app won't really work. Only locations saved by user will trigger the deeplinks.
* Deleting custom locations. I didn't do that just to keep the scope limited and time caped to 14 hours (two productive working days without meetings and context switching).
* Proper tests coverage.
* Proper async operations cancellation.
* CI&CD.
* Swiftlint.
* Localization.
* If there's no Wiki app on the device, it won't give you any feedback.

## Other remarks

The UI is really basic and simple. What would be nice to have here:

* empty state for the list of location
* feedback when user saves a location
* If Wiki app has not gone through Onboarding it won't work as expected
* Sometimes Wiki app updates the UI only partially: Search bar is updated, the map region is updated, but the annotation is not displayed. I could not find 100% reproducible pattern.
