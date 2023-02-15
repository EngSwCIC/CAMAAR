<script>
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
    },
    removeInput(key) {
      this.data = this.data.filter(input => input.key !== key)
    }
  }
};
</script>

<template>
    <div>
        <div v-for="input in data" :key="input.key" class="container">
            <input name="selected_options" type="checkbox" :value="input.key" class="radio" disabled />
            <input type="text" v-model="input.value" class="input" />
            <q-btn
              rounded
              color="negative"
              @click="removeInput(input.key)"
            >x</q-btn>
        </div>
        <q-btn
          rounded
          color="primary"
          @click="addInput"
        > adicionar linha </q-btn>
    </div>
</template>
<style scoped>
  .container {
    margin: 20px 0;
    display: flex;
  }

  .radio {
    width: 24px;
    border-radius: 12px;
  }

  .input {
    width: 100%;
    border: none;
    outline: none;
    resize: none;
    padding: 10px;
    font-size: 16px;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
    margin: 0 20px;
  }

</style>
