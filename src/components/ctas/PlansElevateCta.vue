<!-- PlansElevateCta.vue -->

<script setup lang="ts">
import { computed } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();
const pricingLink = computed(() => router.resolve({ name: 'Pricing' }).href);

</script>

<template>
  <section
           class="mb-8 bg-gradient-to-r from-brand-600 to-brand-800 dark:from-brand-800 dark:to-brand-900 rounded-lg shadow-lg p-6 text-white">
    <h4 class="text-xl font-semibold mb-2 text-white">{{ $t('web.COMMON.custom_domains_title') }}</h4>
    <p class="mb-4 text-white/90 dark:text-white/80">{{ $t('web.COMMON.custom_domains_description') }}</p>
    <a :href="pricingLink"
       class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-brand rounded-md text-brand-600 bg-white
       dark:bg-gray-800 dark:text-brand-400 hover:bg-gray-50 dark:hover:bg-gray-700
       focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500 dark:focus:ring-brand-400
       transition-colors duration-200">
      <svg class="mr-2 h-5 w-5"
           xmlns="http://www.w3.org/2000/svg"
           fill="none"
           viewBox="0 0 24 24"
           stroke="currentColor"
           aria-hidden="true"
           height="24"
           width="24">
        <path stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9" />
      </svg>
      {{ $t('web.COMMON.get_started_button') }}
      <svg class="ml-2 w-4 h-4"
           fill="none"
           stroke="currentColor"
           height="20"
           width="20"
           viewBox="0 0 24 24"
           xmlns="http://www.w3.org/2000/svg">
        <path stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M9 5l7 7-7 7"></path>
      </svg>
    </a>
  </section>
</template>
