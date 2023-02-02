<script setup>
import { reactive, ref } from "vue";
import CheckboxComponent from "src/components/CheckboxComponent.vue";
import { v4 as uuidv4 } from "uuid";

const title = ref("Página sem título");
const questions = reactive([]);
const questionsTypes = [
  "Múltipla Escolha",
  "Caixa de Seleção",
  "Texto",
  "Escala Linear",
];

function addQuestion() {
  const newQuestion = {
    id: uuidv4(),
    title: "",
    type: "Caixa de Seleção",
    data: {
      checkboxes: [],
    },
  };

  questions.push(newQuestion);
}
function deleteQuestion(index) {
  questions.splice(index, 1);
}

function addCheckbox(label, questionId) {
  const questionIndex = questions.findIndex(
    (question) => question.id === questionId
  );

  questions[questionIndex].data.checkboxes.push(label);
}
</script>

<template>
  <header>
    <q-input v-model="title" type="text" />
  </header>

  <div
    v-for="(question, index) in questions"
    :key="index"
    class="q-ma-md q-pa-sm bg-purple-1"
  >
    <q-input type="text" v-model="question.title" label="Titulo da Pergunta" />
    <q-select
      v-model="question.type"
      :options="questionsTypes"
      label="Tipo da Pergunta"
    />

    <div>
      <q-btn color="secondary" icon="delete" @click="deleteQuestion(index)" />
    </div>

    <div class="bg-blue-1 q-ma-md q-pa-md">
      <CheckboxComponent
        v-if="question.type === 'Caixa de Seleção'"
        :items="question.data.checkboxes"
        :id="question.id"
        :addItem="addCheckbox"
      />
      <q-input v-if="question.type === 'Texto'" label="Text" />
    </div>
  </div>

  <div>
    <q-btn color="secondary" @click="addQuestion">Adicionar Pergunta</q-btn>
    <q-btn color="secondary">Salvar</q-btn>
  </div>
</template>
