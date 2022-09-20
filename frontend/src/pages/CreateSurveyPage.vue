<script>
import axios from "axios";
import { ref } from "vue";

import { useRouter } from "vue-router";

export default {
  setup() {
    var courses = ref(null);
    var turma = ref(null);
    var questionFormat = ref(null);
    var questions = ref([]);
    var multiple_choice_array = ref([]);
    const router = useRouter();

    return {
      questionFormat,
      courses,
      turma,
      name_quest: ref(null),
      desc_quest: ref(null),
      questExpirationDate: ref(null),
      semester: ref(null),
      options: ["Eng. Software", "PAA", "APC", "OAC"],
      questions,
      text: ref(""),
      multiple_choice_text: ref(""),
      multiple_choice_array,
      likertRange: ref(null),
      isOptional: ref(null),
      checkbox_model: ref(null),
      ratingModel: 10, // garante que o likert estará sempre full
      surveyModel: {
        name: "",
        description: "",
        role_id: 2,
        expiration_date: "",
        semester: "",
        survey_questions_attributes: [],
      },
      questionForBack: {
        question_number: 0,
        question: "", //enunciado
        question_type_id: 0, // 1 discursive e etc
        optional: false,
        question_options_attributes: [], // multipla escolha
        likert_scale_questions_attributes: [],
      },
      choiceFormat: {
        question: "",
        question_number: 0,
        scale_points: 5,
      },
      questionTypes: [
        {
          suvey_question_id: 1,
          question_type: "discursive",
          content: null,
          label: "Discursiva",
          id: 1,
        },
        {
          survey_question_id: 2,
          question_type: "multiple_choice",
          content: null,
          label: "Multipla Escolha",
          id: 2,
        },
        {
          survey_question_id: 3,
          question_type: "likert_scale",
          content: null,
          label: "Escala",
          id: 3,
        },
      ],
      semesters: ["2021.1", "2021.2", "2022.1", "2022.2"],
      mainEvent(e) {
        var s1 = new Object(this.surveyModel);
        // turmas: ["A", "B", "C"],
        // {
        //   "name": "TESTE DERRADEIRO",
        //   "description": "this is a test survey",
        //   "role_id": 2,
        //   "expiration_date": "Thu, 21 Jun 2028 12:15:50 -0300",
        //   "semester": "2021/2",}

        s1.name = this.text;

        // const s1 = Object.create(this.surveyModel, {
        //   alice: { value: 18, enumerable: true },
        //   bob: { value: 27, enumerable: true },
        // });

        console.error("my object survey 1 : %o", s1);

        console.log("my object questionFormat: %o", {
          ...questionFormat.value,
        });

        var question_obj = new Object();

        question_obj.content = this.text;
        question_obj.label = questionFormat.value.label;
        question_obj.id = questionFormat.value.id;
        question_obj.question_type = questionFormat.value.question_type;
        question_obj.isOptional = this.checkbox_model;

        if (question_obj.question_type == "likert_scale") {
          question_obj.likert_range = this.likertRange;
        }
        if (question_obj.question_type == "multiple_choice") {
          question_obj.multiple_choice_obj = { ...this.multiple_choice_array };
          this.multiple_choice_array = [];
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
      async createData() {
        var aux = new Object(this.surveyModel);
        var question_aux = new Object(this.questionForBack);

        aux.name = this.name_quest;
        aux.description = this.desc_quest;
        aux.semester = this.semester;
        aux.expiration_date = this.questExpirationDate;

        questions.value.forEach(function (item, i) {
          question_aux.optional = item.isOptional;
          question_aux.question = item.content;
          question_aux.question_type_id = item.id;
          aux.survey_questions_attributes.push(question_aux);
        });

        const res = await axios.post("/api/surveys/", aux);

        if (res.status == 200) {
          // await router.push({ path: "/surveys" });
          alert("Deu bom");
        } else {
          alert("Deu ruim");
        }

        return aux;
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
          <q-form class="q-gutter-md">
            <!-- <h3>Selecione a matéria</h3>
            <q-select
              filled
              v-model="courses"
              :options="options"
              label="Selecione a matéria"
            /> -->
            <!-- <h3>Selecione a turma</h3>
            <q-select
              filled
              v-model="turma"
              :options="turmas"
              label="Selecione a turma"
            /> -->

            <h3>Nome do Questionário</h3>
            <q-input
              v-model="name_quest"
              filled
              type="textarea"
              class="form-control"
              data-test-Nome_do_questionário="Nome do questionário"
            />
            <h3>Descrição do Questionário</h3>
            <q-input
              v-model="desc_quest"
              filled
              type="textarea"
              class="form-control"
              data-test-Descrição_do_Questionário="Descrição do Questionário"
            />
            <h3>Data de Expiração do Questionário</h3>
            <q-date 
            data-test-Data_de_Expiração_do_Questionário="Data de Expiração do Questionário"
            v-model="questExpirationDate" minimal />
            <q-select
              filled
              v-model="semester"
              :options="semesters"
              label="Selecione o semestre"
              data-test-Selecione_o_semestre="Selecione o semestre"
            />
            <q-card
              v-for="item in questions"
              class="rounded-border q-pa-xl hsize justify-left text-left"
              :key="item.survey_question_id"
            >
              <div class="text-h6">{{ item.label }}</div>
              <div class="text-subtitle2">{{ item.content }}</div>
              <div v-if="item.multiple_choice_obj">
                <q-list
                  bordered
                  separator
                  v-for="(choice, index) in item.multiple_choice_obj"
                  :key="choice.id"
                >
                  <q-item clickable v-ripple>
                    <q-item-section
                      >Opção {{ Number(index) + 1 }} :
                      {{ choice.content }}</q-item-section
                    >
                  </q-item>
                </q-list>
              </div>

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
            data-test-Selecione_o_tipo_da_questão="Selecione o tipo da questão"         
              />
              <br />

              <input type="checkbox" id="checkbox" v-model="checkbox_model" data-test-Opcional="Opcional" />
              <label for="checkbox"> Opcional </label>
            </div>

            <q-input
              v-model="text"
              filled
              type="textarea"
              class="form-control"
              placeholder="Escreva o enunciado..."
              data-test-Escreva_o_enunciado="Escreva o enunciado"
            />
            <q-card
              v-for="(item, index) in multiple_choice_array"
              class="rounded-border q-pa-xl hsize justify-left text-left"
              :key="item.content"
            >
              <div class="text-subtitle2">
                Opção {{ index + 1 }} : {{ item.content }}
              </div>
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
            <q-btn color="secondary" @click="mainEvent($event)"
            data-test-button-Adicionar_questão="Adicionar questão"
            >
              Adicionar questão
            </q-btn>
            <q-btn color="secondary" @click="cancelQuestEvent($event)"
            data-test-button-Cancelar="Cancelar"
            >
              Cancelar
            </q-btn>
            <q-btn color="secondary" @click="createData($event)"
            data-test-button-Finalizar_Questionário="Finalizar Questionário"
            >
              Finalizar Questionário
            </q-btn>
          </q-form>
        </div>
      </div>
    </div>
  </div>
</template>
