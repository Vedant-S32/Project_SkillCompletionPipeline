class_name C_FBDatabase
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
	if(U_ID):
		return U_ID
		pass
	else:
		var add_task : FirestoreTask = U_Collection.add(P_Subject, {'name': 'Document Name', 'active': 'true'})
		var document = await add_task.task_finished


func F_FBCommitRating(P_Link, P_APIRequest, P_CourseLevel, P_FireCollection, P_Suject):
	var temp = ""
	for i in range(0,len(P_Link), 1):
		if(P_Link[i] == "="):
			var j = i
			while (j != len(P_Link) and P_Link[j] != '&'):
				U_LinkID += P_Link[j]
				j += 1
			break


func F_FBCommit(P_Link, P_APIRequest, P_CourseLevel, P_FireCollection, P_Suject, P_Index):
	var temp = ""
	U_LinkID = ""
	for i in range(0,len(P_Link), 1):
		if(P_Link[i] == "="):
			var j = i
			while (j != len(P_Link) and P_Link[j] != '&'):
				U_LinkID += P_Link[j]
				j += 1
			break
	print(U_LinkID)
	var P_LinkID = P_APIRequest + temp + I_APIKeys.U_YoutubeAPIKey
	print(P_LinkID)
	
	U_FBDatabase = await F_FetchID(P_Suject, P_CourseLevel)
	print(P_CourseLevel)
	if(P_CourseLevel == "Beginner"):
		if(len(U_FBDatabase.Beginner) == P_Index):
			U_FBDatabase.Beginner += [U_LinkID]
		else:
			U_FBDatabase.Beginner += [""]
			var DB_Len = len(U_FBDatabase.Beginner) - 1
			print(DB_Len)
			print(U_FBDatabase.Beginner)
			while(DB_Len > P_Index):
				U_FBDatabase.Beginner[DB_Len] = U_FBDatabase.Beginner[DB_Len - 1]
				U_FBDatabase.Beginner[DB_Len - 1] = ""
				DB_Len -= 1
			print(P_Index)
			print(P_Index, U_LinkID)
			U_FBDatabase.Beginner[P_Index] = U_LinkID
	elif(P_CourseLevel == "Intermediate"):
		if(len(U_FBDatabase.Intermediate) == P_Index):
			U_FBDatabase.Intermediate += [U_LinkID]
		else:
			U_FBDatabase.Intermediate += [""]
			var DB_Len = len(U_FBDatabase.Intermediate) - 1
			print(DB_Len)
			print(U_FBDatabase.Intermediate)
			while(DB_Len > P_Index):
				U_FBDatabase.Intermediate[DB_Len] = U_FBDatabase.Intermediate[DB_Len - 1]
				U_FBDatabase.Intermediate[DB_Len - 1] = ""
				DB_Len -= 1
			print(P_Index)
			print(P_Index, U_LinkID)
			U_FBDatabase.Intermediate[P_Index] = U_LinkID
			print(U_FBDatabase.Intermediate)
	elif(P_CourseLevel == "Advanced"):
		if(len(U_FBDatabase.Advanced) == P_Index):
			U_FBDatabase.Advanced += [U_LinkID]
		else:
			U_FBDatabase.Advanced += [""]
			var DB_Len = len(U_FBDatabase.Advanced) - 1
			print(DB_Len)
			print(U_FBDatabase.Advanced)
			while(DB_Len > P_Index):
				U_FBDatabase.Advanced[DB_Len] = U_FBDatabase.Advanced[DB_Len - 1]
				U_FBDatabase.Advanced[DB_Len - 1] = ""
				DB_Len -= 1
			print(P_Index)
			print(P_Index, U_LinkID)
			U_FBDatabase.Advanced[P_Index] = U_LinkID
			print(U_FBDatabase.Advanced)
	
	P_FireCollection.update(P_Suject, U_FBDatabase)
