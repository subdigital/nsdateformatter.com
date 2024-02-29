<script>
  export let locales = [];
  export let locale;

  import { DropdownItem, Button, Dropdown, Search } from 'flowbite-svelte';
  import { onMount } from 'svelte';

  let term = "";
  let filteredLocales;
  let open = false;

  $: {
    filteredLocales = locales.filter((l) => {
      return l.toLowerCase().indexOf(term.toLowerCase()) != -1;
    });
  }

  /** @param {string} loc
   */
  function selectLocale(loc) {
    locale = loc;
    open = false;
  }

  /** @param {KeyboardEvent} event
  */
  function handleNav(event) {
    let index = filteredLocales.indexOf(locale);
    if (event.key == "ArrowUp") {
      if (index > 0) {
        index = index - 1;
      }
    } else if (event.key == "ArrowDown") {
      if (index < filteredLocales.length) {
        index = index + 1;
      }
    } else {
      return
    }

    event.preventDefault();

    // select new item and scroll into view
    locale = filteredLocales[index];
    let item = document.querySelector(`li[data-locale="${locale}"]`);
    if (item) {
      item.scrollIntoView({block: "nearest"});
    }
  }

  /** @param {KeyboardEvent} event
  */
  function handleWindowKeypress(event) {
    if (!open) { return }

    if (event.key == "Escape") {
      open = false;
    }

    return handleNav(event);
  }

  function onShow() {
      console.log("on c u")
  }


  onMount(() => {
    window.addEventListener("keydown", handleWindowKeypress);
    return () => {
      window.removeEventListener("keydown", handleWindowKeypress);
    }
  })
</script>

<Button class="p-2 mt-1 mb-2 h-10 border-0 rounded-md bg-black/80 hover:bg-black/60">
  <span class="inline-block mr-2">{locale}</span>
  <svg class="h-5 w-5 text-white" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
    <path fill-rule="evenodd" d="M10 3a.75.75 0 01.55.24l3.25 3.5a.75.75 0 11-1.1 1.02L10 4.852 7.3 7.76a.75.75 0 01-1.1-1.02l3.25-3.5A.75.75 0 0110 3zm-3.76 9.2a.75.75 0 011.06.04l2.7 2.908 2.7-2.908a.75.75 0 111.1 1.02l-3.25 3.5a.75.75 0 01-1.1 0l-3.25-3.5a.75.75 0 01.04-1.06z" clip-rule="evenodd" />
  </svg>
</Button>
<Dropdown on:show={onShow} class="overflow-y-auto px-3 pb-3 text-sm h-60" containerClass="divide-y" bind:open>
  <div slot="header" class="p-3">
    <Search size="sm" bind:value={term} on:keydown={handleNav} />
  </div>
  {#each filteredLocales as loc}
    <DropdownItem on:click={() => selectLocale(loc)} defaultClass="text-gray-500">
      <li data-locale="{loc}" class="flex rounded p-2 hover:bg-gray-100 dark:hover:bg-gray-600 cursor-pointer">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-5 h-5">
          {#if loc == locale}
            <path fill-rule="evenodd" d="M16.704 4.153a.75.75 0 0 1 .143 1.052l-8 10.5a.75.75 0 0 1-1.127.075l-4.5-4.5a.75.75 0 0 1 1.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 0 1 1.05-.143Z" clip-rule="evenodd" />
          {/if}
        </svg>
        <span>{loc}</span>
      </li>
    </DropdownItem>
  {/each}
</Dropdown>

