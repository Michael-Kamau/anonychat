<template>
  <main class="p-6">
    <h1 class="text-2xl font-bold">Hello from Vue + Inertia! About Page</h1>
    <p class="mt-2">Name from server prop: <strong>{{ name }}</strong></p>
    <Link href="/">Go to Home Page</Link>
  </main>
</template>

<script setup>
import { Link } from '@inertiajs/vue3'
defineProps({ name: String })
</script>
