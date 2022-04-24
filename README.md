# CAMAAR
Sistema para avaliação de atividades acadêmicas remotas do CIC

# SPRINT 2
## Feature: Filtragem de pesquisas disponíveis por turma
### Responsável: João Vítor Maia
- Para essa sprint foi desenvolvido um endpoint que retornar as classes disponíveis para filtragem, com seu ID, CODE, SEMESTER e TIME. Possibilitando assim a filtragem no endpoint de pesquisas, o retorno é no formato:
        
        "id": "1",
            "type": "cclasses",
            "attributes": {
                "id": 1,
                "code": "TA",
                "semester": "2021.2",
                "time": "35T45"
            }
        
 - No zenhub temos as issues:
	- (Done) Endpoint para retornar a lista de turmas #34
	- (Done) Filtro de questões por turma #32
	- (In Progress) RSpec do filtro de questões por turma #35


## Feature: Geração do Arquivo PDF
### Responsável: Igor Silva de Oliveira ardoso

 - Para essa sprint foi desenvolvido um componente que foi usado na páina * para gerar os gráficos. Nesse componente contece uma requisição, do tipo GET, para API que retorna uma respota (vide exemplo abaixo), que estiliza o texto recebido para gerar um arquivo PDF.
 - No zenhub temos as issues:
 	- Done) Componetização
 	- (Done) Requisição para API
 	- (In Progress) Integração a página
 	- (In Progress) Estilização (apresentação) do texto
 	
 	
## Feature: Geração de Graficos do Professor
### Responsável: Gabriel Pinheiro
 - Para essa sprint foi desenvolvida uma página genérica de geração de gráficos. A geração foi separada em pagina e componente conforme convenção de uso do Vue e para alimentação teste foi utilizado a API https://canvasjs.com/ que fornece um JSON com dados números no formato ideal para a geração dos gráficos em questão.
* No ZenHub/GitHub as seguintes Issues foram criadas. Elas estão em andamento e algumas já foram concluídas
	- (Done) Implementar ChartKick para geração de gráficos automática #18
	- (Done) Separar em arquivo Components a feature de geração de gráficos do professor #24
	- (Done) Atualizar consumação de API para utlização de AXIOS #27
	- (In Progress) Incrementar geração de gráficos do professor na página principal com aparição dinâmica conforme seleção de pergunta #25
	- (In Progress) Desenvolver testagem do frontend (Jest) #26
	
	
## Feature: Filtrar questões do Banco de Dados
### Responsável: Luiza de Araújo Nunes Gomes

- Como não tínhamos models para começar a escrever o nosso código, necessitei escrever uma model para cada componente básico de nossos questionário:
  - Questionário (Survey);
  - Questão do Questionário (Question);
  - Opções do Questionário (Option) e;
  - Resposta (answer).
  
- Algo que tomou um certo tempo em relação ao foco principal de filtrar as questões. Com o projeto já meio atrasado, ainda conseguimos realizar as *controllers* dessas models e construir RSpecs para essas.
- **Gabriel Pinheiro, Igor Silva e Luiza Gomes**: No frontend, realizou-se a filtragem desses dados com Axios, Rails e ajuda do Quasar.
- Issues utilizadas no Zenhub:
	- (Done) Controllers de Questões, Opções e Respostas #31;
	- (Done) RSpec de filtragem das questões #23;
	- (Done) Criar Model para Questionário dos Alunos #22 e;
	- (In Progress) Realizar o básico do Frontend da Filtragem #36.
