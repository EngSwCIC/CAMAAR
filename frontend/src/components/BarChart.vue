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
  props: ["datasets", "title"],
  data() {
    return {
      chartData: this.datasets,
      chartOptions: {
        responsive: true,
        scales: {
          x: {
            ticks: {
              display: false,
            },
            grid: {
              display: false,
            },
          },
          y: {
            beginAtZero: true,
            suggestedMax: 5,
          },
        },
        plugins: {
          legend: {
            display: false,
          },
          title: {
            display: true,
            text: this.title,
          },
          tooltip: {
            callbacks: {
              /**
               * texto da tooltip acaba dando overflow no gráfico
               * esse é o workaround para quebrarmos a linha e limitar o width
               */
              title: function (context) {
                const words = context[0].label.split(" ");
                const label = [];
                let line = "";

                words.forEach((word) => {
                  if (line.length + word.length < 40) {
                    line += word + " ";
                  } else {
                    label.push(line);
                    line = word + " ";
                  }
                });
                label.push(line);

                return label;
              },
            },
          },
        },
      },
    };
  },
};
</script>

<template>
  <Bar :chart-data="chartData" :chart-options="chartOptions" />
</template>
