/**
* Name: Humankind
* Based on the internal empty template. 
* Author: dianov
* Tags: 
*/


model Humankind

global {
	string MALE <- 'm';
	string FEMALE <- 'f';
}

species human {
	date birthday;
	string sex;
	human mother;
	human father;
	human partner;
	int child_cnt <- 0;
	
	init {
		birthday <- current_date; // временная мера
		if(flip(0.5)) {sex <- MALE;}
		else {sex <- FEMALE;}
	}
	
	int get_age {
		return current_date.year - birthday.year;
	}
	
	list<human> get_parents(int depth) { // главное не переборщить с рекурсией
		list<human> result <- [self];
		if(depth >= 0 and mother != nil and father != nil) {
			result <- result + mother.get_parents(depth - 1);
			result <- result + father.get_parents(depth - 1);
		}
		return result;
	}
	
	bool is_relatives(human h) {
		list<human> self_parents <- get_parents(2);
		list<human> pair_parents <- h.get_parents(2);
		list<human> intersection <- self_parents where (each in pair_parents);
		if(length(intersection) > 0) {
			return true;
		}
		return false;
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
		create human with: (mother: self, father: f);
		child_cnt <- child_cnt + 1;
		f.child_cnt <- f.child_cnt + 1;
	}
	
	reflex pairing when: is_reproductive() and (sex = MALE) and partner = nil {
		ask human where (each.sex = FEMALE) where (each.is_reproductive()) {
			if(self.partner = nil and myself.partner = nil and self.sex = FEMALE and (not self.is_relatives(myself))) {
				do make_pair(myself);
			}
		}
	}
	
	reflex new_baby when: partner != nil and sex = FEMALE {
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
		if(not flip((100-get_age())/100)) {
			do die;
		}
	}
}

