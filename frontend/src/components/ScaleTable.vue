<script setup>
import ScaleQuestionsRow from './ScaleQuestionsRow.vue'
const props = defineProps({
    questions: Array
})
</script>

<template>
    <table>
        <tr>
            <th></th>
            <th>1 - Discordo Totalmente</th>
            <th>2 - Discordo Parcialmente</th>
            <th>3 - Não sei/Não se Aplica</th>
            <th>4 - Concordo Parcialmente</th>
            <th>5 - Concordo Totalmente</th>
        </tr>
        <ScaleQuestionsRow v-for="question in props.questions" :key="question" :question="question"/>
    </table>
</template>

<style scoped>
    table {
        border: 1px solid black;
    }
    th {
        padding: 5px;
    }
</style>