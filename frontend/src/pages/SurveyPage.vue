<template>
    <div> {{ $route.params.id }} </div>
</template>

<script>
    import axios from 'axios'

    console.log('eu existo')

    export default {
    data() {
        return { survey: null };
    },
    mounted() {
        axios.get('http://localhost:3000/surveys/' + this.$route.params.id)
        .then((res) => console.log(res))
        .finally(() => console.log(this.survey))
    }
    };
</script>