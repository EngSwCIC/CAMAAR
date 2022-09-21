<script>
import SurveyCard from "../../components/SurveyCard.vue";
import { ref } from 'vue'
const menuList = [
    {
    label: 'QUESTIONÁRIOS',
    separator: false
  },
]
export default {
  components: {
    SurveyCard,
  },
  data() {
    return {
      surveys: null,
    };
  },
  async mounted() {
    const res = await this.$axios.get("/api/surveys/open")
    this.surveys = res.data
    console.log(res)
// .then((res) => (this.surveys = res.data))
      // .finally(() => console.log(this.surveys));
  },
  setup () {
    return {
      drawer: ref(true),
      menuList
    }
  }
};
</script>

<template>
  <div class="q-pa-md bg-secondary fullscreen">
    <q-layout
      view="hHh Lpr lff"
      container
      style="height: 900px"
      class="shadow-2 rounded-borders"
    >
      <q-header elevated class="bg-secondary">
        <q-toolbar>
          <q-btn flat @click="drawer = !drawer" round dense icon="menu" />
        </q-toolbar>
      </q-header>

      <q-drawer
        v-model="drawer"
        :width="200"
        :breakpoint="500"
        overlay
        bordered
        class="bg-menu"
      >
        <q-scroll-area class="fit">
          <q-list>
            <div
              color="black"
              class="row justify-center"
              style="padding-top: 20%; padding-bottom: 10%; font-size: 30px"
            >
              MENU
            </div>
            <div
              class="row justify-center"
              style="padding-bottom: 10%; font-size: 20px; color: #9c27b0"
            >
              ALUNO
            </div>
            <template v-for="(menuItem, index) in menuList" :key="index">
              <q-item clickable :active="menuItem.label === 'Outbox'" v-ripple>
                <q-item-section style="color: white; background-color: #9c27b0">
                  Questionários
                </q-item-section>
              </q-item>
              <q-separator :key="'sep' + index" v-if="menuItem.separator" />
              <q-item clickable :active="menuItem.label === 'Outbox'" v-ripple>
                <q-item-section style="color: #9C27B0; background-color: white" @click="$router.push('/aluno')">
                  VOLTAR
                </q-item-section>
              </q-item>
              <q-separator :key="'sep' + index" v-if="menuItem.separator" />
            </template>
          </q-list>
        </q-scroll-area>
      </q-drawer>

      <q-page-container class="bg-grey-3">
        <q-page padding>
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
                    :key="surveys.indexOf(survey)"
                    :survey="survey"
                    class="card .col-12 q-mx-md"
                  />
                </div>

              </div>
            </div>
          </div>
        </q-page>
      </q-page-container>
    </q-layout>
  </div>
</template>
