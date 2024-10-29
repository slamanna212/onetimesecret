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
      <header
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

      <!-- Status & Timeline -->
      <section v-if="!details.show_secret_link" class="bg-gray-50 dark:bg-gray-800 rounded-lg p-4"
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
      </section>

      <!-- Actions -->
      <section v-if="!details.show_secret_link"
               class="flex flex-col gap-3"
               aria-labelledby="section-actions">
        <h2 id="section-actions"
            class="sr-only">
          {{ t('web.COMMON.actions') }}
        </h2>

        <BurnButtonForm :metadata="record"
                        :details="details"
                        @secret-burned="handleSecretBurned"
                        @update-details="newDetails => details = newDetails" />

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
import StatusBadge from '@/components/secrets/metadata/StatusBadge.vue';
import StatusBar from '@/components/StatusBar.vue';
import TimelineDisplay from '@/components/secrets/metadata/TimelineDisplay.vue';

import BurnButtonForm from '@/components/secrets/metadata/BurnButtonForm.vue';
import MetadataFAQ from '@/components/secrets/metadata/MetadataFAQ.vue';
import SecretLink from '@/components/secrets/metadata/SecretLink.vue';
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
  fetchData: fetchMetadata,
  updateRecord
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

const handleSecretBurned = (updatedRecord: MetadataData) => {
  // Use updateRecord instead of trying to modify record directly
  updateRecord(updatedRecord);
  if (details.value) {
    details.value = {
      ...details.value,
      is_burned: true
    };
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
