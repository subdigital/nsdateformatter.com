<script>
  export let viewData;

  import {formatDate} from '../api.js';
  import LocaleSelector from './LocaleSelector.svelte';

  let inputDate;
  let format;
  let result;
  let locale;

  $: {
    if (!inputDate) {
      inputDate = viewData.inputDate;
      format = viewData.exampleFormat;
      result = viewData.exampleResult;
      locale = viewData.defaultLocale;
    }
  }

  function sendRequest() {
    let timestamp = new Date(inputDate).valueOf() / 1000;
    formatDate({
      locale,
      timestamp,
      format: { raw: format }
    }).then((response) => {
      console.log(response);
      result = response[0].value;
    });
  }

</script>

<form on:submit|preventDefault={sendRequest}>
  <!-- container -->
  <div id="date-form-container" class="sm:rounded-md shadow-xl my-4 p-4 sm:p-8 bg-white/10 backdrop-blur-md">

    <!-- fields -->
    <div id="fields" class="flex flex-col md:flex-row justify-between gap-8 md:gap-2">

      <!-- date field -->
      <div class="flex flex-col flex-initial">
        <label for="date-input" class="text-sm font-medium uppercase text-gray-80">
          Date Input:
        </label>
        <input id="date-input" name="date-input" type="datetime-local" class="p-2 mt-1 h-10 mb-2 border-0 rounded-md bg-black/80" bind:value={inputDate}>
      </div>

        <!-- format field -->
      <div class="flex flex-col grow">
        <label for="format" class="text-sm font-medium uppercase text-gray-80">
          Format text
        </label>
        <input id="format" type="text" name="format" class="p-2 mt-1 mb-2 h-10 border-0 rounded-md bg-black/80" bind:value={format}>
      </div>

      <!-- locale field -->
      <div class="flex flex-col grow md:grow-0 md:w-48 z-50">
        <label for="locale-selector" class="text-sm font-medium uppercase text-gray-80">
          Locale
        </label>

        <LocaleSelector bind:locale locales={viewData.locales} />
      </div>

      <!-- submit button -->
      <div class="flex items-end">
        <button name="format-btn" class="w-full format-btn h-10 shadow hover:shadow-none bg-white/25 hover:bg-white/20 backdrop-blur-lg rounded-md px-4 py-2 m-1 mb-2 transition">&rarr;</button>
      </div>
    </div>

    <div class="mt-10">
      <div class="border-b border-b-white/20 text-white text-sm font-medium mb-4">
        Result
      </div>
      <div class="text-4xl font-medium">
        <span class="date-result">
          {result}
        </span>
      </div>
    </div>
  </div>
</form>

<style>
  input {
    color-scheme: dark;
  }
</style>
