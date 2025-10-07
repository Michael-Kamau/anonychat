<template>
  <main class="p-6">
    <h1 class="text-2xl font-bold">Hello from Vue + Inertia! About Page</h1>
    <p class="mt-2">Name from server prop: <strong>{{ name }}</strong></p>
    <Link href="/">Go to Home Page</Link>
    <Chat/>
  </main>
</template>

<script setup>
import { Link } from '@inertiajs/vue3'
import Chat from '../components/Chat.vue';
defineProps({ name: String })
</script>
