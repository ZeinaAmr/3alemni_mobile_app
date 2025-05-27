class Center {
  final String id;
  final String name;
  final String location;
  final List<String> teacherIds;
  final List<String> courseIds;

  Center({
    required this.id,
    required this.name,
    required this.location,
    required this.teacherIds,
    required this.courseIds,
  });
}

class Teacher {
  final String id;
  final String name;
  final String subject;
  final String session;
  final double price;
  final String status;
  final int capacity;
  final String image;
  final String centerId;
  final List<String> courseIds;

  Teacher({
    required this.id,
    required this.name,
    required this.subject,
    required this.session,
    required this.price,
    required this.status,
    required this.capacity,
    required this.image,
    required this.centerId,
    required this.courseIds,
  });
}

class Course {
  final String id;
  final String title;
  final String description;
  final String duration;
  final double price;
  final List<String> teacherIds;
  final String centerId;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.price,
    required this.teacherIds,
    required this.centerId,
  });
}
