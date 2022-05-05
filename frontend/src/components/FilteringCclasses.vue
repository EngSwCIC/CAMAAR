<template>
<div class="card text-center m-3">
    <q-btn-dropdown color="pink" label="Escolher turma" dropdown-icon="change_history">
      <q-list v-for="item in cclassess" :key="item.id">
            <q-list v-for="itemx in item" :key="itemx.id">
                <q-item clickable v-close-popup>
                <q-item-section @click="chooseCclass(itemx['attributes']['code'])">
                    <q-item-label > {{ itemx['attributes']['id'] +" => " + itemx['attributes']['code']}}</q-item-label>
                </q-item-section>
                </q-item>
            </q-list>
      </q-list>
    </q-btn-dropdown>
    <q-btn-dropdown color="pink" label="Escolher código do Questionário" dropdown-icon="change_history">
      <q-list v-for="item in surveyss" :key="item.id">
            <q-list v-for="itemx in item" :key="itemx.id">
                <q-item clickable v-close-popup>
                <q-item-section @click="chooseSurvey(itemx['attributes']['code'])" >
                    <q-item-label> {{ itemx['attributes']['code'] }}</q-item-label>
                </q-item-section>
                </q-item>
            </q-list>
      </q-list>
    </q-btn-dropdown>
    <q-btn-dropdown color="pink" label="Escolher código do Questão" dropdown-icon="change_history">
      <q-list v-for="item in questionss" :key="item.id">
        <q-list v-for="itemx in item" :key="itemx.id">
          <q-item clickable v-close-popup>
            <q-item-section @click="chooseQuestion(itemx['id'])">
              <q-item-label> {{ itemx['id']}} </q-item-label>
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
  props: {
    updateFilters: { type: Function }
  },
  data() {
    return {
      cclassess: null,
      surveyss: null,
      questionss: null,
      choices: {}
    };
  },
  methods: {
    chooseCclass (cclass) {
      this.choices.cclassess = cclass
      this.updateFilters(this.choices)
    },
    chooseSurvey (survey) {
      this.choices.surveyss = survey
      this.updateFilters(this.choices)
    },
    chooseQuestion (question) {
      this.choices.questionss = question
      this.updateFilters(this.choices)
    }
  },
  async created() {
    // GET request using fetch with async/await
    const response = await fetch("http://0.0.0.0:3030/cclasses");
    this.cclassess = await response.json();
    const response2 = await fetch("http://0.0.0.0:3030/surveys");
    this.surveyss = await response2.json();
    const response3 = await fetch("http://0.0.0.0:3030/questions");
    this.questionss = await response3.json();
  }
};
</script>