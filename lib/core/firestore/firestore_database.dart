import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatabase {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> addDocument(
      {required String collectionPath,
      required Map<String, dynamic> data}) async {
    final documentReference = await _db.collection(collectionPath).add(data);
    return documentReference.id;
  }

  Future<String> addObject<T>(
      {required String collectionPath,
      required T data,
      required ObjectEncoder<T> objectEncoder}) async {
    final documentReference =
        await _db.collection(collectionPath).add(objectEncoder(data));
    return documentReference.id;
  }

  Future<void> setDocument(
      {required String collectionPath,
      required String documentId,
      required Map<String, dynamic> data,
      bool merge = true}) async {
    DocumentReference<Map<String, dynamic>> reference;
    reference = _db.collection(collectionPath).doc(documentId);
    await reference.set(data, SetOptions(merge: merge));
  }

  Future<void> setObject<T>(
      {required String collectionPath,
      required String documentId,
      required T data,
      required ObjectEncoder<T> objectEncoder,
      bool merge = true}) async {
    DocumentReference<Map<String, dynamic>> reference;
    reference = _db.collection(collectionPath).doc(documentId);
    await reference.set(objectEncoder(data), SetOptions(merge: merge));
  }

  Future<Map<String, dynamic>?> getDocument(
      {required String collectionPath, required String documentId}) async {
    DocumentReference<Map<String, dynamic>> reference;
    reference = _db.collection(collectionPath).doc(documentId);
    final snapshot = await reference.get();
    return snapshot.data();
  }

  Future<T?> getObject<T>(
      {required String collectionPath,
      required String documentId,
      required ObjectDecoder<T> objectDecoder}) async {
    final document = await getDocument(
        collectionPath: collectionPath, documentId: documentId);
    if (document?.isEmpty ?? true) return null;
    return objectDecoder(document!);
  }

  Future<Map<String, dynamic>?> getDocumentByField(
      {required String collectionPath,
      required String field,
      required String match}) async {
    Query<Map<String, dynamic>> query;
    query = _db.collection(collectionPath).where(field, isEqualTo: match);
    final snapshot = await query.get();
    return snapshot.docs.firstOrNull?.data();
  }

  Future<T?> getObjectByField<T>(
      {required String collectionPath,
      required String field,
      required String match,
      required ObjectDecoder<T> objectDecoder}) async {
    final document = await getDocumentByField(
        collectionPath: collectionPath, field: field, match: match);
    if (document?.isEmpty ?? true) return null;
    return objectDecoder(document!);
  }

  Future<void> deleteDocument(
      {required String collectionPath, required String documentId}) async {
    DocumentReference<Map<String, dynamic>> reference;
    reference = _db.collection(collectionPath).doc(documentId);
    await reference.delete();
  }

  Future<void> deleteFirstDocumentByField(
      {required String collectionPath,
      required String field,
      required String match}) async {
    Query<Map<String, dynamic>> query;
    query =
        _db.collection(collectionPath).where(field, isEqualTo: match).limit(1);
    final snapshot = await query.get();
    await snapshot.docs.firstOrNull?.reference.delete();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDocumentStream(
      {required String collectionPath, required String documentId}) {
    DocumentReference<Map<String, dynamic>> reference;
    reference = _db.collection(collectionPath).doc(documentId);
    return reference.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCollectionStream(
      {required String collectionPath}) {
    CollectionReference<Map<String, dynamic>> reference;
    reference = _db.collection(collectionPath);
    return reference.snapshots();
  }
}

typedef ObjectEncoder<T> = Map<String, dynamic> Function(T object);
typedef ObjectDecoder<T> = T Function(Map<String, dynamic> map);
