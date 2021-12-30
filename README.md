# NSDateFormatter

[nsdateformatter.com](https://nsdateformatter.com)

This is a Swift web application that offers live date formatting using `DateFormatter` on the server.

This is useful for `Swift` and `Objective-C` developers as a way to test out behavior without having to compile & run over and over again.

It was originally written as a means to learn Swift on Linux. It stayed because so many people found it useful!

## The Tech Stack

* Swift 5.5
* Vapor 4
* Rollup
* Tailwindcss

## Building Front-end Assets

Assets are located in the `front-end` folder and are bundled with rollup.

To run the rollup process and watch for changes:

```
npm run dev
```

To just build them prior to deployment:

```
npm run build
```

## Running the App Locally

You can use Xcode or launch it via command line. I edited this in Neovim using the sourcekit-lsp.

To build & run the web server:

```
npm run vapor
```

Keep in mind that you have to stop & restart for any Swift-level change.

Changing CSS/js/leaf templates do not require a restart.

## Deployment

This app can run on essentially any cheap Linux VPS. There is a docker file. Or you can deploy to Heroku, which is where it is currently hosted (using the [Vapor buildpack](https://github.com/vapor-community/heroku-buildpack)).

## MIT License

The source code to this application is released under the MIT license. See [LICENSE](https://github.com/subdigital/nsdateformatter.com/blob/main/LICENSE).


## Inspired by

This site was inspired by [foragoodstrftime.com](https://www.foragoodstrftime.com), which does the same thing but for Ruby. 🍻

## Contributions

Pull requests are welcome. Keep in mind that not all suggestions will make it in, as I want this to be an easy to use resource, not an exhaustive list of everything DateFormatter can do.