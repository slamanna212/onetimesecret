<template>
  <section class="mb-8">
    <h3 class="text-2xl font-semibold mb-4 text-gray-900 dark:text-gray-100"
        aria-label="Feedback Form">
      Share your feedback
    </h3>

    <FeedbackForm :showRedButton="true" />

    <!-- Founder's Message -->
    <div class="bg-white dark:bg-gray-800 shadow-md rounded-lg overflow-hidden my-4">
      <div class="p-6">
        <h2 class="text-xl font-semibold mb-4 text-gray-800 dark:text-gray-200">A note from Delano, founder of Onetime
          Secret</h2>
        <div class="space-y-3 text-gray-600 dark:text-gray-400">
          <p>
            Hey there, thanks for stopping by our feedback page. Your input isn't just welcome - it's crucial.
          </p>
          <p>
            We've built this tool to help you share sensitive info securely, and your real-world experiences are crucial
            for focusing our efforts. It helps us figure out what to work on next and how to make the service better for
            everyone.
          </p>
          <p>
            Thanks for helping Onetime Secret improve. It means a lot.
          </p>
          <p class="font-medium">
            - Delano
          </p>
        </div>
      </div>
    </div>

  </section>

</template>

<script setup lang="ts">
import FeedbackForm from '@/components/FeedbackForm.vue';

</script>
