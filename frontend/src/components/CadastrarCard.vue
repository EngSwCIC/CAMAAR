<script setup>
import { ref, reactive } from "vue";
import { useRouter } from 'vue-router'
import {useQuasar} from 'quasar'
import axios from "axios"
const $q = useQuasar()
const router = useRouter()
// data
const form = ref(null)

const users = reactive({
  email: null,
  senha: null,
  created_at: Date(),
  updated_at: Date()
});
const PostMembers = async () =>{
  const Control1 = await form.value.validate()
  if (Control1) {
    try {
      let req = await axios.post("http://localhost:3030/users", {
        email_pessoa: users.email, senha_pessoa: users.senha,
        created_at_pessoa: users.created_at, updated_at_pessoa: users.updated_at
      })
      let Control2 = await req.data.user
      req.data.message
      if (Control2 != null) {
        $q.notify({
          message: req.data.message,
          position: 'top',
          color: 'positive'
        })
        await router.push({path: '/'})
      }
      else{
        $q.notify({
          message: req.data.message,
          position: 'top',
          color: 'negative'
        })
      }
    }
    catch (e) {
      $q.notify({
        message: req.data.message,
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
      <h1 class="text-h3">Formulario de Registro</h1>
      <q-form ref="form" class="q-gutter-sm q-mt-xl row">
        <q-input
          rounded
          outlined
          placeholder="Digite seu email"
          label="E-Mail"
          type="email"
          name="email"
          v-model="users.email"
          class="col-12"
          lazy-rules
          :rules="[val => !!val || 'E-Mail Obrigatório']"
          data-test-email="email"
        ></q-input>
        <q-input
          type="password"
          rounded
          outlined
          placeholder="Digite sua senha"
          label="Senha"
          v-model="users.senha"
          class="col-12"
          :rules="[val => !!val || 'Senha Obrigatória']"
          data-test-senha="senha"
        ></q-input>

		<q-btn
          rounded
          color="secondary"
          class="col-12"
          size="lg"
          @click="PostMembers"
          data-test-button-register="registrar"
        >Efetuar o Registro</q-btn>

		<a href="/#/"><q-btn
          rounded
          color="secondary"
          class="col-12"
          size="lg"
          data-test-button-voltar="voltar"
          >Voltar</q-btn></a>

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
