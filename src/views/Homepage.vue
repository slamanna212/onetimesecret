<template>
  <div class="container mx-auto py-1 min-w-[320px] max-w-2xl">
    <HomepageTaglines v-if="!authenticated"
                      class="mb-6" />

    <HomepagePlansCTA v-if="authenticationSettings.signup"
                      class="mb-6" />

    <SecretForm class="mb-8"
                :withRecipient="false"
                :withAsterisk="true"
                :withGenerate="true" />

    <div v-if="!authenticated"
         class="flex flex-col items-center text-center">
      <p class="text-sm text-gray-400 italic dark:text-gray-400">
        {{ $t('web.homepage.secret_hint') }}
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import SecretForm from '@/components/secrets/form/SecretForm.vue';
import HomepagePlansCTA from '@/components/ctas/HomepagePlansCTA.vue';
import HomepageTaglines from '@/components/HomepageTaglines.vue';

const authenticated = window.authenticated;
const authenticationSettings = window.authentication;
</script>
