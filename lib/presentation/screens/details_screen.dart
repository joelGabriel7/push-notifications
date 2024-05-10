import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/domain/entities/push_messages.dart';
import 'package:push_app/presentation/blocs/notifications/notifications_bloc.dart';

class DetailScreen extends StatelessWidget {
  final String pushMessageId;
  const DetailScreen({super.key, required this.pushMessageId});

  @override
  Widget build(BuildContext context) {

    final PushMessages? message = context.watch<NotificationsBloc>()
                .getMessageById(pushMessageId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Push'),
      ),
      body: (message != null )
       ?  _DetailView(messages: message)
       : const Center(child: Text('Message not found')),
    );
  }
}

class _DetailView extends StatelessWidget {
  final PushMessages messages;
  const _DetailView({required this.messages});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(children: [


        if (messages.imageUrl != null)
          Image.network(messages.imageUrl!,),

          const SizedBox(height: 30),
          Text(messages.title, style:textStyle.titleMedium ,),
          Text(messages.body),
          const Divider(),
          Text(messages.data.toString()),

      ]
    ),
    );
  }
}
