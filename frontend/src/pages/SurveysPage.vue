<script>
import SurveyCard from "../components/SurveyCard.vue";
import SurveySelector from "../components/surveySelector/surveySelectorComponent.vue"
export default {
  components: {
    // SurveyCard,
    SurveySelector,
  },
  data() {
    return {
      surveys: [],
      // surveys: null,
    };
  },
  methods: {
    surveyAnswer(survey, id) {
      console.log(survey, id)
      const index = this.surveys.findIndex(s => s.id === id);
      if (index > -1) {
        console.log('entrou aqui --->')
        this.surveys[index] = survey;
      }
    },
    add() {
      this.surveys.push({
        id: this.surveys.length + 1,
      })
    },
    save() {
      console.log('----->', this.surveys)
    }
  },
//   async mounted() {
//     const res = await this.$axios.get("/api/surveys/open")
//     this.surveys = res.data
//     console.log(res)
// // .then((res) => (this.surveys = res.data))
//       // .finally(() => console.log(this.surveys));
//   },
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
        <!-- <div class="row justify-center reverse-wrap items-baseline"> -->
          <!-- <SurveyCard
            v-for="survey in surveys"
            :key="surveys.indexOf(survey)"
            :survey="survey"
            class="card .col-12 q-mx-md"
          /> -->
          <SurveySelector v-for="survey in surveys" :key="survey.id" @survey-answer="(e) => surveyAnswer(e, survey.id)" />
          <button @click="add">adicionar</button>
          <button @click="save">salvar</button>
        <!-- </div> -->
      </div>
    </div>
  </div>
</template>
