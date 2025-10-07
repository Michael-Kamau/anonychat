<template>
  <main class="p-6">
    <h1 class="text-2xl font-bold">Hello from Vue + Inertia! Home Page</h1>
    <p class="mt-2 text-xs text-red-800">Name from server prop: <strong>{{ name }}</strong></p>
    <Link href="/about">Go to About Page</Link> <br>

  </main>
</template>

<script setup>
import { Link } from '@inertiajs/vue3'
defineProps({ name: String })
</script>
