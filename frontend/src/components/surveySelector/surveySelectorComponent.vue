<script>
import TextSurvey from "./textSurvey.vue";
import RadioSurvey from "./radioSurvey.vue";

export default {
  props: ["title"],
  components: {
    TextSurvey,
    RadioSurvey,
  },

  data() {
    return {
      questionTitle: "",
      selectedType: "text",
      options: [
        { value: "text", label: "Texto" },
        { value: "checkbox", label: "Múltipla escolha" },
        { value: "radio", label: "Caixa de seleção" },
        { value: "linear", label: "Escala linear" },
      ],
      answerValue: "",
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
    <TextSurvey v-if="selectedType === options[0].value" :answer="answerValue" />
    <!-- <TextSurvey v-else-if="selectedType === options[1].value" /> -->
    <RadioSurvey v-else-if="selectedType === options[2].value"/>
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
