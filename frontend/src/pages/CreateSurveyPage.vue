<script>
import { ref } from "vue";

export default {
  setup() {
    var courses = ref(null);
    var turma = ref(null);
    var questionFormat = ref(null);
    var questions = ref([]);
    var multiple_choice_array = ref([]);

    return {
      questionFormat,
      courses,
      turma,
      options: ["Eng. Software", "PAA", "APC", "OAC"],
      questions,
      text: ref(""),
      multiple_choice_text: ref(""),
      multiple_choice_array,
      likertRange: ref(null),
      isOptional: ref(null),
      checkbox_model: ref(null),
      ratingModel: 10, // garante que o likert estará sempre full
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
      mainEvent(e) {
        var question_obj = new Object();

        question_obj.content = this.text;
        question_obj.label = questionFormat.value.label;
        question_obj.question_type = questionFormat.value.question_type;
        question_obj.isOptional = this.checkbox_model;

        if (question_obj.question_type == "likert_scale") {
          question_obj.likert_range = this.likertRange;
        }

        questions.value.push(question_obj);

        this.text = "";
      },
      multipleChoiceEvent(e) {
        var multi_quest_obj = new Object();

        multi_quest_obj.content = this.multiple_choice_text;
        multiple_choice_array.value.push(multi_quest_obj);

        this.multiple_choice_text = "";
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
            <q-card
              v-for="item in questions"
              class="rounded-border q-pa-xl hsize justify-left text-left"
              :key="item.survey_question_id"
            >
              <div class="text-h6">{{ item.label }}</div>
              <div class="text-subtitle2">{{ item.content }}</div>

              <div v-if="item.isOptional">
                <input
                  type="checkbox"
                  id="checkbox"
                  v-model="item.isOptional"
                  :disabled="true"
                />
                <label for="checkbox"> Opcional </label>
              </div>

              <q-rating
                v-if="item.question_type == 'likert_scale'"
                v-model="ratingModel"
                size="2em"
                :max="item.likert_range"
                color="primary"
              />
            </q-card>

            <h3>Inserir nova questão</h3>
            <div>
              <q-select
                filled
                v-model="questionFormat"
                :options="questionTypes"
                label="Selecione o tipo da questão"
              />
              <br />

              <input type="checkbox" id="checkbox" v-model="checkbox_model" />
              <label for="checkbox"> Opcional </label>
            </div>

            <q-input
              v-model="text"
              filled
              type="textarea"
              class="form-control"
              placeholder="Escreva o enunciado..."
            />
            <q-card
              v-for="item in multiple_choice_array"
              class="rounded-border q-pa-xl hsize justify-left text-left"
              :key="item.content"
            >
              <div class="text-subtitle2">{{ item.content }}</div>
            </q-card>
            <q-input
              v-if="questionFormat?.question_type == 'multiple_choice'"
              v-model="multiple_choice_text"
              filled
              type="textarea"
              class="form-control"
              placeholder="Escreva a opção..."
            />

            <div v-if="questionFormat?.question_type == 'likert_scale'">
              <q-badge color="secondary">
                Número de Opções da Escala: {{ likertRange }}
              </q-badge>
              <q-slider v-model="likertRange" :min="3" :max="10" />
            </div>

            <q-btn
              v-if="questionFormat?.question_type == 'multiple_choice'"
              color="secondary"
              @click="multipleChoiceEvent($event)"
            >
              Adicionar Opção (multipla escolha)
            </q-btn>
            <q-btn color="secondary" @click="mainEvent($event)">
              Adicionar questão
            </q-btn>
          </q-form>
        </div>
      </div>
    </div>
  </div>
</template>
<!--  v-if="questionFormat.label == 'likert_scale'"
-->
