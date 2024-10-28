<template>
  <StatusBar :success="success"
             :error="error"
             :loading="isSubmitting"
             :auto-dismiss="true" />
  <main class="max-w-2xl mx-auto px-4 py-6"
        role="main"
        :aria-busy="isLoading">
    <!--<DashboardTabNav />-->

    <!-- Loading State -->
    <div v-if="isLoading"
         class="flex justify-center py-8"
         role="status"
         aria-label="Loading secret details">
      <Icon icon="mdi:loading"
            class="w-8 h-8 text-brand-500 animate-spin"
            aria-hidden="true" />
      <span class="sr-only">{{ $t('web.COMMON.loading') }}</span>
    </div>

    <!-- Content State -->
    <div v-else-if="record && details"
         class="space-y-8">
      <!-- Secret Link Header -->
      <header v-if="details.show_secret_link"
              class="animate-fade-in"
              aria-labelledby="secret-header">
        <h1 id="secret-header"
            class="sr-only">
          {{ $t('web.COMMON.secret_link') }}
        </h1>
        <SecretLink :metadata="record"
                    :details="details"
                    class="focus-within:ring-2 focus-within:ring-brand-500 rounded-lg" />

      </header>

      <!-- Additional Content Sections -->
      <section v-if="details.show_secret_link"
               class="relative sr-only"
               aria-labelledby="section-secret-link">
        <h2 id="section-secret-link">
          {{ $t('web.COMMON.secret_link') }}
        </h2>
      </section>

      <!-- Secondary: Status & Lifecycle -->
      <section class="bg-gray-50 dark:bg-gray-800 rounded-lg p-4"
               aria-labelledby="section-status">
        <div class="flex items-center justify-between mb-2">
          <h2 id="section-status"
              class="text-sm font-medium text-gray-700 dark:text-gray-300">
            {{ $t('web.COMMON.secret_status') }}
          </h2>
          <StatusBadge :status="secretStatus" />
        </div>

        <TimelineDisplay :metadata="record"
                         :details="details" />
      </section>

      <!-- Tertiary: Actions -->
      <section class="flex flex-col gap-3"
               aria-labelledby="section-actions">
        <h2 id="section-actions"
            class="sr-only">
          {{ $t('web.COMMON.actions') }}
        </h2>

        <BurnButtonForm v-if="!details.is_destroyed"
                        :metadata="record"
                        :details="details"
                        class="w-full" />

        <button type="button"
                @click="handleCreateNew"
                class="inline-flex items-center justify-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 dark:bg-gray-800 dark:text-gray-200 dark:border-gray-600 dark:hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500 dark:focus:ring-offset-gray-900">
          {{ $t('web.COMMON.create_new_secret') }}
        </button>
      </section>

      <!-- Help Section -->
      <section aria-labelledby="section-help">
        <h2 id="section-help"
            class="sr-only">
          {{ $t('web.COMMON.help_section') }}
        </h2>

        <button type="button"
                @click="toggleHelp"
                class="text-sm text-gray-500 hover:text-gray-700 dark:hover:text-gray-300 flex items-center gap-2 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500 rounded-md p-1">
          <Icon icon="mdi:information"
                class="w-5 h-5"
                aria-hidden="true" />
          <span>{{ $t('web.COMMON.need_help') }}</span>
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
import StatusBar from '@/components/StatusBar.vue';
import BurnButtonForm from '@/components/secrets/metadata/BurnButtonForm.vue';
import MetadataFAQ from '@/components/secrets/metadata/MetadataFAQ.vue';
import SecretLink from '@/components/secrets/metadata/SecretLink.vue';
import StatusBadge from '@/components/secrets/metadata/StatusBadge.vue';
import TimelineDisplay from '@/components/secrets/metadata/TimelineDisplay.vue';
import { useFetchDataRecord } from '@/composables/useFetchData';
import type { MetadataData } from '@/types/onetime';
import { Icon } from '@iconify/vue';
import { computed, onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';

interface Props {
  metadataKey: string;
}

const props = defineProps<Props>();
const router = useRouter();
const showHelp = ref(false);

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

const toggleHelp = () => {
  showHelp.value = !showHelp.value;
};

const handleCreateNew = () => {
  router.push('/');
};

onMounted(fetchMetadata);
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

<script lang="ts">
/**
 * Looking at this from a fresh UX perspective, let me share some key
 * observations and suggestions for reimagining this confirmation page:
 *
 * Core Purpose & User Needs:
 * 1. Primary Goal: Users need to securely copy and share a one-time secret link
 * 2. Secondary Goal: Understand the secret's lifecycle (expiration, burn status)
 *
 * Key Issues with Current Design:
 * - Information hierarchy is flat - everything appears equally important
 * - Visual noise from multiple bordered elements competing for attention
 * - Lack of clear visual guidance for the primary action (copying link)
 * - FAQ section adds cognitive load at a moment when focus is needed
 *
 * Suggested Improvements:
 *
 * 1. Information Architecture:
 * - Create a clear visual hierarchy with three distinct zones:
 *   1. Primary: Secret Link (copy mechanism)
 *   2. Secondary: Status/Lifecycle info
 *   3. Tertiary: Additional actions (burn, create new)
 *
 * 2. Interaction Design:
 * - Implement a more sophisticated copy mechanism with clear feedback
 * - Consider a temporary "copied" state that fades naturally
 * - Remove the need to select text manually
 *
 * 3. Visual Design:
 * - Use white space more effectively to create "breathing room"
 * - Implement subtle animations for state changes
 * - Consider a progress indicator for expiration time
 * - Use color purposefully to indicate status and actions
 *
 * 4. Content Strategy:
 * - Move FAQ to a subtle expandable section or separate page
 * - Simplify status messages
 * - Use progressive disclosure for advanced features
 *
 * 5. Emotional Design:
 * - Create a sense of security through calm, confident design
 * - Use subtle micro-interactions to provide feedback
 * - Consider adding a simple checkmark or success indicator
 *
 * Before diving into code changes, I'd first recommend creating a simplified user flow that focuses on:
 * 1. Clear confirmation that the secret was created
 * 2. Effortless link copying
 * 3. At-a-glance expiration status
 * 4. One-click access to secondary actions
 *
 * Would you like me to proceed with specific code recommendations based on these observations?
 */
</script>
