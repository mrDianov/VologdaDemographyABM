/**
* Name: Humankind
* Based on the internal empty template. 
* Author: dianov
* Tags: 
*/


model Humankind

import "PyramidModel.gaml" 
import "DemographyDatabase.gaml"

global {
	string MALE <- 'm';
	string FEMALE <- 'f';
	int death_cnt <- 0;
	int creationIndex <- 0;
	list<float> m_list <- [0.004356, 0.00045, 0.000315, 0.000226, 0.000172, 0.000178, 0.000154, 0.00016, 0.000152, 0.00015, 0.000161, 0.000193, 0.000215, 0.000259, 0.000345, 0.0004, 0.000427, 0.000493, 0.000736, 0.001004, 0.001181, 0.001333, 0.001295, 0.001463, 0.001453, 0.001592, 0.001556, 0.001694, 0.001803, 0.001839, 0.002026, 0.002169, 0.002386, 0.002733, 0.003019, 0.00336, 0.003428, 0.003732, 0.004123, 0.004549, 0.004944, 0.005081, 0.005503, 0.006073, 0.006154, 0.006496, 0.006767, 0.006952, 0.007299, 0.007611, 0.00822, 0.00812, 0.008599, 0.009346, 0.009927, 0.010867, 0.011187, 0.012088, 0.012958, 0.014059, 0.015251, 0.016151, 0.017716, 0.019424, 0.020667, 0.021644, 0.023623, 0.025344, 0.027223, 0.029137, 0.032544, 0.033424, 0.036342, 0.041972, 0.039804, 0.050558, 0.045901, 0.051014, 0.058128, 0.057692, 0.077806, 0.076142, 0.088139, 0.102196, 0.104799, 0.11911, 0.131147, 0.144309, 0.155713, 0.177249, 0.197253, 0.198905, 0.217091, 0.256453, 0.263833, 0.264779, 0.260201, 0.218944, 0.205048, 0.177401, 0.074475];
}

species human {
	date birthday;
	string sex;
	int motherId;
	int fatherId;
	human partner;
	int child_cnt <- 0;
	int id;
	
	init {
		creationIndex <- creationIndex + 1;
		id <- creationIndex;
//		birthday <- current_date; // временная мера
		if(flip(world.male_sex_p(get_age()))) {sex <- MALE;}
		else {sex <- FEMALE;}
		ask database {
			if (! isConnected()) {
				do connect;
			}

			do createHumanRecord(myself.id, myself.motherId, myself.fatherId);
		}
	}
	
	int get_age {
		return current_date.year - birthday.year;
	}
	
//	list<human> get_parents(int depth) { // главное не переборщить с рекурсией
//		list<human> result <- [self];
//		if(depth >= 0 and mother != nil and father != nil) {
//			result <- result + mother.get_parents(depth - 1);
//			result <- result + father.get_parents(depth - 1);
//		}
//		return result;
//	}
//	
	bool is_relatives(human h) {
////		list<human> self_parents <- get_parents(2);
////		list<human> pair_parents <- h.get_parents(2);
////		list<human> intersection <- self_parents where (each in pair_parents);
//		if(length(intersection) > 0) {
//			return true;
//		}
//		return false;
		ask database {
			return hasCommonRelatives(myself.id, h.id, 2);
		}
	}
	
	bool is_reproductive {
		if(get_age() > 18 and get_age() < 60) {
			return true;
		}
		return false;
	}
	
	action make_pair(human h) {
		h.partner <- self;
		partner <- h;
	}
	
	action birth(human f) {
		create species(self) with: (motherId: self.id, fatherId: f.id, birthday: current_date);
		child_cnt <- child_cnt + 1;
		if(not dead(f)) {
		f.child_cnt <- f.child_cnt + 1;
	}
	
	}
	
	reflex pairing when: is_reproductive() and (sex = MALE) and partner = nil {
//		write self;
		ask species(self) where(each.sex = FEMALE) where(each.is_reproductive()) {
//			write self;
			if(self.partner = nil and myself.partner = nil and self.sex = FEMALE and (not self.is_relatives(myself))) {
				do make_pair(myself);
			}
		}
	}
	
	reflex new_baby when: partner != nil and sex = FEMALE and !dead(partner) {
		float v <- 0.55;
		if(child_cnt = 1) {
			v <- 0.33;
		} else {
			v <- 0.12;
		}
		if (flip(v/(60-18))) {
			do birth(partner);
		}
	}
	
	reflex alive {
		float m <- last(m_list);
		if (get_age() < length(m_list)) {
			m <- m_list[get_age()];
		}
		float death_p <- (2*m)/(2+m);
		if(flip(death_p)) {
			death_cnt <- death_cnt + 1;
			do die;
		}
	}
}

