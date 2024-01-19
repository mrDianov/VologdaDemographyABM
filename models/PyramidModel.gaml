/**
* Name: PyramidModel
* Based on the internal empty template. 
* Author: dianov
* Tags: 
*/


model PyramidModel

global {
	file pyramid_file <- csv_file("../includes/pyramid.csv", true);
	init {
		loop el over: age_proportions() {
			write el;
		}
		write male_sex_p(0);
	}
	
	list<float> age_proportions {
		list<float> res <- [];
		loop i from: 0 to: pyramid_file.contents.rows-1{
			add float(pyramid_file.contents[0,i]) to: res;
		}
		return res;
	}
	
	float male_sex_p(int age) {
		return float(pyramid_file.contents[1, age]);
	}
}