<script setup>
import { ref, defineProps } from "vue";

const props = defineProps(["items", "addItem", "id"]);
let newLabel = ref("");

function handleAddItem() {
  props.addItem(newLabel.value, props.id);
  newLabel.value = "";
}
</script>

<template>
  <div>
    <div v-for="item in props.items" :key="item">
      <input type="radio" name="radioComponent"/>
      {{ item }}
    </div>
    <div>
      <input type="radio" name="radioComponent"/>
      <input type="text" v-model="newLabel" @keyup.enter="handleAddItem" />
    </div>
  </div>
</template>
