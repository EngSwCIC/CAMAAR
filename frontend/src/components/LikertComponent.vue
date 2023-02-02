<template>
    <div class="likert-scale">
      <div class="heading">
        <div class="empty"></div>
        <div v-for="(label, index) in labels" :key="`label-${index}`" class="options">
          {{ label }}
        </div>
      </div>
      <div class="selections">
        <div v-for="(label, index) in labels" :key="`radio-${index}`" class="options radio">
          <input type="radio" v-model="inputValue" :name="uniqueName" :vs-value="index"  />
        </div>
      </div>
    </div>
</template>

<script>
  import { v4 as uuid } from 'uuid';
  export default {
    name: "LikertScale",
    props: {
      value: {
        type: Number,
        required: true
      },
      labels: {
        type: Array,
        default: () => [
          'Discordo completamente',
          'Discordo parcialmente',
          'Nem concordo nem discordo',
          'Concordo Parcialmente',
          'Concordo completamente'
        ]
      }
    },
    computed: {
      uniqueName() {
        return uuid()
      },
      inputValue: {
        get() {
          return this.value
        },
        set(value) {
          this.$emit('input', value)
        }
      }
    }
  }
</script>

<style lang="scss" scoped>
  .likert-scale {
    font-size: 0.8em;
    background: #FFF;
    max-width: 40em;
    .heading,
    .selections
    {
      display: flex;
      border-bottom: 1px solid #eaeaea;
      align-items: center;
      justify-content: left;

      .options {
        flex: 1;
        border-left: 1px solid #eaeaea;
        border-right: 1px solid #eaeaea;
        text-align: center;
        padding: 1em 0.5em;
        max-width: 8em;
        &.radio {
          padding: 2.2em 1em;
        }
      }
    }
  }
</style>
