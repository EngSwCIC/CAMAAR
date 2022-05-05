<script setup>
import VueChartkick from 'vue-chartkick'
import 'chartkick/chart.js'
import ProfessorComponentT1 from "src/components/GraficoProfessorTipo1.vue";
import ProfessorComponentT2 from "src/components/GraficoProfessorTipo2.vue";
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
    },
    updateFilters(filters) {
      this.filters = filters
      console.log('professor page')
      console.log(this.filters)
    },
    api() {
      this.graficoTipo1 = !this.graficoTipo1;
      this.graficoTipo2 = !this.graficoTipo2;

      if (this.graficoTipo1) {
        this.api_url_child =
          "https://canvasjs.com/services/data/datapoints.php?length=5&type=json";
      } else {
        this.api_url_child =
          "https://canvasjs.com/services/data/datapoints.php?xstart=1&ystart=1&length=3&type=json";
      }
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
        <q-btn @click="api" color="primary" label="Mudar API" />
      </div>
      <ReportDownload />
    </center>
    <div v-if="isHidden && graficoTipo1">
      <ProfessorComponentT1 :api_url="api_url_child" :filter_options="filters" />
    </div>
    <div v-if="isHidden && graficoTipo2">
      <ProfessorComponentT2 :api_url="api_url_child" :filter_options="filters" />
    </div>
  </div>
</template>