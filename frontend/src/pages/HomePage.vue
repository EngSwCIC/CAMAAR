<script setup>
import SurveyCard from '../components/SurveyCard.vue'
</script>
<template>
  <div class="page" style="min-height: 100vh;">
    <div id="q-app" style="min-height: 100vh;">
      <div class="q-pa-md">
        <q-parallax :height="200" :speed="0.5">
          <template v-slot:media>
            <img src="https://braziljournal.s3.amazonaws.com/covers/45b8fd3d-76a8-2c53-a564-83a394cef7f9.jpg?v=1596499602">
          </template>

          <h1 class="text-white">Seus Questionários</h1>
        </q-parallax>
      </div>
    </div>
    <div class=" fullscreen row items-center ">
      <SurveyCard class="col-11 col-sm-8 col-md-6 col-lg-4 col-xl-4"/>
    </div>
  </div>

</template>

<style scoped>

.page {
    padding: 1em
}

</style>
