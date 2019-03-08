SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP TABLE IF EXISTS Instructors, 
	Courses, 
	SectionsCurrent, 
	SectionsHistory, 
	Outcomes,
	OutcomeResults,
	AssessmentTypes,
	Assessments,
	Rubrics,
	RubricNames,
	Narratives,
	PerformanceLevels,
	CourseMapping;

-- -----------------------------------------------------
-- Table `Instructors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instructors` (
  `instructorId` VARCHAR(15) NOT NULL,
  `instructorFirstName` VARCHAR(45) NOT NULL,
  `instructorLastName` VARCHAR(45) NULL,
  `instructorEmail` VARCHAR(45) NOT NULL,
  `instructorPassword` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`instructorId`));



-- -----------------------------------------------------
-- Table `Courses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Courses` (
	`courseId` VARCHAR(10) NOT NULL,
	`courseTitle` VARCHAR(45) NOT NULL,
	PRIMARY KEY (`courseId`));


-- -----------------------------------------------------
-- Table `SectionsCurrent`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SectionsCurrent` (
  `sectionId` INT NOT NULL AUTO_INCREMENT,
  `courseId` VARCHAR(10) NOT NULL,
  `instructorId` VARCHAR(15) NOT NULL,
  `sectionSemester` VARCHAR(6) NOT NULL,
  `sectionYear` YEAR NOT NULL,
  PRIMARY KEY (`sectionId`),
  INDEX `fk_Sections_Courses1_idx` (`courseId` ASC),
  INDEX `fk_Sections_Instructors1_idx` (`instructorId` ASC),
  CONSTRAINT `fk_Sections_Courses2`
    FOREIGN KEY (`courseId`)
    REFERENCES `Courses` (`courseId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_UsersToSections_Users2`
    FOREIGN KEY (`instructorId`)
    REFERENCES `Instructors` (`instructorId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------
-- Table 'SectionsHistory'
-- ----------------------------------------------------
CREATE TABLE IF NOT EXISTS SectionsHistory (
	sectionId INT NOT NULL AUTO_INCREMENT,
	courseId VARCHAR(10) NOT NULL,
	instructorId VARCHAR(15) NOT NULL,
	sectionSemester VARCHAR(6) NOT NULL,
	sectionYear YEAR NOT NULL,
	PRIMARY KEY (sectionId));

-- -----------------------------------------------------
-- Table `Outcomes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Outcomes` (
  `outcomeMajor` enum("CS", "CpE", "EE") NOT NULL,
  `outcomeId` VARCHAR(3) NOT NULL,
  `outcomeDescription` BLOB NOT NULL,
  `outcomeRubric` INT DEFAULT NULL,
  PRIMARY KEY (`outcomeId`, `outcomeMajor`),
  INDEX `fk_Outcomes_Rubrics1_idx` (`outcomeRubric` ASC));

-- -----------------------------------------------------
-- Table OutcomeResults
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS OutcomeResults (
	sectionId INT NOT NULL,
	outcomeMajor enum("CS", "CpE", "EE") NOT NULL,
	outcomeId VARCHAR(3) NOT NULL,
	performanceLevel INT  NOT NULL,
	numberOfStudents INT NOT NULL
);

-- ----------------------------------------------------
-- Table AssessmentTypes
-- ----------------------------------------------------
CREATE TABLE IF NOT EXISTS AssessmentTypes (
	assessmentId INT NOT NULL AUTO_INCREMENT,
	assessmentType CHAR(25) NOT NULL,
	PRIMARY KEY (assessmentId));

-- ----------------------------------------------------
-- Table Assessments
-- ----------------------------------------------------
CREATE TABLE IF NOT EXISTS Assessments (
	sectionId INT NOT NULL,
	assessmentId INT NOT NULL,
	assessmentDesc CHAR(100) NOT NULL,
	outcomeMajor enum("CS", "CpE", "EE") NOT NULL,
	outcomeId VARCHAR(3) NOT NULL,
	weight DECIMAL(9,2) NOT NULL,
	rubricId INT NOT NULL,
	PRIMARY KEY (sectionId, assessmentId, outcomeId));


-- -----------------------------------------------------
-- Table Rubrics
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Rubrics (
	rubricId INT NOT NULL,
	performanceLevel INT NOT NULL,
	description BLOB NOT NULL,
	PRIMARY KEY (rubricId, performanceLevel));


-- -----------------------------------------------------
-- Table RubricNames
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS RubricNames (
	rubricId INT NOT NULL AUTO_INCREMENT,
	rubricName VARCHAR(25),
	outcomeId VARCHAR(3) NOT NULL,
	instructorId VARCHAR(15) DEFAULT NULL,
	PRIMARY KEY (rubricId)
);


-- -----------------------------------------------------
-- Table Narratives
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Narratives (
	sectionId INT NOT NULL,
	outcomeMajor enum("CS", "CpE", "EE") NOT NULL,
	outcomeId VARCHAR(3) NOT NULL,
	strengths BLOB NOT NULL,
	weaknesses BLOB NOT NULL,
	actions BLOB NOT NULL
);

-- -----------------------------------------------------
-- Table PerformanceLevels
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PerformanceLevels (
	performanceLevel INT NOT NULL,
	description enum("Not Meets Expectations", "Meets Expectations", "Exceeds Expectations") NOT NULL,
	PRIMARY KEY(performanceLevel));

-- -----------------------------------------------------
-- Table `CourseMapping`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CourseMapping` (
	`courseId` VARCHAR(10) NOT NULL,
	`outcomeMajor` enum("CS", "CpE", "EE") NOT NULL,
	`outcomeId` VARCHAR(3) NOT NULL,
	PRIMARY KEY (`courseId`, `outcomeId`, `outcomeMajor`),
	INDEX `fk_Courses_has_Outcomes_Outcomes1_idx` (`outcomeId` ASC, `outcomeMajor` ASC),
	INDEX `fk_Courses_has_Outcomes_Courses1_idx` (`courseId` ASC),
	CONSTRAINT `fk_Courses_has_Outcomes_Courses1`
	FOREIGN KEY (`courseId`)
	REFERENCES `Courses` (`courseId`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	CONSTRAINT `fk_Courses_has_Outcomes_Outcomes1`
	FOREIGN KEY (`outcomeId` , `outcomeMajor`)
	REFERENCES `Outcomes` (`outcomeId` , `outcomeMajor`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

insert into Courses values ("CS312", "Python");
insert into Courses values ("CS340", "C#");
insert into Courses values ("CS360", "C");
insert into Courses values ("CS395", "C++");
insert into Courses values ("CS402", "Senior Design");
insert into Courses values ("CS365", "Java");

insert into Courses values ("ECE255", "The Motherboard");
insert into Courses values ("ECE256", "The Fatherboard");
insert into Courses values ("ECE351", "Graphics Cards");
insert into Courses values ("ECE395", "Keyboards");
insert into Courses values ("ECE402", "Senior Design");

insert into Courses values ("ECE315", "Wires");
insert into Courses values ("ECE325", "Circuits");
insert into Courses values ("ECE335", "Chips");
insert into Courses values ("ECE342", "AC/DC and Other Rock Bands");

insert into Instructors values("JB", "Joe", "Budden", "jb@vols.utk.edu", "password");
insert into Instructors values("lilY", "Lil", "Yachty", "lilY@vols.utk.edu", "password");
insert into Instructors values("2pac", "Tupac", "Shakur", "2pac@vols.utk.edu", "password");
insert into Instructors values("BIG", "The Notorious", "BIG", "BIG@vols.utk.edu", "password");

insert into SectionsCurrent (courseId, instructorId, sectionSemester, sectionYear) values ("CS312", "lilY", "Fall", 2018); 
insert into SectionsCurrent (courseId, instructorId, sectionSemester, sectionYear) values ("CS340", "2pac", "Fall", 2018);
insert into SectionsCurrent (courseId, instructorId, sectionSemester, sectionYear) values ("CS360", "2pac", "Fall", 2018);
insert into SectionsCurrent (courseId, instructorId, sectionSemester, sectionYear) values ("CS395", "lilY", "Fall", 2018);
insert into SectionsCurrent (courseId, instructorId, sectionSemester, sectionYear) values ("CS402", "JB", "Fall", 2018);
insert into SectionsCurrent (courseId, instructorId, sectionSemester, sectionYear) values ("CS365", "2pac", "Fall", 2018);

insert into SectionsCurrent (courseId, instructorId, sectionSemester, sectionYear) values ("ECE255", "BIG", "Fall", 2018);
insert into SectionsCurrent (courseId, instructorId, sectionSemester, sectionYear) values ("ECE256", "BIG", "Fall", 2018);
insert into SectionsCurrent (courseId, instructorId, sectionSemester, sectionYear) values ("ECE351", "JB", "Fall", 2018);
insert into SectionsCurrent (courseId, instructorId, sectionSemester, sectionYear) values ("ECE395", "JB", "Fall", 2018);
insert into SectionsCurrent (courseId, instructorId, sectionSemester, sectionYear) values ("ECE402", "lilY", "Fall", 2018);

insert into SectionsCurrent (courseId, instructorId, sectionSemester, sectionYear) values ("ECE315", "BIG", "Fall", 2018);
insert into SectionsCurrent (courseId, instructorId, sectionSemester, sectionYear) values ("ECE335", "JB", "Fall", 2018);
insert into SectionsCurrent (courseId, instructorId, sectionSemester, sectionYear) values ("ECE342", "2pac", "Fall", 2018);
insert into SectionsCurrent (courseId, instructorId, sectionSemester, sectionYear) values ("ECE325", "lilY", "Fall", 2018);

insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("CS312", "2pac", "Spring", 2018); 
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("CS340", "lilY", "Spring", 2018);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("CS360", "2pac", "Spring", 2018);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("CS395", "lilY", "Spring", 2018);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("CS402", "JB", "Spring", 2018);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("CS365", "2pac", "Spring", 2018);

insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("ECE255", "JB", "Spring", 2018);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("ECE256", "BIG", "Spring", 2018);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("ECE351", "BIG", "Spring", 2018);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("ECE395", "JB", "Spring", 2018);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("ECE402", "lilY", "Spring", 2018);

insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("ECE315", "BIG", "Spring", 2018);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("ECE335", "JB", "Spring", 2018);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("ECE342", "2pac", "Spring", 2018);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("ECE325", "lilY", "Spring", 2018);

insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("CS312", "lilY", "Fall", 2017); 
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("CS340", "2pac", "Fall", 2017);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("CS360", "2pac", "Fall", 2017);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("CS395", "lilY", "Fall", 2017);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("CS402", "JB", "Fall", 2017);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("CS365", "2pac", "Fall", 2017);

insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("ECE255", "JB", "Fall", 2017);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("ECE256", "BIG", "Fall", 2017);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("ECE351", "BIG", "Fall", 2017);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("ECE395", "JB", "Fall", 2017);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("ECE402", "lilY", "Fall", 2017);

insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("ECE315", "BIG", "Fall", 2017);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("ECE335", "JB", "Fall", 2017);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("ECE342", "2pac", "Fall", 2017);
insert into SectionsHistory (courseId, instructorId, sectionSemester, sectionYear) values ("ECE325", "lilY", "Fall", 2017);

insert into Outcomes values ("CS", "C1", "Analyze a complex computing problem and to apply principles of computing and other relevant disciplines to identify solutions.", NULL);
insert into Outcomes values ("CS", "C2", "Design, implement, and evaluate a computing-based solution to meet a given set of computing requirements in the context of the program’s discipline.", NULL);
insert into Outcomes values ("CS", "C3", "Communicate effectively in a variety of professional contexts.", 1);
insert into Outcomes values ("CS", "C4", "Recognize professional responsibilities and make informed judgments in computing practice based on legal and ethical principles.", NULL);
insert into Outcomes values ("CS", "C5", "Function effectively as a member or leader of a team engaged in activities appropriate to the program’s discipline.", NULL);
insert into Outcomes values ("CS", "C6", "Apply computer science theory and software development fundamentals to produce computing-based solutions.", NULL);

insert into Outcomes values ("CS", "C7", 
	"Graduates who enter professional practice will demonstrate progression toward positions of technical responsibility or leadership in their discipline.", NULL);
insert into Outcomes values ("CS", "C8", 
	"Graduates who pursue full-time graduate or advanced professional study will successfully complete their programs of study in their discipline.", NULL);
insert into Outcomes values ("CS", "C9",
	"Graduates will demonstrate professionalism that is consistent with the goals of life-long learning and professional ethics.", NULL);

insert into Outcomes values ("CpE", "E1", 
	"an ability to identify, formulate, and solve complex engineering problems by applying principles of engineering, science, and mathematics.", NULL);
insert into Outcomes values ("CpE", "E2", 
	"an ability to apply engineering design to produce solutions that meet specified needs with consideration of public health, safety, and welfare, as well as global, cultural, social, environmental, and economic factors.", NULL);
insert into Outcomes values ("CpE", "E3", 
	"an ability to communicate effectively with a range of audiences.", NULL);
insert into Outcomes values ("CpE", "E4", 
	"an ability to recognize ethical and professional responsibilities in engineering situations and make informed judgments, which must consider the impact of engineering solutions in global, economic, environmental, and societal contexts.", NULL);
insert into Outcomes values ("CpE", "E5", 
	"an ability to function effectively on a team whose members together provide leadership, create a collaborative and inclusive environment, establish goals, plan tasks, and meet objectives.", NULL);
insert into Outcomes values ("CpE", "E6", 
	"an ability to develop and conduct appropriate experimentation, analyze and interpret data, and use engineering judgment to draw conclusions.", NULL);
insert into Outcomes values ("CpE", "E7",
	"an ability to acquire and apply new knowledge as needed, using appropriate learning strategies.", NULL);

insert into Outcomes values ("CpE", "E8", 
	"Graduates who enter professional practice will demonstrate progression toward positions of technical responsibility or leadership in their discipline.", NULL);
insert into Outcomes values ("CpE", "E9", 
	"Graduates who pursue full-time graduate or advanced professional study will successfully complete their programs of study in their discipline.", NULL);
insert into Outcomes values ("CpE", "E10",
	"Graduates will demonstrate professionalism that is consistent with the goals of life-long learning and professional ethics.", NULL);

insert into Outcomes values ("EE", "E11", 
	"an ability to identify, formulate, and solve complex engineering problems by applying principles of engineering, science, and mathematics.", NULL);
insert into Outcomes values ("EE", "E12", 
	"an ability to apply engineering design to produce solutions that meet specified needs with consideration of public health, safety, and welfare, as well as global, cultural, social, environmental, and economic factors.", NULL);
insert into Outcomes values ("EE", "E13", 
	"an ability to communicate effectively with a range of audiences.", NULL);
insert into Outcomes values ("EE", "E14", 
	"an ability to recognize ethical and professional responsibilities in engineering situations and make informed judgments, which must consider the impact of engineering solutions in global, economic, environmental, and societal contexts.", NULL);
insert into Outcomes values ("EE", "E15", 
	"an ability to function effectively on a team whose members together provide leadership, create a collaborative and inclusive environment, establish goals, plan tasks, and meet objectives.", NULL);
insert into Outcomes values ("EE", "E16", 
	"an ability to develop and conduct appropriate experimentation, analyze and interpret data, and use engineering judgment to draw conclusions.", NULL);
insert into Outcomes values ("EE", "E17",
	"an ability to acquire and apply new knowledge as needed, using appropriate learning strategies.", NULL);

insert into Outcomes values ("EE", "E18", 
	"Graduates who enter professional practice will demonstrate progression toward positions of technical responsibility or leadership in their discipline.", NULL);
insert into Outcomes values ("EE", "E19", 
	"Graduates who pursue full-time graduate or advanced professional study will successfully complete their programs of study in their discipline.", NULL);
insert into Outcomes values ("EE", "E20",
	"Graduates will demonstrate professionalism that is consistent with the goals of life-long learning and professional ethics.", NULL);

insert into PerformanceLevels values (1, "Exceeds Expectations");
insert into PerformanceLevels values (2, "Meets Expectations");
insert into PerformanceLevels values (3, "Not Meets Expectations");

insert into CourseMapping values ("CS312", "CS", "C1");
insert into CourseMapping values ("CS312", "CS", "C7");
insert into CourseMapping values ("CS312", "CS", "C8");
insert into CourseMapping values ("CS312", "CS", "C9");

insert into CourseMapping values ("CS340", "CS", "C2");
insert into CourseMapping values ("CS340", "CS", "C7");
insert into CourseMapping values ("CS340", "CS", "C8");
insert into CourseMapping values ("CS340", "CS", "C9");

insert into CourseMapping values ("CS360", "CS", "C3");
insert into CourseMapping values ("CS360", "CS", "C7");
insert into CourseMapping values ("CS360", "CS", "C8");
insert into CourseMapping values ("CS360", "CS", "C9");

insert into CourseMapping values ("CS395", "CS", "C4");
insert into CourseMapping values ("CS395", "CS", "C7");
insert into CourseMapping values ("CS395", "CS", "C8");
insert into CourseMapping values ("CS395", "CS", "C9");

insert into CourseMapping values ("CS402", "CS", "C5");
insert into CourseMapping values ("CS402", "CS", "C7");
insert into CourseMapping values ("CS402", "CS", "C8");
insert into CourseMapping values ("CS402", "CS", "C9");

insert into CourseMapping values ("CS365", "CS", "C6");
insert into CourseMapping values ("CS365", "CS", "C7");
insert into CourseMapping values ("CS365", "CS", "C8");
insert into CourseMapping values ("CS365", "CS", "C9");

insert into CourseMapping values ("ECE255", "CpE", "E1");
insert into CourseMapping values ("ECE255", "CpE", "E2");
insert into CourseMapping values ("ECE255", "CpE", "E8");
insert into CourseMapping values ("ECE255", "CpE", "E9");
insert into CourseMapping values ("ECE255", "CpE", "E10");

insert into CourseMapping values ("ECE256", "CpE", "E3");
insert into CourseMapping values ("ECE256", "CpE", "E4");
insert into CourseMapping values ("ECE256", "CpE", "E8");
insert into CourseMapping values ("ECE256", "CpE", "E9");
insert into CourseMapping values ("ECE256", "CpE", "E10");

insert into CourseMapping values ("ECE351", "CpE", "E5");
insert into CourseMapping values ("ECE351", "CpE", "E6");
insert into CourseMapping values ("ECE351", "CpE", "E8");
insert into CourseMapping values ("ECE351", "CpE", "E9");
insert into CourseMapping values ("ECE351", "CpE", "E10");

insert into CourseMapping values ("ECE395", "CpE", "E7");
insert into CourseMapping values ("ECE395", "CpE", "E8");
insert into CourseMapping values ("ECE395", "CpE", "E9");
insert into CourseMapping values ("ECE395", "CpE", "E10");

insert into CourseMapping values ("ECE402", "CpE", "E8");
insert into CourseMapping values ("ECE402", "CpE", "E9");
insert into CourseMapping values ("ECE402", "CpE", "E10");

insert into CourseMapping values ("ECE255", "EE", "E11");
insert into CourseMapping values ("ECE255", "EE", "E12");
insert into CourseMapping values ("ECE255", "EE", "E18");
insert into CourseMapping values ("ECE255", "EE", "E19");
insert into CourseMapping values ("ECE255", "EE", "E20");

insert into CourseMapping values ("ECE256", "EE", "E13");
insert into CourseMapping values ("ECE256", "EE", "E14");
insert into CourseMapping values ("ECE256", "EE", "E18");
insert into CourseMapping values ("ECE256", "EE", "E19");
insert into CourseMapping values ("ECE256", "EE", "E20");

insert into CourseMapping values ("ECE325", "EE", "E13");
insert into CourseMapping values ("ECE325", "EE", "E14");
insert into CourseMapping values ("ECE325", "EE", "E18");
insert into CourseMapping values ("ECE325", "EE", "E19");
insert into CourseMapping values ("ECE325", "EE", "E20");

insert into CourseMapping values ("ECE325", "CpE", "E3");
insert into CourseMapping values ("ECE325", "CpE", "E4");
insert into CourseMapping values ("ECE325", "CpE", "E8");
insert into CourseMapping values ("ECE325", "CpE", "E9");
insert into CourseMapping values ("ECE325", "CpE", "E10");

insert into CourseMapping values ("ECE351", "EE", "E15");
insert into CourseMapping values ("ECE351", "EE", "E16");
insert into CourseMapping values ("ECE351", "EE", "E18");
insert into CourseMapping values ("ECE351", "EE", "E19");
insert into CourseMapping values ("ECE351", "EE", "E20");

insert into CourseMapping values ("ECE395", "EE", "E17");
insert into CourseMapping values ("ECE395", "EE", "E18");
insert into CourseMapping values ("ECE395", "EE", "E19");
insert into CourseMapping values ("ECE395", "EE", "E20");

insert into CourseMapping values ("ECE402", "EE", "E18");
insert into CourseMapping values ("ECE402", "EE", "E19");
insert into CourseMapping values ("ECE402", "EE", "E20");

insert into AssessmentTypes (assessmentType) values ("exam");
insert into AssessmentTypes (assessmentType) values ("quiz");
insert into AssessmentTypes (assessmentType) values ("homework");
insert into AssessmentTypes (assessmentType) values ("lab");
insert into AssessmentTypes (assessmentType) values ("programming assignment");
insert into AssessmentTypes (assessmentType) values ("project");
insert into AssessmentTypes (assessmentType) values ("written paper");
insert into AssessmentTypes (assessmentType) values ("oral presentation");

insert into Rubrics values (1, 1, "Students showed excellence when completing assignments.");
insert into Rubrics values (1, 2, "Students showed competence when completing assignments.");
insert into Rubrics values (1, 3, "Students showed lack of understanding when completing assignments.");

/*insert into RubricNames values (rubricId, rubricName, outcomeId);*/

insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "C1");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "C2");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "C3");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "C4");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "C5");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "C6");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "C7");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "C8");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "C9");

insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "E1");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "E2");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "E3");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "E4");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "E5");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "E6");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "E7");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "E8");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "E9");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "E10");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "E11");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "E12");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "E13");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "E14");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "E15");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "E16");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "E17");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "E18");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "E19");
insert into RubricNames (rubricName, outcomeId) values ("Generic Rubric", "E20");
