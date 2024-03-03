
<div class="bg-white rounded-lg p-8 lg:max-w-4xl">
  <div class="prose mx-auto max-w-2xl">
    <h2> The main fallacy to be aware of: <code>dateFormat</code> is not locale-aware.</h2>

    <p>You should be aware that using a custom <code>dateFormat</code> comes with a risk of falling into some fallacies.</p>
    <p>
      Especially, you need to realize that the user can use different <code>Locales</code>,
      and that date formats are different for different locales, regions and user settings.
      For example one date formatted with a <code>dateFormat</code> that fits the US might become confusing for anyone in Europe.
    </p>

    <h2> The TL;DR </h2>
    <ul>
      <li>
        Use <code>dateStyle</code> and <code>timeStyle</code> over <code>dateFormat</code> whenever you can.
        Explain the date fallacies to your designer if you need to.
      </li>
      <li>
        If you can't find a fitting <code>dateStyle/timeStyle</code> to format your UI dates, then at least use
        <a href="https://developer.apple.com/documentation/foundation/dateformatter/1417087-setlocalizeddateformatfromtempla">
          <code>dateFormatter.setLocalizedDateFormatFromTemplate(…)</code>
        </a> to account for the user's locale.
      </li>
      <li>When parsing ISO8601 internet dates, always use <code>ISO8601DateFormatter</code></li>
      <li>
        If you can't because your API format doesn't fit ISO8601 and you still absolutely need to use a custom <code>dateFormat</code>,
        then be sure to also set your <code>dateFormatter.locale</code> to the special value <code>Locale(identifier: "en_US_POSIX")</code>.
      </li>
    </ul>

    <h2> Formatting user-visible dates for your UI </h2>

    <p class="quote">
      Apple already has <a href="https://developer.apple.com/documentation/foundation/dateformatter#1680045">a dedicated paragraph</a>
      in their documentation about best practices for formatting a date to present to the user in a locale-aware way.
      Below is just the TL;DR.
    </p>

    <h3> Using <code>dateStyle</code> and <code>timeStyle</code> </h3>

    <p>
      The main recommendation to follow is to <strong>prefer using <code>dateStyle</code> and <code>timeStyle</code>
        over <code>dateFormat</code></strong>.
    </p><p>
      This is because those are locale-aware and account for a lot of edge cases
      that you can otherwise miss when using a custom and hardcoded <code>dateFormat</code>.
    </p>
    <p>
      I would even advise you to convince your designer against using a custom format and explain them that Date
      and Time is <a href="https://yourcalendricalfallacyis.com/">a tricky subject with lots of edge cases</a>
      and that it's generally not worth using a custom format that might fit their assumptions about the locale
      and region they're used to use but might not fit a lot of other's.
    </p>

    <h3> Using DateFormatter's templating methods to auto-adjust for the user's Locale </h3>

    <p>If you still need to use a custom <code>dateFormat</code>, be sure that you use
      <a href="https://developer.apple.com/documentation/foundation/dateformatter/1417087-setlocalizeddateformatfromtempla">
          <code>dateFormatter.setLocalizedDateFormatFromTemplate(…)</code>
      </a> or <a href="https://developer.apple.com/documentation/foundation/dateformatter/1408112-dateformat">
        <code>dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate:…options:…locale:…)</code>
      </a> instead of setting it to a hard-coded <code>String</code>.
    </p>

    <h2> Working with ISO8601 dates and fixed formats for APIs </h2>

    <p class="quote">
      Apple Documentation <a href="https://developer.apple.com/documentation/foundation/dateformatter#2528261">
        also has a dedicated section about those cases here</a>.
    </p>

    <h3> Using <code>ISO8601DateFormatter</code> </h3>

    <p>
      If you need to parse <a href="https://en.wikipedia.org/wiki/ISO_8601">ISO8601</a> dates, consider
      using <code>ISODateFormatter</code> instead of a <code>DateFormatter</code> with a custom <code>dateFormat</code>.
    </p>
    <p>
      This class is dedicated to handle the <a href="https://en.wikipedia.org/wiki/ISO_8601">ISO8601</a> standard
      and all its possible variants and edge cases better than using a custom <code>dateFormat</code> would.
    </p>
    <p class="quote">
      Tip: One of the little-known options of <code>ISO8601DateFormatter</code> is that it is also able to handle
      fractional seconds if you set it up using <code>formatter.formatOptions.insert(.withFractionalSeconds)</code>.
    </p>

    <h3> Always use the en_US_POSIX locale for fixed formats </h3>

    <p>
      In last resort, if you need to parse a date for an API that doesn’t fall into ISO8601 format,
      but that also isn’t intended for UI (and should thus <em>not</em> depend on the user’s locale/region/language),
      then that is the only case when you can use a fixed string as a value for <code>dateFormatter.dateFormat</code>.
    </p>
    <p>
      <strong>BUT</strong> then <strong>ALWAYS also set</strong> your <code>dateFormatter.locale</code> to
      <code>Locale(identifier: "en_US_POSIX")</code> on your <code>DateFormatter</code>.
    </p>
    <p class="quote">
      <code>en_US_POSIX</code> is a special locale that guarantees that the formatting and parsing won’t depend on
      the phone’s locale, and is designed exactly for parsing those “internet dates with fixed format”.
    </p>

    <p>
      If you don't force the locale to <code>en_US_POSIX</code>, there are risks that your code might seem to work in some
      regions (like the US), but will fail to parse your API responses if the user has its phone set in another region
      (e.g. <code>en_GB</code>, <code>es_ES</code> or <code>fr_FR</code>), where date formatting is different, or use 12-hour time
      and not 24-hour time.
    </p>
    <p>
      You can test this kind of edge case on device by setting your phone settings to use <code>es_ES</code> for example and set
      it to use 12-hour with am/pm, and try to parse a date like <code>2020-01-15T22:00:00Z</code>.
    </p>
    <p>
      For more information about those commonly overlooked cases, you can read
      <a href="https://developer.apple.com/library/archive/qa/qa1480/_index.html">Apple's TN1480</a>.
    </p>

    <p class="text-sm italic">This section was contributed by Olivier Halligon</p>
  </div>
</div>

<style>
  code::before {
    content: "";
  }
  code::after {
    content: "";
  }
  code {
    @apply py-1 px-2 text-violet-600 bg-gray-300 bg-opacity-50 rounded-md text-sm;
  }
  h2 code {
    @apply text-lg;
  }
</style>
