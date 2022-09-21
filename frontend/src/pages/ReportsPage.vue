<script>
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
    };
  },
  async mounted() {
    this.loaded = false;
    await axios.get("/api/surveys/reports").then((response) => {
      // formata os dados para o gráfico
      this.surveys = response.data.map((survey) => {
        const labels = survey.survey_questions[0].likert_scale_questions.map(
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
    });
    this.loaded = true;
  },
};
</script>

<template>
  <div
    v-if="loaded"
    class="bg-white fullscreen row items-center justify-center"
  >
    <BarChart
      v-for="(survey, index) in surveys"
      :key="index"
      :datasets="survey"
      :title="survey.title"
      class="q-mx-md"
    />
  </div>
</template>
