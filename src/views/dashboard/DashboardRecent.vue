<template>
  <div class="min-h-screen bg-gray-100 dark:bg-gray-900">
    <DashboardTabNav />

    <main class="container mx-auto px-4 py-8">
      <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-6">Secret Dashboard</h1>

      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Create New Secret Card -->
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6">
          <h2 class="text-xl font-semibold text-gray-800 dark:text-white mb-4">Create New Secret</h2>
          <textarea
            class="w-full h-32 p-2 border border-gray-300 dark:border-gray-700 rounded-md bg-white dark:bg-gray-700 text-gray-800 dark:text-white resize-none focus:ring-2 focus:ring-brand-500"
            placeholder="Enter your secret here..."
          ></textarea>
          <button class="mt-4 w-full bg-brand-500 hover:bg-brand-600 text-white font-bold py-2 px-4 rounded-md transition duration-300 ease-in-out">
            Create Secret
          </button>
        </div>

        <!-- Recent Secrets Card -->
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6 md:col-span-2">
          <h2 class="text-xl font-semibold text-gray-800 dark:text-white mb-4">Recent Secrets</h2>
          <div v-if="isLoading" class="animate-pulse space-y-4">
            <div v-for="i in 3" :key="i" class="h-10 bg-gray-200 dark:bg-gray-700 rounded"></div>
          </div>
          <div v-else-if="details?.has_items" class="space-y-4">
            <div v-for="(item, index) in [...(details.notreceived || []), ...(details.received || [])]" :key="index"
                 class="flex items-center justify-between p-3 bg-gray-50 dark:bg-gray-700 rounded-md">
              <span class="text-gray-800 dark:text-gray-200 truncate">{{ item.identifier }}</span>
              <span class="text-sm text-gray-500 dark:text-gray-400">{{ formatDate(item.created) }}</span>
            </div>
          </div>
          <p v-else class="text-gray-600 dark:text-gray-400 italic">
            No recent secrets. Create one now!
          </p>
        </div>
      </div>

      <!-- Detailed Secret Lists -->
      <div class="mt-8 grid grid-cols-1 md:grid-cols-2 gap-6">
        <SecretMetadataTable
          :hasItems="details?.has_items"
          :notReceived="details?.notreceived"
          :isLoading="isLoading"
          title="Not Received"
          aria-label="Not Received Secrets"
        />
        <SecretMetadataTable
          :hasItems="details?.has_items"
          :received="details?.received"
          :isLoading="isLoading"
          title="Received"
          aria-label="Received Secrets"
        />
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue';
import { useFetchData } from '@/composables/useFetchData';
import DashboardTabNav from '@/components/dashboard/DashboardTabNav.vue';
import SecretMetadataTable from '@/components/secrets/SecretMetadataTable.vue';
import { MetadataData } from '@/types/onetime';

const { details, fetchData: fetchSecrets, isLoading } = useFetchData<MetadataData>({
  url: '/api/v2/private/recent',
});

onMounted(fetchSecrets);
const formatDate = (epoch: number): string => {
  return new Date(epoch * 1000).toLocaleDateString();
};
</script>
