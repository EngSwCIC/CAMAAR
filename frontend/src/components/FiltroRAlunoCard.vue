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
    <q-card
      class="rounded-border q-pa-xl hsize justify-center col-12 text-center"
    >
      <h1 class="text-h3">Pesquisa/Filtro</h1>
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
    </q-card>
  </div>
</template>

<style scoped>
.hsize {
  height: 500px;
}
.rounded-border {
  border-radius: 25px;
}
</style>