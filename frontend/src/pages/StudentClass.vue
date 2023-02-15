
<template>
  <h4>Media das avaliações</h4>
  <table class="table-bordered">
    <tr>
      <th v-for="(column, index) in columns" :key="index">{{ column }}</th>
    </tr>
    <tr v-for="(row, key) in filteredAverage" :key="key">
      <td>{{ key }}</td>
      <td v-for="(value, index) in row" :key="index">{{ value }}</td>
    </tr>
  </table>
  <h4>Avaliação dos Estudantes</h4>
  <table class="table-bordered">
    <tr>
      <th v-for="(column, index) in columns" :key="index">{{ column }}</th>
    </tr>
    <tr v-for="(row, key) in resposta" :key="key">
      <td>{{ key }}</td>
      <td v-for="(value, index) in row" :key="index">{{ value }}</td>
    </tr>
  </table>
</template>

<script>
import axios from 'axios';
export default {
  data() {
    return {
      filteredAverage: [],
      questionAnswers: [],
      resposta: null,
      columns: [],
    };
  },
  created() {
    this.getAnswers()
  },
  methods: {
    async getAnswers() {
      try {
        const id = this.$route.params.id;
        const response = await axios.get(`api/surveys/1/answers`);
        this.questionAnswers = response.data
        this.organizeAnswers(response.data)
      } catch (error) {
        console.error(error);
      }
    },

    organizeAnswers(answers) {
    return answers.reduce((acc, curr) => {
      if (!acc[curr.survey_question_id]) {
        acc[curr.survey_question_id] = [];
      }
      acc[curr.survey_question_id].push(curr.answer);
      this.resposta = acc
      //segundo commit porque mandei errado na branch 2
      this.filteredResult();
      return acc;
    }, {});
  },
  filteredResult() {
      let filteredResult = {};

      for (const key in this.resposta) {
        if (Array.isArray(this.resposta[key])) {
          let values = this.resposta[key];

          if (this.isNumeric(values[0])) {
            let sum = values.reduce((a, b) => parseFloat(a) + parseFloat(b), 0);
            let avg = sum / values.length;
            filteredResult[key] = [parseFloat(avg).toFixed(2).toString()];
          } else if (typeof values[0] === "string") {
            let frequency = {};
            let maxFrequency = 0;
            let mode = [];

            values.forEach(value => {
              if (frequency[value]) {
                frequency[value]++;
              } else {
                frequency[value] = 1;
              }

              if (frequency[value] > maxFrequency) {
                maxFrequency = frequency[value];
                mode = [value];
              } else if (frequency[value] === maxFrequency) {
                mode.push(value);
              }
            });

            filteredResult[key] = mode;
          }
        }
      }
      console.log(filteredResult)
      this.filteredAverage = filteredResult
      return filteredResult;
    },
    
    isNumeric(value) {
    return !isNaN(parseFloat(value)) && isFinite(value);
  }
  }
};

</script>
<style>
table {
  width: 100%;
  margin: 20px 0;
  border-collapse: collapse;
  text-align: center;
}

th, td {
  border: 1px solid #ddd;
  padding: 8px;
}

th {
  background-color: #ddd;
  font-weight: bold;
}

tr:nth-child(even) {
  background-color: #f2f2f2;
}
</style>

