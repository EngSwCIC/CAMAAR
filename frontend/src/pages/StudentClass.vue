<template>
  <div class="q-pa-md">
    <q-table
        title="Média das avaliações"
        :rows="rowsAverage"
        :columns="columnsAverage"
        row-key="name"
    />
  </div>
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
      filteredAnswers: [],
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
      return acc;
    }, {});
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

