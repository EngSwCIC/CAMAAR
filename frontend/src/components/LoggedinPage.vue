<template>
  <div class="LoggedinPage">
    <div id="left-side-container">
      <ButtonLoggedPage></ButtonLoggedPage>
      <a href=""><p id="logout">Sair</p></a>
    </div>
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

    import ButtonLoggedPage from './ButtonLoggedPage.vue';

    export default {
      name: 'LoggedinPage',
      
      components: {
        ButtonLoggedPage
      }
    }
</script>

<style scoped>

  .LoggedinPage {
    overflow-y: scroll;
    position: absolute;
    height: 100vh;
    width: 100 vw;
  }

  #left-side-container {
    height: 100%;
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
    height: 100%;
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
    display: none;
    justify-content: center;
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
    margin-top: 1rem;
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
    bottom: 10px;
    height: 100px;

  }

  #ques {
    border: none;
    width: 90%;
    height: 30%;
    position: relative;
    background: #ffffff;
    margin: 10px;
    display: flex;
    flex-direction: column;
    padding-top: 0.5rem;
  }

  #title-inside {
    font-family: Inter;
    font-size: 24px;
    font-weight: 400;
    font-style: normal;
    line-height: 29px;
    margin: 15px 15px 0 15px;
    display: flex;
    justify-content: left;
    padding-left: 1rem;
  }

  #desc {
    font-family: Inter;
    font-size: 16px;
    font-weight: 400;
    font-style: normal;
    line-height: 20px;
    margin: 15px;
    display: flex;
    justify-content: left;
    padding-left: 1rem;
  }

  #page1, #page2, #page3 {
    position: relative;
    height: 100%;
    width: 100%;
  }


</style>
