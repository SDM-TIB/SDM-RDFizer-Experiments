#!/bin/bash

sed -i 's/enrichment: no/enrichment: yes/g' /scripts/config.ini
echo "config,size,type,mapping,results,time">>/results/results-times.csv
echo "config,size,type,mapping,run,results,time">>/results/results-times-detail.csv
declare -a configs=("enrich" "noenrich")
declare -a sizes=("10k" "100k" "1M")
declare -a types=("25_20times" "75_20times")
declare -a mappings=("1POM_Normal.ttl" "4POM_Normal.ttl")

for config in "${configs[@]}"
do
	for size in "${sizes[@]}"
	do
		for type in "${types[@]}"
		do
			rm /data/*.csv
			cp /data/simple/${size}/${type}.csv /data/data.csv
			total=0
			for mapping in "${mappings[@]}"
			do
				sed -i "s/mappings\/.*.ttl/mappings\/${mapping}/g" /scripts/config.ini
				for j in 1 2 3 4 5
				do
					echo "---Running $config size $size in $type for time $j with mapping $mapping---"
					start=$(date +%s.%N)
					timeout 5h python3 /sdmrdfizer/run_rdfizer.py /scripts/config.ini
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
	sed -i 's/enrichment: yes/enrichment: no/g' /scripts/config.ini	
done
rm /data/*.csv