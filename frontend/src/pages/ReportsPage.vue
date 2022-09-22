<script>
import { ref } from "vue";
import axios from "axios";
import BarChart from "src/components/BarChart.vue";
import { average, getRandomColor } from "../utils";

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
  <div
    v-if="loaded"
    class="bg-white fullscreen row items-center justify-center"
  >
    <q-select
      rounded
      outlined
      label="Selecione um semestre"
      v-model="semesterSelected"
      :options="selectSemesterOptions"
      option-value="id"
      option-label="title"
    />

    <q-select
      v-if="surveys.length > 0"
      rounded
      outlined
      label="Selecione um questionário"
      v-model="surveySelected"
      :options="selectSurveyOptions"
      option-value="id"
      option-label="title"
    />

    <template v-if="surveys.length > 0">
      <BarChart
        v-if="surveySelected"
        :chart-data="surveySelected"
        class="q-mx-md"
      />
      <q-p v-else>Nenhuma opção selecionada</q-p>
    </template>
    <q-p v-else>Nenhum questionário encontrado</q-p>
  </div>
</template>
