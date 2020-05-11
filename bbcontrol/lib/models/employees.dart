//Class for BBC waiters collection documents

class Employee{

  final String id;
  final bool active;
  final num identification;
  final String firstName;
  final String lastName;
  final String email;
  final num phoneNumber;
  final num ordersAmount;

  Employee({

    this.id,
    this.active,
    this.identification,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.ordersAmount
  });

  Employee.fromData(Map<String, dynamic> data):
        id = data['id'],
        active = data['active'],
        identification = data['id'],
        firstName = data['firstName'],
        lastName = data['lastName'],
        email = data['email'],
        phoneNumber = data['phoneNumber'],
  ordersAmount = data['ordersAmount'];

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'active' : active,
      'identification' : identification,
      'firstName': firstName,
      'lastName': lastName,
      'email' : email,
      'phoneNumber' : phoneNumber,
      'ordersAmount' : ordersAmount
    };
  }
}