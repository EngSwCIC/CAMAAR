<script>
import { ref } from "vue";
export default {
  setup() {
    var courses = ref(null);
    var turma = ref(null);
    var questionFormat = ref(null);
    var questions = ref([]);
    return {
      questionFormat,
      courses,
      turma,
      options: ["Eng. Software", "PAA", "APC", "OAC"],
      questions,
      text: ref(""),
      turmas: ["A", "B", "C"],
      questionTypes: [
        {
          suvey_question_id: 1,
          question_type: "discursive",
          content: null,
          label: "Discursiva",
          value: 1,
        },
        {
          survey_question_id: 2,
          question_type: "multiple_choice",
          content: null,
          label: "Multipla Escolha",
          value: 2,
        },
        {
          survey_question_id: 3,
          question_type: "likert_scale",
          content: null,
          label: "Escala",
          value: 3,
        },
      ],
      onSubmit(e) {
        console.log("sera que deu certo?", questionFormat.value.label);
        questions.value.push(questionFormat.value);
      },
    };
  },
};
</script>
<template>
  <div class="page" style="min-height: 100vh">
    <div id="q-app" style="min-height: 100vh">
      <div class="q-pa-md row items-start q-gutter-md">
        <q-parallax :height="200" :speed="0.5">
          <template v-slot:media>
            <img
              src="https://braziljournal.s3.amazonaws.com/covers/45b8fd3d-76a8-2c53-a564-83a394cef7f9.jpg?v=1596499602"
            />
          </template>

          <h1 class="text-white">Criação dos Questionários</h1>
        </q-parallax>
        <div class="rounded-border q-pa-xl hsize justify-center col-6">
          <q-form @submit="onSubmit" @reset="onReset" class="q-gutter-md">
            <h3>Selecione a matéria</h3>
            <q-select
              filled
              v-model="courses"
              :options="options"
              label="Selecione a matéria"
            />
            <h3>Selecione a turma</h3>
            <q-select
              filled
              v-model="turma"
              :options="turmas"
              label="Selecione a turma"
            />
            <div v-for="item in questions" :key="item.survey_question_id">
              {{ item.label }} ola
            </div>

            <h3>Inserir nova questão</h3>
            <q-select
              filled
              v-model="questionFormat"
              :options="questionTypes"
              label="Selecione o tipo da questão"
            />

            <q-input v-model="text" filled type="textarea" />
            <q-btn color="secondary" type="submit"> Adicionar questão </q-btn>
          </q-form>
        </div>
      </div>
    </div>
  </div>
</template>
