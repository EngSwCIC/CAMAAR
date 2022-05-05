<script>
// import api from 'src/services/api.js';
import axios from "axios";

export default {
    props: {
        api_url: String,
        filter_options: Object
    },
    data(){
        return {
            um: null,
            dois: null,
            tres: null,
            quatro: null,
            cinco: null,
        }
    },
    methods: {
        async fetchData() {
            this.dados = null

            const res = await axios.get(this.api_url)
                .then(response => {
                    console.log(response)
                    this.dados = response.data
                    this.um = this.dados[0][1]
                    this.dois = this.dados[1][1]
                    this.tres = this.dados[2][1]
                    this.quatro = this.dados[3][1]
                    this.cinco = this.dados[4][1]
                })
                .catch(error => {
                    console.log(error);
                });
        }
    },
    mounted() {
        this.fetchData()
    },

    name: "ProfessorComponent",
    components: {},

};
</script>

<template>
    <center>
        <br><br><br><br>
        <div style="width:40%; height: 40%;">
            {{dados}}
            <column-chart :data="[['&#128560;', um], ['&#128577;', dois], ['&#129300;', tres], ['&#128578;', quatro], ['&#128516;', cinco]]" ytitle="Num. Alunos" ></column-chart>
        </div>
    </center>
</template>