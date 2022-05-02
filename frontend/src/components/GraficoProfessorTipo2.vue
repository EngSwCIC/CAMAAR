<script>
import api from 'src/services/api.js';

export default {
    props: {
        api_url: String
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
            const res = await api.get(this.api_url)
                .then(response => {
                    this.dados = response.data
                    this.um = this.dados[0][1]
                    this.dois = this.dados[1][1]
                    this.tres = this.dados[2][1]
            
                })
                .catch(error => {
                    console.log(error);
                });            
            // const res = await fetch(`https://canvasjs.com/services/data/datapoints.php?xstart=1&ystart=1&length=5&type=json`);            
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
            <column-chart :data="[['Síncrona', um], ['Indiferente', dois], ['Assíncrona', tres]]" ytitle="Num. Alunos" ></column-chart>
        </div>
    </center>
</template>