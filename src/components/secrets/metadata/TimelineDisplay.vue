<template>
  <div class="relative pt-4">
    <!-- Timeline Track -->
    <div class="absolute top-8 left-6 h-full w-px bg-gray-200 dark:bg-gray-700" />

    <!-- Timeline Events -->
    <div class="space-y-6">
      <!-- Created -->
      <div class="flex gap-4">
        <div class="flex-shrink-0 w-12 h-12 flex items-center justify-center rounded-full bg-brand-100 dark:bg-brand-900">
          <Icon
            icon="material-symbols:schedule-outline"
            class="w-6 h-6 text-brand-600 dark:text-brand-400"
            aria-hidden="true"
          />
        </div>
        <div>
          <p class="text-sm font-medium text-gray-900 dark:text-gray-100">
            {{ $t('web.COMMON.created') }}
          </p>
          <time :datetime="metadata.created_date_utc" class="text-sm text-gray-500 dark:text-gray-400">
            {{ metadata.created_date }}
          </time>
        </div>
      </div>

      <!-- View Count (if applicable) -->
      <div v-if="details.view_count > 0" class="flex gap-4">
        <div class="flex-shrink-0 w-12 h-12 flex items-center justify-center rounded-full bg-blue-100 dark:bg-blue-900">
          <Icon
            icon="material-symbols:visibility-outline"
            class="w-6 h-6 text-blue-600 dark:text-blue-400"
            aria-hidden="true"
          />
        </div>
        <div>
          <p class="text-sm font-medium text-gray-900 dark:text-gray-100">
            {{ $t('web.COMMON.views') }}
          </p>
          <p class="text-sm text-gray-500 dark:text-gray-400">
            {{ details.view_count }} {{ $t('web.COMMON.times_viewed') }}
            <span v-if="details.has_maxviews">
              ({{ $t('web.COMMON.max') }}: {{ details.maxviews }})
            </span>
          </p>
        </div>
      </div>

      <!-- Received (if applicable) -->
      <div v-if="details.is_received" class="flex gap-4">
        <div class="flex-shrink-0 w-12 h-12 flex items-center justify-center rounded-full bg-green-100 dark:bg-green-900">
          <Icon
            icon="material-symbols:mark-email-read-outline"
            class="w-6 h-6 text-green-600 dark:text-green-400"
            aria-hidden="true"
          />
        </div>
        <div>
          <p class="text-sm font-medium text-gray-900 dark:text-gray-100">
            {{ $t('web.COMMON.received') }}
          </p>
          <time :datetime="details.received_date_utc" class="text-sm text-gray-500 dark:text-gray-400">
            {{ details.received_date }}
          </time>
        </div>
      </div>

      <!-- Burned (if applicable) -->
      <div v-if="details.is_burned" class="flex gap-4">
        <div class="flex-shrink-0 w-12 h-12 flex items-center justify-center rounded-full bg-yellow-100 dark:bg-yellow-900">
          <Icon
            icon="material-symbols:local-fire-department"
            class="w-6 h-6 text-yellow-600 dark:text-yellow-400"
            aria-hidden="true"
          />
        </div>
        <div>
          <p class="text-sm font-medium text-gray-900 dark:text-gray-100">
            {{ $t('web.COMMON.burned') }}
          </p>
          <time :datetime="details.burned_date_utc" class="text-sm text-gray-500 dark:text-gray-400">
            {{ details.burned_date }}
          </time>
        </div>
      </div>

      <!-- Expiration -->
      <div class="flex gap-4">
        <div class="flex-shrink-0 w-12 h-12 flex items-center justify-center rounded-full bg-red-100 dark:bg-red-900">
          <Icon
            icon="material-symbols:timer-outline"
            class="w-6 h-6 text-red-600 dark:text-red-400"
            aria-hidden="true"
          />
        </div>
        <div>
          <p class="text-sm font-medium text-gray-900 dark:text-gray-100">
            {{ $t('web.COMMON.expires') }}
          </p>
          <time :datetime="metadata.created_date_utc" class="text-sm text-gray-500 dark:text-gray-400">
            {{ metadata.expiration_stamp }}
          </time>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { MetadataData, MetadataDetails } from '@/types/onetime'
import { Icon } from '@iconify/vue';

interface Props {
  metadata: MetadataData
  details: MetadataDetails
}

defineProps<Props>()
</script>
