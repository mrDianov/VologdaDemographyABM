/**
* Name: Region
* Based on the internal empty template. 
* Author: dianov
* Tags: 
*/


model Region

import "Humankind.gaml"

species region {
	string name <- "unknown";
	int init_size <- 0;
	int size <- 0;
	
	init {
		create citizen number: init_size;
	}
	
	reflex update_size {
		size <- popsize();
	}
	
	int popsize {
		return length(citizen.population);
	}
	
	species citizen parent: human;
}

