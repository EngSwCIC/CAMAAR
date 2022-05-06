<script setup>
const props = defineProps({
    question: String
})

</script>

<template>
    <tr>
        <td className="question">{{props.question}}</td>
        <td><input type="radio" :name="props.question" value="1"/></td>
        <td><input type="radio" :name="props.question" value="2"/></td>
        <td><input type="radio" :name="props.question" value="3"/></td>
        <td><input type="radio" :name="props.question" value="4"/></td>
        <td><input type="radio" :name="props.question" value="5"/></td>
    </tr>
</template>

<style scoped>
    tr {
        background-color: aliceblue;
    }
    td {
        padding: 10px;
        text-align: center;
    }
    td.question {
        text-align: start;
    }
</style>