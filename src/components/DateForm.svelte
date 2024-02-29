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
    console.log({ locale, timestamp, format })
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

<div class="sm:rounded-md shadow-xl my-4 p-4 sm:p-8 bg-white/10 backdrop-blur-md">
  <div class="flex flex-col md:flex-row justify-between gap-8 md:gap-2">
    <div class="flex flex-col flex-grow">
      <div class="text-sm font-medium uppercase text-gray-80">
        Date Input:
      </div>
      <input name="date-input" type="datetime-local" class="p-2 mt-1 h-10 mb-2 border-0 rounded-md bg-black/80" bind:value={inputDate}>
    </div>

    <div class="flex flex-col flex-grow">
      <div class="text-sm font-medium uppercase text-gray-80">
        Format text
      </div>
      <input type="text" name="format" class="p-2 mt-1 mb-2 h-10 border-0 rounded-md bg-black/80" bind:value={format}>
    </div>

    <div class="flex flex-col flex-grow">
      <div class="text-sm font-medium uppercase text-gray-80">
        Locale
      </div>

      <LocaleSelector bind:locale locales={viewData.locales} />
    </div>

    <div class="flex items-end">
      <button on:click={sendRequest} name="format-btn" class="w-full format-btn h-10 shadow hover:shadow-none bg-white/25 hover:bg-white/20 backdrop-blur-lg rounded-md px-4 py-2 m-1 mb-2 transition">&rarr;</button>
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

<style>
  input {
    color-scheme: dark;
  }
</style>
