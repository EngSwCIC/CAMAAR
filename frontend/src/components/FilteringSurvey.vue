<template>
    <center>
        <br><br>
        <div class="q-pa-md">
            <q-btn-dropdown color="pink" label="Escolha a Avaliação" dropdown-icon="change_history">
            <q-list class="surveys">
                <q-item clickable v-close-popup v-for="survey in surveys" :key="survey.id" class='survey-item'>
                <q-item-section>
                    <q-item-label>{{ survey.id }}: {{ survey.code}}></q-item-label>
                </q-item-section>
                </q-item>
            </q-list>
            </q-btn-dropdown>
        </div>
   </center>
</template>
<script>
import api from "src/services/api.js";
export default {
    data () {
        return {
        surveys: []
        }
    },
    created () {
        api
        .get('/surveys')
        .then(response => (this.surveys = response.data))
    }
  }
</script>