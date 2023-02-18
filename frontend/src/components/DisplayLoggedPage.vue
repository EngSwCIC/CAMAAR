<template>

    <div class='display-logged' id="p1" style="display: none;">
        <!--Título da página-->
        <h1 class="title">Questionários</h1>
        <div class="cards-container">
            <!--Usa v-for para utilizar o componente passando cada JSON presente 
                no array survey como prop-->
            <!--No final, temos um card para cada survey do banco-->
            <CardLoggedPage 
                v-for="survey in surveys" 
                :survey="survey" 
                :key="survey.id" />
        </div>
    </div>

    <div class='display-logged' id="p2" style="display: none;">
        <!--Título da página-->
        <h1 class="title">Relatórios</h1>
        <div class="cards-container">
           
        </div>
    </div>

    <div class='display-logged' id="p3" style="display: none;">
        <!--Título da página-->
        <h1 class="title">Importar do SIGAA</h1>
        <div class="cards-container">
           
        </div>
    </div>

</template>

<script>

    import CardLoggedPage from './CardLoggedPage.vue';

    export default {
        
        name: 'DisplayLoggedPage',
        components: {
            CardLoggedPage,         
        },

        props: [ 'title' ],

        data() {
            return {
            surveys: null,
            };
        },
        // Faz requisição ao backend para obter informações sobre os questionários
        //e armazena JSON de resposta na variável surveys
        async mounted() {
            const res = await this.$axios.get("/api/surveys/open")
            this.surveys = res.data
            console.log(res)
        },
  
    }

</script>

<style scoped >

    .display-logged {
        height: 100%;
        width: 100%;
        position: fixed;
        background: #f5f5f5;
        left: 334px;
        top: 0px;
    }

    .cards-container {
        position: absolute;
        width: 550px;
        height: 600px;
        left:100px;
        top: 100px;
        background: #d9d9d9;
        display: flex;
        flex-direction: column;
        align-items: center;
        padding-top: 5px;
        padding-bottom: 5px;
    }

    .title {
        font-family: 'Inter';
        font-style: normal;
        font-weight: 400;
        font-size: 36px;
        color: #000000;
        position: absolute;
        left: 90px;
        padding: 10px;
        top: 13px;

    }

</style>