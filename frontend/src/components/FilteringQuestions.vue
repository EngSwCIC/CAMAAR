<template>
<div class="card text-center m-3">
    <q-btn-dropdown color="pink" label="Escolher código do Questionário" dropdown-icon="change_history">
      <q-list v-for="item in questionss" :key="item.id">
        <q-item clickable v-close-popup >
            <q-item-section>
                <q-item-label> {{ item['id'] }}</q-item-label>
            </q-item-section>
        </q-item>
      </q-list>
    </q-btn-dropdown>
</div>
</template>

<script>
export default {
  name: "filtering-questions",
  data() {
    return {
      questionss: null
    };
  },
  async created() {
    const response = await fetch("http://127.0.0.1:3000/questions");
    this.questionss = await response.json();
  }
};
</script>