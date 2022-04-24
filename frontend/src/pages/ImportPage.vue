<script>
  import ImportCard from "src/components/ImportCard.vue"
  import ViewClassesCard from "src/components/viewClassesCard.vue"
  export default {
    name: 'ImportPage',
    components: {
      ImportCard,
      ViewClassesCard
    },
    methods: {
      async atualizaCadastradas () {
        await this.$refs.viewRef.updateRows() 
      }
    }
  }
</script>

<template>
<div class="bg-secondary items-center text-center justify-center row">
  <h1 class="col-12">Import Page</h1>
  <ImportCard @updateCadastradas="atualizaCadastradas" class="col-8" select="multiple" />
  <ViewClassesCard refs="viewRef" class="col-8"/>

</div>
</template>

