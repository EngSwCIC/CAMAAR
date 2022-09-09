<script>
export default {
  components: {},
  data() {
    return {
      surveys: null,
    };
  },
  async mounted() {
    const res = await this.$axios.get("/api/surveys/open");
    this.surveys = res.data;
    console.log(res);
    // .then((res) => (this.surveys = res.data))
    // .finally(() => console.log(this.surveys));
  },
};
</script>
<template>
  <h1>OI</h1>
</template>
