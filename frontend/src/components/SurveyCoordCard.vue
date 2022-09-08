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
    redirectCreateSurvey() {
      this.router.push({ path: "/surveys/create" });
    },
  },
};
</script>
<template>
  <div class="row">
    <q-card class="rounded-border q-pa-xl hsize justify-center text-center">
      <q-space></q-space>
      <br />
      <div class="text-h5">Menu</div>
      <br />
      <q-btn color="secondary" @click="redirectCreateSurvey">
        Criar Questionários
      </q-btn>
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
