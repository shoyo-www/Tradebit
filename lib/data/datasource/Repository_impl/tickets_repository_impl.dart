import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/core/error/exceptions.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/create_ticket.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/ticket_send.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/common_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/ticket_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/ticket_support.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/ticketrespone.dart';
import 'package:tradebit_app/data/datasource/remote/services/apis.dart';
import 'package:tradebit_app/data/datasource/remote/services/dio/rest_client.dart';
import 'package:tradebit_app/domain/Repository/tickets_repository.dart';

class TicketsRepositoryImpl implements TicketsRepository {
  final _restClient = Get.find<RestClient>();

  @override
  Future<Either<Failure, TicketTypeResponse>> ticketsType() async {
    try {
      final response = await _restClient.get(url: Apis.ticketsType);
      return Right(ticketTypeResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, TicketResponse>> tickets() async {
    try {
      final response = await _restClient.get(url: Apis.tickets);
      return Right(ticketResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, TicketSupport>> ticketSupport(int id) async{
    try {
      final response = await _restClient.get(url: "${Apis.ticketSupport}$id");
      return Right(ticketSupportFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> ticketSend(TicketSendRequest request) async{
    try {
      final response = await _restClient.post(url: Apis.ticketCreate, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> createTicket(CreateTicket request) async {
    try {
      final response = await _restClient.post(url: Apis.createTicket, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

}