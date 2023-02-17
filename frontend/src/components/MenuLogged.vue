<template>

   <div class="menu-logged">
        <ButtonLoggedPage></ButtonLoggedPage>
        <ButtonLoggedPage></ButtonLoggedPage>
        <ButtonLoggedPage></ButtonLoggedPage>
   </div>

</template>

<script>

    import ButtonLoggedPage from './ButtonLoggedPage.vue';

    export default {
        name: 'CardLoggedPage',
        data() {
            return {
                title: 'TITLE_VALUE',
                description: 'DESCRIPTION_VALUE'
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