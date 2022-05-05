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
      this.router.push({ path: "/surveys" });
    },
  },
};
</script>
<template>
  <div class="row">
    <q-card
      class="rounded-border q-pa-xl hsize justify-center col-12 text-center"
    >
      <div>
        <q-avatar size="100px">
          <img src="https://cdn.quasar.dev/img/avatar.png" />
        </q-avatar>
      </div>
      <q-space></q-space>
      <q-separator></q-separator>
      <div class="text-h5">Usuário</div>
      <q-btn color="secondary" @click="redirect"
        >Vá para os seus questionários</q-btn
      >
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
