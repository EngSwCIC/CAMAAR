<script>
export default {
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
            //const res = await fetch(`https://canvasjs.com/services/data/datapoints.php?length=5&type=json`)
            const res = await fetch(`https://canvasjs.com/services/data/datapoints.php?xstart=1&ystart=1&length=5&type=json`)
            this.dados = await res.json()
            this.um = this.dados[0][1]
            this.dois = this.dados[1][1]
            this.tres = this.dados[2][1]
            this.quatro = this.dados[3][1]
            this.cinco = this.dados[4][1]
        }
    },
    mounted() {
        //this.fetchData()
    },
        
    name: "Professor",
    components: {},
  
};
</script>

<template>
    <br><br><br><br>
    <center>
        <div style="width:40%; height: 40%;">
            {{dados}}
            <column-chart :data="[['&#128560;', um], ['&#128577;', dois], ['&#129300;', tres], ['&#128578;', quatro], ['&#128516;', cinco]]" ytitle="Num. Alunos" ></column-chart>
            <br><br>
            <button @click="fetchData()">API</button>
        </div>     
    </center>
</template>

