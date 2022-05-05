<script setup>
import ScaleQuestionsRow from './ScaleQuestionsRow.vue'
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
        <ScaleQuestionsRow/>
        <ScaleQuestionsRow/>
        <ScaleQuestionsRow/>
    </table>
</template>

<style scoped>

</style>