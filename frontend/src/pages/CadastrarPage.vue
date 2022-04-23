<template>
  <div class="rounded-border q-pa-xl justify-center col-12 text-center">
    <h1>Pagina de Registro</h1>
    <q-form ref="Formulario" class="row">
      <q-input class="col-12" v-model="email" placeholder="Digite seu email" label="email" :rules="[valor => !!valor||'Campo obrigatorio']"/>
      <q-input class="col-12" v-model="senha" placeholder="Digite sua senha" label="senha" :rules="[valor => !!valor||'Campo obrigatorio']"/>
    </q-form>
    <q-btn label="Registrar" v-on:click="PostMembers"/>
  </div>
</template>
<script>
  export default {
    name: "CadastrarPage",
    data() {
      return {
        email: null,
        senha: null,
        created_at: Date(),
        updated_at: Date()
      }
    },
    methods: {
      async PostMembers(){
        const Control1 = await this.$refs.Formulario.validate()
        if(Control1) {
          let req = await this.$axios.post("http://localhost:3030/users", {
            email_pessoa: this.email, senha_pessoa: this.senha,
            created_at_pessoa: this.created_at, updated_at_pessoa: this.updated_at
          })
          let Control2 = req.data.user
          if(Control2 != null) {
            await this.$router.push({path: '/'})
          }
          else{
            alert("Nao foi possivel realizar o cadastro")
          }
        }
        else{
          alert("Preencha todos os dados para prosseguir");
        }
      }
    }
  }
</script>
<style scoped>
.rounded-border{
  border-radius: 25px;
}
</style>
