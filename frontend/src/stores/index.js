// stores/index.js
import { defineStore } from 'pinia'

export const useEmailStore = defineStore('emailAddress', {
    state: () => ({ email: "" }),
})

export const useJobStore = defineStore('jobId', {
    state: () => ({ jobId: "" }),
})
