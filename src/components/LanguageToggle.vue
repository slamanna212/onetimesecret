<!-- src/components/LanguageToggle.vue -->
<template>
  <DropdownToggle ref="dropdownRef"
                  ariaLabel="Change language"
                  :openDirection="'down'">
    <template #button-content>
      <svg xmlns="http://www.w3.org/2000/svg"
           class="h-5 w-5 mr-2"
           fill="none"
           viewBox="0 0 24 24"
           stroke="currentColor">
        <path stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M3 5h12M9 3v2m1.048 9.5A18.022 18.022 0 016.412 9m6.088 9h7M11 21l5-10 5 10M12.751 5C11.783 10.77 8.07 15.61 3 18.129" />
      </svg>
      {{ currentLocale }}
    </template>
    <template #menu-items>
      <a v-for="locale in supportedLocales"
         :key="locale"
         href="#"
         @click.prevent="changeLocale(locale)"
         :class="[
          'block px-4 py-2 text-sm hover:bg-gray-100 dark:hover:bg-gray-700 hover:text-gray-900 dark:hover:text-gray-100',
          locale === currentLocale ? 'text-indigo-600 dark:text-indigo-400 font-bold bg-gray-100 dark:bg-gray-700' : 'text-gray-700 dark:text-gray-300'
        ]"
         role="menuitem">
        {{ locale }}
      </a>
    </template>
  </DropdownToggle>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { setLanguage } from '@/i18n';
import { useLanguageStore } from '@/stores/languageStore';
import { useWindowProp } from '@/composables/useWindowProps';
import DropdownToggle from './DropdownToggle.vue';

const emit = defineEmits(['localeChanged']);

const languageStore = useLanguageStore();
const supportedLocales = languageStore.getSupportedLocales;

const cust = useWindowProp('cust');

const selectedLocale = ref(languageStore.determineLocale(cust?.value?.locale));

const currentLocale = computed(() => selectedLocale.value);

const dropdownRef = ref<InstanceType<typeof DropdownToggle> | null>(null);

const changeLocale = async (newLocale: string) => {
  if (languageStore.getSupportedLocales.includes(newLocale)) {
    try {
      if (cust.value) {
        cust.value.locale = newLocale;
      }
      await languageStore.updateLanguage(newLocale);
      await setLanguage(newLocale);
      selectedLocale.value = newLocale;
      emit('localeChanged', newLocale);
    } catch (err) {
      console.error('Failed to update language:', err);
    } finally {
      dropdownRef.value?.closeMenu();
    }
  }
};

onMounted(() => {
  setLanguage(selectedLocale.value);
});
</script>
