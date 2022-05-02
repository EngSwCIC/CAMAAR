<script setup>
import VueChartkick from 'vue-chartkick'
import 'chartkick/chart.js'
import ProfessorComponent from "src/components/GraficoProfessor.vue";
import ReportDownload from "/src/components/ReportDownload.vue";
import FilteringQuestions from "src/components/FilteringQuestions.vue";
import FilteringCclasses from "src/components/FilteringCclasses.vue";
import FilteringSurveys from "src/components/FilteringSurveys.vue";
</script>

<script>
export default {
  components: { FilteringSurveys, FilteringCclasses, FilteringQuestions },
  data() {
    return {
      isHidden: true,
      api_change: true,
      api_url_child: null,
    };
  },
  methods: {
    toggle() {
      this.isHidden = !this.isHidden;
    },
    api() {
      this.api_change = !this.api_change;
      if (this.api_change) {
        this.api_url_child =
          "https://canvasjs.com/services/data/datapoints.php?length=5&type=json";
      } else {
        this.api_url_child =
          "https://canvasjs.com/services/data/datapoints.php?xstart=1&ystart=1&length=5&type=json";
      }
    },
  },
};
</script>

<template>
  <div>
    <br /><br /><br /><br />
    <center>
      <FilteringCclasses/>
      <FilteringSurveys/>
      <FilteringQuestions/>
      <div class="q-pa-md q-gutter-sm">
        <q-btn
          @click="toggle"
          color="primary"
          label="Mostrar/Ocultar Gráfico"
        />
        <q-btn @click="api" color="primary" label="Mudar API" />
      </div>
      <ReportDownload />
    </center>
    <div v-if="isHidden">
      <GraficoProfessor/>
    </div>
  </div>
</template>

