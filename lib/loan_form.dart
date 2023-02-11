import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'google_signin.dart';
import 'constants.dart';

class LoanForm extends StatefulWidget {
  const LoanForm({super.key});

  @override
  State<LoanForm> createState() => _LoanFormState();
}

class _LoanFormState extends State<LoanForm> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final pinCodeController = TextEditingController();
  final amountController = TextEditingController();
  final callUsController = TextEditingController();

  List<String> loanTypeList = [
    'Home loan',
    'Business loan',
    'Mortgage loan',
    'Personal loan'
  ];
  var loanType = 'Home loan'.obs;
  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    cityController.dispose();
    pinCodeController.dispose();
    amountController.dispose();
    callUsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        actions: [
          IconButton(
            onPressed: () {
              signOutAccount();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            height: size.height * 1.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter name',
                    label: Text('Name'),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return textFieldErrorMsg;
                    }
                    return null;
                  },
                  controller: nameController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter phone number',
                    label: Text('Phone'),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return textFieldErrorMsg;
                    } else if (val.length != 10) {
                      return mobileValideErrorMsg;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  maxLength: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter city',
                    label: Text('City'),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return textFieldErrorMsg;
                    }
                    return null;
                  },
                  controller: cityController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter pincode',
                    label: Text('Pincode'),
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 6,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return textFieldErrorMsg;
                    } else if (val.length != 6) {
                      return 'pincode must be of 6 digit';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: pinCodeController,
                ),
                Obx(
                  () => DropdownButtonFormField(
                    value: loanType.value,
                    decoration: const InputDecoration(
                      hintText: 'Loan type',
                      label: Text('Locan'),
                      border: OutlineInputBorder(),
                    ),
                    items: loanTypeList
                        .map(
                          (data) => DropdownMenuItem(
                            value: data,
                            child: Text(data.toString()),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      loanType.value = val.toString();
                    },
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter amount',
                    label: Text('Amount'),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return textFieldErrorMsg;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: amountController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter call us',
                    label: Text('Call us'),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return textFieldErrorMsg;
                    } else if (val.length != 10) {
                      return mobileValideErrorMsg;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  controller: callUsController,
                  maxLength: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      FirebaseFirestore.instance.collection('userdata').add({
                        'name': nameController.text,
                        'phone number': int.parse(phoneController.text),
                        'city': cityController.text,
                        'pincode': int.parse(pinCodeController.text),
                        'loan type': loanType.value,
                        'amount': int.parse(amountController.text),
                        'call us': int.parse(callUsController.text),
                      }).then(
                        (value) => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Message!'),
                            content: const Text('Loan apply successfully.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('ok'),
                              ),
                            ],
                          ),
                        ),
                      );
                      nameController.clear();
                      phoneController.clear();
                      cityController.clear();
                      pinCodeController.clear();
                      amountController.clear();
                      callUsController.clear();
                      FocusScope.of(context).unfocus();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(size.width, size.height * 0.07),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
