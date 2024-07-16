extends Node
class_name FirestoreUtils

static var _str = "stringValue"
static var _int = "integerValue"

static func getString(doc_data: FirestoreDocument, field: String) -> String:
	return doc_data.document[field][_str]
	
static func getInteger(doc_data: FirestoreDocument, field: String) -> int:
	return int(doc_data.document[field][_int])
