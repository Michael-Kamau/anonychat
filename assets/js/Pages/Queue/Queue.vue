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

          <Link href="/about" class="text-gray-700 hover:text-emerald-600">
            About
          </Link>

          <Link href="/queue" class="text-emerald-600 font-semibold">
            Queue
          </Link>
        </div>
      </nav>
    </header>

    <!-- Main Content -->
    <main class="mx-auto max-w-4xl px-6 py-12">
      <section class="rounded-xl bg-white p-6 shadow-sm">
        <h2 class="text-2xl font-bold">
          Send Message to Queue
        </h2>

        <p class="mt-2 text-sm text-gray-600">
          Add a message below. It will be sent to RabbitMQ and consumed by the worker.
        </p>

        <!-- Form -->
        <form @submit.prevent="submitMessage" class="mt-6 space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700">
              Message
            </label>

            <textarea
              v-model="form.message"
              rows="4"
              placeholder="Enter your queue message..."
              class="mt-2 w-full rounded-lg border border-gray-300 p-3 text-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500"
            ></textarea>

            <p v-if="form.errors.message" class="mt-1 text-sm text-red-600">
              {{ form.errors.message }}
            </p>
          </div>

          <button
            type="submit"
            :disabled="form.processing"
            class="rounded-lg bg-emerald-600 px-5 py-3 text-sm font-semibold text-white hover:bg-emerald-700 disabled:opacity-50"
          >
            {{ form.processing ? 'Sending...' : 'Send to Queue' }}
          </button>
        </form>
      </section>

      <!-- Consumed Messages -->
      <section class="mt-8 rounded-xl bg-white p-6 shadow-sm">
        <div class="flex items-center justify-between">
          <h2 class="text-2xl font-bold">
            Consumed Messages
          </h2>

          <button
            @click="refreshMessages"
            class="text-sm font-medium text-emerald-600 hover:text-emerald-700"
          >
            Refresh
          </button>
        </div>

        <div v-if="messages.length === 0" class="mt-6 rounded-lg bg-gray-100 p-4 text-sm text-gray-600">
          No consumed messages yet.
        </div>

        <ul v-else class="mt-6 space-y-3">
          <li
            v-for="message in messages"
            :key="message.id"
            class="rounded-lg border border-gray-200 p-4"
          >
            <p class="text-gray-800">
              {{ message.message }}
            </p>

            <p class="mt-2 text-xs text-gray-500">
              Consumed at: {{ message.created_at }}
            </p>
          </li>
        </ul>
      </section>
    </main>
  </div>
</template>

<script setup>
import { Link, router, useForm } from '@inertiajs/vue3'

const props = defineProps({
  messages: {
    type: Array,
    default: () => []
  }
})

const form = useForm({
  message: ''
})

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  ?.getAttribute('content')

const submitMessage = () => {
  form.post('/queue', {
    headers: csrfToken
      ? {
          'x-csrf-token': csrfToken
        }
      : {},
    preserveScroll: true,
    onSuccess: () => {
      form.reset('message')

      router.reload({
        only: ['messages']
      })
    }
  })
}

const refreshMessages = () => {
  router.reload({
    only: ['messages'],
    preserveScroll: true
  })
}
</script>
