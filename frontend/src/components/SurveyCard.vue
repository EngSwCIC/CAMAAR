<script>
import { useRouter } from "vue-router";
export default {
  props: ["survey"],
  setup() {
    const router = useRouter();

    return {
      router,
    };
  },
  methods: {
    redirect() {
      this.router.push({ path: "/surveys/" + this.survey.id });
    },
  },
};
</script>

<template>
  <div class="row">
    <q-card class="my-card">
      <q-card-section class="bg-purple text-white">
        <div class="text-h5">{{ survey.name }}</div>
        <div class="text-subtitle2">Semestre {{ survey.semester }}</div>
      </q-card-section>

      <q-separator></q-separator>

      <q-card-actions align="right">
        <!-- <q-btn flat>Editar</q-btn> -->
        <q-btn flat @click="redirect">Acessar</q-btn>
      </q-card-actions>
    </q-card>
  </div>
</template>

<style scoped>
.hsize {
  height: 500px;
}
.my-card {
  width: 100%;
  max-width: 250px;
}

.rounded-border {
  border-radius: 25px;
}
</style>
