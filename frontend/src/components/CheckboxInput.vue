<script setup>
const props = defineProps({
    campo: String
})
</script>

<template>
    <div>
        <input type="checkbox"/>
        <label>{{props.campo}}</label>
    </div>
</template>

<style scoped>
    label {
        margin-left: 5px;
    }
</style>