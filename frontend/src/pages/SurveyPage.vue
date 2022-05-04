<template>
  <div>{{ survey }}</div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      survey: null,
    };
  },
  mounted() {
    axios
      .get("http://localhost:3000/surveys/open")
      .then((res) => (this.survey = res.data))
      .finally(() => console.log(this.res));
  },
};
</script>
