#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "somatic exome pipeline with qc"
requirements:
    - class: SubworkflowFeatureRequirement
inputs:
    reference:
        type: File
        secondaryFiles: [.fai, .bwt, .sa, .ann, .amb, .pac, ^.dict, .alt]
    normal_bams:
        type: File[]
    normal_readgroups:
        type: string[]
    tumor_bams:
        type: File[]
    tumor_readgroups:
        type: string[]
    mills:
        type: File
        secondaryFiles: [.tbi]
    known_indels:
        type: File
        secondaryFiles: [.tbi]
    dbsnp:
        type: File
        secondaryFiles: [.tbi]
    cosmic_vcf:
        type: File?
        secondaryFiles: [.tbi]
    bait_intervals:
        type: File
    target_intervals:
        type: File
    omni_vcf:
        type: File
        secondaryFiles: [.tbi]
outputs:
    final_vcf:
        type: File
        outputSource: alignment_and_detect_variants/final_vcf
    tumor_bam:
        type: File
        outputSource: alignment_and_detect_variants/tumor_bam
    normal_bam:
        type: File
        outputSource: alignment_and_detect_variants/normal_bam
    tumor_insert_size_metrics:
        type: File
        outputSource: tumor_qc/insert_size_metrics
    tumor_alignment_summary_metrics:
        type: File
        outputSource: tumor_qc/alignment_summary_metrics
    tumor_hs_metrics:
        type: File
        outputSource: tumor_qc/hs_metrics
    tumor_flagstats:
        type: File
        outputSource: tumor_qc/flagstats
    tumor_verify_bam_id_metrics:
        type: File
        outputSource: tumor_qc/verify_bam_id_metrics
    tumor_verify_bam_id_depth:
        type: File
        outputSource: tumor_qc/verify_bam_id_depth
    normal_insert_size_metrics:
        type: File
        outputSource: normal_qc/insert_size_metrics
    normal_alignment_summary_metrics:
        type: File
        outputSource: normal_qc/alignment_summary_metrics
    normal_hs_metrics:
        type: File
        outputSource: normal_qc/hs_metrics
    normal_flagstats:
        type: File
        outputSource: normal_qc/flagstats
    normal_verify_bam_id_metrics:
        type: File
        outputSource: normal_qc/verify_bam_id_metrics
    normal_verify_bam_id_depth:
        type: File
        outputSource: normal_qc/verify_bam_id_depth
steps:
    alignment_and_detect_variants:
        run: alignment_and_detect_variants.cwl
        in:
            reference: reference
            normal_bams: normal_bams
            normal_readgroups: normal_readgroups
            tumor_bams: tumor_bams
            tumor_readgroups: tumor_readgroups
            mills: mills
            known_indels: known_indels
            dbsnp: dbsnp
            interval_list: target_intervals
            strelka_exome_mode:
                default: true
            cosmic_vcf: cosmic_vcf
        out: [final_vcf, tumor_bam, normal_bam]
    tumor_qc:
        run: qc/workflow_exome.cwl
        in:
            bam: alignment_and_detect_variants/tumor_bam
            reference: reference
            bait_intervals: bait_intervals
            target_intervals: target_intervals
            omni_vcf: omni_vcf
        out: [insert_size_metrics, alignment_summary_metrics, hs_metrics, flagstats, verify_bam_id_metrics, verify_bam_id_depth]
    normal_qc:
        run: qc/workflow_exome.cwl
        in:
            bam: alignment_and_detect_variants/normal_bam
            reference: reference
            bait_intervals: bait_intervals
            target_intervals: target_intervals
            omni_vcf: omni_vcf
        out: [insert_size_metrics, alignment_summary_metrics, hs_metrics, flagstats, verify_bam_id_metrics, verify_bam_id_depth]
