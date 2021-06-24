# Experiments for CIKM 2020 - Resource Track 

## Resources
1) Mappings: Predicate-object-map with column reference (1-4 POMs) or simple experiment, Reference join without condition (2-5 TriplesMap) or medium experiment and  Join Condition (2-5 TriplesMap) or complex experiment.
2) Data: 10k, 100K and 1M rows per source with 25-75% of duplicates (10 or 20 times each duplicate)
3) Engines: Docker compose file with images of RMLMapper v4.7, RocketRML v1.7.0 and SDM-RDFizer v3.2

## How to run it?
1) Download [data](https://doi.org/10.6084/m9.figshare.14838342.v1)
2) Go to engines folder and run `docker-compose up -d`
3) For run each experiment run `docker exec -it [rmlmapper|sdmrdfizer|rocketrml] bash /scripts/run-[simple|medium|complex].sh`
4) Results available at results folder.
