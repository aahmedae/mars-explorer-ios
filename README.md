# Mars Explorer
### An iPad app built using Swift 3 to view photos on Mars using NASA's rover API

<p align = "center">
  <img src = "https://github.com/aahmedae/aahmedae.github.io/blob/master/images/screenshots/mars-explorer/screen_01.png" width = "80%">
</p>

<p align = "center">
  <img src = "https://github.com/aahmedae/aahmedae.github.io/blob/master/images/screenshots/mars-explorer/screen_02.png" width = "80%">  
</p>

<p align = "center">
  <img src = "https://github.com/aahmedae/aahmedae.github.io/blob/master/images/screenshots/mars-explorer/screen_03.png" width = "80%">   
</p>

#### Description
Mars Explorer is an iPad app that allows the user to explore Mars through their iPad. Users can use a control panel interface to feel like they are controlling a rover on Mars. This was built using [NASA's open Rover API.](https://api.nasa.gov/api.html#MarsPhotos)

#### Development Notes

The app utlises the following frameworks and development methodologies:  

* [Swifty JSON](https://github.com/SwiftyJSON/SwiftyJSON)
Swifty JSON is used for efficient JSON parsing

* [NSURLSession]
Bare-bones NSURLSession for networking and making HTTP REST requests. No third-party library used.

* OOP in View Controllers
Use of OOP to move generic functionality into parent view controllers. This makes the code easy to maintain and debug in child view controllers.

* Component Design
View controllers utilse static classes and helper classes for dealing with heavy UI code. This keeps view controller classes small.

* Unit testing
XCTestCases for testing out core functionality of the classes.

<p align = "center">
  <a href = "https://itunes.apple.com/ae/app/mars-explorer/id1275950710?mt=8"><img src = "https://github.com/aahmedae/aahmedae.github.io/blob/master/images/screenshots/other/app_store_download_badge.svg"></a>   
</p>
