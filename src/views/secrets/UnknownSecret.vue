
<template>
  <div class="bg-white dark:bg-gray-800 shadow-md rounded-lg p-8">
    <div class="text-center mb-8">
      <svg
        class="mx-auto w-20 h-20 text-brand-500"
        width="60"
        height="60"
        viewBox="0 0 24 24"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        aria-hidden="true">
        <path
          d="M12 15V17M12 7V13M21 12C21 16.9706 16.9706 21 12 21C7.02944 21 3 16.9706 3 12C3 7.02944 7.02944 3 12 3C16.9706 3 21 7.02944 21 12Z"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round" />
      </svg>
    </div>
    <h1
      class="text-3xl font-bold text-gray-800 dark:text-white mb-6"
      aria-label="Information no longer available">
      That information is no longer available.
    </h1>
    <p class="text-lg text-gray-600 dark:text-gray-300 mb-8">
      <em>Welcome to Onetime Secret.</em>
      Sensitive information shared through our service can only be accessed once. Once viewed, the
      content is permanently deleted from our servers to ensure confidentiality. This approach helps
      protect your sensitive data by limiting its exposure and preventing unauthorized access.
    </p>
    <div class="bg-brandcomp-50 dark:bg-brandcomp-900 border-l-4 border-brandcomp-500 p-5 mb-8">
      <p class="text-lg text-brandcomp-700 dark:text-brandcomp-200 font-medium">
        If you're unsure what to do next, please follow up with the person who sent you this link
        for more information.
      </p>
    </div>
    <router-link
      to="/"
      class="inline-block bg-white font-brand hover:border-brand-600 text-brand-500 font-medium py-3 px-6 border-2 rounded-lg transition duration-300 ease-in-out text-lg"
      aria-label="Return to home page">
      Return to Home
    </router-link>
  </div>
</template>

<script setup lang="ts">
</script>
