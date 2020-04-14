//Class for BBC customers collection documents

class Customer {

  final String id;
  final String fullName;
  final String email;
  final DateTime birthDate;
  final int phoneNumber;

  Customer({
    this.id,
    this.fullName,
    this.email,
    this.birthDate,
    this.phoneNumber
  });

  Customer.fromData(Map<String, dynamic> data):
    id = data['id'],
    fullName = data['fullName'],
    email = data['email'],
    birthDate = data['birthDate'],
    phoneNumber = data['phoneNumber'];

  Map<String, dynamic> toJson(){
    return{
      'id' : id,
      'fullName': fullName,
      'email' : email,
      'birthDate' : birthDate,
      'phoneNumber' : phoneNumber
    };
  }
}