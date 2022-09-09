<template>
	<h3>
		Validação de cadastro
	</h3>

	<q-input outlined v-model="codigoInput" label="Codigo" placeholder="Digite seu código aqui" />
	<q-btn @click.prevent="validatePost" label="Validar código"/>
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
