<template>
  <main class="max-w-2xl mx-auto px-4 py-6"
        role="main"
        :aria-busy="isLoading">
    <StatusBar :success="success"
               :error="error"
               :loading="isLoading"
               :auto-dismiss="true" />

    <!-- Loading State -->
    <div v-if="isLoading"
         class="flex justify-center py-8"
         role="status"
         aria-label="Loading secret details">
      <Icon icon="mdi:loading"
            class="w-8 h-8 text-brand-500 animate-spin"
            aria-hidden="true" />
      <span class="sr-only">{{ t('web.COMMON.loading') }}</span>
    </div>

    <!-- Content State -->
    <div v-else-if="record && details"
         class="space-y-8">
      <!-- Secret Link Header -->
      <header v-if="details.show_secret_link"
              class="animate-fade-in relative"
              aria-labelledby="secret-header">
        <h1 id="secret-header"
            class="sr-only">
          {{ t('web.COMMON.secret_link') }}
        </h1>

        <!-- Passphrase Indicator -->
        <div v-if="details.has_passphrase"
             class="absolute -top-4 right-2 flex items-center gap-2 text-sm text-amber-600 dark:text-amber-400">
          <Icon icon="mdi:lock"
                class="w-4 h-4"
                aria-hidden="true" />
          {{ t('web.COMMON.passphrase_protected') }}
        </div>

        <SecretLink :metadata="record"
                    :details="details"
                    class="focus-within:ring-2 focus-within:ring-brand-500 rounded-lg" />
      </header>

      <!-- Security Details Section -->
      <section class="bg-gray-50 dark:bg-gray-800 rounded-lg p-4 space-y-4"
               aria-labelledby="section-security">
        <h2 id="section-security"
            class="text-sm font-medium text-gray-700 dark:text-gray-300">
          {{ t('web.COMMON.security_details') }}
        </h2>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <!-- Encryption Status -->
          <div class="flex items-center gap-2">
            <Icon icon="mdi:shield-lock"
                  class="w-5 h-5 text-green-500"
                  aria-hidden="true" />
            <span class="text-sm text-gray-600 dark:text-gray-400">
              {{ t('web.COMMON.encrypted_in_transit') }}
            </span>
          </div>

          <!-- Passphrase Protection -->
          <div class="flex items-center gap-2">
            <Icon :icon="details.has_passphrase ? 'mdi:lock' : 'mdi:lock-open'"
                  :class="[
                    'w-5 h-5',
                    details.has_passphrase ? 'text-amber-500' : 'text-gray-400'
                  ]"
                  aria-hidden="true" />
            <span class="text-sm text-gray-600 dark:text-gray-400">
              {{ details.has_passphrase
                ? t('web.COMMON.passphrase_protected')
                : t('web.COMMON.no_passphrase') }}
            </span>
          </div>

          <!-- View Limit -->
          <div class="flex items-center gap-2">
            <Icon icon="mdi:eye"
                  class="w-5 h-5 text-blue-500"
                  aria-hidden="true" />
            <span class="text-sm text-gray-600 dark:text-gray-400">
              {{ details.has_maxviews
                ? t('web.COMMON.limited_views', { count: details.maxviews })
                : t('web.COMMON.unlimited_views') }}
            </span>
          </div>

          <!-- Recipients -->
          <div v-if="record.recipients?.length > 0"
               class="flex items-center gap-2">
            <Icon icon="mdi:account-multiple"
                  class="w-5 h-5 text-purple-500"
                  aria-hidden="true" />
            <span class="text-sm text-gray-600 dark:text-gray-400">
              {{ t('web.COMMON.recipients_count', { count: record.recipients.length }) }}
            </span>
          </div>
        </div>
      </section>

      <!-- Status & Timeline -->
      <section class="bg-gray-50 dark:bg-gray-800 rounded-lg p-4"
               aria-labelledby="section-status">
        <div class="flex items-center justify-between mb-2">
          <h2 id="section-status"
              class="text-sm font-medium text-gray-700 dark:text-gray-300">
            {{ t('web.COMMON.secret_status') }}
          </h2>
          <StatusBadge :status="secretStatus" />
        </div>

        <TimelineDisplay :metadata="record"
                         :details="details" />

        <!-- Expiration Countdown -->
        <div v-if="!details.is_destroyed && !details.is_burned"
             class="mt-4 p-3 bg-gray-100 dark:bg-gray-700 rounded-lg">
          <div class="flex items-center justify-between">
            <span class="text-sm text-gray-600 dark:text-gray-400">
              {{ t('web.COMMON.time_remaining') }}
            </span>
            <span class="text-sm font-medium text-gray-900 dark:text-gray-100">
              {{ timeRemaining }}
            </span>
          </div>
          <div class="mt-2 w-full bg-gray-200 dark:bg-gray-600 rounded-full h-2">
            <div class="bg-brand-500 h-2 rounded-full"
                 :style="{ width: `${expirationProgress}%` }"
                 role="progressbar"
                 :aria-valuenow="expirationProgress"
                 aria-valuemin="0"
                 aria-valuemax="100" />
          </div>
        </div>
      </section>

      <!-- Sharing Instructions -->
      <section class="bg-gray-50 dark:bg-gray-800 rounded-lg p-4 space-y-3"
               aria-labelledby="section-sharing">
        <h2 id="section-sharing"
            class="text-sm font-medium text-gray-700 dark:text-gray-300">
          {{ t('web.COMMON.sharing_instructions') }}
        </h2>

        <ul class="space-y-2 text-sm text-gray-600 dark:text-gray-400">
          <li class="flex items-start gap-2">
            <Icon icon="mdi:link"
                  class="w-5 h-5 mt-0.5 text-brand-500"
                  aria-hidden="true" />
            {{ t('web.COMMON.share_link_instruction') }}
          </li>
          <li v-if="details.has_passphrase"
              class="flex items-start gap-2">
            <Icon icon="mdi:key"
                  class="w-5 h-5 mt-0.5 text-amber-500"
                  aria-hidden="true" />
            {{ t('web.COMMON.share_passphrase_instruction') }}
          </li>
          <li class="flex items-start gap-2">
            <Icon icon="mdi:shield-alert"
                  class="w-5 h-5 mt-0.5 text-red-500"
                  aria-hidden="true" />
            {{ t('web.COMMON.secure_channel_instruction') }}
          </li>
        </ul>
      </section>

      <!-- Actions -->
      <section class="flex flex-col gap-3"
               aria-labelledby="section-actions">
        <h2 id="section-actions"
            class="sr-only">
          {{ t('web.COMMON.actions') }}
        </h2>

        <BurnButtonForm v-if="!details.is_destroyed"
                        :metadata="record"
                        :details="details"
                        class="w-full" />

        <button type="button"
                @click="handleCreateNew"
                class="inline-flex items-center justify-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 dark:bg-gray-800 dark:text-gray-200 dark:border-gray-600 dark:hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500 dark:focus:ring-offset-gray-900">
          {{ t('web.COMMON.create_new_secret') }}
        </button>
      </section>

      <!-- Help Section -->
      <section aria-labelledby="section-help">
        <h2 id="section-help"
            class="sr-only">
          {{ t('web.COMMON.help_section') }}
        </h2>

        <button type="button"
                @click="toggleHelp"
                class="text-sm text-gray-500 hover:text-gray-700 dark:hover:text-gray-300 flex items-center gap-2 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500 rounded-md p-1">
          <Icon icon="mdi:information"
                class="w-5 h-5"
                aria-hidden="true" />
          <span>{{ t('web.COMMON.need_help') }}</span>
        </button>

        <MetadataFAQ v-if="showHelp"
                     :metadata="record"
                     :details="details"
                     class="animate-fade-in mt-4" />
      </section>
    </div>
  </main>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, onUnmounted } from 'vue';
import { useRouter } from 'vue-router';
import { useI18n } from 'vue-i18n';
import { Icon } from '@iconify/vue';

import StatusBar from '@/components/StatusBar.vue';
import BurnButtonForm from '@/components/secrets/metadata/BurnButtonForm.vue';
import MetadataFAQ from '@/components/secrets/metadata/MetadataFAQ.vue';
import SecretLink from '@/components/secrets/metadata/SecretLink.vue';
import StatusBadge from '@/components/secrets/metadata/StatusBadge.vue';
import TimelineDisplay from '@/components/secrets/metadata/TimelineDisplay.vue';
import { useFetchDataRecord } from '@/composables/useFetchData';
import type { MetadataData } from '@/types/onetime';

interface Props {
  metadataKey: string;
}

const props = defineProps<Props>();
const router = useRouter();
const showHelp = ref(false);
const { t } = useI18n();

const {
  record,
  details,
  isLoading,
  success,
  error,
  fetchData: fetchMetadata
} = useFetchDataRecord<MetadataData>({
  url: `/api/v2/private/${props.metadataKey}`,
});

const secretStatus = computed(() => {
  if (!details.value) return 'active';

  if (details.value.is_destroyed) return 'destroyed';
  if (details.value.is_burned) return 'burned';
  if (details.value.is_received) return 'received';
  return 'active';
});

// Expiration countdown
const timeRemaining = ref('');
const expirationProgress = ref(0);

const updateTimeRemaining = () => {
  if (!record.value || !details.value) return;

  const now = new Date().getTime();
  // Use created_date_utc and expiration for calculations
  const expiration = new Date(record.value.created_date_utc).getTime() + (record.value.expiration || 0) * 1000;
  const created = new Date(record.value.created_date_utc).getTime();
  const totalDuration = expiration - created;
  const remaining = expiration - now;

  if (remaining <= 0) {
    timeRemaining.value = t('web.COMMON.expired');
    expirationProgress.value = 100;
    return;
  }

  // Calculate progress
  expirationProgress.value = 100 - Math.round((remaining / totalDuration) * 100);

  // Format remaining time
  const hours = Math.floor(remaining / (1000 * 60 * 60));
  const minutes = Math.floor((remaining % (1000 * 60 * 60)) / (1000 * 60));

  if (hours > 24) {
    const days = Math.floor(hours / 24);
    timeRemaining.value = t('web.COMMON.days_remaining', { count: days });
  } else if (hours > 0) {
    timeRemaining.value = t('web.COMMON.hours_remaining', { count: hours });
  } else {
    timeRemaining.value = t('web.COMMON.minutes_remaining', { count: minutes });
  }
};

// Update countdown every minute
let countdownInterval: number;

onMounted(() => {
  fetchMetadata();
  updateTimeRemaining();
  countdownInterval = window.setInterval(updateTimeRemaining, 60000);
});

onUnmounted(() => {
  if (countdownInterval) {
    clearInterval(countdownInterval);
  }
});

const toggleHelp = () => {
  showHelp.value = !showHelp.value;
};

const handleCreateNew = () => {
  router.push('/');
};
</script>

<style scoped>
.animate-fade-in {
  animation: fadeIn 0.3s ease-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
