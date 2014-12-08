A Comparison of Go Web Frameworks
-------------------

A few months ago we introduced [Go]() to our system at Square and it's quickly become one of our sharpest tools. We recently evaluated Go web frameworks looking for one that fits us best.

**TL;DR:** We recommend just using the [net/http]() package in the standard library to start. And if you want help with request routing we recommend looking at [Gorilla]() and [Gocraft/web](). Both Revel and [Martini]() have too much dependency injection and other magic to make us feel comfortable. Gorilla is the most minimal.

All of the frameworks we looked at are built on top of the net/http package.

**Routing** is the mechanism by which requests get mapped to a handler function.
Routing is the base functionality for all of these frameworks. Gorilla seems to
have the most flexibility, but they are all roughly equivalent. One important
note is that the implementation of this functionality is very straightforward.

* **Revel**: Supports parameters and wildcards in the URL. For example, "/hotels/:id" which match the regex  ```"/hotels/[^/]+" while "/hotels/*id" ```will match the regex "/hotels/.+". A revel app specifies routes in a configuration file.
* **Martini**: Supports parameters, wildcards and regular expressions in URLs. For example, "/hotels/:id" and "/hotels/**". Routes are tied to a particular HTTP method (e.g. GET, POST, HEAD, etc.)
* **Gocraft/web**: Supports parameters and regular expressions in URLs. For example, "/hotels/:id" and "/hotels/:id:[0-9]+". Similar to the functionality provided by the other frameworks, but gocraft/web has made an effort to be higher performance by structuring routes in a tree instead of as a list.
* **Gorilla**: Supports parameters in the URL where each parameter can have an optional regex that specifies what it matches. For example, "/hotels/{id}" matches the regex ```"/hotels/[^/]+" while "/hotels/{id:[0-9]+}" ```matches the regex "/hotels/[0-9]+". In addition to routing based on URL, Gorilla supports routing based on HTTP method, HTTP headers, URL scheme, query parameters, or using an arbitrary function. Routes are specified programmatically.

**Data binding** is the mechanism by which request parameters are extracted for use by handlers.

* **Revel**: Matched parameters are made available in a map[string]string and also via arguments to the handler method. For example, "/hotels/:id" might be mapped to a Show(id int) method and the "id" parameter would automatically be filled in. Revel's use of reflection and injection here feels a bit magical.
* **Martini**: Matched parameters are made available in a map[string]string which is injected into the parameters for the handler method. Martini provides full dependency injections of the handler method parameters and allows specifying global and request level mappings. If you like dependency injection, you'll feel right at home here.
* **Gocraft/web**: Matched parameters are made available in a map[string]string. Unlike gorilla, gocraft/web providers wrappers around http.ResponseWriter and http.Request. The parameters are a field within the web.Request type.
* **Gorilla**: Matched parameters are made available in a map[string]string that is retrieved by calling mux.Vars(request). No dependency injection. No magic.

**Controllers** or **Context** are used to maintain per-request state.

* **Revel**: Strong notion of Controller which you are forced to use. Your app controller must embed a *revel.Controller and there are mildly awkward type assertions necessary in middleware to go from a revel.Controller back to your app controller type.
* **Martini**: No notion of Controller or Context, but dependency injection allows you to easily create such concepts yourself.
* **Gocraft/web**: Routing is associated with a user-specified context struct. The context struct is often filled by middleware.
* **Gorilla**: No support for controllers or context. Do it yourself.
**Middleware** is the terminology used for providing common functionality across a set of handlers. A common example of middleware is a logging module. Note that there is nothing magical about the infrastructure to support middleware. Instead of calling a single handler method, the framework is calling a series of methods.

* **Revel**: Revel calls middleware "interceptors".
* **Martini**: Most of Martini's functionality is captured in middleware. Lots of third-party contributions that are not part of the Martini core.
* **Gocraft/web**: Middleware can be completely general or associated with a context. When associated with a context, middleware can provide common functionality across a set of handlers, such as authenticating a user.
* **Gorilla**: No support for middleware. Do it yourself (see below).

**Miscellaneous notes**

* **Revel**: Similar to Rails. Both the most comprehensive and most opinionated framework. Provides routing, data binding, validation, sessions, caching, a testing framework and internationalization. Specifies how directories are structured (separate "models", "controllers" and "views" directories). Heck, you don't even write a main() function as revel generates one for you.
* **Martini**: Inspired by Express (a Node.js web framework) and Sinatra (a Ruby web framework).
* **Gocraft/web**: Written in response to the author's frustration with using Revel. A library, not a framework.
* **Gorilla**: Structured as a series of independent libraries. It is easy to pick the parts you want and ignore the parts you don't.

**Doing it yourself**

In our analysis we didn't gravitate toward any full-featured framework. The strength of the standard library lets us build moderately complex apps without any of the above, and of these options, Gorilla is our favorite because it is minimally intrusive.

Rather than using a package that gives us routing, middleware and controllers bundled together, we prefer small libraries encapsulating useful behavior. It's not bad to forgo the use of middleware if it means you get to keep control over the behavior of your app and you can keep things simple. For example, if you want to authenticate a user you could have a common bit of code at the beginning of every handler to invoke some user authentication method:

```
func myHandler(rw http.ResponseWriter, req *http.Request) {
  user := AuthenticateUser(rw, req)
  if user == nil {
    // AuthenticateUser will have sent an error response through
    // the http.ResponseWriter on failure.
    return
  }
  ...
}
```

There's redundancy there, but it's explicit and fits nicely with the Go style of extremely readable code at the cost of slightly more verbosity.