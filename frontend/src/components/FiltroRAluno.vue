<script setup>
import { ref, onMounted } from "vue";
import axios from "axios";
const filterArg = "";
// methods
const filter = async (filterArg) => {
  const subjects = ref(["a"]);
  await axios
    .get("http://localhost:3030/subjects/")
    .then((resp) => {
      subjects.value = resp.data;
      //Faz o filtro pelo nome e código da disciplina
     subjects.value.filter(
        (value) =>
          value.name.toLowerCase().indexOf(filterArg.toLowerCase()) !== -1
          ||
           value.code.toLowerCase().indexOf(filterArg.toLowerCase()) !== -1
      )
      filterArg = "";
    })
    .catch((err) => {
      console.error(err);
    });
};
</script>

<template>
  <div class="row">
    <q-form ref="form" class="q-gutter-sm q-mt-xl row">
      <q-input
        rounded
        outlined
        label="pesquisa"
        type="pesquisa"
        v-model="filterArg"
      ></q-input>
      <q-btn
        rounded
        color="secondary"
        class="col-12"
        size="lg"
        @click="filter(filterArg)"
        data-test-button-filtro="filtro"
        >Filtro</q-btn
      >
    </q-form>
  </div>
</template>

<style scoped>
  .q-form {
    width: 100%;
    margin: 0 64px 24px 64px;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
  }

  .q-input {
    width: 85%;
    margin: 0;
  }

  .q-btn {
    width: 100px;
    margin: 0;
  }
</style>
