<template>
    <div> {{ $route.params.id }} </div>
</template>

<script>
    import axios from 'axios'

    export default {
    data() {
        return { survey: null };
    },
    mounted() {
        axios.get('http://localhost:3000/surveys/' + this.$route.params.id)
        .then((res) => this.survey = res.data)
        .catch((err) => console.error(err))
    }
    };
</script>