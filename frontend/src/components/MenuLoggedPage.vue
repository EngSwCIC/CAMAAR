<template>
   <div class="menu-logged" >
        <ButtonLoggedPage v-for="(item, index) in allowed_buttons" :item="item" :index="index" :key="item.id" />
   </div>
</template>

<script>

    import ButtonLoggedPage from './ButtonLoggedPage.vue';

    export default {

        name: 'MenuLogged',

        data() {
            return {
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
        height: 1024px;
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