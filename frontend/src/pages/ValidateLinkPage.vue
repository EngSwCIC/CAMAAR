<template>
	<div class="bg-secondary fullscreen row items-center justify-center">
	<div class="col-11 col-sm-8 col-md-6 col-lg-4 col-xl-4">
	<q-card class="rounded-border q-pa-xl hsize justify-center col-12 text-center">

    <div v-if="cadastrado">
        <h1 class="text-h3">Cadastro feito com sucesso!</h1>
    </div>
    <div v-else>
    <h1 class="text-h3">Validação de cadastro</h1>
        <q-form ref="form" class="q-gutter-sm q-mt-xl row">
            <q-input 
			outlined 
			rounded
			label="Senha " 
			v-model="codigoInput" 
			placeholder="Digite sua senha cadastrada" 
			class="col-12"
        	lazy-rules
		    />

            <q-btn 
                rounded
                color="secondary"
                class="col-12"
                size="lg"
                @click.prevent="validatePost" 
                label="Validar cadastro"
            />

        </q-form>
    </div>
      
    </q-card>
	</div>
	</div>
</template>

<script>
import axios from "axios";
import { useQuasar } from "quasar";
import { useRouter } from "vue-router";

const $q = useQuasar()
const router = useRouter()

export default {
	data() {
		return {
			senhaInput: '',  	// Senha cadastrada
            cadastrado: false,
		}
	},
    
    setup() {
        const $q = useQuasar();
        const router = useRouter();
        const notify = (param) => {
        $q.notify(param);
        };
        return {
        notify,
        router,
        };
    },

	async mounted() {
        try {
            const resultado = await this.$axios.get("/api/validate/" + this.$route.params.id)
            this.email = resultado.data;
        } catch (err) {
            console.error(err);
            this.notify({
                message: "Erro ao carregar link.",
                position: "top",
                color: "negative",
            });
            this.router.push({ path: "/home" });
        }
	},

	methods: {
		async validatePost() {
            try {
                let resultado = await this.$axios.post(
                    "/api/validate/" + this.$route.params.id, 
                    { senha: this.senhaInput})
            } catch (e) {
                this.notify({
                    message: 'Senha Inválida',
                    position: 'top',
                    color: 'negative'
                })
            }
		}
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
