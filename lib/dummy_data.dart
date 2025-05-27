import 'models.dart';

List<Center> centers = [
  Center(id: "1", name: "Tech Academy", location: "Cairo", teacherIds: ["T1"], courseIds: ["101"]),
  Center(id: "2", name: "Code School", location: "Alexandria", teacherIds: ["T2"], courseIds: ["102"]),
];

List<Teacher> teachers = [
  Teacher(id: "T1", name: "John Doe", subject: "Mathematics", session: "Evening", price: 300, status: "Available", capacity: 20, image: "teacher1.png", centerId: "1", courseIds: ["101"]),
  Teacher(id: "T2", name: "Jane Smith", subject: "Physics", session: "Morning", price: 350, status: "Available", capacity: 15, image: "teacher2.png", centerId: "2", courseIds: ["102"]),
];

List<Course> courses = [
  Course(id: "101", title: "Flutter Development", description: "Learn Flutter from scratch.", duration: "3 months", price: 5000, teacherIds: ["T1"], centerId: "1"),
  Course(id: "102", title: "Python Programming", description: "Master Python programming.", duration: "2 months", price: 4000, teacherIds: ["T2"], centerId: "2"),
];
