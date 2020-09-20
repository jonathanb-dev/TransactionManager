import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Helpers
import '../../../helpers/datetime_helper.dart';

// Models
import '../../../models/transactions.dart';
import '../../../models/transaction.dart';

class EditTransactionScreen extends StatefulWidget {
  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  var _isInit = true;
  final _formKey = GlobalKey<FormState>();
  final _amountFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  var _dateAndTimeController = new TextEditingController();

  var _currentTransaction = Transaction(
    id: null,
    name: null,
    description: null,
    amount: null,
    dateAndTime: null,
  );

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final transactionId = ModalRoute.of(context).settings.arguments as int;
      if (transactionId != null) {
        _currentTransaction = Provider.of<Transactions>(context, listen: false).getTransactionById(transactionId);
        _dateAndTimeController.text = _currentTransaction.dateAndTime != null ? DateFormat('dd/MM/yyyy HH:mm').format(_currentTransaction.dateAndTime) : null;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _amountFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _dateAndTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectDateAndTime(BuildContext context, DateTime dateAndTime) async {
    DateTime pickedDateAndTime = await DateTimeHelper.showDateAndTimePicker(context, dateAndTime);
    if (pickedDateAndTime != null) {
      setState(() {
        _dateAndTimeController.value = TextEditingValue(
          text: DateFormat('dd/MM/yyyy HH:mm').format(pickedDateAndTime),
        );
      });
      _submitForm();
    }
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_currentTransaction.id != null) {
        Provider.of<Transactions>(context, listen: false).updateTransaction(_currentTransaction);
      }
      else {
        Provider.of<Transactions>(context, listen: false).addTransaction(_currentTransaction);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentTransaction.id != null ? 'Edit transaction #${_currentTransaction.id}' : 'Add new transaction',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name *',
                  ),
                  initialValue: _currentTransaction.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_amountFocusNode);
                  },
                  onSaved: (value) {
                    _currentTransaction.name = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Amount *',
                  ),
                  focusNode: _amountFocusNode,
                  initialValue: _currentTransaction.amount?.toString(),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Amount is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                    double amount = double.parse(value);
                    if (amount == 0.0 || amount < -1000000.0 || amount > 1000000.0) {
                      return 'Amount must be between -1.000.000 and 1.000.000 and not equal to 0';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) {
                    _currentTransaction.amount = double.parse(value);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  focusNode: _descriptionFocusNode,
                  initialValue: _currentTransaction.description,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  onSaved: (value) {
                    _currentTransaction.description = value;
                  },
                ),
                GestureDetector(
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _dateAndTimeController,
                      decoration: InputDecoration(
                        labelText: 'Date and time *',
                      ),
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Date is required';
                        }
                        if (DateFormat("yyyy-MM-dd HH:mm").parse(DateFormat("dd/MM/yyyy HH:mm").parse(value).toString()).isAfter(DateTime.now())) {
                          return 'Future date and time is not allowed';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _currentTransaction.dateAndTime = DateFormat("yyyy-MM-dd HH:mm").parse(DateFormat("dd/MM/yyyy HH:mm").parse(value).toString());
                      },
                    ),
                  ),
                  onTap: () => _selectDateAndTime(context, _currentTransaction.dateAndTime),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: Icon(
          Icons.done,
        ),
        onPressed: _submitForm,
      ),
    );
  }
}