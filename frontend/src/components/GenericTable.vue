<template>
  <div class="outer row" v-if="!!select">
    <q-table
      id="tableSelect"
      :title="name"
      class="col-12"
      :rows="treatedRows"
      :columns="fields"
      :filter="filter"
      selection="multiple"
      v-model:selected="selected"
      row-key="id"
    >
      <template v-slot:top-right>
        <q-input
          borderless
          dense
          for="search"
          debounce="300"
          v-model="filter"
          placeholder="Filtrar resultado">
          <template v-slot:append>
            <q-icon name="search"/>
          </template>
        </q-input>
      </template>
    </q-table>
  </div>
  <div class="row outer" v-if="!select">
    <q-table
      id="table"
      :title="name"
      :rows="treatedRows"
      class="col-12"
      :columns="fields"
      :filter="filter"
      row-key="id"
    >
      <template v-slot:top-right>
        <q-input
          borderless
          dense
          for="search"
          debounce="300"
          v-model="filter"
          placeholder="Filtrar resultado">
          <template v-slot:append>
            <q-icon name="search"/>
          </template>
        </q-input>
      </template>
    </q-table>
  </div>
</template>

<script>
  export default {

    data(){
      return {
        filter: null,
        selected: []
      }
    },
    watch: {
      selected(newValue){
        this.$emit('selected', newValue)
      }
    },
    computed: {
      treatedRows: function () {
        return this.rows.map(row => {
          Object.keys(row).forEach(key => {
             let value = row[key]
             row[key] = ((value == null || value == '') ? '-' : value)
          })
          return row
        })
      }
    },

    props: {
      select: String,

      name: {
        type: String,
      },

      fields: {
        type: Array,
        required: true,
      },

      rows: {
        type: Array,
        required: true,
      },
    }
  }
</script>

<style>
.outer {
  width: 70%;
}

/* .q-table__title {
  font-size: 15px !important;
}

.q-table tbody td {
  font-size: 13px !important;
}

.q-table thead th {
  font-size: 13px !important;
} */

</style>
