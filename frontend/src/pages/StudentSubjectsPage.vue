<template>
  <div>
    <h1>subjects:</h1>
    <!-- passar as disciplinas para o componente filho e mostrar na tela -->
    <StudentSubjectItem v-for="(subject, idx) in subjects" v-bind:key="idx" :subject="subject" />
  </div>
</template>

<script setup>
  import StudentSubjectItem from 'src/components/StudentSubjectItem.vue'
  import { ref, onMounted } from 'vue';
  import axios from "axios";

  // obter lista de disciplinas do backend
  const subjects = ref(["a"])
  onMounted(async () => {
    await axios.get("http://localhost:3030/subjects/index")
      .then(resp => {
        subjects.value = resp.data
      })
      .catch(err => {
          console.error(err);
      });
  })

</script>
