<template>
  <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6" :aria-label="title">
    <h2 class="text-xl font-semibold text-gray-800 dark:text-white mb-4">{{ title }}</h2>
    <div v-if="isLoading" class="animate-pulse space-y-4">
      <div v-for="i in 3" :key="i" class="h-10 bg-gray-200 dark:bg-gray-700 rounded"></div>
    </div>
    <div v-else-if="hasItems && items && items.length > 0" class="space-y-2">
      <div v-for="item in items" :key="item.identifier"
           class="flex items-center justify-between p-2 bg-gray-50 dark:bg-gray-700 rounded-md hover:bg-gray-100 dark:hover:bg-gray-600 transition duration-300 ease-in-out">
        <span class="text-gray-800 dark:text-gray-200 truncate">{{ item.identifier }}</span>
        <div class="flex items-center space-x-2">
          <span class="text-sm text-gray-500 dark:text-gray-400">{{ formatDate(item.created) }}</span>
          <button class="text-brand-500 hover:text-brand-600 focus:outline-none focus:ring-2 focus:ring-brand-500 rounded-full p-1"
                  aria-label="View secret details">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
              <path d="M10 12a2 2 0 100-4 2 2 0 000 4z" />
              <path fill-rule="evenodd" d="M.458 10C1.732 5.943 5.522 3 10 3s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7S1.732 14.057.458 10zM14 10a4 4 0 11-8 0 4 4 0 018 0z" clip-rule="evenodd" />
            </svg>
          </button>
        </div>
      </div>
    </div>
    <p v-else class="text-gray-600 dark:text-gray-400 italic">
      No {{ title.toLowerCase() }} secrets.
    </p>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { Metadata } from '@/types/onetime';

interface Props {
  hasItems?: boolean;
  notReceived?: Metadata[];
  received?: Metadata[];
  isLoading: boolean;
  title: string;
}

const props = defineProps<Props>();

const items = computed(() => {
  return props.title === 'Received' ? props.received : props.notReceived;
});

/**
 * Formats an epoch integer (as string or number) to a locale date string.
 * @param epoch - The epoch integer to format, can be a string or number.
 * @returns The formatted date string.
 */
const formatDate = (epoch: string | number): string => {
  const epochNumber = typeof epoch === 'string' ? parseInt(epoch, 10) : epoch;
  return new Date(epochNumber * 1000).toLocaleDateString();
};
</script>
