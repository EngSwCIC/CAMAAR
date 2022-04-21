<template>
  <div class="q-pa-md">
    <q-table
        title="Students Evaluation"
        :rows="props.rows"
        :columns="columns"
        row-key="name"
    />
  </div>
</template>

<script setup>

const props = defineProps({
  id: Number,
  rows: Array
})

const columns = [
  { name: 'student', label: 'Aluno', field: row => row.student, format: val => `${val}`, sortable: true },
  { name: 'question1', align: 'center', label: 'Questão 1', field: 'question1', sortable: true },
  { name: 'question2', align: 'center', label: 'Questão 2', field: 'question2', sortable: true },
  { name: 'question3', align: 'center', label: 'Questão 3', field: 'question3', sortable: true },
  { name: 'question4', align: 'center', label: 'Questão 4', field: 'question4', sortable: true },
  { name: 'question5', align: 'center', label: 'Questão 5', field: 'question5', sortable: true },
  { name: 'question6', align: 'center', label: 'Questão 6', field: 'question6', sortable: true },
  { name: 'question7', align: 'center', label: 'Questão 7', field: 'question7', sortable: true },
  { name: 'question8', align: 'center', label: 'Questão 8', field: 'question8', sortable: true },
  { name: 'question9', align: 'center', label: 'Questão 9', field: 'question9', sortable: true },
  { name: 'question10', align: 'center', label: 'Questão 10', field: 'question10', sortable: true },
  { name: 'question11', align: 'center', label: 'Questão 11', field: 'question11', sortable: true },
  { name: 'question12', align: 'center', label: 'Questão 12', field: 'question12', sortable: true },
  { name: 'question13', align: 'center', label: 'Questão 13', field: 'question13', sortable: true },
  { name: 'question14', align: 'center', label: 'Questão 14', field: 'question14', sortable: true }]
//
//
// const rows = [
//   {
//     student: 'Maria',
//     question1: 1,
//     question2: 2,
//     question3: 3,
//     question4: 4,
//     question5: 5,
//     question6: 3,
//     question7: 2,
//     question8: 4,
//     question9: 1,
//     question10: 2,
//     question11: 5,
//     question12: 3,
//     question13: 4,
//     question14: 1
//   },
//   {
//     student: 'Duda',
//     question1: 1,
//     question2: 2,
//     question3: 3,
//     question4: 4,
//     question5: 5,
//     question6: 3,
//     question7: 2,
//     question8: 4,
//     question9: 1,
//     question10: 2,
//     question11: 5,
//     question12: 3,
//     question13: 4,
//     question14: 1
//   },
//   {
//     student: 'Cleude',
//     question1: 1,
//     question2: 2,
//     question3: 3,
//     question4: 4,
//     question5: 5,
//     question6: 3,
//     question7: 2,
//     question8: 4,
//     question9: 1,
//     question10: 2,
//     question11: 5,
//     question12: 3,
//     question13: 4,
//     question14: 1
//   },
//   {
//     student: 'Jertrudes',
//     question1: 1,
//     question2: 2,
//     question3: 3,
//     question4: 4,
//     question5: 5,
//     question6: 3,
//     question7: 2,
//     question8: 4,
//     question9: 1,
//     question10: 2,
//     question11: 5,
//     question12: 3,
//     question13: 4,
//     question14: 1
//   },
//   {
//     student: 'Lubas',
//     question1: 1,
//     question2: 2,
//     question3: 3,
//     question4: 4,
//     question5: 5,
//     question6: 3,
//     question7: 2,
//     question8: 4,
//     question9: 1,
//     question10: 2,
//     question11: 5,
//     question12: 3,
//     question13: 4,
//     question14: 1
//   },
//   {
//     student: 'Otavio',
//     question1: 1,
//     question2: 2,
//     question3: 3,
//     question4: 4,
//     question5: 5,
//     question6: 3,
//     question7: 2,
//     question8: 4,
//     question9: 1,
//     question10: 2,
//     question11: 5,
//     question12: 3,
//     question13: 4,
//     question14: 1
//   },
//   {
//     student: 'Paulo Otavio',
//     question1: 1,
//     question2: 2,
//     question3: 3,
//     question4: 4,
//     question5: 5,
//     question6: 3,
//     question7: 2,
//     question8: 4,
//     question9: 1,
//     question10: 2,
//     question11: 5,
//     question12: 3,
//     question13: 4,
//     question14: 1
//   },
//   {
//     student: 'Janaina',
//     question1: 1,
//     question2: 2,
//     question3: 3,
//     question4: 4,
//     question5: 5,
//     question6: 3,
//     question7: 2,
//     question8: 4,
//     question9: 1,
//     question10: 2,
//     question11: 5,
//     question12: 3,
//     question13: 4,
//     question14: 1
//   }
// ]
</script>

