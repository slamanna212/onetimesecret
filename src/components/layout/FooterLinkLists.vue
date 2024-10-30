<template>
  <div class="">
    <div class="grid grid-cols-2 md:grid-cols-3 gap-8 mb-8 py-6 pl-4 sm:pl-8 md:pl-16">

      <!-- Resources links -->
      <div class="space-y-4">
        <h3 class="font-semibold text-gray-800 dark:text-gray-200 text-xl">Resources</h3>
        <ul class="prose dark:prose-invert font-brand space-y-2">
          <li>
            <a href="https://github.com/onetimesecret/onetimesecret"
              class="text-gray-600 dark:text-gray-400 hover:text-brand-500 dark:hover:text-brand-400 transition-colors duration-300 text-xl md:text-lg"
              aria-label="View our source code on GitHub"
              target="_blank"
              rel="noopener noreferrer">GitHub</a>
          </li>
          <li v-if="supportHost">
            <a :href="`${supportHost}/docs`"
              aria-label="Access our documentation"
              class="text-gray-600 dark:text-gray-400 hover:text-brand-500 dark:hover:text-brand-400 transition-colors duration-300 text-xl md:text-lg"
              target="_blank"
              rel="noopener noreferrer">Docs</a>
          </li>
          <li v-if="supportHost">
            <a :href="`${supportHost}/docs/rest-api`"
              aria-label="Explore our API documentation"
              class="text-gray-600 dark:text-gray-400 hover:text-brand-500 dark:hover:text-brand-400 transition-colors duration-300 text-xl md:text-lg"
              target="_blank"
              rel="noopener noreferrer">API</a>
          </li>
        </ul>
      </div>

    </div>

    <!-- Border separator element -->
    <div class="border-t border-gray-200 dark:border-gray-700 my-2"></div>
  </div>
</template>

<script setup lang="ts">
import type { Props as DefaultProps } from '@/layouts/DefaultLayout.vue';
// Define the props for this layout, extending the DefaultLayout props
export interface Props extends DefaultProps {
  displayLinks?: boolean
  displayVersion?: boolean
  displayToggles?: boolean
}

withDefaults(defineProps<Props>(), {
  displayLinks: true,
  displayVersion: true,
  displayToggles: true,
});
</script>
