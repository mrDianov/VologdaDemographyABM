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
	
	init {
		step <- 1#year;
		create region number: 1 with: (name: "Вологда", init_size: 318112);
		create region number: 1 with: (name: "Череповец", init_size: 301040);
		create region number: 1 with: (name: "Череповец1", init_size: 301040);
		create region number: 1 with: (name: "Череповец2", init_size: 301040);
	}
}

experiment main_experiment {
	output{
        display myDisplay {
            species region;
        }
    }
}