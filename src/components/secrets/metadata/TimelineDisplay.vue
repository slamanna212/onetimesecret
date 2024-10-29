<template>
  <div class="relative pt-4">
    <!-- Timeline Track -->
    <div class="absolute top-8 left-6 h-full w-px bg-gray-200 dark:bg-gray-700" />

    <!-- Timeline Events -->
    <div class="space-y-6">
      <!-- Created -->
      <div class="group flex gap-4">
        <div class="
          flex-shrink-0 w-12 h-12
          flex items-center justify-center
          rounded-full
          bg-brand-100 dark:bg-brand-900
          transition-transform duration-200
          group-hover:scale-110">
          <Icon
            icon="material-symbols:schedule-outline"
            class="w-6 h-6 text-brand-600 dark:text-brand-400"
            aria-hidden="true"
          />
        </div>
        <div class="group-hover:translate-x-1 transition-transform duration-200">
          <p class="text-sm font-medium text-gray-900 dark:text-gray-100">
            {{ $t('web.COMMON.created') }}
          </p>
          <time :datetime="metadata.created_date_utc"
                class="text-sm text-gray-500 dark:text-gray-400">
            {{ metadata.created_date_utc }}
          </time>
        </div>
      </div>

      <!-- Received (if applicable) -->
      <div v-if="details.is_received" class="group flex gap-4">
        <div class="
          flex-shrink-0 w-12 h-12
          flex items-center justify-center
          rounded-full
          bg-green-100 dark:bg-green-900
          transition-transform duration-200
          group-hover:scale-110">
          <Icon
            icon="material-symbols:mark-email-read-outline"
            class="w-6 h-6 text-green-600 dark:text-green-400"
            aria-hidden="true"
          />
        </div>
        <div class="group-hover:translate-x-1 transition-transform duration-200">
          <p class="text-sm font-medium text-gray-900 dark:text-gray-100">
            {{ $t('web.COMMON.received') }}
          </p>
          <time :datetime="details.received_date_utc"
                class="text-sm text-gray-500 dark:text-gray-400">
            {{ details.received_date_utc }}
          </time>
          <p v-if="receivedTimeAgo" class="text-xs text-gray-400 dark:text-gray-500 mt-0.5">
            {{ receivedTimeAgo }}
          </p>
        </div>
      </div>

      <!-- Burned (if applicable) -->
      <div v-if="details.is_burned" class="group flex gap-4">
        <div class="
          flex-shrink-0 w-12 h-12
          flex items-center justify-center
          rounded-full
          bg-yellow-100 dark:bg-yellow-900
          transition-transform duration-200
          group-hover:scale-110">
          <Icon
            icon="material-symbols:local-fire-department"
            class="w-6 h-6 text-yellow-600 dark:text-yellow-400"
            aria-hidden="true"
          />
        </div>
        <div class="group-hover:translate-x-1 transition-transform duration-200">
          <p class="text-sm font-medium text-gray-900 dark:text-gray-100">
            {{ $t('web.COMMON.burned') }}
          </p>
          <time :datetime="details.burned_date_utc"
                class="text-sm text-gray-500 dark:text-gray-400">
            {{ details.burned_date_utc }}
          </time>
          <p v-if="burnedTimeAgo" class="text-xs text-gray-400 dark:text-gray-500 mt-0.5">
            {{ burnedTimeAgo }}
          </p>
        </div>
      </div>

      <!-- Expiration -->
      <div class="group flex gap-4">
        <div class="
          flex-shrink-0 w-12 h-12
          flex items-center justify-center
          rounded-full
          bg-red-100 dark:bg-red-900
          transition-transform duration-200
          group-hover:scale-110">
          <Icon
            icon="material-symbols:timer-outline"
            class="w-6 h-6 text-red-600 dark:text-red-400"
            aria-hidden="true"
          />
        </div>
        <div class="flex-grow group-hover:translate-x-1 transition-transform duration-200">
          <p class="text-sm font-medium text-gray-900 dark:text-gray-100">
            {{ $t('web.COMMON.expires') }}
          </p>
          <time :datetime="metadata.expiration_stamp"
                class="text-sm text-gray-500 dark:text-gray-400">
            {{ metadata.expiration_stamp }}
          </time>

        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { MetadataData, MetadataDetails } from '@/types/onetime';
import { Icon } from '@iconify/vue';
import { computed, onMounted, onUnmounted, ref } from 'vue';

interface Props {
  metadata: MetadataData;
  details: MetadataDetails;
}

const props = defineProps<Props>();

// Calculate time ago for events
const calculateTimeAgo = (dateStr: string) => {
  const date = new Date(dateStr);
  const now = new Date();
  const seconds = Math.floor((now.getTime() - date.getTime()) / 1000);

  if (seconds < 60) return 'just now';
  const minutes = Math.floor(seconds / 60);
  if (minutes < 60) return `${minutes}m ago`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `${hours}h ago`;
  const days = Math.floor(hours / 24);
  return `${days}d ago`;
};

// Reactive time ago values
const receivedTimeAgo = computed(() => {
  if (!props.details.received_date_utc) return '';
  return calculateTimeAgo(props.details.received_date_utc);
});

const burnedTimeAgo = computed(() => {
  if (!props.details.burned_date_utc) return '';
  return calculateTimeAgo(props.details.burned_date_utc);
});

const timeRemaining = ref('');
const expirationProgress = ref(0);

const updateExpirationInfo = () => {
  const now = new Date().getTime();
  const created = new Date(props.metadata.created_date_utc).getTime();
  const expiration = created + (props.metadata.expiration || 0) * 1000;
  const totalDuration = expiration - created;
  const elapsed = now - created;
  const remaining = expiration - now;

  // Update progress
  expirationProgress.value = Math.min(100, Math.round((elapsed / totalDuration) * 100));

  // Update time remaining text
  if (remaining <= 0) {
    timeRemaining.value = 'Expired';
    return;
  }

  const hours = Math.floor(remaining / (1000 * 60 * 60));
  const minutes = Math.floor((remaining % (1000 * 60 * 60)) / (1000 * 60));

  if (hours > 24) {
    const days = Math.floor(hours / 24);
    timeRemaining.value = `${days} days remaining`;
  } else if (hours > 0) {
    timeRemaining.value = `${hours}h ${minutes}m remaining`;
  } else {
    timeRemaining.value = `${minutes}m remaining`;
  }
};

// Update expiration info every minute
let updateInterval: number;

onMounted(() => {
  updateExpirationInfo();
  updateInterval = window.setInterval(updateExpirationInfo, 60000);
});

onUnmounted(() => {
  if (updateInterval) {
    clearInterval(updateInterval);
  }
});
</script>
