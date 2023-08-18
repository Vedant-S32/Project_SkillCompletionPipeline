class_name C_FBRating
extends Node

var I_APIKeys = C_APIKeys.new()

var U_Collection: FirestoreCollection
var query: FirestoreQuery = FirestoreQuery.new()
var U_Document_task: FirestoreTask
var U_Document: FirestoreDocument
var U_Subject
var U_Level
var U_FBDatabase
var U_LinkID = ""
var U_ID


func F_FetchID(P_Subject, P_Level):
	U_Collection = Firebase.Firestore.collection(I_APIKeys.U_CollectionName)
	U_Document_task = U_Collection.get_doc(P_Subject)
	U_Document = await U_Document_task.get_document
	U_ID = U_Document.F_GetDictionary()
	return U_ID


func F_FBCommitRating(P_Link, P_APIRequest, P_CourseLevel , P_FireCollection, P_Rating, P_Index, P_Suject):
	var temp = P_Link[P_Index]
	U_LinkID = ""
	print(temp)
	for i in range(0,len(temp), 1):
		if(temp[i] == "="):
			var j = i
			while (j != len(temp) and temp[j] != '&'):
				U_LinkID += temp[j]
				j += 1
			break
	print(U_LinkID)
	print(P_CourseLevel)
	U_FBDatabase = await F_FetchID(P_Suject, P_CourseLevel)
	print(U_FBDatabase)
	if(P_CourseLevel == "Beginner"):
		U_FBDatabase.Beginner[P_Index] = U_LinkID + "&" + P_Rating + "$"
		print("done")
	elif(P_CourseLevel == "Intermediate"):
		U_FBDatabase.Intermediate[P_Index] = U_LinkID + "&" + P_Rating + "$"
	elif(P_CourseLevel == "Advanced"):
		U_FBDatabase.Advanced[P_Index] = U_LinkID + "&" + P_Rating + "$"
	
	P_FireCollection.update(P_Suject, U_FBDatabase)
