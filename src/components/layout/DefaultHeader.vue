<template>
  <header class="bg-white dark:bg-gray-900">
    <div class="container mx-auto px-4 py-4 min-w-[320px] max-w-2xl">
      <div v-if="displayMasthead"
           class="w-full">
        <div class="flex flex-col sm:flex-row justify-between items-center">
          <div class="mb-4 sm:mb-0">
            <router-link to="/"
                         class="flex items-center">
              <img id="logo"
                   src="@/assets/img/onetime-logo-v3-xl.svg"
                   class="w-12 h-12 sm:w-16 sm:h-16 rounded-md"
                   aria-label="Onetime Secret"
                   alt="Logo">
              <span class="ml-2 text-xl font-bold font-brand text-gray-800 dark:text-white">
                Onetime Secret
              </span>
            </router-link>
          </div>

          <nav v-if="displayNavigation"
               class="flex flex-wrap justify-center sm:justify-end items-center gap-4 text-sm sm:text-base font-brand">
            <template v-if="authenticated && cust">
              <HeaderUserNav :cust="cust"
                             :colonel="colonel" />
              <a href="#"
                 @click="openSettingsModal"
                 class="text-gray-600 hover:text-gray-800 dark:text-gray-300 dark:hover:text-white transition-colors duration-200"
                 title="Your Account">{{ $t('web.COMMON.header_settings') }}</a>

              <SettingsModal :is-open="isSettingsModalOpen"
                             @close="closeSettingsModal" />

              <span class="text-gray-400">|</span>
              <router-link to="/logout"
                           class="text-gray-600 hover:text-gray-800 dark:text-gray-300 dark:hover:text-white transition-colors duration-200"
                           :title="$t('web.COMMON.header_logout')"
                           :aria-label="$t('web.COMMON.header_logout')">
                <svg xmlns="http://www.w3.org/2000/svg"
                     fill="none"
                     viewBox="0 0 24 24"
                     stroke-width="1.5"
                     stroke="currentColor"
                     class="w-6 h-6"
                     aria-hidden="true">
                  <path stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15m3 0l3-3m0 0l-3-3m3 3H9" />
                </svg>
              </router-link>

            </template>

            <template v-else>
              <template v-if="authentication.enabled">
                <router-link v-if="authentication.signup"
                             to="/signup"
                             title="Signup - Individual and Business plans"
                             class="font-bold text-gray-600 hover:text-gray-800 dark:text-gray-300 dark:hover:text-white transition-colors duration-200">
                  {{ $t('web.COMMON.header_create_account') }}
                </router-link>
                <span class="text-gray-400">|</span>
                <router-link to="/about"
                             title="About Onetime Secret"
                             class="text-gray-600 hover:text-gray-800 dark:text-gray-300 dark:hover:text-white transition-colors duration-200">
                  {{ $t('web.COMMON.header_about') }}
                </router-link>
                <span class="text-gray-400">|</span>
                <router-link v-if="authentication.signin"
                             to="/signin"
                             title="Log in to Onetime Secret"
                             class="text-gray-600 hover:text-gray-800 dark:text-gray-300 dark:hover:text-white transition-colors duration-200">
                  {{ $t('web.COMMON.header_sign_in') }}
                </router-link>
              </template>

              <router-link v-else
                           to="/about"
                           title="About Onetime Secret"
                           class="text-gray-600 hover:text-gray-800 dark:text-gray-300 dark:hover:text-white transition-colors duration-200">
                {{ $t('web.COMMON.header_about') }}
              </router-link>
            </template>
          </nav>
        </div>
      </div>
    </div>
  </header>
</template>



<script setup lang="ts">
import HeaderUserNav from '@/components/layout/HeaderUserNav.vue';
import SettingsModal from '@/components/modals/SettingsModal.vue';
import type { Props as BaseProps } from '@/layouts/BaseLayout.vue';
import { computed, ref } from 'vue';


// Define the props for this layout, extending the BaseLayout props
export interface Props extends BaseProps {
  displayMasthead?: boolean;
  displayNavigation?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  displayMasthead: true,
  displayNavigation: true,
  colonel: false,
});


const colonel = computed(() => props.cust?.role === 'colonel');

// Reactive state
const isSettingsModalOpen = ref(false);

// Methods
const openSettingsModal = () => {
  isSettingsModalOpen.value = true;
};

const closeSettingsModal = () => {
  isSettingsModalOpen.value = false;
};

</script>
