<template>
  <div class="q-pa-md" style="width: 100%; padding: 0; padding-inline:8px;">
    <q-list bordered class="rounded-borders">
      <q-expansion-item
        expand-separator
        :label="subject.code + ' — ' + subject.name"
      >
        <q-card>
          <q-card-section>
            Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quidem, eius reprehenderit eos corrupti
            commodi magni quaerat ex numquam, dolorum officiis modi facere maiores architecto suscipit iste
            eveniet doloribus ullam aliquid.
          </q-card-section>
        </q-card>
      </q-expansion-item>
    </q-list>
  </div>
</template>

<script setup>
  const props = defineProps({
  subject: {
    required: true
  }
})

</script>
