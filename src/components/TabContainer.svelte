<script>
  import Examples from "./Examples.svelte";
  import Reference from "./Reference.svelte";

  export let viewData;

  const tabs = [
    {
      route: "#examples",
      title: "Examples",
      content: Examples
    },
    {
      route: "#reference",
      title: "Reference",
      content: Reference
    },
    {
      route: "#best-practices",
      title: "Best Practices",
      content: Examples
    },
    {
      route: "#about",
      title: "About this site",
      content: Examples
    },
  ];

  let selectedTab = tabs[0];

  window.addEventListener("hashchange", () => {
    const href = window.location.href;
    let tabRoute = href.substring(href.indexOf("#", null));
    let tab = tabs.find((t) => t.route == tabRoute);
    if (tab === undefined) {
      tab = tabs[0];
    }
    console.log("Setting tab to ", tab.route);
    selectedTab = tab;
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
    {#each tabs as tab}
      {#if selectedTab == tab}
        <section class="{tab.route.substring(1, null)}">
          <svelte:component this={tab.content} viewData={viewData} />
        </section>
      {/if}
    {/each}
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
