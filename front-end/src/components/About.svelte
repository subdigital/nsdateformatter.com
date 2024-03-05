<script>
  import avatar from "../assets/avatar.jpeg"
  import mastodonLogo from "../assets/mastodon.svg"
</script>
<div class="bg-white rounded-lg p-8 lg:max-w-4xl">
  <div class="prose mx-auto">
    <p>
      <strong>nsdateformatter.com</strong> is written with <a href="http://swift.org">Swift</a> for the backend,
      Svelte for the front end. It was originally as a means to learn open-source Swift, Swift Package Manager,
      and deploying to Linux. It uses the <a href="https://vapor.codes" target="_blank">Vapor</a> web application
      framework and is deployed to AWS Lambda. The front-end is built using Svelte and Vite as a local dev server.
    </p>

    <p>
      The site is <a href="https://github.com/subdigital/nsdateformatter.com">open source</a>, so if you want to
      fix a bug or submit an enhancement, feel free to submit a pull request.
    </p>

    <h2> About the Author </h2>

    <div class="space-y-4 sm:grid sm:grid-cols-4 sm:items-start sm:gap-6 sm:space-y-0">
      <div class="aspect-w-3 aspect-h-2 sm:aspect-w-3 sm:aspect-h-4">
        <img class="object-cover shadow-lg rounded-lg" src={avatar} alt="Ben Scheirman">
      </div>
      <div class="sm:col-span-3">
        <div class="space-y-4">
          <div class="text-lg leading-6 font-medium space-y-1">
            <h3 class="mb-1">Ben Scheirman</h3>
            <a href="https://mastodon.xyz/@bens" target="_blank" class="inline-flex items-center">
              <img alt="mastodon" class="w-5 m-0 mr-2 not-prose" src={mastodonLogo}>
              <span>@bens@mastodon.xyz</span>
            </a>
          </div>
          <div class="text-lg">
            <p class="text-gray-500">
              Ben is an experienced software developer from Houston, TX. He is the founder of <a href="http://nsscreencast.com">NSScreencast</a>,
              where you can find over 500 screencasts on iOS development topics.
            </p>
            <p class="text-gray-500">You can find Ben on <a href="https://mastodon.xyz/@bens">Mastodon</a> or his <a href="http://benscheirman.com">blog</a>.
          </div>
        </div>
      </div>
    </div>

    <div class="text-zinc-600 bg-yellow-100 mt-4 p-2 rounded-md text-center">
      Special thanks to Dave DeLong and Olivier Halligon for their contributions to this site.
    </div>
  </div>
</div>

