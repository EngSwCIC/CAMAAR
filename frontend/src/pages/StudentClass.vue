<template>
  <div class="q-pa-md">
    <q-table
        title="Média das avaliações"
        :rows="rowsAverage"
        :columns="columnsAverage"
        row-key="name"
    />
  </div>
  <div class="q-pa-md">
    <q-table
        title="Avaliação dos Estudantes"
        :rows="rows"
        :columns="columns"
        row-key="name"
    />
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      questionAnswers: []
    };
  },
  created() {
    const id = this.$route.params.id;
    axios
      .get(`api/surveys/1/answers`)
      .then(response => {
        this.questionAnswers = response.data;
      })
      .catch(error => {
        console.error(error);
      });
  }
};
</script>