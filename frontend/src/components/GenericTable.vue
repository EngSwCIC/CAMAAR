<template>
  <div class="outer" >
    <q-table id="table" :title="name" :rows="rows" :columns="fields" row-key="id" virtual-scroll/>
  </div>
</template>

<script>
  export default {

    props: {
      name: {
        type: String,
      },
      fields: {
        type: Array,
        required: true
      },

      rows: {
        type: Array,
        required: true
      },
    }
  }
</script>