/**
* Name: DemographyDatabase
* Based on the internal empty template. 
* Author: dianov
* Tags: 
*/


model DemographyDatabase 

/* Insert your model definition here */
global {
	init {
		create database;
		ask database {
			write getReproductiveWomen();
		}
	}
}

species database parent: AgentDB {
	map<string, string> SQLITE_PARAMS <- [
		'dbtype'::'sqlite',
		'database'::'../includes/sqlite.db'
	];
	
	map<string, string> PGSQL_PARAMS <- [
		"dbtype"::"postgres",
		"host"::"localhost",
		"port"::"5432",
		"user"::"gama",
		"passwd"::"123456",
		"database"::"demography"
	];
	
	init {
//		do connect params: SQLITE_PARAMS;
		do connect params: PGSQL_PARAMS;
//		do destroy;
//		do executeUpdate updateComm: "CREATE TABLE relatives (" +
//			"id INTEGER NOT NULL," +
//			"mother INTEGER," +
//			"father INTEGER," +
//			"CONSTRAINT relatives_pk PRIMARY KEY (id)," +
//			"CONSTRAINT relatives_mother_FK FOREIGN KEY (mother) REFERENCES relatives(id)," +
//			"CONSTRAINT relatives_father_FK FOREIGN KEY (father) REFERENCES relatives(id));";
			
//		do createHumanRecord(1,2,3);
//		do createHumanRecord(2, 0, 0);
//		
//		write getMotherId(1);
//		write getFatherId(1);
//		
//		write getMotherId(2);
//		write getFatherId(2);
//		
//		do destroy;
	}

	action destroy {
		do executeUpdate updateComm: "DROP TABLE relatives;";
	}
	
	bool hasCommonRelatives(int id1, int id2, int depth) {
		return false;
	}
	
	int createHumanRecord(int motherId, int fatherId, string sex, date birthday) {
		string mid <- motherId = 0 ? nil : motherId;
		string fid <- fatherId = 0 ? nil : fatherId;
//		do executeUpdate updateComm: "INSERT INTO relatives (id, mother, father) VALUES(0, 0, 0);";
//		do insert into: "humankind" columns: ["mother_id", "father_id", "sex", "birthday"] values: [motherId, fatherId, sex = "m", string(birthday, "yyyyMMdd")];
		do executeUpdate updateComm: "INSERT INTO humankind (mother_id, father_id, sex, birthday) VALUES(nullif(?,0), nullif(?,0), ?, date(?));" 
			values: [motherId, fatherId, sex = "m", string(birthday, "yyyyMMdd")];
		return int(select('SELECT "last_value" FROM public.humankind_id_seq')[2][0][0]);
	}
	
	int getMotherId(int id) {
		int motherId <- select("SELECT mother FROM relatives where id=?", [id])[2][0][0];
		return motherId;
	}
	
	int getFatherId(int id) {
		int fatherId <- select("SELECT father FROM relatives where id = ?;", [id])[2][0][0];
		return fatherId;
	}
	
	list<list> getReproductiveWomen {
		return select("select * from gama.reproductive_women_view rmv")[2];
	}
	
	list<list> getReproductiveMen {
		return select("select * from gama.reproductive_men_view rmv")[2];
	}
	
	action makePair(int manId, int womanId) {
		do insert into: "pairs" columns: ["human_man_id", "human_woman_id"] values: [manId, womanId];
	}
}

experiment startDb {
	
}