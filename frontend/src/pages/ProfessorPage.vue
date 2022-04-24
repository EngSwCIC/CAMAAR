<script setup>
    import ProfessorComponent from "src/components/GraficoProfessor.vue";
</script>

<script>
export default {
    data(){       
        return {
            isHidden: true,
            api_change: true,
            api_url_child: null,
        }
    },
    methods: {
        toggle() {
            this.isHidden = !this.isHidden
        },
        api() {
            this.api_change = !this.api_change
            if (this.api_change){
                this.api_url_child = "https://canvasjs.com/services/data/datapoints.php?length=5&type=json"
            }
            else{
                this.api_url_child = "https://canvasjs.com/services/data/datapoints.php?xstart=1&ystart=1&length=5&type=json"
            }
            
        }
    }
}
</script>

<template>
    <br><br><br><br>
    <center>
        <div class="q-pa-md q-gutter-sm">
            <q-btn @click="toggle" color="primary" label="Mostrar/Ocultar Gráfico" />
            <q-btn @click="api" color="primary" label="Mudar API" />
        </div>
    </center>
    <div v-if="isHidden">
        <ProfessorComponent :api_url=api_url_child />
    </div>
</template>

