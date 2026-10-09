<template>
  <div class="min-h-screen bg-gray-50 text-gray-900">
      <h1 class="text-2xl font-bold">
        Hello from Vue + Inertia! About Page
      </h1>

      <p class="mt-2">
        Name from server prop:
        <strong>{{ name }}</strong>
      </p>

      <div class="mt-4">
        <Link href="/" class="text-emerald-600 hover:text-emerald-700">
          Go to Home Page
        </Link>
      </div>

      <div class="mt-8">
        <Chat />
      </div>
  </div>
</template>

<script setup>
import { Link } from '@inertiajs/vue3'
import Chat from '../components/Chat.vue'
import AppLayout from '../Layouts/AppLayout.vue';

defineOptions({ layout: AppLayout })

defineProps({
  name: String
})
</script>