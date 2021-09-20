import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class MerchantBNPLProfileScreen extends StatefulWidget {
  const MerchantBNPLProfileScreen({Key? key}) : super(key: key);

  @override
  _MerchantBNPLProfileScreenState createState() =>
      _MerchantBNPLProfileScreenState();
}

class _MerchantBNPLProfileScreenState extends State<MerchantBNPLProfileScreen> {
  int _index = 0;
  final _userDetailsFormKey = GlobalKey<FormState>();
  final _businessDetailsFormKey = GlobalKey<FormState>();

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  PhoneNumber? _phoneNumber;

  final TextEditingController _businessName = TextEditingController();
  String businessCategoryValue =
      "Automotive Products - Automotive parts and accessories";
  String monthlyRevenueValue = 'Less < 50k per month';

  List<String> _businessCategories = [
    "Automotive Products - Automotive parts and accessories",
    "Automotive Products - Wheels and tires",
    "Children Products - Children clothes and nurturing products",
    "Children Products - Children Toys",
    "Children Products - Diversified Children Products",
    "Clothing and  Shoes - Adult shoes and clothing",
    "Clothing and Shoes - General shoes and clothing",
    "Clothing and Shoes - Underwear",
    "Clothing and Shoes - Youthful shoes and clothing",
    "Electronics - Car Electronics",
    "Electronics - Diversified electronics",
    "Electronics - Electronic equipment and related accessories",
    "Electronics - Household Electronics",
    "Electronics - Office machines and related accessories",
    "Entertainment - Book and magazines",
    "Entertainment - Diversified entertainment",
    "Entertaiment - Music and movies",
    "Entertainment - Video games and related accessories",
    "Erotic Materials - Diversified Erotic Material",
    "Erotic Materials - Erotic clothing and accessories",
    "Erotic Materials - Sex Toys",
    "Food and Beverage - Candy",
    "Food and Beverage - Food and beverage",
    "Food and Beverage - Tobacco",
    "Food and Beverage - Wine beer and liquour",
    "Health and Beauty",
    "Home and Garden - Plants and flowers",
    "Home and Garden - Safety products",
    "Home and Garden - Tools and home improvement",
    "Jewelry and Accessories - Bags and wallets",
    "Jewelry and Accessories - Diversified jewelry and accessories",
    "Jewelry and Accessories - Jewelry and watches",
    "Jewelry and Accessories - Non prescription sunglasses and lenses",
    "Leisure, Sport and Hobby - Collectibles",
    "Leisure, Sport and Hobby - Concept stores and miscellaneous",
    "Leisure, Sport and Hobby - Costumes and party supplies",
    "Leisure, Sport and Hobby - Hobby articles",
    "Leisure, Sport and Hobby - Musical instruments and equipment",
    "Leisure, Sport and Hobby - Prints and photos",
    "Leisure, Sport and Hobby - Sports gear and outdoor",
  ];

  List<String> _monthlyRevenueCategories = [
    'Less < 50k per month',
    'Between 50k and 100k per month',
    'Over 100k per month',
  ];

  @override
  void dispose() {
    _lastName.dispose();
    _firstName.dispose();
    _phoneNumberController.dispose();
    _businessName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Started"),
      ),
      body: Stepper(
        currentStep: _index,
        onStepCancel: () {
          if (_index > 0) {
            setState(() {
              _index -= 1;
            });
          }
        },
        onStepContinue: () {
          if (_index == 0) {
            if (_userDetailsFormKey.currentState!.validate()) {
              setState(() {
                _index += 1;
              });
            } else {
              print("User Details Form is Invalid");
            }
          } else if (_index == 1) {
            if (_businessDetailsFormKey.currentState!.validate() &&
                _userDetailsFormKey.currentState!.validate()) {
              Navigator.of(context).pop();
            } else {
              print("Business Details Form is Invalid");
            }
          }
        },
        onStepTapped: (int index) {
          setState(() {
            _index = index;
          });
        },
        type: StepperType.vertical,
        steps: <Step>[
          Step(
            title: const Text('User Details'),
            content: Container(
              alignment: Alignment.centerLeft,
              child: Form(
                key: _userDetailsFormKey,
                child: Container(
                  height: 300,
                  child: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _firstName,
                          autocorrect: true,
                          enableSuggestions: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          maxLines: 2,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            contentPadding: EdgeInsets.all(10),
                            labelText: 'First Name (required)',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your First Name";
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _lastName,
                          autocorrect: true,
                          enableSuggestions: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          maxLines: 2,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            contentPadding: EdgeInsets.all(10),
                            labelText: 'Last Name (required)',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your Last Name";
                            }
                            return null;
                          },
                        ),
                      ),
                      InternationalPhoneNumberInput(
                        // countries: _countries,
                        onInputChanged: (PhoneNumber number) {
                          setState(() {
                            _phoneNumber = number;
                          });
                        },
                        onInputValidated: (bool value) {
                          // print(value);
                        },
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        ),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        // selectorTextStyle: TextStyle(color: Colors.black),
                        initialValue: PhoneNumber(isoCode: 'KE'),
                        textFieldController: _phoneNumberController,
                        formatInput: false,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputBorder: OutlineInputBorder(),
                        onSaved: (PhoneNumber number) {
                          // print('On Saved: $number');
                        },
                        searchBoxDecoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Step(
            title: Text('Business Details'),
            content: Form(
              key: _businessDetailsFormKey,
              child: Container(
                height: 300,
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _businessName,
                        autocorrect: true,
                        enableSuggestions: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLines: 2,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          contentPadding: EdgeInsets.all(10),
                          labelText: 'Business Name (required)',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your Business Name";
                          }
                          return null;
                        },
                      ),
                    ),
                    Center(
                      child: Container(
                        child: Text("Business Category"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 2,
                          color: Colors.purpleAccent,
                        ),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: businessCategoryValue,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        underline: SizedBox.shrink(),
                        borderRadius: BorderRadius.circular(20),
                        onChanged: (String? newValue) {
                          setState(() {
                            businessCategoryValue = newValue!;
                          });
                        },
                        items: _businessCategories
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Center(
                      child: Container(
                        child: Text("Average Monthly Revenue"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 2,
                            color: Colors.purpleAccent,
                          )),
                      child: DropdownButton<String>(
                        value: monthlyRevenueValue,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        underline: SizedBox.shrink(),
                        borderRadius: BorderRadius.circular(20),
                        onChanged: (String? newValue) {
                          setState(() {
                            monthlyRevenueValue = newValue!;
                          });
                        },
                        items: _monthlyRevenueCategories
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
