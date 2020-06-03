#!/bin/bash

sed -i 's/enrichment: no/enrichment: yes/g' /sdmrdfizer/config.ini
echo "config,size,type,mapping,results,time">>/results/results-times.csv
echo "config,size,type,mapping,run,results,time">>/results/results-times-detail.csv
declare -a configs=("enrich" "noenrich")
declare -a sizes=("10k 100k 1M 10M")
declare -a types=("25_10times" "25_20times" "75_10times" "75_20times")
declare -a mappings=("2POM_Normal.ttl" "2TM_reference_sameSource.ttl" "5POM_Normal.ttl" "5TM_reference_sameSource.ttl" "10POM_Normal.ttl" "10TM_reference_sameSource.ttl")

for config in "${configs[@]}"
do
	for size in "${sizes[@]}"
	do
		for type in "${types[@]}"
		do
			cp /data/simple/${size}/${type}.csv /data/data.csv
			total=0
			for mapping in "${mapping[@]}"
			do
				sed -i "s/mappings\/.*.ttl/mappings\/${mapping}/g" /sdmrdfizer/config.ini
				for j in 1 2 3 4 5
				do
					echo "---Running $config size $size in $type for time $j with mapping $mapping---"
					start=$(date +%s.%N)
					timeout 5h python3 /sdmrdfizer/rdfizer/run_rdfizer.py /sdmrdfizer/config.ini
					exit_status=$?
					finish=$(date +%s.%N)
					dur=$(echo "$finish - $start" | bc)
					if [ $exit_status -eq 124 ];then
						echo "$config,$size,$type,$mapping,0,TimeOut">>/results/results-times.csv
						total=0
						break
					else
						lines=$(cat "/results/output.nt" | wc -l)
						echo "$config,$size,$type,$mapping,$j,$lines,$dur">>/results/results-times-detail.csv
						total=$(echo "$total+$dur" | bc)
						if [ $j -ne 5 ];then
							rm /results/output.nt
						fi
					fi
				done
				mv /results/output.nt /results/output-$config-$size-$type-$mapping.nt
				mv /results/output_datasets_stats.csv /results/stats_output-$config-$size-$type-$mapping.csv
				if (( $(echo "$total > 0" | bc -l) ));then
					total=$(echo "$total/5" | bc -l)
					echo "$config,$size,$type,$mapping,$lines,$total">>/results/results-times.csv
				fi
			done
		done
	done
	sed -i 's/enrichment: yes/enrichment: no/g' /sdmrdfizer/config.ini	
done
rm /data/*.csv