<script setup>
import axios from "axios";
import { onMounted, ref } from "vue";
import { useRoute } from "vue-router";

const route = useRoute();

let rows = ref([]);
let columns = ref([]);
let average_rows = ref([]);

onMounted(async () => {
  await axios
    .get(`/api/cclasses/${route.params.id}/answers`)
    .then((res) => {
      columns.value = res.data.columns.map((column) => {
        return {
          name: column,
          label: column,
          field: column,
          align: "center",
          sortable: true,
        };
      });
      rows.value = res.data.rows;
      average_rows.value = res.data.average_rows;
    })
    .catch((err) => {
      console.error(err);
    });
});
</script>

<template>
  <div class="q-pa-md">
    <q-table
      title="Média das avaliações"
      :rows="average_rows"
      :columns="columns"
      row-key="name"
      dense
      :rows-per-page-options="[0]"
    />
  </div>
  <div class="q-pa-md">
    <q-table
      title="Avaliação dos Estudantes"
      :rows="rows"
      :columns="columns"
      row-key="name"
      dense
      :rows-per-page-options="[15, 30, 50, 0]"
    />
  </div>
</template>
