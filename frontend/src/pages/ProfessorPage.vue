<script setup>
import VueChartkick from 'vue-chartkick'
import 'chartkick/chart.js'
import ProfessorComponentT1 from "src/components/GraficoProfessorTipo1.vue";
import ReportDownload from "/src/components/ReportDownload.vue";
import FilteringCclasses from "src/components/FilteringCclasses.vue";
</script>

<script>
export default {
  components: { FilteringCclasses },
  data() {
    return {
      isHidden: true,
      graficoTipo1: true,
      graficoTipo2: false,
      api_change: true,
      api_url_child: null,
      filters: {}
    };
  },
  methods: {
    toggle() {
      this.isHidden = !this.isHidden;
      this.api()
    },
    updateFilters(filters) {
      this.filters = filters
    },
    api() {
      this.graficoTipo1 = true
      this.api_url_child = `http://127.0.0.1:3000/reports?question_id=${this.filters.questionss}`
    },
  },
};
</script>

<template>
  <div>
    <br /><br /><br /><br />
    <center>
      <FilteringCclasses :updateFilters="updateFilters" />
      <div class="q-pa-md q-gutter-sm">
        <q-btn
          @click="toggle"
          color="primary"
          label="Mostrar/Ocultar Gráfico"
        />
      </div>
      <ReportDownload />
    </center>
    <div v-if="isHidden && graficoTipo1">
      <ProfessorComponentT1 :api_url="api_url_child" :filter_options="filters" />
    </div>
  </div>
</template>