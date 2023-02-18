<template>
   <div class="menu-logged" >
        <!--Usa v-for para utilizar o componente passando cada JSON presente no array 
            allowed_buttons como prop-->
        <ButtonLoggedPage v-for="(item, index) in allowed_buttons" :item="item" :index="index" :key="item.name" />
   </div>
</template>

<script>

    import ButtonLoggedPage from './ButtonLoggedPage.vue';

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

</style>