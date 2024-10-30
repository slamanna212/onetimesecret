
<script setup lang="ts">
import { ref, computed } from 'vue';

import { useWindowProps } from '@/composables/useWindowProps';
import { Plan } from '@/types/onetime';

import { onMounted } from 'vue';

const { available_plans, default_planid } = useWindowProps(['available_plans', 'default_planid']);
const defaultPlan = ref({} as Plan);
const anonymousPlan = ref({} as Plan);

const secondsToDays = (seconds: number) => {
  return seconds != null ? Math.floor(seconds / 86400) : 0;
};

const bytesToKB = (bytes: number) => {
  return bytes != null ? Math.round(bytes / 1024) : 0;
};

// Anonymous users can create secrets that last up to {{ anonymousTtlDays }} days
// and have a maximum size of {{ anonymousSizeKB }} KB. Free account holders get
// extended benefits: secrets can last up to {{ defaultTtlDays }} days and can be
// up to {{ defaultSizeKB }} KB in size. Account holders also get access to
// additional features like burn-before-reading options, which allow senders to
// delete secrets before they're received.
const anonymousTtlDays = computed(() => secondsToDays(anonymousPlan.value?.options?.ttl));
const anonymousSizeKB = computed(() => bytesToKB(anonymousPlan.value?.options?.size));
const defaultTtlDays = computed(() => secondsToDays(defaultPlan.value?.options?.ttl));
const defaultSizeKB = computed(() => bytesToKB(defaultPlan.value?.options?.size));

onMounted(() => {
  if (available_plans.value && default_planid.value) {
    defaultPlan.value = available_plans.value[default_planid.value] ?? null;
    anonymousPlan.value = available_plans.value.anonymous;
  }
});

</script>

<template>
  <article class="prose dark:prose-invert md:prose-lg lg:prose-xl">
    <h2 class="intro">About Us</h2>

    <p class="">
      Modified version of <a href="https://github.com/onetimesecret/onetimesecret" title="OneTimeSecret">OneTimeSecret</a>
      
      Hosted and run by <a href="https://slamanna.com" title"Sam">Sam</a>
    </p>

  </article>
</template>