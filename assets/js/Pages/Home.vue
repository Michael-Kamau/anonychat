<template>
  <div class="min-h-screen bg-gray-50 text-gray-900">
    <header class="border-b border-gray-100 bg-white/95 shadow-sm">
      <nav class="mx-auto flex max-w-6xl items-center justify-between px-6 py-4">
        <h1 class="text-xl font-bold text-emerald-600">
          Anonychat
        </h1>

        <div class="space-x-6 text-sm font-medium">
          <Link href="/" class="font-semibold text-emerald-600">
            Home
          </Link>
          <Link
            href="/about"
            class="text-gray-700 transition hover:text-emerald-600"
          >
            Chat
          </Link>
          <Link
            href="/queue"
            class="text-gray-700 transition hover:text-emerald-600"
          >
            Queue
          </Link>
        </div>
      </nav>
    </header>

    <main class="mx-auto max-w-6xl px-6 py-20 text-center">
      <p class="text-sm font-semibold uppercase tracking-wide text-emerald-600">
        Phoenix + Inertia + RabbitMQ broker
      </p>

      <h2 class="mt-4 text-4xl font-bold tracking-tight">
        Simple RabbitMQ/Sockets Queue Project
      </h2>

      <p class="mx-auto mt-4 max-w-2xl text-lg leading-8 text-gray-600">
        A beginner-friendly demo showing how messages are sent, queued,
        consumed, and streamed back to connected clients.
      </p>

      <div class="mt-8 flex flex-col justify-center gap-3 sm:flex-row">
        <Link
          href="/queue"
          class="rounded-lg bg-emerald-600 px-5 py-3 text-sm font-semibold text-white shadow-sm transition hover:-translate-y-0.5 hover:bg-emerald-700"
        >
          Open Queue
        </Link>

        <Link
          href="/about"
          class="rounded-lg border border-gray-300 bg-white px-5 py-3 text-sm font-semibold text-gray-700 transition hover:-translate-y-0.5 hover:bg-gray-100"
        >
          Open Chat
        </Link>
      </div>

      <div class="mx-auto mt-12 grid max-w-3xl gap-4 text-left sm:grid-cols-3">
        <div class="rounded-lg border border-gray-200 bg-white p-4 shadow-sm">
          <p class="text-sm font-semibold text-gray-900">Send</p>
          <p class="mt-1 text-sm text-gray-600">
            Post a message from the app.
          </p>
        </div>

        <div class="rounded-lg border border-gray-200 bg-white p-4 shadow-sm">
          <p class="text-sm font-semibold text-gray-900">Queue</p>
          <p class="mt-1 text-sm text-gray-600">
            RabbitMQ holds it for the worker.
          </p>
        </div>

        <div class="rounded-lg border border-gray-200 bg-white p-4 shadow-sm">
          <p class="text-sm font-semibold text-gray-900">Consume</p>
          <p class="mt-1 text-sm text-gray-600">
            Phoenix broadcasts it live.
          </p>
        </div>
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
