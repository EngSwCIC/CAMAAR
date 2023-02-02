<script>
export default {
  props: ["title", 'type'],

  data() {
    return {
      questionTitle: "",
      selectedType: "text",
      options: [
        { value: "text", label: "Texto" },
        { value: "radio", label: "Múltipla escolha" },
        { value: "checkbox", label: "Caixa de seleção" },
        { value: "linear", label: "Escala linear" },
      ]
    }
  }
};
</script>

<template>
  <div class="card">
    <div class="header">
      <input type="text" v-model="questionTitle" placeholder="Pergunta sem título" />
      <select v-model="selectedType">
        <option v-for="{ label, value } in options" :key="value" :value="value">{{ label }}</option>
      </select>
    </div>
    <component :is="selectedType" />
  </div>
</template>

<style scoped>
.card {
  width: 100%;
  padding: 20px;
  background: white;
  border-radius: 20px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
}

.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
</style>
