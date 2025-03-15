import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/allCartBloc/AllCartEvent.dart';
import '../Bloc/allCartBloc/allCartbloc.dart';

class EditCartDialog extends StatelessWidget {
  final int cartId;

  EditCartDialog({required this.cartId});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _textEditingControllers = List.generate(
      5,
      (index) => TextEditingController(),
    );

    return AlertDialog(
      title: const Text('Edit Cart'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _textEditingControllers[0],
                decoration: InputDecoration(
                    hintText: "Field 1",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter value';
                  }
                  return null;
                },
              ),
              // Add other text fields similarly...
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final updatedData = {
                'field1': _textEditingControllers[0].text,
              };
              context.read<AllCartBloc>().add(UpdateCartEvent(
                    cartId: cartId,
                    updatedCart: updatedData,
                  ));
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
