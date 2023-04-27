#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "Call and annotate fusions with Arriba"
baseCommand: ["/arriba_v2.4.0/arriba"]
requirements:
    - class: ShellCommandRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 12
    - class: DockerRequirement
      dockerPull: "uhrigs/arriba:2.4.0"
arguments: [
    "-b", "/arriba_v2.4.0/database/blacklist_hg38_GRCh38_v2.4.0.tsv.gz",
    "-k", "/arriba_v2.4.0/database/known_fusions_hg38_GRCh38_v2.4.0.tsv.gz",
    "-t", "/arriba_v2.4.0/database/known_fusions_hg38_GRCh38_v2.4.0.tsv.gz",
    "-p", "/arriba_v2.4.0/database/protein_domains_hg38_GRCh38_v2.4.0.gff3",
    "-o", "arriba_fusions.tsv",
    "-O", "arriba_fusions.discarded.tsv"
]
inputs:
    aligned_bam:
        type: File
        inputBinding:
            prefix: '-x'
    reference_annotation:
        type: File
        inputBinding:
            prefix: '-g'
    reference:
        type:
            - string
            - File
        secondaryFiles: [.fai, ^.dict]
        inputBinding:
            prefix: '-a'
outputs:
    fusion_predictions:
      type: File
      outputBinding:
        glob: "arriba_fusions.tsv"
    discarded_fusion_predictions:
      type: File
      outputBinding:
        glob: "arriba_fusions.discarded.tsv"
