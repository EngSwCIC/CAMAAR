<template>
    <div class="q-pa-md">
        <q-table
            :title="title"
            :rows="rows"
            row-key="name"
        />
    </div>
</template>

<script>
  export default {
    computed: {
      title() {
        return this.subject?.name
      },
      rows() {
        const arrayOfArrays = this.subject.classes.map(({ name, grade }) => ([
          name,
          grade.toString().slice(0, -1) + "," + grade.toString().slice(-1)
        ]))
        return [Object.fromEntries(arrayOfArrays)]
      }
    },

    props: ['subject']
  }
</script>
