# NSDateFormatter

[nsdateformatter.com](https://nsdateformatter.com)

This is a Swift web application that offers live date formatting using `DateFormatter` on the server.

This is useful for `Swift` and `Objective-C` developers as a way to test out behavior without having to compile & run over and over again.

It was originally written as a means to learn Swift on Linux. It stayed because so many people found it useful!

## The Tech Stack

* Swift 5.9
* Vapor 4
* Svelte
* Vite
* Tailwindcss

## Deployment

(Previously: Digital Ocean, Heroku)

Current: Netlify front-end, AWS Lambda for backend.

## Front-end

The front-end is written in Svelte and uses Vite as a development server.

To run the dev server:

```
npm run dev
```

To build the dist folder that contains all the final files for deployment:

```
npm run build
```

This is automatically run by Netlify upon deployment.

## Running the App Locally

You can use Xcode or launch it via command line.

To build & run the vapor backend server:

```
swift run
```

Keep in mind that you have to stop & restart for any Swift-level change.

You'll also need to run the front-end server:

```
npm run dev
```

Connect to this front-end server in your browser.

## Deployment

This app can run essentially anywhere (and has). The Dockerfile can be used to deploy this on a number of 
cloud infrastructure or PAAS providers.

Currently this is done with AWS Lambda and Netlify.

To deploy the backend server, run:

```
just deploy
```

This will build the docker image and deploy it with a SAM template.

The Netlify deployment happens on a git push.

## MIT License

The source code to this application is released under the MIT license.
See [LICENSE](https://github.com/subdigital/nsdateformatter.com/blob/main/LICENSE).


## Inspired by

This site was inspired by [foragoodstrftime.com](https://www.foragoodstrftime.com), which does the same thing but for Ruby. 🍻

## Contributions

Pull requests are welcome. Keep in mind that not all suggestions will make it in, as I want this to be an easy to use resource, not an exhaustive list of everything DateFormatter can do.
