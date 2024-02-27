<script>
  import Footer from './components/Footer.svelte'
  import Analytics from './components/Analytics.svelte'
  import Header from './components/Header.svelte'
  import DateForm from './components/DateForm.svelte';
  import TabContainer from './components/TabContainer.svelte';
  import Examples from './components/Examples.svelte';
  import Reference from './components/Reference.svelte';
  import BestPractices from './components/BestPractices.svelte';
  import About from './components/About.svelte';

  import {initialData, fetchData} from './viewData.js';

  let viewData = initialData;
  fetchData().then((x) => viewData = x);

  const tabs = [
    { title: "Examples", route: "#examples"},
    { title: "Reference", route: "#reference"},
    { title: "Best Practices", route: "#best-practices" },
    { title: "About this site", route: "#about" },
  ]

</script>

<main>
  <div class="mx-auto max-w-6xl px-0 sm:px-10 py-10 md:py-20">
    <Header />
    <DateForm viewData={viewData} />
    <TabContainer {tabs} let:selectedTab>
      <h1> selected tab is {selectedTab.route}</h1>
      {#if selectedTab.route == "#examples"}
        <Examples {viewData} />
      {/if}
      {#if selectedTab.route == "#reference"}
        <Reference />
      {/if}
      {#if selectedTab.route == "#best-practices"}
        <BestPractices />
      {/if}
      {#if selectedTab.route == "#about"}
        <About />
      {/if}
    </TabContainer>
    
    <Footer />
    <Analytics />
  </div>
</main>

