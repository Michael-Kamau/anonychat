<!-- ChatPanel.vue -->
<template>
  <div class="mx-auto max-w-2xl h-[75vh] flex flex-col bg-white rounded-xl shadow border overflow-hidden">
    <!-- Header -->
    <header class="px-4 py-3 border-b flex items-center gap-2">
      <span class="inline-block size-2 rounded-full" :class="statusClass"></span>
      <h2 class="font-semibold text-gray-900">Chat</h2>
      <span class="ml-auto text-xs text-gray-500">
        {{ status === 'joining' ? 'Connecting…' : status === 'error' ? 'Disconnected' : 'Lobby' }}
      </span>
    </header>

    <!-- Messages -->
    <div ref="scrollWrap" class="flex-1 overflow-y-auto bg-gray-50">
      <TransitionGroup
        name="slide-fade"
        tag="ul"
        class="p-4 space-y-3"
        aria-live="polite"
        aria-label="Messages"
      >
        <li
          v-for="(m, idx) in messages"
          :key="m.id || idx"
          class="flex"
        >
          <div class="max-w-[80%] rounded-2xl px-3 py-2 bg-white text-gray-900 shadow-sm">
            <p class="whitespace-pre-wrap break-words">{{ m.body }}</p>
            <time v-if="m._ts" class="block mt-1 text-[10px] text-gray-500">
              {{ formatTime(m._ts) }}
            </time>
          </div>
        </li>

        <li v-if="messages.length === 0" key="empty" class="text-center text-sm text-gray-500 py-10">
          No messages yet — say hi 👋
        </li>
      </TransitionGroup>
    </div>

    <!-- Composer -->
    <form @submit.prevent="sendMessage" class="p-3 border-t bg-gray-50">
      <div class="flex items-end gap-2">
        <textarea
          ref="inputEl"
          v-model="newMessage"
          rows="1"
          @input="autoResize"
          @keydown.enter.exact.prevent="sendMessage"
          @keydown.shift.enter.stop
          class="flex-1 resize-none rounded-lg border border-gray-300 bg-white px-3 py-2
                 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent
                 placeholder:text-gray-400"
          placeholder="Type a message"
          :disabled="status !== 'joined'"
        />
        <button
          type="submit"
          :disabled="!canSend"
          class="inline-flex items-center gap-1 rounded-lg bg-indigo-600 text-white px-3 py-2
                 font-medium disabled:opacity-50 disabled:cursor-not-allowed"
          aria-label="Send message"
          title="Send (Enter)"
        >
          <svg viewBox="0 0 20 20" fill="currentColor" class="h-5 w-5">
            <path d="M2.94 2.94a1 1 0 0 1 1.05-.23l13 5a1 1 0 0 1 0 1.86l-13 5A1 1 0 0 1 3 14.67V11l8-1-8-1V3.33a1 1 0 0 1-.06-.39z"/>
          </svg>
          <span>Send</span>
        </button>
      </div>
    </form>
  </div>
</template>

<script>
import { ref, computed, nextTick, onMounted, watch } from 'vue'
import socket from '../socket.js'

export default {
  name: 'ChatPanel',
  setup() {
    const messages = ref([])
    const newMessage = ref('')
    const status = ref('joining') // 'joining' | 'joined' | 'error'

    const inputEl = ref(null)
    const scrollWrap = ref(null)

    // Join the channel
    const channel = socket.channel('room:lobby', {})
    channel.join()
      .receive('ok', () => { status.value = 'joined' })
      .receive('error', (reason) => { status.value = 'error'; console.error('Failed to join', reason) })

    // Incoming messages
    channel.on('new_message', (payload) => {
      messages.value.push({ ...payload, _ts: new Date() })
    })

    // Auto-scroll when messages change
    watch(messages, () => scrollToBottomSoon(), { deep: true })

    const canSend = computed(() =>
      status.value === 'joined' && newMessage.value.trim().length > 0
    )

    const sendMessage = () => {
      const body = newMessage.value.trim()
      if (!body || status.value !== 'joined') return
      channel.push('new_message', { body })
      newMessage.value = ''
      nextTick(() => autoResize())
    }

    const autoResize = () => {
      const el = inputEl.value
      if (!el) return
      el.style.height = 'auto'
      el.style.height = Math.min(el.scrollHeight, 160) + 'px'
    }

    const scrollToBottomSoon = () =>
      nextTick(() => {
        const el = scrollWrap.value
        if (el) el.scrollTop = el.scrollHeight
      })

    const formatTime = (ts) =>
      new Intl.DateTimeFormat(undefined, { hour: '2-digit', minute: '2-digit' }).format(ts)

    const statusClass = computed(() =>
      status.value === 'joined' ? 'bg-emerald-500 animate-pulse' :
      status.value === 'joining' ? 'bg-amber-400 animate-pulse' :
      'bg-red-500'
    )

    onMounted(() => {
      autoResize()
      scrollToBottomSoon()
    })

    return {
      messages,
      newMessage,
      status,
      canSend,
      sendMessage,
      inputEl,
      scrollWrap,
      autoResize,
      formatTime,
      statusClass
    }
  }
}
</script>

<style scoped>
/* Smooth list animations */
.slide-fade-enter-active,
.slide-fade-leave-active { transition: all .18s ease; }
.slide-fade-enter-from { opacity: 0; transform: translateY(4px); }
.slide-fade-leave-to   { opacity: 0; transform: translateY(-4px); }
</style>
