#!/bin/bash


#echo "config,size,type,mapping,results,time">>/results/results-times.csv
#echo "config,size,type,mapping,run,results,time">>/results/results-times-detail.csv
declare -a sizes=("10k" "100k" "1M" "10M")
declare -a types=("25_10times" "25_20times" "75_10times" "75_20times")
declare -a mappings=("2TM_joinCondition_differentSource.ttl" "5TM_joinCondition_differentSource.ttl" "10TM_joinCondition_differentSource.ttl")
config="rmlmapper"

for size in "${sizes[@]}"
do
	for type in "${types[@]}"
	do
		cp /data/complex/${size}/${type}_source*.csv /data/
		rename "s/${type}_//" /data/*.csv
		total=0
		for mapping in "${mappings[@]}"
		do
			for j in 1 2 3 4 5
			do
				echo "---Running $config size $size in $type for time $j with mapping $mapping---"
				start=$(date +%s.%N)
				timeout 5h java -jar /rmlmapper/rmlmapper.jar -m /mappings/${mapping} -o /results/output.nt -d
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
			if (( $(echo "$total > 0" | bc -l) ));then
				total=$(echo "$total/5" | bc -l)
				echo "$config,$size,$type,$mapping,$lines,$total">>/results/results-times.csv
			fi
		done
	done
done

rm /data/*.csv