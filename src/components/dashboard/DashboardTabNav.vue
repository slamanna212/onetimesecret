<template>
  <nav aria-label="Dashboard Navigation"
       class="mb-6 px-4 py-2 bg-gray-50/50 dark:bg-gray-800/50"><!-- Shadow approach -->
    <ul v-if="authenticated"
        class="flex flex-wrap items-center gap-x-6 gap-y-2 max-w-7xl mx-auto font-brand"
        role="menubar">
      <!-- Home -->
      <li role="none">
        <router-link to="/dashboard"
                     role="menuitem"
                     :class="[
                      'inline-flex items-center py-2 text-lg transition-colors duration-200',
                      isActiveRoute('/dashboard')
                        ? 'text-brand-500 font-semibold border-b-2 border-brand-500'
                        : 'text-gray-700 dark:text-gray-300 hover:text-brand-500 dark:hover:text-brand-500'
                    ]">
          <svg aria-hidden="true"
               class="mr-2"
               width="20"
               height="20"
               fill="none"
               stroke="currentColor"
               viewBox="0 0 24 24">
            <path stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
          </svg>
          {{ $t('web.COMMON.title_home') }}
        </router-link>
      </li>

      <!-- Recent Secrets -->
      <li role="none">
        <router-link to="/recent"
                     role="menuitem"
                     :class="[
                      'inline-flex items-center py-2 text-lg transition-colors duration-200',
                      isActiveRoute('/recent')
                        ? 'text-brand-500 font-semibold border-b-2 border-brand-500'
                        : 'text-gray-700 dark:text-gray-300 hover:text-brand-500 dark:hover:text-brand-500'
                    ]">
          <svg aria-hidden="true"
               class="mr-2"
               width="20"
               height="20"
               fill="none"
               stroke="currentColor"
               viewBox="0 0 24 24">
            <path stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <span class="block sm:hidden">{{ $t('web.COMMON.secret') }}</span>
          <span class="hidden sm:block">{{ $t('web.COMMON.title_recent_secrets') }}</span>
          <span class="ml-2 px-2 py-0.5 text-xs font-medium rounded-full bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400"
                aria-label="Recent secrets count">
            {{ metadata_record_count }}
          </span>
        </router-link>
      </li>

      <!-- Custom Domains -->
      <li v-if="domains_enabled && planAllowsCustomDomains"
          role="none">
        <router-link to="/account/domains"
                     role="menuitem"
                     :class="[
                      'inline-flex items-center py-2 text-lg transition-colors duration-200',
                      isActiveRoute('/account/domains')
                        ? 'text-brand-500 font-semibold border-b-2 border-brand-500'
                        : 'text-gray-700 dark:text-gray-300 hover:text-brand-500 dark:hover:text-brand-500'
                    ]">
          <svg aria-hidden="true"
               class="mr-2"
               width="20"
               height="20"
               fill="none"
               stroke="currentColor"
               viewBox="0 0 24 24">
            <path stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9" />
          </svg>
          <span class="block sm:hidden">Domains</span>
          <span class="hidden sm:block">Custom Domains</span>
          <span class="ml-2 px-2 py-0.5 text-xs font-medium rounded-full bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400"
                aria-label="Custom domains count">
            {{ custom_domains_record_count }}
          </span>
        </router-link>
      </li>
    </ul>
  </nav>
</template>



<script setup lang="ts">
import { computed } from 'vue';
import { useRoute } from 'vue-router';
import { useWindowProps } from '@/composables/useWindowProps';

const { authenticated, metadata_record_count, domains_enabled, plan, custom_domains_record_count } =
  useWindowProps(['authenticated', 'metadata_record_count', 'domains_enabled', 'plan', 'custom_domains_record_count']);

const planAllowsCustomDomains = computed(() => plan.value.options?.custom_domains === true);

const route = useRoute();

const isActiveRoute = (path: string) => route.path === path;
</script>
