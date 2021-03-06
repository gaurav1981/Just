Just is a client-side HTTP library inspired by [python-requests][] - HTTP for Humans.

*Caution: Just is still in development and is subject to breaking changes before version 1.0.*


[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) ![Platform](http://img.shields.io/cocoapods/p/Timepiece.svg?style=flat)

Follow [@JustHTTP](twitter) for updates. Questions/comments/concerns are also welcome!

[python-requests]: http://python-requests.org "python-requests"
[twitter]: https://twitter.com/JustHTTP

#   Features

Just lets you to the following effortlessly:

-   URL queries
-   custom headers
-   form (`x-www-form-encoded`) / JSON HTTP body
-   redirect control
-   multpart file upload along with form values.
-   basic/digest authentication
-   cookies
-   timeouts
-   synchrounous / asyncrounous requests
-   friendly accessible results

#  Use

An examle of making a request with Just:

```swift
//  talk to registration end point
let r = Just.post(
    "http://justiceleauge.org/member/register",
    data: ["username": "barryallen", "password":"ReverseF1ashSucks"],
    files: ["profile_photo": .URL(fileURLWithPath:"flash.jpeg", nil)]
)

if (r.ok) { /* success! */ }
```

Here's the same example done asyncronously:

```swift
//  talk to registration end point
Just.post(
    "http://justiceleauge.org/member/register",
    data: ["username": "barryallen", "password":"ReverseF1ashSucks"],
    files: ["profile_photo": .URL(fileURLWithPath:"flash.jpeg", nil)]
) { (r)
    if (r.ok) { /* success! */ }
}

```

You can learn more and play with Just in this [Playground][JustStarting]

[JustStarting]: https://raw.githubusercontent.com/JustHTTP/Just/master/Docs/JustStarting.zip

#  Install

Here are some ways to leverage Just.

-   **Source File**: There's only one. Drop it in a playground or, if so desired, directly into
    your code base.

-   **Git Submodule**: Add this repository as a git submodule, drop `Just.xcodeproj` in to your
    Xcode project so that you can make `Just.framework` a dependency and link to it.

-   **Dynamic Framework**: [Carthage][] can install Just because Just is a dynamic framework
    for iOS and OS X. Other ways to use 3rd party dynamic framework should also work.


[Carthage]: https://github.com/Carthage/Carthage "Carthage"


#  Contribute

Pull requests are welcome. Here are some tips for code contributors:

[Carthage][] is needed to install [Quick][], before you can run the tests.
For Xcode rebels, checkout `Makefile` (you'll need [xcpretty][]).


[Quick]: https://github.com/Quick/Quick "Quick"
[xcpretty]: https://github.com/supermarin/xcpretty "xcpretty"

#  License

MIT, see [LICENSE.md](https://github.com/JustHTTP/Just/blob/master/LICENSE.md).
