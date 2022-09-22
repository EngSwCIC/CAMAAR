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
      selectOptions: [],
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

      this.selectOptions = this.surveys;
      // this.surveySelected = this.selectOptions[0]; // valor default do select
    });
    this.loaded = true;
  },
  methods: {
    onChange(value) {
      // console.log(this.surveySelected);
      // this.$forceUpdate();
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
      label="Selecione um questionário"
      v-model="surveySelected"
      :options="selectOptions"
      option-value="id"
      option-label="title"
      @update:model-value="onChange"
    />

    <BarChart
      v-if="surveySelected"
      :chart-data="surveySelected"
      class="q-mx-md"
    />
    <p v-else>Nenhuma opção selecionada</p>
  </div>
</template>
