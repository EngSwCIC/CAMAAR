<template>
  <div class="LoggedinPage">
    <MenuLogged></MenuLogged>
    <div id="right-side-container">
      <div id="page1">
        <h1 id="title" >Questionários</h1>
        <div id="question-container">
          
            <div id="ques">
              <h1 id="title-inside">Engenharia de Software</h1>
              <p id="desc">Turma A</p>
            </div>
            <div id="ques">
              <h1 id="title-inside">Engenharia de Software</h1>
              <p id="desc">Turma A</p>
            </div>

        </div>
      </div> 

      <div id="page2">
        <h1 id="title" >Relatórios</h1>
        
      </div>
      
      
      <div id="page3">
        <h1 id="title" >SIGAA</h1>
        
      </div> 
    </div>

  </div>    
</template>

<script>
    import MenuLogged from './MenuLogged.vue';

    export default {
      name: 'LoggedinPage',
      
      components: {
        MenuLogged,
      }
    }
</script>

<style scoped>

  #left-side-container {
    height: 1024px;
    width: 334px;
    display: flex;
    flex-direction: column;
    position: fixed;
    left: 0px;
    top: 0px;
    align-items: center;
    padding-top: 50px;
    background: #d9d9d9;
  }

  #right-side-container {
    height: 1024px;
    width: 100%;
    position: fixed;
    background: #f5f5f5;
    left: 334px;
    top: 0px;
  }

  #page1, #page2, #page3 {
    position: relative;
    width: 100%;
    height: 100%;
    text-align: center;
    display:none;
  }

  #logout {
    position: absolute;
    width: 44px;
    height: 29px;
    left: 150px;
    top: 680px;

    font-family: 'Inter';
    font-style: normal;
    font-weight: 400;
    font-size: 24px;
    line-height: 29px;
    color: #000000;
  }

  #question-container {
    position: absolute;
    width: 550px;
    height: 600px;
    left:100px;
    top: 100px;
    background: #d9d9d9;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding-top: 5px;
    padding-bottom: 5px;
  }

  #title {
    font-family: 'Inter';
    font-style: normal;
    font-weight: 400;
    font-size: 36px;
    color: #000000;
    position: absolute;
    left: 90px;
    padding: 10px;
    top: 30px;

  }

  #ques {
    border: none;
    width: 90%;
    height: 30%;
    position: relative;
    background: #ffffff;
    margin: 10px;
  }

  #title-inside {
    font-family: Inter;
    font-size: 24px;
    font-weight: 400;
    font-style: normal;
    line-height: 29px;
    margin: 15px;
  }

  #desc {
    font-family: Inter;
    font-size: 16px;
    font-weight: 400;
    font-style: normal;
    line-height: 20px;
    margin: 15px;
  }

  #page1, #page2, #page3 {
    position: relative;
    height: 100%;
    width: 100%;
  }


</style>
