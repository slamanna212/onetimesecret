<template>
  <div
       class="relative bg-white dark:bg-gray-800 rounded-lg border border-gray-200 dark:border-gray-700 overflow-hidden">
    <!-- Secret Link Display -->
    <div class="flex items-center px-4 py-3">
      <div class="flex-grow min-w-0">
        <input ref="linkInput"
               type="text"
               readonly
               :value="metadata.share_url"
               class="w-full bg-transparent border-0 focus:ring-0 text-gray-900 dark:text-gray-100 font-mono text-sm"
               aria-label="Secret link" />
      </div>

      <div class="flex-shrink-0 ml-4 flex items-center gap-2">
        <button @click="copyToClipboard"
                class="inline-flex items-center justify-center p-2 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500"
                :class="{ 'text-green-500 dark:text-green-400': copied }">
          <Icon :icon="copied ? 'material-symbols:check' : 'material-symbols:content-copy-outline'"
                class="w-5 h-5" />
          <span class="sr-only">{{ copied ? 'Copied!' : 'Copy to clipboard' }}</span>
        </button>
      </div>
    </div>

    <!-- Security Notice -->
    <div class="bg-gray-50 dark:bg-gray-900/50 px-4 py-2 border-t border-gray-200 dark:border-gray-700">
      <div class="flex items-center text-xs text-gray-500 dark:text-gray-400">
        <Icon icon="material-symbols:shield-outline"
              class="w-4 h-4 mr-2" />
        {{ $t('web.private.share_link_securely') }}
      </div>
    </div>

    <!-- Copy Feedback Toast -->
    <div v-if="showToast"
         class="absolute top-0 right-0 mt-2 mr-2 px-3 py-1 bg-gray-900 dark:bg-gray-700 text-white text-sm rounded-md shadow-lg transform transition-all duration-300"
         :class="{ 'opacity-0 translate-y-1': !showToast, 'opacity-100 translate-y-0': showToast }">
      {{ $t('web.COMMON.copied_to_clipboard') }}
    </div>
  </div>
</template>

<script setup lang="ts">
import type { MetadataData, MetadataDetails } from '@/types/onetime';
import { Icon } from '@iconify/vue';
import { ref } from 'vue';

interface Props {
  metadata: MetadataData;
  details: MetadataDetails;
}

defineProps<Props>();

const copied = ref(false);
const showToast = ref(false);
const linkInput = ref<HTMLInputElement>();

const copyToClipboard = async () => {
  if (!linkInput.value) return;

  try {
    await navigator.clipboard.writeText(linkInput.value.value);
    copied.value = true;
    showToast.value = true;

    // Reset copy icon
    setTimeout(() => {
      copied.value = false;
    }, 2000);

    // Hide toast
    setTimeout(() => {
      showToast.value = false;
    }, 1500);

  } catch (err) {
    console.error('Failed to copy text: ', err);

    linkInput.value.select();
    document.execCommand('copy'); // fallback for older browsers
  }
};
</script>
