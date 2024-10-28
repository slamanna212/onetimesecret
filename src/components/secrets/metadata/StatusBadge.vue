<template>
  <span
    class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
    :class="statusClasses"
  >
    <Icon :icon="statusIcon" class="w-4 h-4 mr-1" />
    {{ statusText }}
  </span>
</template>

<script setup lang="ts">
import { Icon } from '@iconify/vue';

interface Props {
  status: 'active' | 'received' | 'burned' | 'destroyed'
}

const props = defineProps<Props>()

const statusClasses = {
  active: 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300',
  received: 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-300',
  burned: 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-300',
  destroyed: 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-300'
}[props.status]

const statusIcon = {
  active: 'material-symbols:check-circle-outline',
  received: 'material-symbols:mark-email-read-outline',
  burned: 'material-symbols:local-fire-department',
  destroyed: 'material-symbols:block'
}[props.status]

const statusText = {
  active: 'Active',
  received: 'Received',
  burned: 'Burned',
  destroyed: 'Destroyed'
}[props.status]
</script>
