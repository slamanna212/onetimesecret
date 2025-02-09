<template>
  <div class="space-y-8">
    <section aria-labelledby="appearance-heading">
      <h3 id="appearance-heading"
          class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
        Appearance
      </h3>
      <div class="rounded-lg bg-gray-50 dark:bg-gray-800 p-4">
        <div class="flex items-center justify-between gap-4 rounded p-2">
          <div class="flex items-center gap-2">
            <Icon icon="carbon:light-filled"
                  class="h-5 w-5 text-gray-500 dark:text-gray-400"
                  aria-hidden="true" />
            <span class="text-sm font-medium text-gray-700 dark:text-gray-300">
              Theme
            </span>
          </div>
          <ThemeToggle @theme-changed="handleThemeChange" />
        </div>
      </div>
    </section>

    <div class="h-px bg-gray-200 dark:bg-gray-700" aria-hidden="true"></div>

    <section aria-labelledby="language-heading">
      <h3 id="language-heading"
          class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
        Language
      </h3>
      <div class="rounded-lg bg-gray-50 dark:bg-gray-800 p-4">
        <LanguageToggle @menuToggled="handleMenuToggled"
                       class="w-full" />
        <div class="prose prose-sm dark:prose-invert prose-gray mt-6 max-w-none space-y-4">
          <p class="text-gray-600 dark:text-gray-300 leading-relaxed">
            As we add new features, our translations gradually need updates to stay current. This affects both
            onetimesecret.com and thousands of self-hosted installations worldwide.
          </p>

          <p class="text-gray-600 dark:text-gray-300 leading-relaxed">
            We're grateful to the
            <router-link to="/translations"
                        @click="$emit('close')"
                        class="text-primary-600 hover:text-primary-700 dark:text-primary-400 dark:hover:text-primary-300 font-medium transition-colors duration-150">
              25+ contributors
            </router-link>
            who've helped with translations as we continue to develop new features.
          </p>

          <p class="text-gray-600 dark:text-gray-300 leading-relaxed">
            If you're interested in translation,
            <a href="https://github.com/onetimesecret/onetimesecret"
               class="text-primary-600 hover:text-primary-700 dark:text-primary-400 dark:hover:text-primary-300 font-medium transition-colors duration-150">
              our GitHub project
            </a>
            welcomes contributors for both existing and new languages.
          </p>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import LanguageToggle from '@/components/LanguageToggle.vue';
import ThemeToggle from '@/components/ThemeToggle.vue';
import { Icon } from '@iconify/vue';

const emit = defineEmits<{
  (e: 'close'): void;
  (e: 'menuToggled'): void;
}>();

const handleMenuToggled = () => {
  emit('menuToggled');
};

const handleThemeChange = (isDark: boolean) => {
  console.log('Theme changed:', isDark);
};
</script>
