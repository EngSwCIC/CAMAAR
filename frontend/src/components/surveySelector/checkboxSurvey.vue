<script>
import M from 'minimatch';

export default {
  data() {
    return {
      data: [
        {
          key: 1,
          value: "",
        }
      ]
    }
  },
  methods: {
    addInput() {
      console.log(this.data)
      this.data.push({
        key: this.data.length + 1,
        value: ""
      })
    }
  }
};
</script>

<template>
  <div>
    <div v-for="input in data" :key="input.key" class="container">
      <input name="selected_options" type="checkbox" :value="input.key" class="radio" />
      <input type="text" v-model="input.value" />
    </div>
    <button @click="addInput"> adicionar linha </button>
  </div>
</template>
<style scoped>
  .container {
    margin: 20px 0;
  }

  .radio {
    margin-right: 10px;
  }
</style>
