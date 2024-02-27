<script>
export let viewData;
</script>

<div class="flex flex-col">
  <div class="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
    <div class="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
      <div class="shadow bg-black/20 backdrop-blur-md overflow-hidden sm:rounded-lg">
        <table class="examples min-w-full border-0">
          <tbody class="divide-y divide-white/5">
            {#each viewData.examples as example}
              <tr class="example-row">
                <td class="px-6 py-4 whitespace-nowrap text-lg font-medium text-white/80">
                  <div>
                    {example.value}
                  </div>
                  <div class="md:hidden pre mt-1 bg-black/50 rounded-md px-4 py-1 text-white">
                    {example.format}
                  </div>
                </td>
                <td class="hidden md:block px-6 py-4 whitespace-nowrap text-lg">
                  <pre class="bg-black/50 rounded-md px-4 py-1 text-white">{example.format}</pre>
                </td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

