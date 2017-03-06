#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: ['/usr/bin/perl', 'helper.pl']
requirements:
    - class: DockerRequirement
      dockerPull: "ubuntu:xenial"
    - class: InitialWorkDirRequirement
      listing:
          - entryname: 'helper.pl'
            entry: |
                use feature qw(say);

                for my $line (<>) {
                    chomp $line;

                    next if substr($line,0,1) eq '@'; #skip header lines

                    my ($chrom, $start, $stop) = split(/\\t/, $line);
                    say(join("\\t", $chrom, $start-1, $stop));
                }

stdout: "interval_list.bed"
inputs:
    interval_list:
        type: File
        inputBinding:
            position: 1
outputs:
    interval_bed:
        type: stdout

