<script>
import useVuelidate from "@vuelidate/core";
import { required } from "@vuelidate/validators";
import { computed, reactive } from "vue";
import { credentialsStore } from "../store/credentials";

export default {
  name: "Login",
  setup() {
    const credentials = credentialsStore();

    const { authenticate } = credentials;

    const user = reactive({
      email: null,
      password: null,
    });

    const rules = computed(() => ({
      email: { required, $lazy: true },
      password: { required, $lazy: true },
    }));

    const v$ = useVuelidate(rules, user);
    return { user, v$, authenticate };
  },
  methods: {
    async login() {
      const res = await this.v$.$validate();
      if (!res) {
        this.$notify.error("Campos Obrigatórios não preenchidos!");
        return;
      }
      try {
        await this.authenticate(this.user);
        this.$router.push("/");
      } catch (e) {
        this.$notify.error(e.message);
      }
    },
  },
};
</script>
<template>
  <div class="bg-white shadow-lg p-16 rounded-3xl">
    <form class="grid grid-cols-1 space-y-3">
      <h1 data-test-login="login" class="text-center font-bold">Entrar</h1>
      <div>
        <label class="pl-3">E-Mail:</label>
        <input
          v-model="user.email"
          placeholder="Digite o seu E-Mail"
          class="p-2 border-2 border-gray-600 rounded-3xl w-full"
        />
        <p v-for="error of v$.email.$errors" :key="error.$uid">
          <strong>{{ error.$message }}</strong>
        </p>
      </div>
      <div>
        <label class="pl-3">Senha:</label>
        <input
          v-model="user.password"
          placeholder="Senha"
          type="password"
          class="p-2 border-2 border-gray-600 rounded-3xl w-full"
        />
        <p v-for="error of v$.password.$errors" :key="error.$uid">
          <strong>{{ error.$message }}</strong>
        </p>
      </div>
      <button
        class="bg-teal-700 rounded-3xl p-2 text-white"
        @click.prevent="login"
      >
        Entrar
      </button>
    </form>
  </div>
</template>

<style></style>
