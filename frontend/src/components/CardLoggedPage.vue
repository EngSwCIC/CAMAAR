<template>

    <div class='menu-logged'>
        <h1 class="title"> {{ title }}</h1>
        <p  class="description"> {{ description }}</p> 
    </div>

</template>

<script>

    export default {
        name: 'CardLoggedPage',
        data() {
            return {
                title: 'TITLE_VALUE',
                description: 'DESCRIPTION_VALUE'
            }
        },
    }

</script>

<style scoped >

    .card-logged {
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

    .card-logged .title {
        font-family: Inter;
        font-size: 24px;
        font-weight: 400;
        font-style: normal;
        line-height: 29px;
        margin: 15px;
    }

    .card-logged .description {
        font-family: Inter;
        font-size: 16px;
        font-weight: 400;
        font-style: normal;
        line-height: 20px;
        margin: 15px;
    }

</style>