<template>
  <div class="min-h-screen bg-gray-50 text-gray-900">
    <!-- Header -->
    <header class="bg-white shadow-sm">
      <nav class="mx-auto flex max-w-6xl items-center justify-between px-6 py-4">
        <h1 class="text-xl font-bold text-emerald-600">
          Phoenix/Inertia Project
        </h1>

        <div class="space-x-6 text-sm font-medium">
          <Link href="/" class="text-gray-700 hover:text-emerald-600">
            Home
          </Link>
          <Link href="/about" class="text-gray-700 hover:text-emerald-600">
            Chat
          </Link>
          <Link href="/queue" class="text-gray-700 hover:text-emerald-600">
            Queue
          </Link>
        </div>
      </nav>
    </header>

    <!-- Hero Section -->
    <main class="mx-auto max-w-6xl px-6 py-20 text-center">
      <h2 class="text-4xl font-bold tracking-tight">
        Simple RabbitMQ Queue Project
      </h2>

      <p class="mx-auto mt-4 max-w-2xl text-gray-600">
        A beginner-friendly demo showing how messages are sent, queued,
        and processed using RabbitMQ.
      </p>

      <p class="mt-4 text-sm text-red-800">
        Name from server prop:
        <strong>{{ name }}</strong>
      </p>

      <div class="mt-8 flex justify-center gap-4">
        <Link
          href="/queue"
          class="rounded-lg bg-emerald-600 px-5 py-3 text-sm font-semibold text-white hover:bg-emerald-700"
        >
           Queues
        </Link>

        <Link
          href="/about"
          class="rounded-lg border border-gray-300 px-5 py-3 text-sm font-semibold text-gray-700 hover:bg-gray-100"
        >
          Chat
        </Link>
      </div>
    </main>
  </div>
</template>

<script setup>
import { Link } from '@inertiajs/vue3'

defineProps({
  name: String
})
</script>