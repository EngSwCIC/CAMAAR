<template>
  <div>
    <ul v-for="cclass in cclasses" v-bind:key="cclass.code">
      <li>{{cclass.code}} {{cclass.name}}</li>
    </ul>
  </div>
</template>

<script>
import api from 'src/services/api.js';
export default {
  props: {
        api_url: String
    },
  data() {
    return {
      cclasses: [],
    };
  },
  methods: {
    async getData() {
      try {
        let response = await fetch("api_url/cclasses");
        this.cclasses = await response.json();;
      } catch (error) {
        console.log(error);
      }
    },
  },
  created() {
    this.getData();
  },

  name: "FilteringCclasses",
  components: {},
};
</script>