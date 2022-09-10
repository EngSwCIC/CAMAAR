<template>
	<div class="bg-secondary fullscreen row items-center justify-center">
	<div class="col-11 col-sm-8 col-md-6 col-lg-4 col-xl-4">
	<q-card class="rounded-border q-pa-xl hsize justify-center col-12 text-center">
      <h1 class="text-h3">Validação de cadastro</h1>
      <q-form ref="form" class="q-gutter-sm q-mt-xl row">

		<q-input 
			outlined 
			rounded
			label="Codigo" 
			v-model="codigoInput" 
			placeholder="Digite seu código aqui" 
			class="col-12"
        	lazy-rules
		/>
			
		<q-btn 
			rounded
        	color="secondary"
        	class="col-12"
        	size="lg"
			@click.prevent="validatePost" 
			label="Validar código"
		/>
	  
      </q-form>
    </q-card>
	</div>
	</div>
</template>

<script>

export default {
	data() {
		return {
			codigoInput: '',  	// codigo inserido na view.
			codigoDesejado: ''	// codigo gerado no backend.
		}
	},
	methods: {
		async validatePost() {
			const data = {
				codigoInput: this.codigoInput
			}
			let resultado = await this.$axios.post("/api/validate", data)
			console.log(resultado)
		}
	},
	async mounted() {
		let resultado = await this.$axios.get("/api/validate")
		console.log(resultado)
		this.codigoDesejado = resultado.data.codigo
	}
}
</script>

<style scoped>
.hsize {
  height: 500px;
}
.rounded-border{
  border-radius: 25px;
}
</style>
