#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "somatic WGS pipeline with qc"
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
    interval_list:
        type: File
    cosmic_vcf:
        type: File?
        secondaryFiles: [.tbi]
    omni_vcf:
        type: File
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
    tumor_gc_bias_metrics:
        type: File
        outputSource: tumor_qc/gc_bias_metrics
    tumor_qc_bias_metrics_chart:
        type: File
        outputSource: tumor_qc/gc_bias_metrics_chart
    tumor_gc_bias_metrics_summary:
        type: File
        outputSource: tumor_qc/gc_bias_metrics_summary
    tumor_qc_wgs_metrics:
        type: File
        outputSource: tumor_qc/wgs_metrics
    tumor_qc_flagstats:
        type: File
        outputSource: tumor_qc/flagstats
    tumor_qc_verify_bam_id_metrics:
        type: File
        outputSource: tumor_qc/verify_bam_id_metrics
    tumor_qc_verify_bam_id_depth:
        type: File
        outputSource: tumor_qc/verify_bam_id_depth
    normal_insert_size_metrics:
        type: File
        outputSource: normal_qc/insert_size_metrics
    normal_alignment_summary_metrics:
        type: File
        outputSource: normal_qc/alignment_summary_metrics
    normal_gc_bias_metrics:
        type: File
        outputSource: normal_qc/gc_bias_metrics
    normal_qc_bias_metrics_chart:
        type: File
        outputSource: normal_qc/gc_bias_metrics_chart
    normal_gc_bias_metrics_summary:
        type: File
        outputSource: normal_qc/gc_bias_metrics_summary
    normal_qc_wgs_metrics:
        type: File
        outputSource: normal_qc/wgs_metrics
    normal_qc_flagstats:
        type: File
        outputSource: normal_qc/flagstats
    normal_qc_verify_bam_id_metrics:
        type: File
        outputSource: normal_qc/verify_bam_id_metrics
    normal_qc_verify_bam_id_depth:
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
            interval_list: interval_list
            strelka_exome_mode:
                default: true
            cosmic_vcf: cosmic_vcf
        out: [final_vcf, tumor_bam, normal_bam]
    tumor_qc:
        run: qc/workflow_wgs.cwl
        in:
            bam: alignment_and_detect_variants/tumor_bam
            reference: reference
            intervals: interval_list
            omni_vcf: omni_vcf
        out: [insert_size_metrics, alignment_summary_metrics, gc_bias_metrics, gc_bias_metrics_chart, gc_bias_metrics_summary, wgs_metrics, flagstats, verify_bam_id_metrics, verify_bam_id_depth]
    normal_qc:
        run: qc/workflow_wgs.cwl
        in:
            bam: alignment_and_detect_variants/normal_bam
            reference: reference
            intervals: interval_list
            omni_vcf: omni_vcf
        out: [insert_size_metrics, alignment_summary_metrics, gc_bias_metrics, gc_bias_metrics_chart, gc_bias_metrics_summary, wgs_metrics, flagstats, verify_bam_id_metrics, verify_bam_id_depth]
