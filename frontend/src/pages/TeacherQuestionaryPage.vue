<script setup>
import SelectClass from "../components/SelectClass.vue";
import SendButton from "../components/SendButton.vue"
import CheckboxInput from "../components/CheckboxInput.vue";
import SugestionField from "../components/SugestionField.vue"
import ScaleTable from "../components/ScaleTable.vue"
</script>
<template>
    <div className="container">
        <SelectClass/>
        <CheckboxInput/>
        <CheckboxInput/>
        <CheckboxInput/>
        <CheckboxInput/>
        <ScaleTable/>
        <SugestionField/>
        <SendButton/>
    </div>
</template>

<style scoped>
    .container {
        display: flex;
        flex-flow: column wrap;
        justify-content: space-around;
        align-content: center;
        height: 100vh;
    }
</style>


