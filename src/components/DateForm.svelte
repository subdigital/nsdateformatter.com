<script>
  export let viewData;
</script>

<div class="sm:rounded-md shadow-xl my-4 p-4 sm:p-8 bg-white/10 backdrop-blur-md">
  <div class="flex flex-col md:flex-row justify-between gap-8 md:gap-2">
    <div class="flex flex-col flex-grow">
      <div class="text-sm font-medium uppercase text-gray-80">
        Date Input:
      </div>
      <input name="date-input" type="datetime-local" class="p-2 mt-1 h-10 mb-2 border-0 rounded-md bg-black/80" value="{viewData.inputDate}">
        <span class="text-xs text-small-caps text-white/30">(enter in ISO8601 format)</span>
      </div>

      <div class="flex flex-col flex-grow">
        <div class="text-sm font-medium uppercase text-gray-80">
          Format text
        </div>
        <input type="text" name="format" class="p-2 mt-1 mb-2 h-10 border-0 rounded-md bg-black/80" value="{viewData.exampleFormat}">
        </div>

        <div class="flex flex-col flex-grow">
          <div class="text-sm font-medium uppercase text-gray-80">
            Locale
          </div>
          <select name="locale" class="mt-1 bg-black/80 block w-full h-10 pl-3 pr-10 py-2.5 border-0 text-base focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md">
            {#each viewData.locales as locale}
            <option selected={locale == viewData.defaultLocale}>{locale}</option>
            {/each}
          </select>
        </div>

        <div class="flex items-end pb-4">
          <button name="format-btn" class="w-full format-btn h-10 shadow hover:shadow-none bg-white/25 hover:bg-white/20 backdrop-blur-lg rounded-md px-4 py-2 m-1 mb-2 transition">&rarr;</button>
        </div>
      </div>

      <div class="mt-10">
        <div class="border-b border-b-white/20 text-white text-sm font-medium mb-4">
          Result
        </div>
        <div class="text-4xl font-medium">
          <span class="date-result">
            {viewData.exampleResult}
          </span>
        </div>
      </div>
    </div>
