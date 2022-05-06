<script setup>
const props = defineProps({
    question: String
})
</script>

<template>
    <div>
        <label>{{props.question}}</label>
        <br>
        <textarea />
    </div>
    
</template>

<style scoped>
    
</style>