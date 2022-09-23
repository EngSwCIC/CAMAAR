<template>
    <div v-if="hasData">
        <template v-for="(subject, index) in subjects" :key="index">
            <SubjectReportTable :subject="subject" data-test-id='gradeTable' />
        </template>
    </div>
    <div v-else data-test-id='noGrades'>
        <h3>não há dados aqui ainda</h3>
    </div>
</template>
<script>
import { isEmpty } from 'lodash';
import axios from 'axios';
import SubjectReportTable from 'src/components/SubjectReportTable.vue';
export default {
    components: { SubjectReportTable },
    data() {
        return {
            subjects: []
        }
    },
    created() {
        axios.get('http://localhost:3000/admin_report').then(
            res => this.subjects = res.data
        )
    },
    computed: {
        hasData() {
            if (isEmpty(this.subjects)) return false

            return true
        }
    }
}
</script>