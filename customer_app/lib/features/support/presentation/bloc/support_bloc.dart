import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/models/support_ticket_model.dart';
import '../../data/models/faq_model.dart';
import '../../domain/repositories/support_repository.dart';

// Events
abstract class SupportEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadChatHistory extends SupportEvent {
  final String channelId;
  final int page;

  LoadChatHistory({required this.channelId, this.page = 1});

  @override
  List<Object?> get props => [channelId, page];
}

class SendMessage extends SupportEvent {
  final String channelId;
  final String message;
  final List<String>? attachments;

  SendMessage({
    required this.channelId,
    required this.message,
    this.attachments,
  });

  @override
  List<Object?> get props => [channelId, message, attachments];
}

class CreateTicket extends SupportEvent {
  final String subject;
  final String description;
  final String category;
  final String priority;
  final String? orderId;
  final List<String>? attachments;

  CreateTicket({
    required this.subject,
    required this.description,
    required this.category,
    this.priority = 'medium',
    this.orderId,
    this.attachments,
  });

  @override
  List<Object?> get props => [subject, description, category, priority, orderId, attachments];
}

class LoadTickets extends SupportEvent {
  final String? status;
  final int page;

  LoadTickets({this.status, this.page = 1});

  @override
  List<Object?> get props => [status, page];
}

class LoadTicketDetails extends SupportEvent {
  final String ticketId;

  LoadTicketDetails(this.ticketId);

  @override
  List<Object?> get props => [ticketId];
}

class CloseTicket extends SupportEvent {
  final String ticketId;

  CloseTicket(this.ticketId);

  @override
  List<Object?> get props => [ticketId];
}

class LoadFAQs extends SupportEvent {
  final String? category;
  final String? searchQuery;

  LoadFAQs({this.category, this.searchQuery});

  @override
  List<Object?> get props => [category, searchQuery];
}

class MarkFAQHelpful extends SupportEvent {
  final String faqId;
  final bool isHelpful;

  MarkFAQHelpful({required this.faqId, required this.isHelpful});

  @override
  List<Object?> get props => [faqId, isHelpful];
}

class MarkMessagesAsRead extends SupportEvent {
  final String channelId;
  final List<String> messageIds;

  MarkMessagesAsRead({required this.channelId, required this.messageIds});

  @override
  List<Object?> get props => [channelId, messageIds];
}

// States
abstract class SupportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SupportInitial extends SupportState {}

class SupportLoading extends SupportState {}

class ChatHistoryLoaded extends SupportState {
  final List<ChatMessageModel> messages;
  final bool hasMore;

  ChatHistoryLoaded({required this.messages, this.hasMore = true});

  @override
  List<Object?> get props => [messages, hasMore];
}

class MessageSent extends SupportState {
  final ChatMessageModel message;

  MessageSent(this.message);

  @override
  List<Object?> get props => [message];
}

class MessagesMarkedAsRead extends SupportState {}

class TicketCreated extends SupportState {
  final SupportTicketModel ticket;

  TicketCreated(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

class TicketsLoaded extends SupportState {
  final List<SupportTicketModel> tickets;
  final bool hasMore;

  TicketsLoaded({required this.tickets, this.hasMore = true});

  @override
  List<Object?> get props => [tickets, hasMore];
}

class TicketDetailsLoaded extends SupportState {
  final SupportTicketModel ticket;

  TicketDetailsLoaded(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

class TicketClosed extends SupportState {
  final String ticketId;

  TicketClosed(this.ticketId);

  @override
  List<Object?> get props => [ticketId];
}

class FAQsLoaded extends SupportState {
  final List<FAQModel> faqs;

  FAQsLoaded(this.faqs);

  @override
  List<Object?> get props => [faqs];
}

class FAQFeedbackSubmitted extends SupportState {
  final String faqId;

  FAQFeedbackSubmitted(this.faqId);

  @override
  List<Object?> get props => [faqId];
}

class SupportError extends SupportState {
  final String message;

  SupportError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final SupportRepository repository;

  SupportBloc({required this.repository}) : super(SupportInitial()) {
    on<LoadChatHistory>(_onLoadChatHistory);
    on<SendMessage>(_onSendMessage);
    on<MarkMessagesAsRead>(_onMarkMessagesAsRead);
    on<CreateTicket>(_onCreateTicket);
    on<LoadTickets>(_onLoadTickets);
    on<LoadTicketDetails>(_onLoadTicketDetails);
    on<CloseTicket>(_onCloseTicket);
    on<LoadFAQs>(_onLoadFAQs);
    on<MarkFAQHelpful>(_onMarkFAQHelpful);
  }

  Future<void> _onLoadChatHistory(
    LoadChatHistory event,
    Emitter<SupportState> emit,
  ) async {
    emit(SupportLoading());

    final result = await repository.getChatHistory(event.channelId, event.page);

    result.fold(
      (failure) => emit(SupportError(failure.message)),
      (messages) => emit(ChatHistoryLoaded(
        messages: messages,
        hasMore: messages.length >= 50,
      )),
    );
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<SupportState> emit,
  ) async {
    final result = await repository.sendMessage(
      event.channelId,
      event.message,
      event.attachments,
    );

    result.fold(
      (failure) => emit(SupportError(failure.message)),
      (message) => emit(MessageSent(message)),
    );
  }

  Future<void> _onMarkMessagesAsRead(
    MarkMessagesAsRead event,
    Emitter<SupportState> emit,
  ) async {
    final result = await repository.markMessagesAsRead(
      event.channelId,
      event.messageIds,
    );

    result.fold(
      (failure) => emit(SupportError(failure.message)),
      (_) => emit(MessagesMarkedAsRead()),
    );
  }

  Future<void> _onCreateTicket(
    CreateTicket event,
    Emitter<SupportState> emit,
  ) async {
    emit(SupportLoading());

    final result = await repository.createSupportTicket(
      subject: event.subject,
      description: event.description,
      category: event.category,
      priority: event.priority,
      orderId: event.orderId,
      attachments: event.attachments,
    );

    result.fold(
      (failure) => emit(SupportError(failure.message)),
      (ticket) => emit(TicketCreated(ticket)),
    );
  }

  Future<void> _onLoadTickets(
    LoadTickets event,
    Emitter<SupportState> emit,
  ) async {
    emit(SupportLoading());

    final result = await repository.getTickets(
      status: event.status,
      page: event.page,
    );

    result.fold(
      (failure) => emit(SupportError(failure.message)),
      (tickets) => emit(TicketsLoaded(
        tickets: tickets,
        hasMore: tickets.length >= 20,
      )),
    );
  }

  Future<void> _onLoadTicketDetails(
    LoadTicketDetails event,
    Emitter<SupportState> emit,
  ) async {
    emit(SupportLoading());

    final result = await repository.getTicketDetails(event.ticketId);

    result.fold(
      (failure) => emit(SupportError(failure.message)),
      (ticket) => emit(TicketDetailsLoaded(ticket)),
    );
  }

  Future<void> _onCloseTicket(
    CloseTicket event,
    Emitter<SupportState> emit,
  ) async {
    final result = await repository.closeTicket(event.ticketId);

    result.fold(
      (failure) => emit(SupportError(failure.message)),
      (_) => emit(TicketClosed(event.ticketId)),
    );
  }

  Future<void> _onLoadFAQs(
    LoadFAQs event,
    Emitter<SupportState> emit,
  ) async {
    emit(SupportLoading());

    final result = await repository.getFAQs(
      category: event.category,
      searchQuery: event.searchQuery,
    );

    result.fold(
      (failure) => emit(SupportError(failure.message)),
      (faqs) => emit(FAQsLoaded(faqs)),
    );
  }

  Future<void> _onMarkFAQHelpful(
    MarkFAQHelpful event,
    Emitter<SupportState> emit,
  ) async {
    final result = await repository.markFAQHelpful(event.faqId, event.isHelpful);

    result.fold(
      (failure) => emit(SupportError(failure.message)),
      (_) => emit(FAQFeedbackSubmitted(event.faqId)),
    );
  }
}
