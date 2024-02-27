<script>
    import { onDestroy, onMount } from "svelte";

  export let tabs;
  let selectedTab = tabs[0];

  function onHashChange() {
    const href = window.location.href;
    let tabRoute = href.substring(href.indexOf("#", null));
    let tab = tabs.find((t) => t.route == tabRoute);
    if (tab === undefined) {
      tab = tabs[0];
    }
    selectedTab = tab;
  }

  onMount(() => {
    window.addEventListener("hashchange", onHashChange);
    onHashChange();
    onDestroy(() => {
      window.removeEventListener("hashchange", onHashChange);
    })
  });
</script>

<section class="mt-10 my-6">
  <div class="sm:hidden px-2">
    <label for="tabs" class="sr-only">Select a tab</label>
    <select bind:value={selectedTab} class="block text-gray-800 w-full focus:ring-indigo-500 focus:border-indigo-500 border-gray-300 rounded-md">
      {#each tabs as tab}
        <option 
          value={tab}
          data-target="{tab.route}">
          {tab.title}
        </option>
      {/each}
    </select>
  </div>

  <div class="hidden sm:block">
    <nav class="flex space-x-4" aria-label="Tabs">
      {#each tabs as tab}
        <a href={tab.route} class={"nav-tab" + (selectedTab == tab ? " selected" : "")}>
          {tab.title}
        </a>
      {/each}
    </nav>
  </div>

  <div class="tab-container my-4">
    <slot {selectedTab} />
  </div>
</section>

<style>
  .nav-tab {
    @apply transition select-none text-white/50 hover:text-white hover:bg-black/10 hover:backdrop-blur-md px-3 py-2 font-medium text-sm rounded-md
  }
  .selected {
    @apply transition text-white backdrop-blur-md bg-black/30;
  }
</style>
