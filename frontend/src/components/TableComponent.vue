<template>
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
export default {
  data() {
    return {
      filteredAnswers: [],
      questionAnswers: [],
      resposta: null,
      columns: [],
    };
  },
};
</script>
