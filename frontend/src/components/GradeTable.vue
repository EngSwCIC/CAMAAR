<template>
    <div classname="container">
        <div classname="header">
            <div classname="header-row">
                <p>Disciplina</p>
            </div>
            <div classname="header-row">
                <p>Média das Notas</p>
            </div>
        </div>
        <div classname="body">
            <div classname="collum" style="{{margin-right: 1px #3A3B3C solid;}}">

            </div>
            <div classname="collum">
                
            </div>
        </div>
    </div>
</template>

<script>
    export default {
        
        data() {
            return [
                {
                    name: 'subject',
                    classes: [
                        {
                            name: 'T0',
                            grade: 50
                        },
                        {
                            name: 'T1',
                            grade: 60
                        }
                    ]
                },
                {
                    name: 'other subject',
                    classes: [
                        {
                            name: 'T3',
                            grade: nil
                        }
                    ]
                }
            ]
        }
    }
</script>

<style scoped>
    .container {
        background-color: #ffff;
        width: 80%;
        display: flex;
        margin: 0 auto;

    }

    .header {
        font-weight: 700;
        margin-bottom: 1rem;
        color: #3A3B3C;
        width: 100%;
        max-height: 100px;
        display: flex;
        justify-content: space-between;
    }

    .header-row {
        width: 50%;
        display: flex;
        justify-content: center;
        height: 100%;
        align-items: center;
    }

    .collum {
        width: 50%;
        display: flex;
        justify-content: center;
        min-height: 200px;
        align-items: center;
    }

</style>