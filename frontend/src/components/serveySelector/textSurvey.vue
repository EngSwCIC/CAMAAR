<script>
export default {
  props: ["answer"],
  mounted() {
    this.resizeTextarea()
    this.$refs.textarea.addEventListener('input', this.resizeTextarea)
  },
  beforeUnmount() {
    this.$refs.textarea.removeEventListener('input', this.resizeTextarea)
  },
  methods: {
    resizeTextarea() {
      this.$refs.textarea.style.height = 'auto'
      this.$refs.textarea.style.height = this.$refs.textarea.scrollHeight + 'px'
    }
  }
};
</script>

<template>
  <textarea ref="textarea"  :value="answer" placeholder="texto de resposta" class="container"></textarea>
</template>

<style scoped>
  .container {
    margin-top: 20px;
    width: 100%;
  }
</style>
