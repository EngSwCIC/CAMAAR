<template>
  <div class="outer" >
    <q-table 
      id="table" 
      :title="name" 
      :rows="rows" 
      :columns="fields" 
      row-key="id" 
      virtual-scroll 
      >
        <template v-slot:body-cell="props">
          <q-td>
            {{(props.value == null || props.value == '') ? '-' : props.value}}
          </q-td>
        </template>
    </q-table>
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