<template>
   <div class="menu-logged" >
        <!--Usa v-for para utilizar o componente passando cada JSON presente no array 
            allowed_buttons como prop-->
        <ButtonLoggedPage v-for="(item, index) in allowed_buttons" :item="item" :index="index" :key="item.name" />
        <button class="btn-exit"> <router-link class="link" to="/">Sair</router-link></button>
   </div>
</template>

<script>

    import ButtonLoggedPage from './ButtonLoggedPage.vue';
    import { RouterLink } from 'vue-router' //Importando para usar a tag router-link

    export default {

        name: 'MenuLogged',

        data() {
            return {
                //Array de JSONs que contém os nomes que são utilizados nos botões do menu lateral
                allowed_buttons: [ 
                    { name: 'Questionários'},
                    { name: 'Relatórios'},
                    { name: 'Importar do SIGAA'}
                ]
            }
        },
       
        components: {
            ButtonLoggedPage,
        }
    }

</script>

<style scoped >

    .menu-logged {
        height: 100vh;
        width: 334px;
        display: flex;
        flex-direction: column;
        position: fixed;
        left: 0px;
        top: 0px;
        align-items: center;
        padding-top: 50px;
        background: #d9d9d9;
    }

    .menu-logged .btn-exit {
        position: absolute;
        background: none;
        border: none;
        width: 44px;
        height: 29px;
        left: 150px;
        top: 680px;
        font-family: 'Inter';
        font-style: normal;
        font-weight: 400;
        font-size: 24px;
        line-height: 29px;
        color: #000000;
    }

    .link {
        text-decoration: none;
        cursor: pointer;
        color:#000000;
    }

</style>