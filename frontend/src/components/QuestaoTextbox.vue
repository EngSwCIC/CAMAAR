<template>

<div>
        <q-input
            class="textbox"
            color="secondary"
            outlined
            autogrow
            clearable
            :model-value="modelValue.content"
            @update:model-value="(value) => $emit('update:modelValue', updateAnswer(value))"
        />
    </div>
</template>
<script>
export default {
    props: ['modelValue'],
    methods: {
        updateAnswer(value) {
            return {
                ...this.modelValue,
                content: value
            }
        }
    }
}
</script>