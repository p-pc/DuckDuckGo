# DuckDuckGo
DuckDuckGo - sample app - Seinfeld

Duck Duck Go:

Language : Swift 4.0

Design:

The app is started from a Master-Detail template as per the requirements.

The home screen is built to be a table view with a collection view hidden within. Either will be shown on a Switch button click in Navigation Controller.

Service call was made usign a service manager (Alamofire in this case). 
The service managers will let us effectively handle the service requests going on in the application.
They also help us handle any auth chanllenges, custom redirects, etc. asynchronously.
App transport Security is disabled in app, for http:// insecure calling of given API

CocoaPods is used to easily add third party libs, which provide quick integration of rich features and UI components.

KingFisher Image Cache manager is used to download the images only once and read from cached memory after that. 
Image caching will save a lot of bandwidth for a user and also improve performance of app significantly.

A Singleton Utility class is added which serves all utility function needs for the app. MVC pattern used to distinguish services, model parsings and UI data.

Reachability class is used to check the app for data connection and Bridging Header is used to add this Obj C class in th Swift project.
Reachability can also be used to automatically refresh data when data is available through call back blocks.

Git repo is build by default and used to manage incremental changes.

UI of the app is managed from same view files for both iPhone and iPad. 
Autolayout classes are useed to manage better data presentation for different device configurations.



Coding:

Call back blocks used to handle service response asynchronously.
Escaping closures in Service Managers will ensure app performance is not lagging because of network delays.
Guards are used effectively to handle any king of unexpected data of format behavior.
Simple test cases added for UI testing and Performance testing. No custom identifiers used.
UIApplicationWillEnterForeground notification observed to refresh UI when app comes to foreground in every session.
