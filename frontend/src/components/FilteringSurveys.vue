<template>
<div class="card text-center m-3">
    <q-btn-dropdown color="pink" label="Escolher código do Questionário" dropdown-icon="change_history">
      <q-list v-for="item in totalId" :key="item.id">
            <q-list v-for="itemx in item" :key="itemx.id">
                <q-item clickable v-close-popup >
                <q-item-section>
                    <q-item-label> {{ itemx['attributes']['code'] }}</q-item-label>
                </q-item-section>
                </q-item>
            </q-list>
      </q-list>
    </q-btn-dropdown>
</div>
</template>

<script>
export default {
  name: "filtering-surveys",
  data() {
    return {
      totalId: null
    };
  },
  async created() {
    // GET request using fetch with async/await
    const response = await fetch("http://127.0.0.1:3000/surveys");
    this.totalId = await response.json();
  }
};
</script>