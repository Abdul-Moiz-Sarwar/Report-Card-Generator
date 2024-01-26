Table sheet;      //marks sheet
Table attendance; //attendance sheet
PImage back;      //background
PFont gilroylight;       //font1
PFont gilroybold;        //font2
//grading threshold percentage inclusive
int AA = 78;  //100 - 80
int A = 68;    //80 - 70
int B = 58;    //70 - 60
int C = 48;    //60 - 50
int D = 38;    //50 - 40
int E = 32;    //40 - 33
int U = 0;    //33 - 0
int totalsubjects = 13;
int totalstudents = 151;
int index = 0;
int attcol;

void setup() {
  size(2217, 1934);  //make screen
  back = loadImage("Inputs/Background.png");  //load background picture
  sheet = loadTable("Inputs/Marks.csv");  //load csv file with all marks data
  attendance = loadTable("Inputs/Attendance.csv");  //load csv file with all attendace data
  //find at which column is the attendance data present
  String temp;
  for (attcol = 34; attcol < 40; attcol++) {
    temp = attendance.getString(3, attcol);
    if (temp.equals("Present")) {
      break;
    }
  }
  gilroybold = createFont("Gilroy Extrabold", 50);
  gilroylight = createFont("Gilroy Light", 45);
}

int row = 5;  //students list starting position
void draw() {
  image(back, 0, 0);               //draw background picture
  fill(0, 0, 0);                  //set draw color to black
  textFont(gilroylight);          //set font style to light
  textSize(50);
  String date = sheet.getString(2, 0);
  text(date, 1180, 230);    //print date
  String name = sheet.getString(row, 1);
  text(name, 1000, 350);    //print name
  String grade = sheet.getString(row, 2);
  text(grade, 1000, 475);    //print class
  String subject;
  String marks1;
  int marks1int;
  String marks2;
  int marks2int;
  String total1;
  String total2;
  String percentage;
  String subjectgrade = "";
  int percentageint;
  int yofsub = 760;
  int subjectcount = 0;

  for (int col = 3; col <(totalsubjects + 1)* 3; col+= 3) {
    //get marks in T1
    marks1 = sheet.getString(row, col);      //if student abscent then marks in T1 are -1
    if (marks1.equals("A")) {
      marks1int = -1;
    } else {
      marks1int = int(marks1);
    }
    //get marks in T2
    marks2 = sheet.getString(row, col + 1);  //if student absent then marks in T2 are -1
    if (marks2.equals("A") ) {
      marks2int = -1;
    } else {
      marks2int = int(marks2);
    }
    //get total marks of both tests
    total1 = sheet.getString(3, col);
    total2 = sheet.getString(3, col + 1);
    //get percentage
    percentage = sheet.getString(row, col + 2);
    //if student absent int both T1 and T2 then percentage is N/A
    if (percentage.equals("A") || (marks1.equals("") && marks2.equals("A")) || (marks2.equals("") && marks1.equals("A"))   || (marks1.equals("") && marks2.equals("")) ) {
      percentageint = -1;
      percentage = "N/A";
    } else {
      percentageint = int ( percentage.substring( 0, percentage.length() - 1 ) );
    }
    //subjects, marks, percentage and grades printing
    if (!marks1.equals("") || !marks2.equals("")) {   //if marks exist
      subjectcount++;
      //subject printing
      subject = sheet.getString(0, col);              //then get the subject
      text(subject, 670, yofsub);                    //write down the subject
      //marks printing
      if (marks1.equals("") ) {
        text(total2, 1045, yofsub);
        text(marks2, 1290, yofsub);                     //write down the marks 2 if marks 1 dont exist
      } else  if (marks2.equals("") ) {
        text(total1, 1045, yofsub);
        text(marks1, 1290, yofsub);                     //write down the marks 1 if marks 2 dont exist
      } else {
        if (marks1int > marks2int) {                    //if both exist
          text(total1, 1045, yofsub);
          text(marks1, 1290, yofsub);                   //write down the marks 1 if marks 2 is less
        } else {
          text(total2, 1045, yofsub);
          text(marks2, 1290, yofsub);                   //write down the marks 2 if marks 1 is less
        }
      }
      //percentage printing
      text(percentage, 1540, yofsub);                 //write down the percentage
      if (percentage.equals("N/A")) {
        subjectgrade = "N/A";
      } else if (percentageint >= AA) {
        subjectgrade = " A*";
      } else if (percentageint >= A) {
        subjectgrade = " A";
      } else if (percentageint >= B) {
        subjectgrade = " B";
      } else if (percentageint >= C) {
        subjectgrade = " C";
      } else if (percentageint >= D) {
        subjectgrade = " D";
      } else if (percentageint >= E) {
        subjectgrade = " E";
      } else {
        subjectgrade = " U";
      }
      textFont(gilroybold);          //set font style to bold
      text(subjectgrade, 1800, yofsub);
      textFont(gilroylight);          //set font style to light
      yofsub += 126;                                  //go to next line to print subject
    }
  }

  //getting attendance
  String attname;
  String present;
  String absent;
  String total;
  String attper;
  attname = attendance.getString(4, 2);
  int linenumber;
  //find the student in the list
  for (linenumber = 4; linenumber < 156; linenumber++) {//from start of attendance to end of attendance
    attname = attendance.getString(linenumber, 2);
    if (attname.equals(name)) {
      break;
    }
  }
  //fetch present, absent, total and percentage
  present = attendance.getString(linenumber, attcol);
  absent = attendance.getString(linenumber, attcol + 1);
  total = attendance.getString(linenumber, attcol + 2);
  attper = attendance.getString(linenumber, attcol + 3);
  //prnit attendance
  text(total, 1045, 1860);
  text(present, 1300, 1860);
  text(absent, 1550, 1860);
  text(attper, 1770, 1860);

  row++;  //go to next student
  if (row >= 5 + totalstudents) {  //termination if all students done
    exit();
  }
  if (subjectcount > 0) {  //only save a file if a student had atleast 1 test
    index++;
    save("Outputs/" + index + "_" + str(row - 5) + "-" + name + ".png");
  }
}
