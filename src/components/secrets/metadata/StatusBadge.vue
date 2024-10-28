<template>
  <span
    class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium transition-all duration-200 hover:scale-105"
    :class="[statusClasses, { 'animate-pulse': isExpiringSoon }]"
    :title="statusDescription"
    role="status"
  >
    <Icon :icon="statusIcon" class="w-4 h-4 mr-1" :class="{ 'animate-spin-slow': isProcessing }" />
    {{ statusText }}
  </span>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { Icon } from '@iconify/vue';
import { useI18n } from 'vue-i18n';

type StatusType = 'active' | 'received' | 'burned' | 'destroyed' | 'expiring-soon' | 'processing';

interface Props {
  status: StatusType;
  expiresIn?: number; // Time in seconds until expiration
}

const props = defineProps<Props>();
const { t } = useI18n();

const isExpiringSoon = computed(() => {
  if (!props.expiresIn) return false;
  // Consider "expiring soon" if less than 1 hour remains
  return props.expiresIn < 3600;
});

const isProcessing = computed(() => props.status === 'processing');

const statusClasses = computed(() => ({
  'active': 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300',
  'received': 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-300',
  'burned': 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-300',
  'destroyed': 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-300',
  'expiring-soon': 'bg-orange-100 text-orange-800 dark:bg-orange-900 dark:text-orange-300',
  'processing': 'bg-purple-100 text-purple-800 dark:bg-purple-900 dark:text-purple-300'
}[props.status]));

const statusIcon = computed(() => ({
  'active': 'material-symbols:check-circle-outline',
  'received': 'material-symbols:mark-email-read-outline',
  'burned': 'material-symbols:local-fire-department',
  'destroyed': 'material-symbols:block',
  'expiring-soon': 'material-symbols:timer-outline',
  'processing': 'material-symbols:refresh'
}[props.status]));

const statusText = computed(() => ({
  'active': t('web.STATUS.active'),
  'received': t('web.STATUS.received'),
  'burned': t('web.STATUS.burned'),
  'destroyed': t('web.STATUS.destroyed'),
  'expiring-soon': t('web.STATUS.expiring_soon'),
  'processing': t('web.STATUS.processing')
}[props.status]));

const statusDescription = computed(() => ({
  'active': t('web.STATUS.active_description'),
  'received': t('web.STATUS.received_description'),
  'burned': t('web.STATUS.burned_description'),
  'destroyed': t('web.STATUS.destroyed_description'),
  'expiring-soon': t('web.STATUS.expiring_soon_description'),
  'processing': t('web.STATUS.processing_description')
}[props.status]));
</script>

<style scoped>
.animate-spin-slow {
  animation: spin 2s linear infinite;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

/* Ensure high contrast in dark mode */
:deep(.dark) .text-green-800 { color: rgb(22, 101, 52); }
:deep(.dark) .text-blue-800 { color: rgb(30, 64, 175); }
:deep(.dark) .text-yellow-800 { color: rgb(133, 77, 14); }
:deep(.dark) .text-red-800 { color: rgb(153, 27, 27); }
:deep(.dark) .text-orange-800 { color: rgb(154, 52, 18); }
:deep(.dark) .text-purple-800 { color: rgb(107, 33, 168); }
</style>
