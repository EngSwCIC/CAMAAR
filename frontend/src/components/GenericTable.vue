<template>
  <div class="outer" >
    <q-table class="table" id="table" striped hover :rows=items :columns=fields></q-table>
  </div>
</template>

<script>
  export default {
    props: {
        fields: {
            type: Array,
            required: true
        },

        items: {
            type: Array,
            required: true
        },
    }
  }
</script>

<style scoped >
.table {}
.outer {
  margin: 35px;
}
</style>