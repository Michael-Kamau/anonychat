<template>
  <div class="min-h-screen bg-gray-50 text-gray-900">
    <!-- Header -->
    <header class="bg-white shadow-sm">
      <nav class="mx-auto flex max-w-6xl items-center justify-between px-6 py-4">
        <h1 class="text-xl font-bold text-emerald-600">
          Phoenix/Inertia
        </h1>

        <div class="space-x-6 text-sm font-medium">
          <Link href="/" class="text-gray-700 hover:text-emerald-600">
            Home
          </Link>

          <Link href="/about" class="font-semibold text-emerald-600">
            About
          </Link>

          <Link href="/queue" class="text-gray-700 hover:text-emerald-600">
            Queue
          </Link>
        </div>
      </nav>
    </header>

    <!-- Page Content -->
    <main class="mx-auto max-w-6xl p-6">
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
    </main>
  </div>
</template>

<script setup>
import { Link } from '@inertiajs/vue3'
import Chat from '../components/Chat.vue'

defineProps({
  name: String
})
</script>