<template>
    
    <button @click="showPage1" id='main-button' type="button"> {{ button1_name }}</button>
    <button @click="showPage2" id='main-button' type="button"> {{ button2_name }}</button>
    <button @click="showPage3" id='main-button' type="button"> {{ button3_name }}</button>

</template>


<script>

    export default {
        name: 'ButtonLoggedPage',
        data() {
            return {
                button1_name: 'Questionários',
                button2_name: 'Relatórios',
                button3_name: 'Importar do SIGAA',
            }
        },

        methods: {
            showPage1() {
                document.getElementById('page1').style.display = 'grid'
                document.getElementById('page2').style.display = 'none'
                document.getElementById('page3').style.display = 'none'
          
          
            },

            showPage2() {
                document.getElementById('page1').style.display = 'none'
                document.getElementById('page2').style.display = 'grid'
                document.getElementById('page3').style.display = 'none'
          
            },

            showPage3() {
                document.getElementById('page2').style.display = 'none'
                document.getElementById('page1').style.display = 'none'
                document.getElementById('page3').style.display = 'grid'
            }
        }


    }

</script>

<style scoped >

#main-button {
    position: relative;
    width: 289px;
    height: 50px;
    border: none;
    margin: 10px;
    font-family: Inter;
    font-size: 24px;
    background: #ffffff;
}

#main-button:focus, #main-button:hover {
    background: linear-gradient(0deg, #7AC7FF, #7AC7FF), linear-gradient(0deg, #FFFFFF, #FFFFFF), #FFFFFF;

}

</style>