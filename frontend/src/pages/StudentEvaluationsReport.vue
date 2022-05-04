<template>
  <div fullscreen>
    <h3>Avaliações dos alunos</h3>
    <!-- passar as disciplinas para o componente filho e mostrar na tela -->
    <FiltroRAluno @filterEvent="filterItems" />
    <StudentSubjectItem
      v-for="(subject, idx) in subjects"
      v-bind:key="idx"
      :subject="subject"
      :subject_classes="getClasses(subject)"
    />
  </div>
</template>

<script setup>
import FiltroRAluno from "src/components/FiltroRAluno.vue";
import StudentSubjectItem from "src/components/StudentSubjectItem.vue";
import { ref, onMounted } from "vue";
import axios from "axios";

const subjects = ref([]);
const classes = ref([]);
onMounted(async () => {
  // obter lista de disciplinas do backend
  await axios
    .get("http://localhost:3030/subjects")
    .then((resp) => {
      subjects.value = resp.data;
    })
    .catch((err) => {
      console.error(err);
    });

  // obter lista de todas as turmas
  await axios
    .get("http://localhost:3030/cclasses")
    .then((resp) => {
      classes.value = resp.data;
    })
    .catch((err) => {
      console.error(err);
    });
});

// retorna as turmas da disciplina
const getClasses = (subject) =>
  classes.value.filter((cclass) => cclass.subject_id === subject.id);

const filterItems = async (filterArg) => {
  filterArg = filterArg.toLowerCase().trim();
  await axios
    .get("http://localhost:3030/subjects/")
    .then((resp) => {
      subjects.value = resp.data;
      //Faz o filtro pelo nome e código da disciplina
      if (filterArg != "") {
        subjects.value = subjects.value.filter(
          (value) =>
            value.name.toLowerCase().indexOf(filterArg) !== -1 ||
            value.code.toLowerCase().indexOf(filterArg) !== -1 ||
            value.id == filterArg
        );
      } else {
        subjects.value = resp.data;
      }
    })
    .catch((err) => {
      console.error(err);
    });
};
</script>

<style>
h3 {
  padding: 0;
  font-size: 2.5em;
  font-weight: 500;
  margin: 64px;
  margin-bottom: 32px;
}
</style>
