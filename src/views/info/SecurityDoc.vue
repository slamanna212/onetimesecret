<template>
  <article class="prose dark:prose-invert">
     <h2 class="text-2xl font-bold mb-4 dark:text-white">Security Policy</h2>
     <p class="mb-4 dark:text-gray-300">
       We take the security of this project seriously and appreciate your efforts
       to responsibly disclose vulnerabilities. This document outlines our security
       policy and provides guidelines on how to report vulnerabilities.
     </p>
     <h3 class="text-xl font-semibold mb-2 dark:text-white">Supported Versions</h3>
     <p class="mb-4 dark:text-gray-300">We provide security updates for the following versions of our project:</p>
     <table class="w-full mb-4">
       <thead>
         <tr class="bg-gray-100 dark:bg-gray-700">
           <th class="p-2 text-left dark:text-white">Version</th>
           <th class="p-2 text-left dark:text-white">Supported</th>
         </tr>
       </thead>
       <tbody>
         <tr class="border-b dark:border-gray-600">
           <td class="p-2 dark:text-gray-300">0.18.x+</td>
           <td class="p-2 dark:text-gray-300">✅</td>
         </tr>
         <tr class="border-b dark:border-gray-600">
           <td class="p-2 dark:text-gray-300">0.17.x</td>
           <td class="p-2 dark:text-gray-300">✅</td>
         </tr>
         <tr>
           <td class="p-2 dark:text-gray-300">&lt;= 0.16.0</td>
           <td class="p-2 dark:text-gray-300">❌</td>
         </tr>
       </tbody>
     </table>
     <p class="mb-4 dark:text-gray-300">
       If you are using an unsupported version, we strongly recommend upgrading to
       one of the supported versions to ensure you receive the latest security
       updates.
     </p>
     <h3 class="text-xl font-semibold mb-2 dark:text-white">Reporting a Vulnerability</h3>
     <p class="mb-4 dark:text-gray-300">
       If you discover a security vulnerability within this project, we encourage
       you to report it as soon as possible. Here's how you can do it:
     </p>
     <h4 class="text-lg font-semibold mb-2 dark:text-white">How to Report</h4>
     <ol class="list-decimal pl-6 mb-4 dark:text-gray-300">
       <li class="mb-2">
          <strong>Email</strong>: Send an email to
          <EmailObfuscator
            email="security@onetimesecret.com"
            subject="Vulnerability Report: [Brief Description]"
          />
          with the subject line "Vulnerability Report: [Brief Description]".
        </li>
       <li>
         <strong>Details</strong>: Include as much information as possible about
         the vulnerability. This should include:
         <ul class="list-disc pl-6 mt-2">
           <li>A detailed description of the vulnerability.</li>
           <li>Steps to reproduce the issue.</li>
           <li>Any potential impact.</li>
           <li>Your contact information for follow-up questions.</li>
         </ul>
       </li>
     </ol>
     <h4 class="text-lg font-semibold mb-2 dark:text-white">What to Expect</h4>
     <ol class="dark:text-gray-300">
       <li>
         <strong>Acknowledgment</strong>: You will receive an acknowledgment of
         your report within 5 business days.
       </li>
       <li>
         <strong>Initial Assessment</strong>: We will conduct an initial assessment
         of the vulnerability within 14 business days.
       </li>
       <li>
         <strong>Updates</strong>: You can expect to receive updates on the status
         of your report at least once every 7 days until the issue is resolved or a
         decision is made.
       </li>
     </ol>
     <h4 class="text-lg font-semibold mb-2 dark:text-white">Resolution Process</h4>
     <ol class="dark:text-gray-300">
       <li>
         <strong>Accepted Vulnerabilities</strong>: If the vulnerability is
         accepted, we will work on a fix and aim to release it as soon as possible.
         You will be notified once the fix is deployed.
       </li>
       <li>
         <strong>Declined Vulnerabilities</strong>: If the vulnerability is
         declined, we will provide a detailed explanation as to why it was not
         accepted.
       </li>
     </ol>
     <h4 class="text-lg font-semibold mb-2 dark:text-white">Confidentiality</h4>
     <p class="prose dark:text-gray-300">
       We take your privacy seriously. All reports will be kept confidential, and
       we will work with you to ensure that any details of the vulnerability are
       not disclosed until a fix is in place.
     </p>
     <p class="prose dark:text-gray-300">Thank you for helping us keep Onetime Secret secure and excellent!</p>
   </article>
</template>

<script setup lang="ts">
import EmailObfuscator from '@/components/EmailObfuscator.vue';
</script>
