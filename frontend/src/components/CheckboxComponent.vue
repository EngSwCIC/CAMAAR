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
      <input type="checkbox" />
      {{ item }}
    </div>
    <div>
      <input type="checkbox" />
      <input type="text" v-model="newLabel" @keyup.enter="handleAddItem" />
    </div>
  </div>
</template>
