import 'package:flutter/material.dart';
import 'package:flutter_app/injection_container.dart';
import 'package:flutter_app/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_app/presentation/widgets/loading_widget.dart';
import 'package:flutter_app/presentation/widgets/message_display.dart';
import 'package:flutter_app/presentation/widgets/trivia_controls.dart';
import 'package:flutter_app/presentation/widgets/trivia_display.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Number Trivia'),
        ),
        body: SingleChildScrollView(
          child: buildBody(context),
        ),
      ),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 10),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                if (state is Empty) {
                  return MessageDisplay(message: 'Start Searching!');
                } else if (state is Loading) {
                  return LoadingWidget();
                } else if (state is Loaded) {
                  return TriviaDisplay(
                    numberTrivia: state.trivia,
                  );
                } else if (state is Error) {
                  return MessageDisplay(message: state.message);
                }
                return null;
              }),
              SizedBox(height: 20),
              TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}


