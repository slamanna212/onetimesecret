<template>
  <div class="
    relative overflow-hidden
    rounded-lg border
    bg-white
    dark:bg-gray-800 dark:border-gray-700
    border-gray-200">
    <!-- Enhanced Security Indicator -->
    <div class="absolute top-0 left-0 w-full h-1.5 flex">
      <div class="flex-1 bg-green-500"></div>
      <div v-if="details.has_passphrase" class="flex-1 bg-amber-500"></div>
      <div v-if="details.has_maxviews" class="flex-1 bg-blue-500"></div>
    </div>

    <!-- Secret Link Display -->
    <div class="flex items-center px-4 py-3">
      <div class="flex-grow min-w-0">
        <!-- Enhanced Status Display -->
        <div class="flex items-center gap-3 mb-2">
          <div class="flex items-center gap-2 text-sm text-green-600 dark:text-green-400">
            <Icon icon="mdi:check-circle"
                  class="w-4 h-4"
                  aria-hidden="true" />
            <span>{{ $t('web.private.secret_created') }}</span>
          </div>
          <div class="flex items-center gap-1 text-sm text-blue-600 dark:text-blue-400">
            <Icon icon="material-symbols:timer-outline"
                  class="w-4 h-4"
                  aria-hidden="true" />
            <span>{{ $t('web.secrets.expiresIn', { duration: metadata.expiration_stamp }) }}</span>
          </div>
        </div>

        <textarea ref="linkInput"
                  readonly
                  :value="metadata.share_url"
                  :class="details.show_secret_link ? 'inline' : 'blur-sm'"
                  class="
            w-full
            bg-transparent border-0
            text-gray-900 font-mono text-sm sm:text-base
            dark:text-gray-100
            focus:ring-0 hover:ring-0 hover:blur-0
            resize-none
          "
                  aria-label="Secret link" />
      </div>

      <div class="flex items-center gap-2">
        <!-- Encryption Status Icon -->
        <div class="flex-shrink-0">
          <div class="p-1.5 rounded-full bg-blue-100 dark:bg-blue-900">
            <Icon icon="mdi:lock-check"
                  class="w-4 h-4 text-blue-600 dark:text-blue-400"
                  aria-hidden="true" />
          </div>
        </div>

        <!-- Copy Button -->
        <button @click="copyToClipboard"
                class="inline-flex items-center justify-center p-2 rounded-md
                 text-gray-500 dark:text-gray-400
                 hover:text-gray-700 dark:hover:text-gray-200
                 hover:bg-gray-100 dark:hover:bg-gray-700
                 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500
                 transition-colors duration-150"
                :class="{ 'text-green-500 dark:text-green-400': copied }">
          <Icon :icon="copied ? 'material-symbols:check' : 'material-symbols:content-copy-outline'"
                class="w-5 h-5" />
          <span class="sr-only">{{ copied ? 'Copied!' : 'Copy to clipboard' }}</span>
        </button>
      </div>
    </div>

    <!-- Enhanced Security Notice -->
    <div class="bg-gray-50 dark:bg-gray-900/50 px-4 py-3 border-t border-gray-200 dark:border-gray-700">
      <div class="space-y-2">
        <div class="flex items-center text-sm text-gray-600 dark:text-gray-300">
          <Icon icon="material-symbols:shield"
                class="w-5 h-5 mr-2 text-brand-500" />
          <span class="font-medium">{{ $t('web.private.enhanced_security') }}</span>
        </div>
        <div class="text-xs text-gray-500 dark:text-gray-400 pl-7">
          <ul class="space-y-1">
            <li class="flex items-center gap-1">
              <Icon icon="mdi:lock-check"
                    class="w-3.5 h-3.5 text-green-500" />
              {{ $t('web.COMMON.encrypted_in_transit') }}
            </li>
            <li v-if="details.has_passphrase" class="flex items-center gap-1">
              <Icon icon="mdi:key"
                    class="w-3.5 h-3.5 text-amber-500" />
              {{ $t('web.COMMON.passphrase_protected') }}
            </li>
            <li v-if="metadata.share_domain" class="flex items-center gap-1">
              <Icon icon="mdi:earth"
                    class="w-3.5 h-3.5 text-brand-500" />
              {{ $t('web.COMMON.custom_domain_protected') }}
            </li>
          </ul>
        </div>
      </div>
    </div>

    <!-- Copy Feedback Toast -->
    <div v-if="showToast"
         class="absolute top-3 right-3 px-3 py-1.5
             bg-gray-900 dark:bg-gray-700
             text-white text-sm
             rounded-md shadow-lg
             transform transition-all duration-300"
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
