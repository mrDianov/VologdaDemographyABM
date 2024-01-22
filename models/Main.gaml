/**
* Name: Main
* Based on the internal empty template. 
* Author: dianovds
* Tags: 
*/


model Main

import "Region.gaml"
import "Humankind.gaml"

global {
	int vologda_size <- 1300000;
	int death_inc <- 0;
	int prev_death_cnt <- 0;
	int birth_inc <- 0;
	int prev_size <- vologda_size;
	init {
		create database;
		step <- 1#year;
		starting_date <- date("20220101");
		create region number: 1 with: (name: "Вологда", init_size: vologda_size);
//		create region number: 1 with: (name: "Вологда", init_size: 318112);
//		create region number: 1 with: (name: "Череповец", init_size: 301040);
	}
	reflex death {
		int current_size <- sum(region collect each.popsize());
		death_inc <- death_cnt - prev_death_cnt;
		prev_death_cnt <- death_cnt;
		birth_inc <- current_size + death_inc - prev_size;
		if (current_size = 0 and cycle > 5) {
			do pause;
		}
		prev_size <- current_size;
	}
}

experiment main_experiment {
	output{
        display myDisplay {
            species region;
            chart "stats" type: series {
            	data "stats data" value: (sum(region collect each.popsize()));
            	data "death data" value: death_inc;
            	data "birth data" value: birth_inc;
            }
        }
    }
}