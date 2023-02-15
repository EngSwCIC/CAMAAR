<script setup>
import { ref, reactive, onMounted } from "vue";
import { useRouter } from 'vue-router'
import { useQuasar } from 'quasar'
import axios from "axios"
const $q = useQuasar()
const router = useRouter()
// data
const form = ref(null)

const users = reactive({
  email: null,
  senha: null,
  senha_confirmacao: null,
  senha_atual: null,
});

onMounted(async () => {
  const res = await axios.get("/api/members/redefine_password/" + router.currentRoute.value.params.redefinition_link)
  users.email = res.data.email
})

const PostMembers = async () => {
  const Control1 = await form.value.validate()
  if (Control1) {
    try {
      let req = await axios.put("/api/auth", {
        "user": {
          "email": users.email, 
          "current_password": users.senha_atual,
          "password": users.senha,
          "password_confirmation": users.senha_confirmacao
        }
      })
      let Control2 = await req.data.user
      req.data.message
      if (Control2 != null) {
        $q.notify({
          message: req.data.message,
          position: 'top',
          color: 'positive'
        })
        await router.push({ path: '/' })
      }
      else {
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
    <q-card class="rounded-border q-pa-xl hsize justify-center col-18 text-center">
      <h1 class="text-h3">Formulario de Redefinição de senha</h1>
      <q-form ref="form" class="q-gutter-sm q-mt-xl row">
        <q-input rounded outlined placeholder="Digite seu email" label="E-Mail" type="email" name="email"
          v-model="users.email" class="col-10" lazy-rules :rules="[val => !!val || 'E-Mail Obrigatório']"
          data-test-email="email" :model-value="users.email" :disable="true"></q-input>
        <q-input type="password" rounded outlined placeholder="Digite senha antiga" label="Senha" v-model="users.senha_atual"
          class="col-10" :rules="[val => !!val || 'Senha Obrigatória']" data-test-senhaantiga="senhaantiga"></q-input>
        <q-input type="password" rounded outlined placeholder="Digite sua nova senha" label="Senha" v-model="users.senha"
          class="col-10" :rules="[val => !!val || 'Senha Obrigatória']" data-test-senhanova="senhanova"></q-input>
        <q-input type="password" rounded outlined placeholder="Confirme a nova senha" label="Senha" v-model="users.senha_confirmacao"
          class="col-10" :rules="[val => !!val || 'Senha Obrigatória']" data-test-senhaconfirmacao="senhaconfirmacao"></q-input>

        <q-btn rounded color="secondary" class="col-12" size="lg" @click="PostMembers"
          data-test-button-register="registrar">Efetuar o Registro</q-btn>

        <a href="/#/"><q-btn rounded color="secondary" class="col-12" size="lg"
            data-test-button-voltar="voltar">Voltar</q-btn></a>

      </q-form>
    </q-card>
  </div>
</template>
<style scoped>
.hsize {
  height: 700px;
}

.rounded-border {
  border-radius: 25px;
}
</style>
