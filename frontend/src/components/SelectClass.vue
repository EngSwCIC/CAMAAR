<script setup>
const props = defineProps({
    campos: Object
})
</script>
<template>
    <div>
        <label>{{props.campos.pergunta}}</label>
        <select>
            <option v-for="opcao in props.campos.opcoes" :key="opcao">{{opcao}}</option>
        </select>
    </div>
</template>

<style scoped>
    select {
        margin-left: 5px;
    }
</style>