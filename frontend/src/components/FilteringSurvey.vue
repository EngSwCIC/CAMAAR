<template>
    <center>
        <br>
        <div class="dropdown-survey">
            <q-btn-dropdown color="pink" label="Escolha a Avaliação" dropdown-icon="change_history">
            <q-list class="surveys">
                <q-item clickable v-close-popup>
                    <q-item-section>
                        <q-item-label>{{surveys}}</q-item-label>
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
            data: null
        }
    },
    created () {
        api
        .get('/surveys.json')
        .then(response => (this.attributes = response.data['attributes']))
    }
  }
</script>