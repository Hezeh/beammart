# Beammart

A Flutter mobile app for search and discover products sold nearby.

## Playstore Link
Your can find the mobile app here: https://play.google.com/store/apps/details?id=com.beammart.beammart

## App Website Code (Javascript - React)
https://github.com/Hezeh/beammart-web/tree/6d494b0dce8dffe47e86c2ce0799a69ac07d13f6

## Backend for fetching data from ElasticSearch (Python - FastAPI)
Mostly written to access the Elasticsearch database & perform a couple of backend functionalities.
https://github.com/Hezeh/search

## Firebase Functions Indexing Logic (Javascript)
https://github.com/Hezeh/beammart-index
Functions are called whenever a firestore index changes, a Google Cloud Pub/Sub topic is initialized and the same changes are made in Elasticsearch Database through a 
code logic written in Python (FastAPI).
Others are:
Orders indexing functions -> https://github.com/Hezeh/orders-firebase-functions
All Items functions -> https://github.com/Hezeh/all-items
Services functions -> https://github.com/Hezeh/services-funcs

## Flutter Merchants App Code (Dart)
Merchants can list their products, purchase playstore subscriptions, get analytics and many other functionalities.
(Functionality was later migrated to the main app).
https://github.com/Hezeh/beammart_merchants

## Subscriptions Cron-Job (Python - FastAPI)
Checks whether merchant's products can be listed any renews their subscriptions if they have enough tokens in their accounts.
https://github.com/Hezeh/tokens_cron_job

## Search Engine Results Page(SERP) Clickstream (Python - FastAPI)
Takes clicks from the mobile app's SERP and publishes them to Google Pub/Sub where subscribers can take it to analytical systems (e.g. BigQuery, Flink, Apache Spark etc)
https://github.com/Hezeh/serp_clickstream

## Items Views (Python - FastAPI)
Takes event data when a user views a product. Publishes the data to Google Cloud Pub/Sub. Joined in the backend with clickstream data to measure which items are currently popular.
https://github.com/Hezeh/item_viewstream

## Google Play Policy Page (JavaScript - React)
Policy Website required by Google Play Console.
https://github.com/Hezeh/policies

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
