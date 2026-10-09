<template>
  <div class="min-h-screen bg-gray-50 text-gray-900">
    <header class="border-b border-gray-100 bg-white/95 shadow-sm">
      <nav class="mx-auto flex max-w-6xl items-center justify-between px-6 py-4">
        <h1 class="text-xl font-bold text-emerald-600">
          Anonychat
        </h1>

        <div class="space-x-6 text-sm font-medium">
          <Link href="/" class="transition  duration-300 " 
         :class="page?.url =='/' ? 'text-emerald-600' :'text-gray-700'"

          >
            Home
          </Link>
          <Link
            href="/about"
            class=" transition duration-300 "
            :class="page?.url =='/about' ? 'text-emerald-600' :'text-gray-700'"
          >
            Chat
          </Link>
          <Link
            href="/queue"
            class=" transition duration-300 "
            :class="page?.url =='/queue' ? 'text-emerald-600' :'text-gray-700'"
            >
            Queue
            </Link>
            </div>
        </nav>
    </header>
    <main class="mx-auto max-w-6xl px-6 py-20 text-center">
      <slot />
    </main>
  </div>
</template>

<script setup>
import { Link, usePage } from '@inertiajs/vue3'
const page = usePage()


defineProps({
  name: String
})
</script>
