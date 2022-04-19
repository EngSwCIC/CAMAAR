<template>
  <div class="outer" >
    <q-table
      id="table"
      :title="name"
      :rows="treatedRows"
      :columns="fields"
      :filter="filter"
      class="col-12"
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

.q-table__title {
  font-size: 25px !important;
}

.q-table tbody td {
  font-size: 20px !important;
}

.q-table thead th {
  font-size: 20px !important;
}

</style>
