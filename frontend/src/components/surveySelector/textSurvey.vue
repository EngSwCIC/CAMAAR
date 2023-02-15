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
  width: 100%;
  border: none;
  outline: none;
  resize: none;
  padding: 10px;
  font-size: 16px;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
}
</style>
