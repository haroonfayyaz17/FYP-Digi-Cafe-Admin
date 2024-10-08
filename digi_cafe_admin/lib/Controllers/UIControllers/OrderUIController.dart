import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_cafe_admin/Model/OrderItem.dart';
import 'package:digi_cafe_admin/Model/Voucher.dart';
import 'package:digi_cafe_admin/Model/FoodItem.dart';
import 'package:digi_cafe_admin/Model/Order.dart';
import 'package:digi_cafe_admin/Controllers/DBControllers/OrderDBController.dart';
import 'package:digi_cafe_admin/Views/FeedbackDetailsClass.dart';

class OrderUIController {
  OrderDBController _orderDBController;

  Order _Order;
  OrderUIController() {
    _orderDBController = new OrderDBController();
  }

  Stream<QuerySnapshot> getOrdersSnapshot() {
    return _orderDBController.getOrdersSnapshot();
  }

  Future<Stream<QuerySnapshot>> getFilteredOrdersSnapshot(
      String filterType, DateTime fromDate, DateTime toDate) async {
    return await _orderDBController.getFilteredOrdersSnapshot(
        filterType, fromDate, toDate);
  }

  Stream<QuerySnapshot> getComplaintsSnapshot(
      {String newValue = null, DateTime fromDate, DateTime toDate}) {
    return _orderDBController.getComplaintsSnapshot(
        newValue: newValue, fromDate: fromDate, toDate: toDate);
  }

  Future<void> changeComplaintStatus(String id, String status) async {
    await _orderDBController.changeComplaintStatus(id, status);
  }

  Stream<QuerySnapshot> getSuggestionSnapshot(
      {DateTime fromDate, DateTime toDate}) {
    return _orderDBController.getSuggestionSnapshot(
        fromDate: fromDate, toDate: toDate);
  }

  Future<void> changeSuggestionStatus(String id, String status) async {
    await _orderDBController.changeSuggestionStatus(id, status);
  }

  Future<FeedbackDetails> getFeedbackData(
      String complaintID, String type) async {
    return await _orderDBController.getFeedbackData(complaintID, type);
  }

  Future<void> submitReply(
      {String feedbackID,
      String reply,
      String type,
      String email,
      String text}) async {
    await _orderDBController.submitReply(
        feedbackID: feedbackID,
        reply: reply,
        type: type,
        email: email,
        text: text);
  }

  Future<Order> fetchOrderData(String orderNo, {bool detail = false}) async {
    return await _orderDBController.getOrderItemsList(orderNo, detail: detail);
  }

  Stream<QuerySnapshot> getDuesSnapshot() {
    return _orderDBController.getDuesSnapshot();
  }

  Future<DocumentSnapshot> getPersonData(var docId) async {
    return await _orderDBController.getPersonData(docId);
  }

  Future<void> sendNotifications(String title, var tokenId, String msg) async {
    _orderDBController.sendNotifications(title, tokenId, msg);
  }

  Stream<QuerySnapshot> getDuesDetailSnapshot({String docId}) {
    return _orderDBController.getDuesDetailSnapshot(docId: docId);
  }

  Stream<QuerySnapshot> getOrderReviewsSnapshot({int no}) {
    return _orderDBController.getOrderReviewsSnapshot(no: no);
  }

  Future<DocumentSnapshot> getFoodItemData(var docId) async {
    return await _orderDBController.getFoodItemData(docId);
  }

  Stream<QuerySnapshot> getOrderSnapshot(docID) {
    return _orderDBController.getOrderSnapshot(docID);
  }
}
