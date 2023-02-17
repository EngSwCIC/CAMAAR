<template>

    <div class='display-logged'>
        <h1 class="title">Questionários</h1>
        <CardLoggedPage></CardLoggedPage>
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
    }

</script>

<style scoped >

    .display-logged {
        height: 1024px;
        width: 100%;
        position: fixed;
        background: #f5f5f5;
        left: 334px;
        top: 0px;
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