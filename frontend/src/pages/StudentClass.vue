<script setup>
import axios from "axios";
import {
  BarElement,
  CategoryScale,
  Chart as ChartJS,
  Legend,
  LinearScale,
  Title,
  Tooltip,
} from "chart.js";
import { onMounted, ref } from "vue";
import { Bar } from "vue-chartjs";
import { useRoute } from "vue-router";

ChartJS.register(
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale
);

const route = useRoute();

let rows = ref([]);
let columns = ref([]);
let average_rows = ref([]);
let charts = ref([]);

onMounted(async () => {
  await axios
    .get(`/api/cclasses/${route.params.id}/answers`)
    .then((res) => {
      columns.value = res.data.columns.map((column) => {
        return {
          name: column,
          label: column,
          field: column,
          align: "center",
          sortable: true,
        };
      });
      rows.value = res.data.rows;
      average_rows.value = res.data.average_rows;
      charts.value = formatCharts(res.data.charts);
    })
    .catch((err) => {
      console.error(err);
    });
});

const formatCharts = (charts) => {
  return charts.map(({ labels, data, question }) => {
    return {
      question,
      labels,
      datasets: [
        {
          data,
          backgroundColor: "#9c27b0",
          label: "",
        },
      ],
    };
  });
};

const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
};
</script>

<template>
  <div class="q-pa-md">
    <q-table
      title="Média das avaliações"
      :rows="average_rows"
      :columns="columns"
      row-key="name"
      dense
      :rows-per-page-options="[0]"
    />
  </div>
  <div class="q-pa-md">
    <q-table
      title="Avaliação dos Estudantes"
      :rows="rows"
      :columns="columns"
      row-key="name"
      dense
      :rows-per-page-options="[15, 30, 50, 0]"
    />
  </div>

  <div
    v-for="chart in charts"
    v-bind:key="chart.datasets.label"
    class="chart-container"
  >
    <p class="chart-title">{{ chart.question }}</p>
    <Bar
      :chart-data="chart"
      :chart-id="s"
      cssClasses="chart"
      dataset-id-key="label"
      :chart-options="chartOptions"
    />
  </div>
</template>

<style scoped>
.chart-container {
  padding: 2rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
  border-bottom: 1px solid gray;
}

.chart-title {
  display: inline-block;
  align-self: flex-start;
  font-size: 1.1rem;
}
</style>
