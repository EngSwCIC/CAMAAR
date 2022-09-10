<script>
import { Bar } from "vue-chartjs";
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
} from "chart.js";

ChartJS.register(
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale
);

export default {
  name: "BarChart",
  components: { Bar },
  props: ["datasets"],
  data() {
    return {
      chartData: {
        labels: this.datasets.data.map((dataset) => dataset.label),
        datasets: [
          {
            data: this.datasets.data.map((dataset) => dataset.data),
            label: this.datasets.label,
            backgroundColor: "#9C27B0",
          },
        ],
      },
    };
  },
};
</script>

<template>
  <Bar :chart-data="chartData" />
</template>
