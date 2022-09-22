<script>
import { ref } from "vue";
import axios from "axios";
import BarChart from "src/components/BarChart.vue";
import { average, getRandomColor } from "../utils";
import { useQuasar } from "quasar";

export default {
  components: {
    BarChart,
  },
  data() {
    return {
      surveys: [],
      loaded: false,
      surveySelected: ref(null),
      selectSurveyOptions: [],
      semesterSelected: ref("2021.2"),
      selectSemesterOptions: ["2020.1", "2020.2", "2021.1", "2021.2"],
    };
  },
  async mounted() {
    this.getSurveyData(this.semesterSelected);
  },
  watch: {
    semesterSelected: function (newVal, oldVal) {
      this.getSurveyData(newVal);
    },
  },
  methods: {
    getSurveyData(semester) {
      this.loaded = false;
      axios
        .get(`/api/surveys/reports?semester=${semester}`)
        .then((response) => {
          // formata os dados para o gráfico
          this.surveys = response.data.map((survey) => {
            const labels =
              survey.survey_questions[0].likert_scale_questions.map(
                (question) => question.question
              );
            const data = survey.survey_questions[0].likert_scale_questions.map(
              (question) => average(question.answers)
            );

            const randomColors = data.map(() => getRandomColor());

            return {
              title: survey.name,
              labels,
              datasets: [
                {
                  label: survey.name,
                  backgroundColor: randomColors.map((color) => color + "80"), // opacidade
                  borderColor: randomColors,
                  barThickness: 24,
                  borderWidth: 1,
                  data,
                },
              ],
            };
          });

          this.selectSurveyOptions = this.surveys;
          // this.surveySelected = this.selectSurveyOptions[0]; // valor default do select
        });
      this.loaded = true;
    },
  },
};
</script>

<template>
  <div class="bg-secondary fullscreen row items-center justify-center">
    <q-card
      class="card-width rounded-border q-pa-xl justify-center text-center"
    >
      <h1 class="text-h3 q-mt-none">Relatórios</h1>
      <div class="row justify-between selects-gap q-mb-xl">
        <div class="col-4">
          <q-select
            rounded
            outlined
            label="Semestre"
            v-model="semesterSelected"
            :options="selectSemesterOptions"
            option-value="id"
            option-label="title"
          />
        </div>

        <div class="col">
          <q-select
            v-if="loaded && surveys.length > 0"
            rounded
            outlined
            label="Selecione um questionário"
            v-model="surveySelected"
            :options="selectSurveyOptions"
            option-value="id"
            option-label="title"
          />
        </div>
      </div>

      <div
        v-if="!loaded"
        class="row justify-center items-center barChart-height"
      >
        <q-circular-progress
          indeterminate
          rounded
          size="50px"
          color="secondary"
          class="q-ma-md"
        />
      </div>
      <template v-else>
        <template v-if="surveys.length > 0">
          <BarChart
            v-if="surveySelected"
            :chart-data="surveySelected"
            class="q-mx-md"
          />
          <div v-else class="row justify-center items-center barChart-height">
            <p>Nenhum questionário selecionado</p>
          </div>
        </template>
        <div v-else class="row justify-center items-center barChart-height">
          <p>Nenhum questionário encontrado</p>
        </div>
      </template>
    </q-card>
  </div>
</template>

<style>
.card-width {
  width: 100%;
  max-width: 500px;
}
.selects-gap {
  gap: 10px;
}
.barChart-height {
  height: 372px;
}
</style>
