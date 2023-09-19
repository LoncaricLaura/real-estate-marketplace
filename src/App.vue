<script setup>
import Header from './components/Header.vue'
</script>

<template>
  <div class="flex flex-col h-screen">
    <Header />
    <router-view/>
  </div>
</template>

<script>
export default {
  componenst: {
    Header
  }
}
</script>

<style scoped>
#app {
  background: #3C3C3C;
  height: 100%;
}
</style>
