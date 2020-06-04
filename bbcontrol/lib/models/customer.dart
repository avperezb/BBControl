//Class for BBC customers collection documents

class Customer {

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime birthDate;
  final int phoneNumber;
  final num limitAmount;

  Customer({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.birthDate,
    this.phoneNumber,
    this.limitAmount
  });

  Customer.fromData(Map<String, dynamic> data):
        id = data['id'],
        firstName = data['firstName'],
        lastName = data['lastName'],
        email = data['email'],
        birthDate = DateTime.parse(data['birthDate'].toDate().toString()),
        phoneNumber = data['phoneNumber'],
        limitAmount = data['limitAmount'];

  Map<String, dynamic> toJson(){
    return{
      'id' : id,
      'firstName': firstName,
      'lastName': lastName,
      'email' : email,
      'birthDate' : birthDate,
      'phoneNumber' : phoneNumber,
      'limitAmount' : limitAmount
    };
  }
}