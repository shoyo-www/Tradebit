import 'package:dartz/dartz.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/create_ticket.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/ticket_send.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/common_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/ticket_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/ticket_support.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/ticketrespone.dart';

abstract class TicketsRepository {
  Future<Either<Failure, TicketTypeResponse>> ticketsType();
  Future<Either<Failure, TicketResponse>> tickets();
  Future<Either<Failure, TicketSupport>> ticketSupport(int id);
  Future<Either<Failure, CommonResponse>> ticketSend(TicketSendRequest request);
  Future<Either<Failure, CommonResponse>> createTicket(CreateTicket request);
}