<template>
    <!--Utiliza o parâmetro name da prop que o componente recebe como texto da tag button-->
    <button @click="change(item.name)" class='btn-logged' type='button'> {{ item.name }} </button>

</template>


<script>

    export default {
        name: 'ButtonLoggedPage',
        props: ['item'],  // Recebe uma prop chamada item que é utilizada como texto na tag button acima
        data() {
            return {
                ixtem: this.item,
            }
        },

        methods: {
            change: (itemName) => {
                // Lógica para mudar display da tela quando botões do menu lateral são clicados
                switch (itemName) {
                    case 'Questionários':
                        document.getElementById('p1').style.display = 'block';
                        document.getElementById('p2').style.display = 'none';
                        document.getElementById('p3').style.display = 'none';
                        break;

                    case 'Relatórios':
                        document.getElementById('p1').style.display = 'none';
                        document.getElementById('p2').style.display = 'block';
                        document.getElementById('p3').style.display = 'none';
                        break;

                    case 'Importar do SIGAA':
                        document.getElementById('p1').style.display = 'none';
                        document.getElementById('p2').style.display = 'none';
                        document.getElementById('p3').style.display = 'block';
                        break;

                    default:
                        break;
                }
            }
        }
       
    }

</script>

<style scoped >

    .btn-logged {
        position: relative;
        width: 289px;
        height: 50px;
        border: none;
        margin: 10px;
        font-family: Inter;
        font-size: 24px;
        background: #ffffff;
    }

    .btn-logged:focus, .btn-logged:hover {
        background: linear-gradient(0deg, #7AC7FF, #7AC7FF), linear-gradient(0deg, #FFFFFF, #FFFFFF), #FFFFFF;
    }

</style>