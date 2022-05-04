<script setup>

  const login = async () =>{
    router.push({path: `/survey/{$route.params.id}`})
  }
  // methods
</script>
<template>
<div class="row">
  <q-card class="my-card">
   <q-card-section class="bg-purple text-white">
        <div class="text-h6">Questionário 1</div>
        <div class="text-subtitle2">por Professor Fulano</div>
      </q-card-section>

      <q-separator></q-separator>

      <q-card-actions align="right">
        <q-btn flat>Editar</q-btn>
        <q-btn 
        flat
        @click="login"
        >Acessar</q-btn>
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
  
.rounded-border{
  border-radius: 25px;
}
</style>
