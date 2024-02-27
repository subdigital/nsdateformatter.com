<script>
  import Footer from './components/Footer.svelte'
  import Analytics from './components/Analytics.svelte'
  import Header from './components/Header.svelte'
  import DateForm from './components/DateForm.svelte';
  import TabContainer from './components/TabContainer.svelte';
  import {initialData, fetchData} from './viewData.js';

  let viewData = initialData;
  fetchData().then((x) => viewData = x);

</script>

<main>
  <div class="mx-auto max-w-6xl px-0 sm:px-10 py-10 md:py-20">
    <Header />
    <DateForm viewData={viewData} />
    <TabContainer viewData={viewData} />
    <Footer />
    <Analytics />
  </div>
</main>

