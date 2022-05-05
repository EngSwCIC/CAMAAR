<script>
import axios from "axios";
import SurveyCard from "../components/SurveyCard.vue";
export default {
  components: {
    SurveyCard,
  },
  data() {
    return {
      surveys: null,
    };
  },
  mounted() {
    axios
      .get("http://localhost:3000/surveys/open")
      .then((res) => (this.surveys = res.data))
      .finally(() => console.log(this.surveys));
  },
};
</script>
<template>
  <div class="page" style="min-height: 100vh">
    <div id="q-app" style="min-height: 100vh">
      <div class="q-pa-md row items-start q-gutter-md">
        <q-parallax :height="200" :speed="0.5">
          <template v-slot:media>
            <img
              src="https://braziljournal.s3.amazonaws.com/covers/45b8fd3d-76a8-2c53-a564-83a394cef7f9.jpg?v=1596499602"
            />
          </template>

          <h1 class="text-white">Seus Questionários</h1>
        </q-parallax>
        <div class="row justify-center reverse-wrap items-baseline">
          <SurveyCard
            v-for="survey in surveys"
            :key="survey.id"
            :survey="survey"
            class="card .col-12 q-mx-md"
          />
        </div>
      </div>
    </div>
  </div>
</template>
