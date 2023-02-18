<template>

    <div class='card-logged'>
        <router-link to="surveys">
            <!--Tag h1 utiliza o parâmetro "name" do JSON "survey"-->
            <h1 class="title"> {{ survey.name }}</h1> 
            <!--Tag p utiliza o parâmetro "description" do JSON "survey"-->
        <p  class="description"> {{ survey.description }}</p> 
    </router-link>
    </div>

</template>

<script>
    import { RouterLink } from 'vue-router' //Importando para usar a tag router-link

    export default {
        name: 'CardLoggedPage',
        components: {RouterLink},
        props:['survey'], //Recebe um JSON referente a um questionário como prop

    }

</script>

<style scoped >

    .card-logged {
        width: 500px;
        height: 125px;
        margin: 10px;   
        background: #ffffff;
        display: flex;
        flex-direction: column;
        align-items: left;
        padding-top: 5px;
        padding-bottom: 5px;
        padding-left: 20px;
    }

    .card-logged .title {
        font-family: Inter;
        font-size: 23px;
        font-weight: 400;
        font-style: normal;
        line-height: 22px;
        margin: 5px;
        margin-top: 12px;
    }

    .card-logged .description {
        font-family: Inter;
        font-size: 16px;
        font-weight: 400;
        font-style: normal;
        line-height: 20px;
        margin: 5px;
    }

</style>