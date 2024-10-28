<template>
  <div v-if="!details.is_destroyed"
       class="flex flex-col items-center">
    <router-link :to="{ name: 'Burn secret', params: { metadataKey: metadata.key } }"
                 class="
        w-full px-4 py-3
        inline-flex items-center justify-center gap-2
        text-base font-medium text-gray-800
        bg-yellow-400 hover:bg-yellow-300
        dark:text-gray-900 dark:hover:bg-yellow-300
        rounded-lg
        transition-colors duration-200
        focus:outline-none focus:ring-2 focus:ring-yellow-400 focus:ring-offset-2
        dark:focus:ring-offset-gray-800
      "
                 :aria-label="$t('web.COMMON.burn_this_secret_aria')">
      <Icon icon="heroicons:fire-20-solid"
            class="w-5 h-5"
            aria-hidden="true" />
      <span>{{ $t('web.COMMON.burn_this_secret') }}</span>
    </router-link>

    <p class="mt-2 text-sm text-gray-500 dark:text-gray-400"
       role="note">
      * {{ $t('web.COMMON.burn_this_secret_hint') }}
    </p>

    <div class="w-full mt-6 flex items-center gap-4"
         role="separator"
         aria-hidden="true">
      <div class="flex-grow h-px bg-gray-200 dark:bg-gray-700"></div>
      <Icon icon="heroicons:lock-closed"
            class="w-4 h-4 text-gray-400 dark:text-gray-600" />
      <div class="flex-grow h-px bg-gray-200 dark:bg-gray-700"></div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { MetadataData, MetadataDetails } from '@/types/onetime';
import { Icon } from '@iconify/vue';

interface Props {
  metadata: MetadataData;
  details: MetadataDetails;
}

defineProps<Props>();
</script>

<script lang="ts">
// Component documentation
export default {
  name: 'BurnButtonForm',
  inheritAttrs: false
};
</script>
