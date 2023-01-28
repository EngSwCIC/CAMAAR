<script setup>
import { reactive } from "vue";

const title = reactive("Página sem título");
const questions = reactive([]);
const questionsTypes = [
  "Múltipla Escolha",
  "Caixa de Seleção",
  "Texto",
  "Escala Linear",
];

function addQuestion() {
  questions.push({
    title: "",
    type: "Múltipla Escolha",
  });
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

    <div class="bg-blue-1 q-ma-md q-pa-md">
      <q-input v-if="question.type === 'Texto'" label="Text" />
      <q-select v-if="question.type === 'Caixa de Seleção'" label="Select" />
    </div>
  </div>

  <div>
    <q-btn color="secondary" @click="addQuestion">Adicionar Pergunta</q-btn>
    <q-btn color="secondary">Salvar</q-btn>
  </div>
</template>
