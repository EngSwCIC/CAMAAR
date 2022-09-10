<script>
import axios from "axios";
import BarChart from "src/components/BarChart.vue";

function average(arr) {
  return arr.reduce((a, b) => a + b, 0) / arr.length;
}

export default {
  components: {
    BarChart,
  },
  data() {
    return {
      reports: [],
      loaded: false,
    };
  },
  async mounted() {
    this.loaded = false;
    await axios
      .get("http://localhost:3030/cclasses/reports")
      .then((response) => {
        // formata os dados para o gráfico
        this.reports = response.data.map((report) => {
          return {
            label: report.name,
            data: report.survey_questions.likert_scale_questions.map(
              (question) => ({
                label: question.id,
                data: question.answers ? average(question.answers) : 0,
              })
            ),
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
      v-for="(report, index) in reports"
      :key="index"
      :datasets="report"
      class="q-mx-md"
    />
  </div>
</template>
