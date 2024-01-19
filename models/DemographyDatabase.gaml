/**
* Name: DemographyDatabase
* Based on the internal empty template. 
* Author: dianov
* Tags: 
*/


model DemographyDatabase 

/* Insert your model definition here */
global {
//	init {
//		create database;
//	}
}

species database parent: AgentDB {
	map<string, string> SQLITE_PARAMS <- [
		'dbtype'::'sqlite',
		'database'::'../includes/sqlite.db'
	];
	
	init {
		do connect params: SQLITE_PARAMS;
		do destroy;
		do executeUpdate updateComm: "CREATE TABLE relatives (" +
			"id INTEGER NOT NULL," +
			"mother INTEGER," +
			"father INTEGER," +
			"CONSTRAINT relatives_pk PRIMARY KEY (id)," +
			"CONSTRAINT relatives_mother_FK FOREIGN KEY (mother) REFERENCES relatives(id)," +
			"CONSTRAINT relatives_father_FK FOREIGN KEY (father) REFERENCES relatives(id));";
			
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
	
	action createHumanRecord(int id, int motherId, int fatherId) {
		string mid <- motherId = 0 ? nil : motherId;
		string fid <- fatherId = 0 ? nil : fatherId;
//		do executeUpdate updateComm: "INSERT INTO relatives (id, mother, father) VALUES(0, 0, 0);";
		do insert into: "relatives" columns: ["id", "mother", "father"] values: [id, motherId, fatherId];
	}
	
	int getMotherId(int id) {
		int motherId <- select("SELECT mother FROM relatives where id=?", [id])[2][0][0];
		return motherId;
	}
	
	int getFatherId(int id) {
		int fatherId <- select("SELECT father FROM relatives where id = ?;", [id])[2][0][0];
		return fatherId;
	}
}

experiment startDb {
	
}