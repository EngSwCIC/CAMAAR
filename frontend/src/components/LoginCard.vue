<script setup>
  import { ref, reactive } from "vue";
  import { credentialsStore } from "@/stores/credentials";
  import {useQuasar} from 'quasar'

  const credentials = credentialsStore();
  const $q = useQuasar()

  const { authenticate } = credentials;

  // data
  const form = ref(null)

  const user = reactive({
    email: null,
    password: null,
  });

  // methods
  const login = async () =>{
    const isValid = await form.value.validate()
    if(isValid){
      try {
        await authenticate(user);
      } catch (e) {
        console.error(e);
          $q.notify({
          message: 'Falha ao fazer login.',
          position: 'top',
          color: 'negative'
        })
      }
    }
  }
</script>
<template>
<div class="row">
  <q-card class="rounded-border q-pa-xl hsize justify-center col-12 text-center">
    <h1 class="text-h3">Login</h1>
    <q-form ref="form" class="q-gutter-sm q-mt-xl row">
      <q-input
        rounded
        outlined
        label="E-Mail"
        v-model="user.email"
        class="col-12"
        :rules="[val => !!val || 'E-Mail Obrigatório']"
        data-test-email="email"
      ></q-input>
      <q-input
        type="password"
        rounded
        outlined
        label="Senha"
        v-model="user.password"
        class="col-12"
        :rules="[val => !!val || 'Senha Obrigatório']"
        data-test-senha="senha"
      ></q-input>
      <q-btn
        rounded
        color="secondary"
        class="col-12"
        size="lg"
        @click="login"
        data-test-button-login="login"
      >Entrar</q-btn>
    </q-form>
  </q-card>
</div>
</template>

<style scoped>
.hsize {
  height: 500px;
}
.rounded-border{
  border-radius: 25px;
}
</style>
