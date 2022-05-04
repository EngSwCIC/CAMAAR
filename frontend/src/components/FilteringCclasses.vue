<template>
<div class="card text-center m-3">
    <q-btn-dropdown color="pink" label="Escolher turma" dropdown-icon="change_history" @click="chooseCclass($event)">
      <q-list v-for="item in cclassess" :key="item.id">
            <q-list v-for="itemx in item" :key="itemx.id">
                <q-item clickable v-close-popup :value="itemx['id']">
                <q-item-section>
                    <q-item-label> {{ itemx['attributes']['id'] +" => " + itemx['attributes']['code']}}</q-item-label>
                </q-item-section>
                </q-item>
            </q-list>
      </q-list>
    </q-btn-dropdown>
    <q-btn-dropdown color="pink" label="Escolher código do Questionário" dropdown-icon="change_history" @click="chooseSurvey($event)">
      <q-list v-for="item in surveyss" :key="item.id">
            <q-list v-for="itemx in item" :key="itemx.id">
                <q-item clickable v-close-popup  :value="itemx['attributes']['code']">
                <q-item-section>
                    <q-item-label> {{ itemx['attributes']['code'] }}</q-item-label>
                </q-item-section>
                </q-item>
            </q-list>
      </q-list>
    </q-btn-dropdown>
    <q-btn-dropdown color="pink" label="Escolher código do Questão" dropdown-icon="change_history" @click="chooseQuestion($event)" >
      <q-list v-for="item in questionss" :key="item.id">
        <q-list v-for="itemx in item" :key="itemx.id">
          <q-item clickable v-close-popup :value="itemx['id']">
            <q-item-section>
              <q-item-label> {{ itemx['id'] }}</q-item-label>
            </q-item-section>
          </q-item>
        </q-list>
      </q-list>
    </q-btn-dropdown>
</div>
</template>

<script>
export default {
  name: "filtering-cclasses",
  data() {
    return {
      cclassess: null,
      surveyss: null,
      questionss: null
    };
  },
  setup () {
    return {
      chooseCclass (event) {
        console.log(event.target.value)
      },
      chooseSurvey (event) {
        console.log(event.target.value)
      },
      chooseQuestion (event) {
        console.log(event.target.value)
      }
    }
  },
  async created() {
    // GET request using fetch with async/await
    const response = await fetch("http://127.0.0.1:3000/cclasses");
    this.cclassess = await response.json();
    const response2 = await fetch("http://127.0.0.1:3000/surveys");
    this.surveyss = await response2.json();
    const response3 = await fetch("http://127.0.0.1:3000/questions");
    this.questionss = await response3.json();
  }
};
</script>