<!-- EmailObfuscator.vue -->
<template>
  <a
    @click="handleClick"
    class="email cursor-pointer text-brand-500 dark:text-brand-400 hover:underline"
  >
    {{ displayedEmail }}
  </a>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';

interface Props {
  email: string;
  subject?: string;
}

const props = withDefaults(defineProps<Props>(), {
  subject: '',
});

const obfuscateEmail = (email: string): string => {
  return email.replace('@', ' &#65;&#84; ').replace('.', ' D0T ');
};

const deobfuscateEmail = (email: string): string => {
  return email
    .replace(/ &#65;&#84; /g, "@")
    .replace(/ AT /g, "@")
    .replace(/ D0T /g, ".");
};

const displayedEmail = ref(obfuscateEmail(props.email));

const handleClick = async () => {
  const deobfuscatedEmail = deobfuscateEmail(props.email);

  // Copy email to clipboard
  try {
    await navigator.clipboard.writeText(deobfuscatedEmail);
    alert('Email address copied to clipboard!');
  } catch (err) {
    console.error('Failed to copy email: ', err);
  }

};

onMounted(() => {
  displayedEmail.value = deobfuscateEmail(props.email);
});
</script>
