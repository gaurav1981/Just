//: # Just: HTTP for Humans
//: This document is an introduction to the basics of donig HTTP via Just.
//: Readers are assumed to understand of the HTTP protocal.
//:
//: Just's API is heavily influenced by [python-requests](http://python-requests.org),
//: a popular client-side HTTP library in the Python community.
//:
//: Here's a simple POST request via Just:

    Just.post("http://httpbin.org/post")

//: A GET request with some URL query parameters is as simple as:

    Just.get("http://httpbin.org/get", params:["page": 3])

//: Just supports these methods *DELETE/GET/HEAD/OPTIONS/PATCH/POST/PUT*
//: The URL is the only required argument when making a request. Just strives
//: for a minimum interface.

//: ## Synchronous v. Asynchronous
//: When working with Swift, we tend to shun sychronous network requests because
//: they block when invoked on the main thread, which would prevent our
//: Cocoa/Cocoa Touch apps from smooth UI rendering. However, there's nothing
//: inherantly wrong with synchronous requests. In fact, synchronous code is often
//: easier to understand and, therefore, a better paradigm to explore HTTP
//: resources with. In REPL or playgrounds, you can see the result of
//: synchronous results.

    var r = Just.get("http://httpbin.org/get", params:["page": 3])
    // … "r" becomes available here

//: However, Just doesn't force you to choose. The same request can be made
//: asynchronously like this

    Just.get("http://httpbin.org/get", params:["page": 3]) { (r) in
        // the same "r" is available asynchronously here
    }

//: That is, you can switch between the two paradigm by adding/removing a
//: callback. When such callback is present, the result of the request becomes
//: available asynchronously as an arugment to the callback. Otherwise,
//: Just will return the very same result synchronously.
//:
//: The examples in the rest of this document will be synchronous. Keep in
//: mind that all of them can easily be asynchronous.

//: ## HTTP Result
//: The result of a HTTP request is captured in a single object.
//: Let's take a look at *r* from the previous example.

    // is the request successful?
    r.ok
    r.statusCode

//: Hopefully, that's self explainatory. **ok** is *true* if a response is
//: received and the **statusCode** is not *4xx* or *5xx*.
//:
//: Moving on:

    // what did the server return?
    r.headers       // response headers
    r.content       // response body as NSData?
    r.text          // response body as text?
    r.json          // response body parsed by NSJSONSerielization
    r.url           // the URL, as *NSURL*
    r.isRedirect    // is this a redirect response

//: The **headers** property is a Swift-dictionary-like object:

    for (k,v) in r.headers {
        println("\(k):\(v)")
    }

//: It's different from a normal dictionary in that its values can be accessed
//: by case-insensitive keys:

    r.headers["Content-Length"]
    r.headers["cOnTeNt-LeNgTh"]

//: The original request is preserved as a *NSURLRequest*:

    r.request
    r.request?.HTTPMethod

//: When things aren't going so well:
    let erronous = Just.get("http://httpbin.org/does/not/exist") // oops
    erronous.ok         // nope
    erronous.reason     // text description of the failure
    erronous.error      // NSError from NSURLSession, if any

//: ## More Complicated Requests
//:
//: To send form values, use the **data** parameter:

    // body of this request will be *firstName=Barry&lastName=Allen*
    // a *Content-Type* header will be added as *application/x-form-www-encoded*
    Just.post("http://httpbin.org/post", data:["firstName":"Barry","lastName":"Allen"])

//: JSON values are similar:

    // body of this request will be in JSON
    // a *Content-Type* header will be added as *application/json*
    Just.post("http://httpbin.org/post", json:["firstName":"Barry","lastName":"Allen"])

//: By default, Just follows server's redirect instrution. You can supply an
//: **allowRedirects** argument to control this behavior.

    // redirects
    Just.get("http://httpbin.org/redirect/2").isRedirect

    // no redirects
    Just.get("http://httpbin.org/redirect/2", allowRedirects:false).isRedirect

//: In addition, a permanent redirect can be detected this way:
    // permanent redirect
    Just.get("http://httpbin.org/status/301", allowRedirects:false).isPermanentRedirect

    // non permanent redirect
    Just.get("http://httpbin.org/status/302", allowRedirects:false).isPermanentRedirect

//: ## Files
//: Uploading files is easy with Just:

    import Foundation
    if let photoPath = NSBundle.mainBundle().pathForResource("elon", ofType:"jpg"), let photoURL = NSURL(fileURLWithPath: photoPath) {
        let uploadResult =  Just.post("http://httpbin.org/post", files:["elon":.URL(photoURL, nil)]) // <== that's it
        print(uploadResult.text ?? "")
    }

//: Here a file is specified with an NSURL. Alternatively, a file can be a NSData or just a string. Although in both cases, a filename is needed.

    if let someData = "Marco".dataUsingEncoding(NSUTF8StringEncoding) {
        if let text = Just.post(
            "http://httpbin.org/post",
            files:["a":.Data("marco.text", someData, nil), "b":.Text("polo.txt", "Polo", nil)] // <== two files
        ).text {
            print(text)
        }
    }

//: Two files are being uploaded here.
//:
//: The *nil* part of the argument in both examples is an optional String that can be used to specify the MIMEType of the files.
//:
//: **data** parameter can be used in conjuction with **files**. When that happens, though, the *Content-Type* of the request will be *multipart/form-data; ...*.

    if let photoPath = NSBundle.mainBundle().pathForResource("elon", ofType:"jpg"), let photoURL = NSURL(fileURLWithPath: photoPath) {
        if let json = Just.post("http://httpbin.org/post", data:["lastName":"Musk"], files:["elon":.URL(photoURL, nil)]).json as? [String:AnyObject] {
            print(json["form"] ?? [:])
            print(json["files"] ?? [:])
        }
    }

//: ## Cookies
//:
//: If you expect the server to return some cookie, you can find them this way:

    Just.get("http://httpbin.org/cookies/set/name/elon", allowRedirects:false).cookies["name"] // returns an NSHTTPCookie

//: To send requests with cookies:

    Just.get("http://httpbin.org/cookies", cookies:["test":"just"])

//: ## Authentication
//:
//: If a request is to be challenged by basic or digest authentication, use the **auth** parameter to provide a tuple for username and password

    Just.get("http://httpbin.org/basic-auth/flash/allen", auth:("flash", "allen"))

//: ## Timeout
//:
//: You can tell Just to stop waiting for a response after a given number of seconds with the timeout parameter:

    // this request won't finish
    Just.get("http://httpbin.org/delay/5", timeout:0.2).reason
