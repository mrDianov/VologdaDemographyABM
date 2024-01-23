/**
* Name: Region
* Based on the internal empty template. 
* Author: dianov
* Tags: 
*/


model Region

import "Humankind.gaml"
import "PyramidModel.gaml"

global {
	list<float> age_proportions <- age_proportions();
}

species region {
	string name <- "unknown";
	int init_size <- 0;
	int size <- 0;
	
	
	init {
		step <- 1#year;
		int age <- 0;
		loop proportion over: age_proportions {
			create citizen number: int(init_size * proportion) with: (birthday: starting_date-age*#year, fatherId: 0, motherId: 0);
			age <- age + 1;
		}
	}
	
	reflex update_size {
		size <- popsize();
	}
	
	int popsize {
		return length(citizen.population);
	}
	
	species citizen parent: human {
		init {
			
		}
	}
}

