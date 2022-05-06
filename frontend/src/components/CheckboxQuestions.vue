<script setup>
import CheckboxInput from './CheckboxInput.vue';
const props = defineProps({
    campos: Object
})
</script>

<template>
    <p>{{props.campos.pergunta}}</p>
    <CheckboxInput v-for="question in props.campos.checkboxQuestions" :key="question" :campo="question"/>
</template>

<style>

</style>