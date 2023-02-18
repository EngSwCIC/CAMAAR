// Código que cria componente pai (surveySelectorComponent) referente à criação de questionários.  
// Tal componente é reponsável por renderizar as componentes relacionadas ao tipo de pergunta 
// desejada e selecionada pelo usuario (TextSurvey, RadioSurvey, CheckboxSurvey ou LinearScaleSurvey). 
// O método typeChange emite um evento para informar ao componente pai as informações referente ao tipo 
// da pergunta e o seu respectivo titulo sempre que estes são atualizados. Já o método getAnswer, 
// pega as respostas das outras componentes.

<script>
import TextSurvey from "./textSurvey.vue";
import RadioSurvey from "./radioSurvey.vue";
import CheckboxSurvey from "./checkboxSurvey.vue";
import LinearScaleSurvey from "./linearScaleSurvey.vue";

export default {
  components: {
    TextSurvey,
    CheckboxSurvey,
    RadioSurvey,
    LinearScaleSurvey
  },

  emits: ["surveyAnswer"],

  methods: {
    getAnswer: function (answer) {
      this.$emit("surveyAnswer", {
        questionTitle: this.questionTitle,
        selectedType: this.selectedType,
        answer: answer,
      })
    },
    typeChange: function () {
      this.$emit("surveyAnswer", {
        questionTitle: this.questionTitle,
        selectedType: this.selectedType,
        answer: "",
      })
    }
  },
  mounted() {
    this.$emit("surveyAnswer", {
      questionTitle: this.questionTitle,
      selectedType: this.selectedType,
      answer: "",
    })
  },

  data() {
    return {
      questionTitle: "",
      selectedType: "text",
      options: [
        { value: "text", label: "Texto" },
        { value: "radio", label: "Caixa de seleção" },
        { value: "checkbox", label: "Múltipla escolha" },
        { value: "linear", label: "Escala linear" },
      ],
    }
  }
};
</script>

<template>
  <div class="card">
    <div class="header">
      <input type="text" v-model="questionTitle" placeholder="Pergunta sem título" class="title" @input="typeChange" />
      <select v-model="selectedType" class="selectMenu" @change="typeChange">
        <option v-for="{ label, value } in options" :key="value" :value="value">{{ label }}</option>
      </select>
    </div>
    <TextSurvey v-if="selectedType === options[0].value" />
    <RadioSurvey v-else-if="selectedType === options[1].value" @answer="getAnswer" />
    <CheckboxSurvey v-else-if="selectedType === options[2].value" @answer="getAnswer" />
    <LinearScaleSurvey v-else-if="selectedType === options[3].value" @answer="getAnswer"/>
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
  margin-bottom: 20px;
}

.title {
  width: 50%;
  border: none;
  outline: none;
  font-size: 20px;
  font-weight: 500;
  color: #333;
  margin-right: 20px;
}

.selectMenu {
  width: 30%;
  border: none;
  outline: none;
  font-size: 16px;
  font-weight: 500;
  color: #333;
  background: #f2f2f2;
  padding: 10px;
  border-radius: 10px;
}

</style>
