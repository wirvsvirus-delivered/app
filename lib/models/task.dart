import 'package:flutter/material.dart';

class Task {

  Task(this.items, this.over16, this.over18, this.delivered, this.payed, this.address);

  List<Item> items;
  bool over16;
  bool over18;
  bool delivered;
  bool payed;
  Address address;
}

class Item {
  Item(this.amount, this.item, this.info);

  String amount;
  String item;
  String info;

  @override
  String toString() {
    return amount + " "+ item + " (" + info + ")";
  }
}

class Address {

  Address(this.street, this.houseNumber, this.zip, this.country);

  String street;
  String houseNumber;
  int zip;
  String country;

  @override
  String toString() {
    return street + " " + houseNumber + ", " + country.toUpperCase() + "-" + zip.toString();
  }

}