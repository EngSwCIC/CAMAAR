<script setup>
var filterArg = "";
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
        @click="$emit('filterEvent', filterArg, filterArg = '')"
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
